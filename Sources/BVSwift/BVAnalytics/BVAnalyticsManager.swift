//
//
//  BVAnalyticsManager.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal class BVAnalyticsManager {
  
  private static var clientId: String? {
    get {
      guard let analyticsConfig: BVAnalyticsConfiguration =
        BVManager.sharedManager.getConfiguration() else {
          return nil
      }
      return analyticsConfig.configurationKey
    }
  }
  
  private var concurrentEventDispatchQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVAnalyticsManager.concurrentEventQueue",
      qos: .utility,
      attributes: .concurrent,
      autoreleaseFrequency: .inherit,
      target: nil)
  
  private var timerDispatchQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVAnalyticsManager.timerDispatchQueue")
  
  private var queueFlushTimer: DispatchSourceTimer?
  
  private var eventQueue: [BVAnalyticsEventInstance] =
    [BVAnalyticsEventInstance]()
  private var pageViewQueue: [BVAnalyticsEventInstance] =
    [BVAnalyticsEventInstance]()
  
  internal static let sharedManager = BVAnalyticsManager()
  
  internal func enqueue(
    analyticsEvent: BVAnalyticsEvent, anonymous: Bool = false) {
    
    guard let event = augmentEventWithClientData(analyticsEvent) else {
      return
    }
    
    concurrentEventDispatchQueue.async(flags: .barrier) {
      let instance: BVAnalyticsEventInstance = (event, anonymous)
      switch analyticsEvent {
      case .pageView:
        self.pageViewQueue.append(instance)
        break
      default:
        self.eventQueue.append(instance)
        break
      }
      self.scheduleEventQueueFlush()
    }
  }
  
  internal func enqueue(
    analyticsEventable: BVAnalyticsEventable, anonymous: Bool = false) {
    
    guard let event = augmentEventWithClientData(analyticsEventable) else {
      return
    }
    
    concurrentEventDispatchQueue.async(flags: .barrier) {
      let instance: BVAnalyticsEventInstance = (event, anonymous)
      self.eventQueue.append(instance)
      self.scheduleEventQueueFlush()
    }
  }
  
  internal func flush(_ completion: ((UInt?, [Error]?) -> Void)? = nil) {
    
    concurrentEventDispatchQueue.async(flags: .barrier) {
      
      self.timerDispatchQueue.sync {
        self.queueFlushTimer?.cancel()
        self.queueFlushTimer = nil
      }
      
      /*
       * The problem is that we want a separate page view event queue from all
       * the rest while also being able to only signal the completion handler
       * once with the respective successes and potential errors found along
       * the way. Firstly, we have to use a group (could have used semaphore as
       * well...) to gate on the block yielding. Secondly, we need a
       * synchronization primitive to deal with the number of successes and
       * errors to be returned back to the caller.
       */
      let flushGroup: DispatchGroup = DispatchGroup()
      let flushQueueLabel: String =
      "com.bvswift.BVAnalyticsManager.flushQ_\(UUID().description)"
      let flushQueue: DispatchQueue = DispatchQueue(label: flushQueueLabel)
      var batchSize: UInt = 0
      var batchErrors: [Error] = []
      
      if !self.eventQueue.isEmpty {
        let batch: BVAnalyticsEventBatch =
          BVAnalyticsEventBatch(self.eventQueue)
        let batchAttempt = UInt(self.eventQueue.count)
        
        flushGroup.enter()
        
        self.postBatch(batch: batch) { (errors: [Error]?) in
          if let errs = errors {
            flushQueue.sync {
              batchErrors += errs
            }
          } else {
            flushQueue.sync {
              batchSize += batchAttempt
            }
          }
          
          flushGroup.leave()
        }
        self.eventQueue.removeAll()
      }
      
      if !self.pageViewQueue.isEmpty {
        let batch: BVAnalyticsEventBatch =
          BVAnalyticsEventBatch(self.pageViewQueue)
        let batchAttempt = UInt(self.pageViewQueue.count)
        
        flushGroup.enter()
        
        self.postBatch(batch: batch) { (errors: [Error]?) in
          if let errs = errors {
            flushQueue.sync {
              batchErrors += errs
            }
          } else {
            flushQueue.sync {
              batchSize += batchAttempt
            }
          }
          
          flushGroup.leave()
        }
        self.pageViewQueue.removeAll()
      }
      
      flushGroup.notify(queue: self.concurrentEventDispatchQueue) {
        flushQueue.async {
          completion?(batchSize, !batchErrors.isEmpty ? batchErrors : nil)
        }
      }
    }
  }
  
  private init() { }
  
  private func augmentEventWithClientData(
    _ event: BVAnalyticsEventable?) -> BVAnalyticsEventable? {
    
    guard let analyticsConfig: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration(),
      var mutate: BVAnalyticsEventable = event else {
        assert(
          false, "No valid BVAnalyticsConfiguration for BVAnalyticsManager")
        return event
    }
    
    let clientData: [String : String] =
      ["client" : analyticsConfig.configurationKey]
    mutate.augment(clientData)
    return mutate
  }
  
  private func scheduleEventQueueFlush() {
    timerDispatchQueue.sync {
      
      /// Bail if we've already set up the timer
      if let _ = queueFlushTimer {
        return
      }
      
      let handler: DispatchSourceProtocol.DispatchSourceHandler? =
      { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.flush()
      }
      
      queueFlushTimer =
        DispatchSource.makeTimerSource(queue: DispatchQueue.main)
      queueFlushTimer?.schedule(
        deadline: .now(), repeating: .never, leeway: .nanoseconds(0))
      
      queueFlushTimer?.setEventHandler(
        qos: .utility,
        flags: [],
        handler: handler)
      
      queueFlushTimer?.resume()
    }
  }
  
  private func postBatch(
    batch: BVAnalyticsEventBatch, completion: @escaping (([Error]?) -> Void)) {
    
    guard let analyticsConfig: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        assert(
          false, "No valid BVAnalyticsConfiguration for BVAnalyticsManager")
        return 
    }
    
    /// Dry run, bail and log
    if case .dryRun = analyticsConfig {
      completion(nil)
      return
    }
    
    let batchPost = BVAnalyticsSubmission(batch)
      .configure(analyticsConfig)
      .handler { (response: BVAnalyticsSubmission.BVAnalyticsEventResponse) in
        if case let .failure(errors) = response {
          completion(errors)
          return
        }
        completion(nil)
    }
    
    /// Grab proper session ???
    batchPost.async()
  }
}

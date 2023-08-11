//
//
//  BVAnalyticsManager.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

typealias BVAnalyticsEventInstanceMap =
  [BVAnalyticsConfiguration: [BVAnalyticsEventInstance]]

internal class BVAnalyticsManager {
  
  private static var analyticsConfiguration: BVAnalyticsConfiguration? {
    guard let analyticsConfig: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        return nil
    }
    return analyticsConfig
  }
  
  internal var clientId: String? {
    guard let analyticsConfig =
      BVAnalyticsManager.analyticsConfiguration else {
        return nil
    }
    return analyticsConfig.configurationKey
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
    analyticsEvent: BVAnalyticsEvent,
    configuration: BVAnalyticsConfiguration,
    anonymous: Bool = false,
    overrides: [String: BVAnyEncodable]? = nil) {
    
    guard let event =
      augmentEventWithClientData(
        analyticsEvent, configuration: configuration) else {
          return
    }
    
    concurrentEventDispatchQueue.async(flags: .barrier) {
      
      let instance: BVAnalyticsEventInstance =
        (event, configuration, anonymous, overrides)
      
      switch analyticsEvent {
      case .pageView:
        self.pageViewQueue.append(instance)
      default:
        self.eventQueue.append(instance)
      }
      self.scheduleEventQueueFlush()
    }
  }
  
  internal func enqueue(
    analyticsEventable: BVAnalyticsEventable,
    configuration: BVAnalyticsConfiguration,
    anonymous: Bool = false,
    overrides: [String: BVAnyEncodable]? = nil) {
    
    guard let event =
      augmentEventWithClientData(
        analyticsEventable, configuration: configuration) else {
          return
    }
    
    concurrentEventDispatchQueue.async(flags: .barrier) {
      
      let instance: BVAnalyticsEventInstance =
        (event, configuration, anonymous, overrides)
      
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
        
        for (config, batch) in self.generateBatches(self.eventQueue) {
          
          let thisBatch: BVAnalyticsEventBatch =
            BVAnalyticsEventBatch(batch)
          
          let batchAttempt = UInt(batch.count)
          
          BVLogger.sharedLogger
            .analytics(
              "Enqueing BVAnalyticsEventBatch: " +
              "(\"event\", \(batchAttempt), \(thisBatch))")
          
          flushGroup.enter()
          
          self.postBatch(batch: thisBatch, configuration: config)
          { (errors: [Error]?) in
            
            if let errs = errors {
              flushQueue.sync {
                batchErrors += errs
              }
              
              BVLogger.sharedLogger
                .analytics(
                  "Failed BVAnalyticsEventBatch: " +
                  "(\"event\", \(batchAttempt), \(thisBatch))")
              
            } else {
              flushQueue.sync {
                batchSize += batchAttempt
              }
              
              BVLogger.sharedLogger
                .analytics(
                  "Succeeded BVAnalyticsEventBatch: " +
                  "(\"event\", \(batchAttempt), \(thisBatch))")
            }
            
            flushGroup.leave()
          }
        }
        
        self.eventQueue.removeAll()
      }
      
      if !self.pageViewQueue.isEmpty {
        
        for (config, batch) in self.generateBatches(self.pageViewQueue) {
          
          let thisBatch: BVAnalyticsEventBatch =
            BVAnalyticsEventBatch(batch)
          let batchAttempt = UInt(batch.count)
          
          BVLogger.sharedLogger
            .analytics(
              "Enqueing BVAnalyticsEventBatch: " +
              "(\"pageView\", \(batchAttempt), \(thisBatch))")
          
          flushGroup.enter()
          
          self.postBatch(batch: thisBatch, configuration: config)
          { (errors: [Error]?) in
            if let errs = errors {
              flushQueue.sync {
                batchErrors += errs
              }
              
              BVLogger.sharedLogger
                .analytics(
                  "Failed BVAnalyticsEventBatch: " +
                  "(\"pageView\", \(batchAttempt), \(thisBatch))")
              
            } else {
              flushQueue.sync {
                batchSize += batchAttempt
              }
              
              BVLogger.sharedLogger
                .analytics(
                  "Succeeded BVAnalyticsEventBatch: " +
                  "(\"pageView\", \(batchAttempt), \(thisBatch))")
            }
            
            flushGroup.leave()
          }
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
    _ event: BVAnalyticsEventable?,
    configuration: BVAnalyticsConfiguration?) -> BVAnalyticsEventable? {
    
    guard let analyticsConfig: BVAnalyticsConfiguration =
      BVAnalyticsManager.analyticsConfiguration ?? configuration,
      var mutate: BVAnalyticsEventable = event else {
        assert(
          false, "No valid BVAnalyticsConfiguration for BVAnalyticsManager")
        return event
    }
    
    let clientData: [String: BVAnyEncodable] =
      ["client": BVAnyEncodable(analyticsConfig.configurationKey)]
    mutate.augment(clientData)
    return mutate
  }
  
  private func scheduleEventQueueFlush() {
    timerDispatchQueue.sync {
      
      /// Bail if we've already set up the timer
      if nil != queueFlushTimer {
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
  
  private func generateBatches(
    _ instances: [BVAnalyticsEventInstance]) -> BVAnalyticsEventInstanceMap {
    return
      instances.reduce(into: [:]) {
        var collection: [BVAnalyticsEventInstance] = []
        if let existing = $0[$1.configuration] {
          collection = existing
        }
        collection.append($1)
        $0[$1.configuration] = collection
    }
  }
  
  private func postBatch(
    batch: BVAnalyticsEventBatch,
    configuration: BVAnalyticsConfiguration,
    completion: @escaping (([Error]?) -> Void)) {
    
    if case let .dryRun(configType) = configuration {
      /// There shouldn't be any situation where you're setting a production
      /// configuration while also setting a dry run configuration.
      if case .production = configType {
        fatalError(
          "Disable .dryRun configuration before pushing a release build.")
      }
      
      /// Dry run, we callback and then bail
      completion(nil)
      return
    }
    
    let batchPost = BVAnalyticsSubmission(batch)
      .configure(configuration)
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

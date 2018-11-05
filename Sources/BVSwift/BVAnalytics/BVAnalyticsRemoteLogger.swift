//
//
//  BVAnalyticsRemoteLogger.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal class BVAnalyticsRemoteLogger {
  private static var analyticsConfiguration: BVAnalyticsConfiguration? {
    guard let analyticsConfig: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        return nil
    }
    return analyticsConfig
  }
  
  private static var clientId: String? {
    guard let analyticsConfig =
      BVAnalyticsRemoteLogger.analyticsConfiguration else {
        return nil
    }
    return analyticsConfig.configurationKey
  }
  
  private static var locale: Locale? {
    guard let analyticsConfig =
      BVAnalyticsRemoteLogger.analyticsConfiguration else {
        return nil
    }
    return analyticsConfig.locale
  }
  
  private var concurrentEventDispatchQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVAnalyticsRemoteLogger.concurrentEventQueue",
      qos: .utility,
      attributes: .concurrent,
      autoreleaseFrequency: .inherit,
      target: nil)
  
  private var serialDispatchQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVAnalyticsRemoteLogger.serialDispatchQueue")
  
  private init() {
    BVLogger.sharedLogger.add(self)
  }
  
  private var internalLogLevel: BVLogger.LogLevel = .fault
  
  internal var logLevel: BVLogger.LogLevel {
    get {
      var level: BVLogger.LogLevel = .fault
      serialDispatchQueue.sync {
        level = internalLogLevel
      }
      return level
    }
    set(newValue) {
      serialDispatchQueue.sync {
        internalLogLevel = newValue
      }
    }
  }
  
  internal var remoteLogTestingCompletion: (
  (BVAnalyticsRemoteLog, [Error]?) -> Void)?
  
  /// Should never get here, but...
  deinit {
    BVLogger.sharedLogger.remove(self)
  }
  
  internal static let sharedManager = BVAnalyticsRemoteLogger()
}

extension BVAnalyticsRemoteLogger: BVLogListener {
  func log(
    logLevel: BVLogger.LogLevel,
    msg: CustomStringConvertible,
    file: String,
    function: String,
    line: Int) {
    
    /// We have to have a production analytics configuration in order to send
    /// to magpie.
    guard let bvLog = msg as? BVLogMessage,
      let analyticsConfig = BVAnalyticsRemoteLogger.analyticsConfiguration,
      case let .configuration(_, configType) = analyticsConfig else {
        return
    }
    
    switch configType {
    case .production:
      break
    case .staging where nil != remoteLogTestingCompletion:
      break
    default:
      return
    }
    
    serialDispatchQueue.async { [weak self] in
      
      guard let ephemeralSelf = self else {
        return
      }
      
      switch (ephemeralSelf.internalLogLevel, logLevel) {
      case (.analytics, let level) where .analytics != level:
        return
      case (_, _)
        where ephemeralSelf.internalLogLevel.rawValue > logLevel.rawValue:
        return
      default:
        break
      }
      
      let log = "[\(function):\(line)] \(msg)"
      let liveLog =
        BVAnalyticsRemoteLog(
          client: BVAnalyticsRemoteLogger.clientId,
          error: logLevel.description,
          locale: BVAnalyticsRemoteLogger.locale,
          log: log,
          bvProduct: bvLog.bvProduct)
      
      let liveLogSubmission = BVAnalyticsSubmission(liveLog)
        .configure(analyticsConfig)
        .handler {
          (response: BVAnalyticsSubmission.BVAnalyticsEventResponse) in
          
          #if DEBUG
          
          guard case let .failure(errors) = response else {
            ephemeralSelf.remoteLogTestingCompletion?(liveLog, nil)
            return
          }
          ephemeralSelf.remoteLogTestingCompletion?(liveLog, errors)
          
          #else
          
          if .fault == logLevel {
            fatalError(log)
          }
          
          #endif /* DEBUG */
      }
      
      liveLogSubmission.async(
        on: ephemeralSelf.concurrentEventDispatchQueue,
        urlSession: BVManager.sharedManager.urlSession)
    }
  }
}

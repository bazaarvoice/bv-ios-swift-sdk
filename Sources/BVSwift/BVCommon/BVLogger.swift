//
//
//  BVLogger.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import os.log

/// The global logger packaged with this module
///
/// - Note:
/// \
/// If it's not entirely obvious, this logger will use os_log(3) by default if
/// running on an applicable and supported platform version. It will also log
/// to stdout during debug builds or if this isn't a supported os_log(3)
/// platform.
public class BVLogger {
  
  /// Supported log levels
  public enum BVLogLevel: UInt {
    case analytics = 0
    case verbose = 1
    case info = 2
    case warning = 3
    case error = 4
  }
  
  /// Singleton interface
  public static let sharedLogger = BVLogger()
  
  /// Log an analytic messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func analytics(_ msg: String) {
    enqueue(msg, logLevel: .analytics)
  }
  
  /// Log an error messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func error(_ msg: String) {
    enqueue(msg, logLevel: .error)
  }
  
  /// Log an info messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func info(_ msg: String) {
    enqueue(msg, logLevel: .info)
  }
  
  /// Log an verbose messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func verbose(_ msg: String) {
    enqueue(msg, logLevel: .verbose)
  }
  
  /// Log an analytic messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func warning(_ msg: String) {
    enqueue(msg, logLevel: .warning)
  }
  
  /// Set the current log level
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func setLogLevel(_ logLevel: BVLogLevel) {
    self.logLevel = logLevel
  }
  
  /// Get the current log level
  /// - Note:
  /// \
  /// This is thread safe.
  public var logLevel: BVLogLevel {
    get {
      var level: BVLogLevel = .error
      loggerQueue.sync {
        level = internalLogLevel
      }
      return level
    }
    set(newValue) {
      loggerQueue.sync {
        internalLogLevel = newValue
      }
    }
  }
  
  /// Private
  private var loggerQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVLogger.loggerQueue")
  
  @available(iOS 10.0, *)
  lazy private var logger = {
    return OSLog(subsystem: "com.bvswift.BVLogger", category: "Module")
  }()
  
  private var internalLogLevel: BVLogLevel = .error
  
  private init() {}
  
  private func enqueue(_ msg: String, logLevel: BVLogLevel) {
    DispatchQueue.main.async {
      
      switch (self.logLevel, logLevel) {
      case (.analytics, .analytics):
        break
      case (.analytics, _):
        return
      case (_, _) where self.logLevel.rawValue <= logLevel.rawValue:
        break
      default:
        return
      }
      
      if #available(iOS 10.0, *) {
        
        #if DEBUG
          print(msg)
        #endif
        
        os_log("%{public}@", log: self.logger, msg)
      } else {
        print(msg)
      }
    }
  }
}

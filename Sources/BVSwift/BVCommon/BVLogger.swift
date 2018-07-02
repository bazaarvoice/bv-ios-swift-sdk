//
//
//  BVLogger.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import os.log

/// The logging redirect closure signature for proxying logs to another output.
public typealias BVLoggerRedirectClosure = ((_ msg: String) -> Swift.Void)

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
    case analytics = 16
    case debug = 1
    case info = 2
    case error = 3
    case fault = 4
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
  public func debug(_ msg: String) {
    enqueue(msg, logLevel: .debug)
  }
  
  /// Log an analytic messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func fault(_ msg: String) {
    enqueue(msg, logLevel: .fault)
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
  
  /// Understanding the need for logging unification this redirect closure is
  /// an interface for serializing logging facilities.
  /// - Note:
  /// \
  /// If this is set with a backing closure then the default logging behavior
  /// will be turned off and instead funneled through the provided closure. The
  /// filtering based on log level will still occur, however, instead of
  /// logging it will package the message up and send it through to the provided
  /// closure. If needing to turn off redirection just set the closure value to
  /// nil.
  ///
  /// This is thread safe.
  public var loggerRedirect: BVLoggerRedirectClosure? {
    get {
      var closure: BVLoggerRedirectClosure?
      loggerQueue.sync {
        closure = internalLoggerRedirect
      }
      return closure
    }
    set(newValue) {
      loggerQueue.sync {
        internalLoggerRedirect = newValue
      }
    }
  }
  
  @available(iOS 10.0, *)
  public var oslogLevel: OSLogType {
    get {
      switch logLevel {
      case .info:
        return .info
      case .debug:
        return .debug
      case .error:
        return .error
      case .fault:
        return .fault
      default:
        return .default
      }
    }
    set(newValue) {
      switch newValue {
      case .info:
        logLevel = .info
      case .debug:
        logLevel = .debug
      case .error:
        logLevel = .error
      case .fault:
        logLevel = .fault
      default:
        break
      }
    }
  }
  
  /// Private
  lazy private var defaultLogClosure: BVLoggerRedirectClosure = {
    return { (msg: String) -> Swift.Void in
      DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
          
          os_log("%{public}@", log: self.logger, msg)
          
          #if DEBUG
          print(msg)
          #endif
          
        } else {
          print(msg)
        }
      }
    }
  }()
  
  private var loggerQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVLogger.loggerQueue")
  
  @available(iOS 10.0, *)
  lazy private var logger = {
    return OSLog(subsystem: "com.bvswift.BVLogger", category: "Module")
  }()
  
  private var internalLogLevel: BVLogLevel = .error
  private var internalLoggerRedirect: BVLoggerRedirectClosure?
  
  private init() {}
  
  private func enqueue(_ msg: String, logLevel: BVLogLevel) {
    loggerQueue.async {
      
      switch (self.internalLogLevel, logLevel) {
      case (.analytics, let level) where .analytics != level:
        return
      case (_, _) where self.internalLogLevel.rawValue > logLevel.rawValue:
        return
      default:
        break
      }
      
      let closure: BVLoggerRedirectClosure =
        self.internalLoggerRedirect ?? self.defaultLogClosure
      closure(msg)
    }
  }
}

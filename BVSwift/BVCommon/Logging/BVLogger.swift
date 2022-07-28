//
//
//  BVLogger.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import os.log

/// The logging notification protocol. Register your class here if you want to
/// be able to direct logging to your own facility.
///
/// - Note:
/// \
/// The reason why the msg is CustomStringConvertible:
/// 1.) Allowing for a plethora of possible types to be passed to be logged
/// 2.) Allowing for an indirect "refcon" if someone is attempting to
///     leverage BVLogListener and wants to pass context around from their
///     specific logging.
public protocol BVLogListener: AnyObject {
  func log(
    logLevel: BVLogger.LogLevel,
    msg: CustomStringConvertible,
    file: String,
    function: String,
    line: Int)
}

/// The global logger packaged with this module
///
/// - Note:
/// \
/// If it's not entirely obvious, this logger will use os_log(3) by default if
/// running on an applicable and supported platform version. It will also log
/// to stdout during debug builds or if this isn't a supported os_log(3)
/// platform.
public class BVLogger {
  /// Singleton interface
  public static let sharedLogger = BVLogger()
  
  /// Supported log levels
  public enum LogLevel: UInt {
    case analytics = 16
    case debug = 1
    case info = 2
    case error = 3
    case fault = 4
    
    public var description: String {
      switch self {
      case .analytics:
        return "analytics"
      case .debug:
        return "debug"
      case .info:
        return "info"
      case .error:
        return "error"
      case .fault:
        return "fault"
      }
    }
  }
  
  /// Private
  private var loggerQueue: DispatchQueue =
    DispatchQueue(
      label: "com.bvswift.BVLogger.loggerQueue")
  
  private var listenerQueue =
    DispatchQueue(label: "com.bvswift.BVLogger.listenerQueue")
  
  private var listeners = [BVLogNotifier]()
    
  private var _logger : OSLog? = nil
  
  @available(iOS 10.0, *)
  private var logger:OSLog  {
      if _logger == nil {
          _logger = OSLog(subsystem: "com.bvswift.BVLogger", category: "Module")
      }
      return _logger!
  }
  
  private var internalLogLevel: LogLevel = .error
  
  private init() {}
}

extension BVLogger {
  /// Log an analytic messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func analytics(
    _ msg: CustomStringConvertible,
    file: String = #file,
    function: String = #function,
    line: Int = #line) {
    enqueue(
      logLevel: .analytics,
      msg: msg,
      file: file,
      function: function,
      line: line)
  }
  
  /// Log an error messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func error(
    _ msg: CustomStringConvertible,
    file: String = #file,
    function: String = #function,
    line: Int = #line) {
    enqueue(
      logLevel: .error,
      msg: msg,
      file: file,
      function: function,
      line: line)
  }
  
  /// Log an info messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func info(
    _ msg: CustomStringConvertible,
    file: String = #file,
    function: String = #function,
    line: Int = #line) {
    enqueue(
      logLevel: .info,
      msg: msg,
      file: file,
      function: function,
      line: line)
  }
  
  /// Log an verbose messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func debug(
    _ msg: CustomStringConvertible,
    file: String = #file,
    function: String = #function,
    line: Int = #line) {
    enqueue(
      logLevel: .debug,
      msg: msg,
      file: file,
      function: function,
      line: line)
  }
  
  /// Log an analytic messages
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func fault(
    _ msg: CustomStringConvertible,
    file: String = #file,
    function: String = #function,
    line: Int = #line) {
    enqueue(
      logLevel: .fault,
      msg: msg,
      file: file,
      function: function,
      line: line)
  }
  
  /// Set the current log level
  /// - Parameters:
  ///   - loglLevel: Log level to be set
  /// - Note:
  /// \
  /// This is thread safe.
  public func setLogLevel(_ logLevel: LogLevel) {
    self.logLevel = logLevel
  }
  
  /// Get the current log level
  /// - Note:
  /// \
  /// This is thread safe.
  public var logLevel: LogLevel {
    get {
      var level: LogLevel = .error
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
}

extension BVLogger {
  private func enqueue(
    logLevel: LogLevel,
    msg: CustomStringConvertible,
    file: String = #file,
    function: String = #function,
    line: Int = #line) {
    loggerQueue.async { [weak self] in
      
      guard let ephemeralSelf = self else {
        return
      }
      
      ephemeralSelf.notify(
        level: logLevel, msg: msg, file: file, function: function, line: line)
      
      switch (ephemeralSelf.internalLogLevel, logLevel) {
      case (.analytics, let level) where .analytics != level:
        return
      case (_, _)
        where ephemeralSelf.internalLogLevel.rawValue > logLevel.rawValue:
        return
      default:
        break
      }
      
      DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
          
          os_log("%{public}@", log: ephemeralSelf.logger, "\(msg)")
          
          #if DEBUG
          print(msg)
          #endif
          
        } else {
          print(msg)
        }
      }
    }
  }
}

extension BVLogger {
  public func add(_ listener: BVLogListener) {
    listenerQueue.sync {
      let listener = BVLogNotifier(listener)
      if !listeners.contains(listener) {
        listeners.append(listener)
      }
    }
  }
  
  public func remove(_ listener: BVLogListener) {
    listenerQueue.sync {
      let notifier = BVLogNotifier(listener)
      listeners = listeners.filter { $0 != notifier && $0.isActive() }
    }
  }
  
  private func expunge() {
    listenerQueue.sync {
      listeners.removeAll()
    }
  }
  
  private func notify(
    level: BVLogger.LogLevel,
    msg: CustomStringConvertible,
    file: String,
    function: String,
    line: Int) {
    listenerQueue.sync {
      listeners = listeners.filter { $0.isActive() }
      listeners.forEach {
        $0.notify(
          level: level, msg: msg, file: file, function: function, line: line)
      }
    }
  }
}

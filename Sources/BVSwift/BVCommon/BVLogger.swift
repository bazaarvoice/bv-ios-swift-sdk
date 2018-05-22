//
//
//  BVLogger.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import os.log

public class BVLogger {
  
  /// Public
  public enum BVLogLevel: UInt {
    case analytics = 0
    case verbose = 1
    case info = 2
    case warning = 3
    case error = 4
  }
  
  public static let sharedLogger = BVLogger()
  
  public func analytics(_ msg: String) {
    enqueue(msg, logLevel: .analytics)
  }
  
  public func error(_ msg: String) {
    enqueue(msg, logLevel: .error)
  }
  
  public func info(_ msg: String) {
    enqueue(msg, logLevel: .info)
  }
  
  public func verbose(_ msg: String) {
    enqueue(msg, logLevel: .verbose)
  }
  
  public func warning(_ msg: String) {
    enqueue(msg, logLevel: .warning)
  }
  
  public func setLogLevel(_ logLevel: BVLogLevel) {
    DispatchQueue.main.async {
      self.logLevel = logLevel
    }
  }
  
  @available(iOS 10.0, *)
  lazy private var logger = {
    return OSLog(subsystem: "com.bvswift.BVLogger", category: "Module")
  }()
  
  private var logLevel: BVLogLevel = .error
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

//
//
//  BVLogNotifier.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVLogNotifier: Hashable {
  static func == (lhs: BVLogNotifier, rhs: BVLogNotifier) -> Bool {
    return lhs.ptrHash == rhs.ptrHash
  }
  
  private var ptrHash: Int = 0x0
  private let active: () -> Bool
  private let call: (
  BVLogger.LogLevel, CustomStringConvertible, String, String, Int) -> Void
  
  init(_ listener: BVLogListener) {
    active = { [weak listener] in
      return nil != listener
    }
    
    call = { [weak listener] in
      listener?.log(logLevel: $0, msg: $1, file: $2, function: $3, line: $4)
    }
    
    var inst = listener
    withUnsafePointer(to: &inst) {
      ptrHash = $0.hashValue
    }
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ptrHash)
  }
  
  internal func isActive() -> Bool {
    return active()
  }
  
  internal func notify(
    level: BVLogger.LogLevel,
    msg: CustomStringConvertible,
    file: String,
    function: String,
    line: Int) {
    return call(level, msg, file, function, line)
  }
}

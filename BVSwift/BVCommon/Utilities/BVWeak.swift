//
//
//  BVWeak.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

prefix operator **

internal struct BVWeak<T: AnyObject> {
  private weak var instance: T?
  
  static prefix func ** (weakRef: BVWeak) -> T? {
    return weakRef.instance
  }
  
  init() {
    self.instance = nil
  }
  
  init(_ instanceType: T) {
    self.instance = instanceType
  }
}

extension BVWeak: Hashable {
  var unsafePointer: UnsafePointer<T>? {
    guard var inst = instance else {
      return nil
    }
    var ptr: UnsafePointer<T>?
    withUnsafePointer(to: &inst) {
      ptr = $0
    }
    return ptr
  }
  
  func hash(into hasher: inout Hasher) {
    guard let ptr = unsafePointer else {
      hasher.combine(0)
      return
    }
    hasher.combine(ptr.hashValue)
  }
  
  static func == (lhs: BVWeak, rhs: BVWeak) -> Bool {
    return lhs.unsafePointer == rhs.unsafePointer
  }
}

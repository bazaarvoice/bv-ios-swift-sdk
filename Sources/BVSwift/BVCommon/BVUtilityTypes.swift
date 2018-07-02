//
//
//  BVUtilityTypes.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

prefix operator **

internal struct BVWeakRef {
  private weak var instance: AnyObject?
  
  static prefix func ** (weakRef: BVWeakRef) -> AnyObject? {
    return weakRef.instance
  }
  
  init() {
    self.instance = nil
  }
  
  init(_ instanceType: AnyObject) {
    self.instance = instanceType
  }
}

extension BVWeakRef: Hashable {
  var hashValue: Int {
    guard let inst = instance else {
      return 0
    }
    return unsafeBitCast(inst, to: Int.self)
  }
  
  static func == (lhs: BVWeakRef, rhs: BVWeakRef) -> Bool {
    switch (**lhs, **rhs) {
    case (.some, .some) where lhs.hashValue == rhs.hashValue:
      return true
    case (.none, .none):
      return true
    default:
      return false
    }
  }
}

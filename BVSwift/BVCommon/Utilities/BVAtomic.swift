//
//
//  BVAtomic.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal final class BVAtomic<T> {
  private let lock = BVLock()
  private var _value: T
  
  internal init(_ value: T) {
    _value = value
  }
  
  internal func with<U>( _ value: (T) -> U) -> U {
    return lock.sync { return value(_value) }
  }
  
  internal func modify( _ modify: (T) -> T) {
    lock.sync {
      _value = modify(_value)
    }
  }
  
  @discardableResult
  internal func swap(_ value: T) -> T {
    return lock.sync {
      let current = _value
      _value = value
      return current
    }
  }
  
  internal var value: T {
    get {
      return lock.sync {
        return _value
      }
    }
    set {
      lock.sync {
        _value = newValue
      }
    }
  }
}

//
//
//  BVReactive.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal typealias ReactiveObserver<T> = ((T) -> Void)

internal class BVReactive<T> {
  private let lock = BVLock(.recursive)
  private var _value: T
  
  private let observers = BVBag<ReactiveObserver<T>>()
  private let expunged = BVCompositeExpungement()
  
  internal var value: T {
    return lock.sync {
      return _value
    }
  }
  
  internal init(_ value: T) {
    _value = value
  }
  
  @discardableResult
  private func addObserver(
    getCurrent: Bool = true,
    _ observer: @escaping ReactiveObserver<T>) -> BVExpungeable {
    
    lock.lock()
    let uuid = observers.add(observer)
    if getCurrent {
      observer(_value)
    }
    lock.unlock()
    
    let lockRef = lock
    let bagRef = observers
    let expungement = BVActionExpungement {
      lockRef.sync {
        bagRef.remove(uuid)
      }
    }
    
    addExpungeable(expungement)
    return expungement
  }
  
  @discardableResult
  internal func observe(
    _ observer: @escaping ReactiveObserver<T>) -> BVExpungeable {
    return addObserver(getCurrent: true, observer)
  }
  
  @discardableResult
  internal func observeNext(
    _ observer: @escaping ReactiveObserver<T>) -> BVExpungeable {
    return addObserver(getCurrent: false, observer)
  }
  
  internal func addExpungeable(_ disposable: BVExpungeable) {
    expunged.compose(disposable)
  }
  
  internal func conditionallyModifyValue(_ modifier: (T) -> T?) {
    lock.sync {
      if let newValue = modifier(_value) {
        _value = newValue
        for item in observers.items() {
          item(newValue)
        }
      }
    }
  }
  
  internal func setValue(_ value: T) {
    conditionallyModifyValue { _ in return value }
  }
}

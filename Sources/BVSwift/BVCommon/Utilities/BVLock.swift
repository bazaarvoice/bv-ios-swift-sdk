//
//
//  BVLock.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal protocol BVSynchronizable {
  func sync<R>(execute work: () throws -> R) rethrows -> R
  func trySync<R>(execute work: () throws -> R) rethrows -> R?
}

internal protocol BVMutex: BVSynchronizable {
  associatedtype Mutex
  var unsafeMutex: Mutex { get }
  func lock()
  func tryLock() -> Bool
  func unlock()
}

extension BVMutex {
  @discardableResult
  internal func sync<R>(execute action: () throws -> R) rethrows -> R {
    lock()
    defer { unlock() }
    return try action()
  }
  
  @discardableResult
  internal func trySync<R>(execute action: () throws -> R) rethrows -> R? {
    guard tryLock() else { return nil }
    defer { unlock() }
    return try action()
  }
}

internal class BVLock: BVMutex {
  typealias Mutex = pthread_mutex_t
  
  private var _lock: pthread_mutex_t = pthread_mutex_t()
  internal var unsafeMutex: pthread_mutex_t {
    return _lock
  }
  
  internal enum BVLockType {
    case normal
    case recursive
  }
  
  init(_ type: BVLockType = .normal) {
    var attr = pthread_mutexattr_t()
    pthread_mutexattr_init(&attr)
    
    switch type {
    case .normal:
      pthread_mutexattr_settype(&attr, Int32(PTHREAD_MUTEX_NORMAL))
    case .recursive:
      pthread_mutexattr_settype(&attr, Int32(PTHREAD_MUTEX_RECURSIVE))
    }
    guard pthread_mutex_init(&_lock, &attr) == 0x0 else {
      preconditionFailure()
    }
    pthread_mutexattr_destroy(&attr)
  }
  
  deinit {
    pthread_mutex_destroy(&_lock)
  }
  
  internal func lock() {
    pthread_mutex_lock(&_lock)
  }
  
  internal func tryLock() -> Bool {
    return pthread_mutex_trylock(&_lock) == 0x0
  }
  
  internal func unlock() {
    pthread_mutex_unlock(&_lock)
  }
}

//
//
//  BVExpungeable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal protocol BVExpungeable {
  var expunged: Bool { get }
  func expunge()
}

internal final class BVExpungement: BVExpungeable {
  private let monitor = BVAtomic(false)
  internal var expunged: Bool { return monitor.value }
  
  internal init() { }
  
  internal func expunge() { monitor.swap(true) }
}

internal final class BVActionExpungement: BVExpungeable {
  private let monitor: BVAtomic<(() -> Void)?>
  internal var expunged: Bool { return monitor.value == nil }
  
  internal init(_ action: @escaping () -> Void) {
    monitor = BVAtomic(action)
  }
  
  internal func expunge() {
    let action = monitor.swap(nil)
    action?()
  }
}

internal func += (lhs: BVCompositeExpungement, rhs: BVExpungeable) {
  return lhs.compose(rhs)
}

internal final class BVCompositeExpungement: BVExpungeable {
  private let monitor = BVAtomic<[BVExpungeable]?>([])
  internal var expunged: Bool { return monitor.value == nil }
  
  internal init() { }
  
  deinit { expunge() }
  
  internal func expunge() {
    let actions = monitor.swap(nil)
    actions?.forEach { $0.expunge() }
  }
  
  internal func compose(_ disposable: BVExpungeable) {
    monitor.modify {
      guard var modified = $0 else {
        disposable.expunge()
        return nil
      }
      modified.append(disposable)
      return modified
    }
  }
  
  internal func compose(_ block: @escaping () -> Void) {
    compose(BVActionExpungement(block))
  }
}

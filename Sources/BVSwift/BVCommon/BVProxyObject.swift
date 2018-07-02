//
//
//  BVProxyObject.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal class BVProxyObject: NSObject {
  internal var receiver: NSObjectProtocol?
  internal weak var proxied: NSObjectProtocol?

  func target(for aSelector: Selector!) -> NSObjectProtocol? {
    if let prx = proxied,
      prx.responds(to: aSelector) {
      return prx
    }
    if let rec = receiver,
      rec.responds(to: aSelector) {
      return rec
    }
    return nil
  }

  init(_ proxy: NSObject) {
    super.init()
    self.proxied = proxy
  }
}

extension BVProxyObject {
  override func forwardingTarget(for aSelector: Selector!) -> Any? {
    guard let target = target(for: aSelector) else {
      return super.forwardingTarget(for: aSelector)
    }
    return target
  }

  override func responds(to aSelector: Selector!) -> Bool {
    guard nil != target(for: aSelector) else {
      return super.responds(to: aSelector)
    }
    return true
  }
}

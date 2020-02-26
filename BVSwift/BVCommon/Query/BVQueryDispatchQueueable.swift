//
//  BVQueryDispatchQueueable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

// MARK: - BVQuery: BVDispatchQueueable
extension BVQuery: BVDispatchQueueable {
  
  @discardableResult
  final public func sync(
    on queue: DispatchQueue = DispatchQueue.main,
    qos: DispatchQoS = .default,
    flags: DispatchWorkItemFlags = [],
    urlSession: URLSession = URLSession.shared) -> Self {
    
    let workItem = DispatchWorkItem(
      qos: qos,
      flags: flags,
      urlSession: urlSession,
      request: self)
    
    queue.sync(execute: workItem)
    
    return self
  }
  
  @discardableResult
  final public func async(
    on queue: DispatchQueue = DispatchQueue.main,
    qos: DispatchQoS = .default,
    flags: DispatchWorkItemFlags = [],
    urlSession: URLSession = URLSession.shared) -> Self {
    
    let workItem = DispatchWorkItem(
      qos: qos,
      flags: flags,
      urlSession: urlSession,
      request: self)
    
    queue.async(execute: workItem)
    
    return self
  }
  
  @discardableResult
  final public func async(
    on queue: DispatchQueue = DispatchQueue.main,
    group: DispatchGroup,
    qos: DispatchQoS = .default,
    flags: DispatchWorkItemFlags = [],
    urlSession: URLSession = URLSession.shared) -> Self {
    
    let workItem = DispatchWorkItem(
      qos: qos,
      flags: flags,
      urlSession: urlSession,
      request: self)
    
    queue.async(group: group, execute: workItem)
    
    return self
  }
  
  @discardableResult
  final public func asyncAfter(
    on queue: DispatchQueue = DispatchQueue.main,
    deadline: DispatchTime,
    qos: DispatchQoS = .default,
    flags: DispatchWorkItemFlags = [],
    urlSession: URLSession = URLSession.shared) -> Self {
    
    let workItem = DispatchWorkItem(
      qos: qos,
      flags: flags,
      urlSession: urlSession,
      request: self)
    
    queue.asyncAfter(deadline: deadline, execute: workItem)
    
    return self
  }
  
  @discardableResult
  final public func asyncAfter(
    on queue: DispatchQueue = DispatchQueue.main,
    wallDeadline: DispatchWallTime,
    qos: DispatchQoS = .default,
    flags: DispatchWorkItemFlags = [],
    urlSession: URLSession = URLSession.shared) -> Self {
    
    let workItem = DispatchWorkItem(
      qos: qos,
      flags: flags,
      urlSession: urlSession,
      request: self)
    
    queue.asyncAfter(wallDeadline: wallDeadline, execute: workItem)
    
    return self
  }
}

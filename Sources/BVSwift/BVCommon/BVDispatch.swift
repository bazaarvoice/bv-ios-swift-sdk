//
//  BVDispatch.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public extension DispatchWorkItem {
  public convenience init(
    qos: DispatchQoS = .default,
    flags: DispatchWorkItemFlags = [],
    urlSession: URLSession = URLSession.shared,
    request: BVURLRequestable) {
    self.init(qos: qos, flags: flags) {
      urlSession.dataTask(with: request)
    }
  }
  
  public convenience init(
    qos: DispatchQoS = .default,
    flags: DispatchWorkItemFlags = [],
    urlSession: URLSession = URLSession.shared,
    requestWithData: BVURLRequestableWithBodyData) {
    self.init(qos: qos, flags: flags) {
      urlSession.uploadTask(with: requestWithData)
    }
  }
}

public protocol BVDispatchQueueable {
  func sync(
    on queue: DispatchQueue,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
  func async(
    on queue: DispatchQueue,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
  func async(
    on queue: DispatchQueue,
    group: DispatchGroup,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
  func asyncAfter(
    on queue: DispatchQueue,
    deadline: DispatchTime,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
  func asyncAfter(
    on queue: DispatchQueue,
    wallDeadline: DispatchWallTime,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
}

//
//  BVDispatch.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// A DispatchWorkItem extension for the BVURLRequestable family of protocols
/// so that they can be dispatchable instead of consumed.
public extension DispatchWorkItem {
  
  /// DispatchWorkItem wrapper for the base BVURLRequestable
  public convenience init(
    qos: DispatchQoS = .default,
    flags: DispatchWorkItemFlags = [],
    urlSession: URLSession = URLSession.shared,
    request: BVURLRequestable) {
    self.init(qos: qos, flags: flags) {
      urlSession.dataTask(with: request)
    }
  }
  
  /// DispatchWorkItem wrapper for the base BVURLRequestableWithBodyData
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

/// A protocol to be leveraged by the BVURLRequestable family in order to be
/// enqueued and used in concert with the DispatchWorkItem extensions.
/// - Note:
/// \
/// We included all the usual suspects that we think have utility, however,
/// other use cases might crop up the more "functional" things start to get
/// in later versions of swift. So anything that needs to change related to
/// Dispatch should probably go here at the root level.
public protocol BVDispatchQueueable {
  
  /// Your usual Dispatch sync { } with a URLSession
  func sync(
    on queue: DispatchQueue,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
  
  /// Your usual Dispatch async { } with a URLSession
  func async(
    on queue: DispatchQueue,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
  
  /// Your usual Dispatch async_group { } with a URLSession
  func async(
    on queue: DispatchQueue,
    group: DispatchGroup,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
  
  /// Your usual DispatchTime async_after { } with a URLSession
  func asyncAfter(
    on queue: DispatchQueue,
    deadline: DispatchTime,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
  
  /// Your usual DispatchWallTime async_after { } with a URLSession
  func asyncAfter(
    on queue: DispatchQueue,
    wallDeadline: DispatchWallTime,
    qos: DispatchQoS,
    flags: DispatchWorkItemFlags,
    urlSession: URLSession) -> Self
}

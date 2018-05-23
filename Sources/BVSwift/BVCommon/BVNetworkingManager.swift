//
//  BVNetworkingManager.swift
//  BVSwift
//
//  Created by Michael Van Milligan on 5/23/18.
//  Copyright © 2018 Michael Van Milligan. All rights reserved.
//

import Foundation

internal class BVNetworkingManager: NSObject {
  
  lazy private var networkingOperationQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.qualityOfService = .userInitiated
    return queue
  }()
  
  
  lazy internal var networkingSession: URLSession = {
    let config = URLSessionConfiguration.default
    if #available(iOS 11.0, *) {
      config.waitsForConnectivity = true
    }
    return
      URLSession(
        configuration: config,
        delegate: self,
        delegateQueue: networkingOperationQueue)
  }()
  
  private override init() {}
  
  /// Public
  internal static let sharedManager = BVNetworkingManager()
}

extension BVNetworkingManager: URLSessionDelegate {
  /// Nothing to see here yet.
}

extension BVNetworkingManager: URLSessionTaskDelegate {
  /// Nothing to see here yet.
}

extension BVNetworkingManager: URLSessionDataDelegate {
  /// Nothing to see here yet.
}

extension BVNetworkingManager: URLSessionDownloadDelegate {
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didFinishDownloadingTo location: URL) {
    /// Nothing to see here yet.
  }
}

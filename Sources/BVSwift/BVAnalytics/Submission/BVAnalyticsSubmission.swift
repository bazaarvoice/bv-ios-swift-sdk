//
//
//  BVAnalyticsSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal class BVAnalyticsSubmission: BVSubmission {
  private var ignoreCompletion: Bool = false
  private var analyticsConfiguration: BVAnalyticsConfiguration?
  
  internal init(_ events: BVAnalyticsEventBatch) {
    super.init(internalType: events)
  }
  
  internal init(_ remoteLog: BVAnalyticsRemoteLog) {
    super.init(internalType: remoteLog)
  }
  
  internal enum BVAnalyticsEventResponse {
    public var success: Bool {
      guard case .success = self else {
        return false
      }
      return true
    }
    
    case success
    case failure([Error])
  }
  
  override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    return nil
  }
  
  override var userAgentClosure: (() -> String)? {
    return { [weak self] in
      return URLRequest.bvUserAgent(self?.analyticsConfiguration?.locale)
    }
  }
}

// MARK: - BVAnalyticsSubmission: BVConfigurable
extension BVAnalyticsSubmission: BVConfigurable {
  typealias Configuration = BVAnalyticsConfiguration
  
  @discardableResult
  final func configure(_ config: BVAnalyticsConfiguration) -> Self {
    analyticsConfiguration = config
    configureExistentially(config)
    return self
  }
}

// MARK: - BVAnalyticsSubmission: BVSubmissionActionable
extension BVAnalyticsSubmission: BVSubmissionActionable {  
  typealias Response = BVAnalyticsEventResponse
  
  var ignoringCompletion: Bool {
    get {
      return ignoreCompletion
    }
    set(newValue) {
      ignoreCompletion = newValue
    }
  }
  
  @discardableResult
  func handler(completion: @escaping ((Response) -> Void)) -> Self {
    
    responseHandler = { [weak self] in
      
      if self?.ignoreCompletion ?? true {
        return
      }
      
      switch $0 {
      case .success:
        completion(.success)
      case let .failure(errors):
        completion(.failure(errors))
      }
    }
    
    return self
  }
}

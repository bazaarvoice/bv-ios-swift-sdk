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
  
  internal init(_ events: BVAnalyticsEventBatch) {
    super.init(internalType: events)
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
}

// MARK: - BVAnalyticsSubmission: BVConfigurable
extension BVAnalyticsSubmission: BVConfigurable {
  typealias Configuration = BVAnalyticsConfiguration
  
  @discardableResult
  final func configure(_ config: BVAnalyticsConfiguration) -> Self {
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

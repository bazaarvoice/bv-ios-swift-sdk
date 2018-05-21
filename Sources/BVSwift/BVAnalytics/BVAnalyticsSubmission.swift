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
      get {
        guard case .success = self else {
          return false
        }
        return true
      }
    }
    
    case success
    case failure([Error])
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
  
  @discardableResult func handler(
    completion: @escaping ((Response) -> Void)) -> Self {
    
    responseHandler = {
      
      if self.ignoreCompletion {
        return
      }
      
      switch $0 {
      case .success(_, _):
        completion(.success)
        break
      case let .failure(errors):
        completion(.failure(errors))
        break
      }
    }
    
    return self
  }
}

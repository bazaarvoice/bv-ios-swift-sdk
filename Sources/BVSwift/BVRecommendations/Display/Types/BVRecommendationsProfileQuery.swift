//
//
//  BVRecommendationsProfileQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVRecommendationsProfile Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/personalization-data-sdk)
public class BVRecommendationsProfileQuery:
BVRecommendationsQuery<BVRecommendationsProfile> {
  private var fields: [BVRecommendationsProfileField] = []
  
  init(_ limit: UInt16 = 20) {
    super.init(BVRecommendationsProfile.self)
    
    preflightHandler =
      { (completion: BVCompletionWithErrorsHandler?) -> Swift.Void in
        
        guard let config = self.configuration else {
          fatalError(
            "BVRecommendationsQuery requires configuration before it " +
            "can be issued.")
        }
        
        self.fields.forEach {
          switch $0 {
          case .preferredCategory:
            fallthrough
          case .requiredCategory:
            fallthrough
          case .product:
            let composed: String =
              [config.type.clientId, "\($0.representedValue)"]
                .joined(separator: "/").escaping()
            self.update(.unsafe($0.description.escaping(), composed, nil))
          case .include:
            fallthrough
          case .strategies:
            self.add(.field($0, nil), coalesce: true)
          default:
            self.update(.field($0, nil))
          }
        }
        
        completion?(nil)
    }
  }
}

// MARK: - BVRecommendationsProfileQuery: BVQueryFieldable
extension BVRecommendationsProfileQuery: BVQueryFieldable {
  public typealias Field = BVRecommendationsProfileField
  
  @discardableResult
  public func field(_ field: Field) -> Self {
    if !fields.contains(field) {
      fields.append(field)
    }
    return self
  }
}
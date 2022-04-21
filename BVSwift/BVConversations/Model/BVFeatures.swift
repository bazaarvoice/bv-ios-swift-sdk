//
//
//  BVFilterReview.swift
//  BVSwift
//
//  Copyright © 2021 Bazaarvoice. All rights reserved.
// 

import Foundation


public struct BVFeatures: BVQueryable {
  
  public static var singularKey: String {
    return BVConversationsConstants.BVFilterReviews.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVFilterReviews.pluralKey
  }
  
  public let productId : String
  public let features : [BVFeature]
  public let language : String
  
  private enum CodingKeys: String, CodingKey {
    case productId = "productId"
    case features = "features"
    case language = "language"
   
  }
}

extension BVFeatures: BVQueryableInternal {
  internal static var getResource: String? {
    return BVConversationsConstants.BVFilterReviews.getResource
  }
}




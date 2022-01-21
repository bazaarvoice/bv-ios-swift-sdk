//
//
//  BVFilterReview.swift
//  BVSwift
//
//  Copyright © 2021 Bazaarvoice. All rights reserved.
// 

import Foundation


public struct BVFilterReview: BVQueryable {
  
  public static var singularKey: String {
    return BVConversationsConstants.BVFilterReviews.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVFilterReviews.pluralKey
  }
  
  public let productId : String
  public let topicFilter : [BVFeature]
  public let language : String
  
  private enum CodingKeys: String, CodingKey {
    case productId = "productId"
    case topicFilter = "features"
    case language = "language"
   
  }
}

extension BVFilterReview: BVQueryableInternal {
  internal static var getResource: String? {
    return BVConversationsConstants.BVFilterReviews.getResource
  }
}




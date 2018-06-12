//
//
//  BVQuestionInclude.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible includable BVQueryable objects with a
/// relation to the target BVQuestion object.
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryIncludeable protocol.
public enum BVQuestionInclude: BVConversationsQueryInclude {
  
  case answers
  case authors
  case products
  
  public var description: String {
    return internalDescription
  }
}

extension BVQuestionInclude: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .answers:
        return BVAnswer.pluralKey
      case .authors:
        return BVAuthor.pluralKey
      case .products:
        return BVProduct.pluralKey
      }
    }
  }
}

//
//  BVBadge.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVBadge type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVBadge: BVAuxiliaryable {
  private let badgeTypeString: String?
  public let contentType: String?
  public let badgeId: String?
  
  public var badgeType: BVBadgeType? {
    get {
      return BVBadgeType(value: badgeTypeString)
    }
  }
  
  public enum BVBadgeType {
    case affiliation
    case custom
    case merit
    case rank
    
    internal init?(value: String?) {
      
      guard let val = value else {
        return nil
      }
      
      switch val {
      case "Affiliation":
        self = .affiliation
      case "Merit":
        self = .merit
      case "Rank":
        self = .rank
      default:
        self = .custom
      }
    }
  }
  
  private enum CodingKeys: String, CodingKey {
    case badgeTypeString = "BadgeType"
    case contentType = "ContentType"
    case badgeId = "Id"
  }
}

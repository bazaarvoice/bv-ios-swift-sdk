//
//  BVBadge.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVBadge: Codable {
  private let badgeTypeString: String?
  let contentType: String?
  let badgeId: String?
  
  var badgeType: BVBadgeType? {
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

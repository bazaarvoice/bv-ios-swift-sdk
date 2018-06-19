//
//
//  BVCurationsLink.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsLink type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsLink: BVAuxiliaryable {
  
  public let domain: String?
  public let displayURL: BVCodableSafe<URL>?
  public let icon: BVCodableSafe<URL>?
  public let identifier: BVIdentifier?
  public let shortURL: BVCodableSafe<URL>?
  public let url: BVCodableSafe<URL>?
  
  private enum CodingKeys: String, CodingKey {
    case domain = "domain"
    case displayURL = "display_url"
    case icon = "favicon"
    case identifier = "id"
    case shortURL = "short_url"
    case url = "url"
  }
}

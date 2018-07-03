//
//  BVSyndicationSource.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVSyndicationSource type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVSyndicationSource: BVAuxiliaryable {
  public let contentLink: BVCodableSafe<URL>?
  public let logoImageUrl: String?
  public let name: String?

  private enum CodingKeys: String, CodingKey {
    case contentLink = "ContentLink"
    case logoImageUrl = "LogoImageUrl"
    case name = "Name"
  }
}

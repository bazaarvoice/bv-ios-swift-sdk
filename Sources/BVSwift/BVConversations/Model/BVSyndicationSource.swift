//
//  BVSyndicationSource.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVSyndicationSource: Codable {
  let contentLink: URL?
  let logoImageUrl: String?
  let name: String?
  
  private enum CodingKeys: String, CodingKey {
    case contentLink = "ContentLink"
    case logoImageUrl = "LogoImageUrl"
    case name = "Name"
  }
}

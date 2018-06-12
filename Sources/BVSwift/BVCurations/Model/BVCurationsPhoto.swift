//
//
//  BVCurationsPhoto.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVCurationsPhoto: BVAuxiliaryable {
  
  public let displayURL: BVCodableSafe<URL>?
  public let identifier: BVIdentifier?
  public let imageServiceURL: BVCodableSafe<URL>?
  public let localURL: BVCodableSafe<URL>?
  public let origin: String?
  public let permalink: BVCodableSafe<URL>?
  public let role: String?
  public let token: String?
  public let url: BVCodableSafe<URL>?
  
  private enum CodingKeys: String, CodingKey {
    case displayURL = "display_url"
    case identifier = "id"
    case imageServiceURL = "image_service_url"
    case localURL = "local_url"
    case origin = "origin"
    case permalink = "permalink"
    case role = "role"
    case token = "dict"
    case url = "url"
  }
}

public struct BVCurationsPhotoSubmission: BVAuxiliaryable {
  public let imageURL: URL?
  
  private enum CodingKeys: String, CodingKey {
    case imageURL = "imageUrl"
  }
  
  init(_ imageURL: URL) {
    self.imageURL = imageURL
  }
}

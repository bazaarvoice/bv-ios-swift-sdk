//
//
//  BVCurationsVideo.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsVideo type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsVideo: BVAuxiliaryable {
  
  public let code: String?
  public let displayURL: BVCodableSafe<URL>?
  public let identifier: BVIdentifier?
  public let imageServiceURL: BVCodableSafe<URL>?
  public let imageURL: BVCodableSafe<URL>?
  public let origin: String?
  public let permalink: BVCodableSafe<URL>?
  public let remoteURL: BVCodableSafe<URL>?
  public let token: String?
  public let videoType: String?
  
  private enum CodingKeys: String, CodingKey {
    case code = "code"
    case displayURL = "display_url"
    case identifier = "id"
    case imageServiceURL = "image_service_url"
    case imageURL = "image_url"
    case origin = "origin"
    case permalink = "permalink"
    case remoteURL = "remote_url"
    case token = "token"
    case videoType = "video_type"
  }
}

public struct BVCurationsVideoSubmission: BVAuxiliaryable {
  public let imageURL: URL?
  public let remoteURL: URL?
  
  private enum CodingKeys: String, CodingKey {
    case imageURL = "imageUrl"
    case remoteURL = "remoteUrl"
  }
  
  init(imageURL: URL, remoteURL: URL) {
    self.imageURL = imageURL
    self.remoteURL = remoteURL
  }
}

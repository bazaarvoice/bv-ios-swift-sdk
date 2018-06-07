//
//  BVVideo.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVVideo type
/// - Note:
/// \
/// It conforms to BVSubmissionable and, therefore, it is used only for
/// BVSubmission.
public struct BVVideo: BVSubmissionable {
  
  public static var singularKey: String {
    get {
      return BVConversationsConstants.BVVideo.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVConversationsConstants.BVVideo.pluralKey
    }
  }
  
  public let caption: String?
  public let videoHost: String?
  public let videoId: String?
  public let videoIframeUrl: URL?
  public let videoThumbnailUrl: URL?
  public let videoUrl: URL?
  
  private enum CodingKeys: String, CodingKey {
    case caption = "Caption"
    case videoHost = "VideoHost"
    case videoId = "VideoId"
    case videoIframeUrl = "VideoIframeUrl"
    case videoThumbnailUrl = "VideoThumbnailUrl"
    case videoUrl = "VideoUrl"
  }
}

extension BVVideo {
  public init(_ url: URL, caption: String) {
    self.videoUrl = url
    self.caption = caption
    self.videoHost = nil
    self.videoId = nil
    self.videoIframeUrl = nil
    self.videoThumbnailUrl = nil
  }
}

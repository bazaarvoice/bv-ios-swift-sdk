//
//  BVVideo.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVVideo: Codable {
  let caption: String?
  let videoHost: String?
  let videoId: String?
  let videoIframeUrl: URL?
  let videoThumbnailUrl: URL?
  let videoUrl: URL?
  
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

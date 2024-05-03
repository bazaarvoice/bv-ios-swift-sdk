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
  
  private static var MaxVideoBytes: UInt = (250 * 1024 * 1024)

  public static var singularKey: String {
    return BVConversationsConstants.BVVideo.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVVideo.pluralKey
  }
  
  public let caption: String?
  public let contentType: ContentType?
  public let videoHost: String?
  public let videoId: String?
  public let videoIframeUrl: BVCodableSafe<URL>?
  public let videoThumbnailUrl: BVCodableSafe<URL>?
  public let videoUrl: BVCodableSafe<URL>?
  
    public func encode(to encoder: Encoder) throws {
      ((try? convertVideoToValidFormat()?.encode(to: encoder)) as ()??)  }
    
    public init(from decoder: Decoder) throws {
        contentType = nil
        caption = nil
        videoIframeUrl = nil
        let container = try decoder.container(keyedBy: CodingKeys.self)
        videoId = try container.decodeIfPresent(String.self, forKey: .videoId)
        videoHost = try container.decodeIfPresent(String.self, forKey: .videoHost)
        let videoThumbnailUrlString = try container.decodeIfPresent(String.self, forKey: .videoThumbnailUrl)
        self.videoThumbnailUrl = BVCodableSafe<URL>(URL(string: videoThumbnailUrlString ?? ""))
        let videoUrlString = try container.decodeIfPresent(String.self, forKey: .videoUrl)
        self.videoUrl = BVCodableSafe<URL>(URL(string: videoUrlString ?? ""))
    }
    
  private enum CodingKeys: String, CodingKey {
    case caption = "Caption"
    case contentType = "ContentType"
    case videoHost = "VideoHost"
    case videoId = "VideoId"
    case videoIframeUrl = "VideoIframeUrl"
    case videoThumbnailUrl = "VideoThumbnailUrl"
    case videoUrl = "VideoUrl"
  }
    
    public enum ContentType {
        case review
        
        internal var description: String {
            switch self {
            case .review:
                return "review"
            }
        }
    }
}

extension BVVideo {
  public init(_ url: URL, caption: String) {
    self.videoUrl = BVCodableSafe<URL>(url)
    self.caption = caption
    self.contentType = nil
    self.videoHost = nil
    self.videoId = nil
    self.videoIframeUrl = nil
    self.videoThumbnailUrl = nil
  }
    
    public init(_ url: URL, contentType: ContentType) {
      self.videoUrl = BVCodableSafe<URL>(url)
      self.contentType = contentType
      self.caption = nil
      self.videoHost = nil
      self.videoId = nil
      self.videoIframeUrl = nil
      self.videoThumbnailUrl = nil
    }
}

extension BVVideo {
    internal func encodeVideoToData() -> Data? {
      return convertVideoToValidFormat()
    }
    
    private func convertVideoToValidFormat() -> Data? {
        guard let videoUrl = self.videoUrl?.value else {
            return nil
        }
        do {
            let data = try Data(contentsOf: videoUrl)
            if BVVideo.MaxVideoBytes > data.count {
                return data
            } else {
                print("Video should be less than \(BVVideo.MaxVideoBytes) bytes")
                return Data()
            }
        } catch {
            print(error)
            return nil
        }
    }
}

extension BVVideo: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return "uploadvideo.json"
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}

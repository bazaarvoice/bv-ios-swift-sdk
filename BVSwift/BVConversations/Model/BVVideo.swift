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
  public let uploadVideo: Bool?

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
        uploadVideo = nil
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
  public init(_ url: URL, caption: String, uploadVideo: Bool = false) {
    self.videoUrl = BVCodableSafe<URL>(url)
    self.caption = caption
    self.contentType = .review
    self.videoHost = nil
    self.videoId = nil
    self.videoIframeUrl = nil
    self.videoThumbnailUrl = nil
    self.uploadVideo = uploadVideo
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

extension BVVideo: BVMergeable {
    internal typealias Mergeable = BVVideo
    
    static func merge(from: Mergeable, into: Mergeable) -> Mergeable {
        return BVVideo(
            caption: into.caption ?? from.caption ?? nil,
            contentType: into.contentType ?? from.contentType ?? nil,
            videoHost: into.videoHost ?? from.videoHost ?? nil,
            videoId: into.videoId ?? from.videoId ?? nil,
            videoIframeUrl: into.videoIframeUrl ?? from.videoIframeUrl ?? nil,
            videoThumbnailUrl: into.videoThumbnailUrl ?? from.videoThumbnailUrl ?? nil,
            videoUrl: into.videoUrl ?? from.videoUrl ?? nil,
            uploadVideo: into.uploadVideo ?? from.uploadVideo ?? false)
    }

    internal init(
        caption: String? = nil,
        contentType: BVVideo.ContentType? = nil,
        videoHost: String? = nil,
        videoId: String? = nil,
        videoIframeUrl: BVCodableSafe<URL>? = nil,
        videoThumbnailUrl: BVCodableSafe<URL>? = nil,
        videoUrl: BVCodableSafe<URL>? = nil,
        uploadVideo: Bool = false) {
            self.caption = caption
            self.contentType = contentType
            self.videoHost = videoHost
            self.videoId = videoId
            self.videoIframeUrl = videoIframeUrl
            self.videoThumbnailUrl = videoThumbnailUrl
            self.videoUrl = videoUrl
            self.uploadVideo = uploadVideo
        }
    
    func merge(_ into: BVVideo) -> BVVideo {
        return BVVideo.merge(from: self, into: into)
    }
}

extension BVVideo: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return "uploadvideo.json"
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}

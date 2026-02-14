//
//
//  BVPhoto.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit

/// The definition for the BVPhoto type
/// - Note:
/// \
/// It conforms to BVSubmissionable and, therefore, it is used only for
/// BVSubmission.
public struct BVPhoto: BVSubmissionable {
  
  private static var MaxImageBytes: UInt =  (5 * 1024 * 1024)
  
  public static var singularKey: String {
    return "Photo"
  }
  
  public static var pluralKey: String {
    return "Photos"
  }
  
  public let caption: String?
  public let contentType: ContentType?
  public let image: UIImage?
  public let photoId: String?
  public var photoSizes: [BVPhotoSize]? {
    return photoSizesArray?.array
  }
  private let photoSizesArray: BVCodableDictionary<BVPhotoSize>?
  
  public func encode(to encoder: Encoder) throws {
    ((try? convertImageToValidFormat()?.encode(to: encoder)) as ()??)  }
  
  public init(from decoder: Decoder) throws {
    image = nil
    contentType = nil
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    caption = try container.decodeIfPresent(String.self, forKey: .caption)
    photoId = try container.decodeIfPresent(String.self, forKey: .photoId)
    photoSizesArray =
      try container
        .decodeIfPresent(
          BVCodableDictionary<BVPhotoSize>.self,
          forKey: .photoSizesArray)
  }
  
  private enum CodingKeys: String, CodingKey {
    case caption = "Caption"
    case photoId = "Id"
    case photoSizesArray = "Sizes"
  }
  
  public enum ContentType {
    case answer
    case comment
    case question
    case review
    
    internal var description: String {
      switch self {
      case .answer:
        return "answer"
      case .comment:
        return "review_comment"
      case .question:
        return "question"
      case .review:
        return "review"
      }
    }
  }
  
  internal func encodeImageToData() -> Data? {
    return convertImageToValidFormat()
  }
  
  private func convertImageToValidFormat() -> Data? {
    guard let img = image else {
      return nil
    }
    
    var workingImage: UIImage = img
    
    guard var data =
      workingImage.jpegData(compressionQuality: 1.0) else {
        return nil
    }
    
    while BVPhoto.MaxImageBytes <= data.count {
      
      if let lossy: Data =
        workingImage.jpegData(compressionQuality: 0.9) {
        data = lossy
      }
      
      if BVPhoto.MaxImageBytes > data.count {
        break
      }
      
      let resize: CGSize =
        CGSize(
          width: workingImage.size.width * 0.5,
          height: workingImage.size.height * 0.5)
      
      guard let resizedImage: UIImage = workingImage.resize(resize),
        let resizedData: Data =
        resizedImage.jpegData(compressionQuality: 1.0) else {
          return nil
      }
      
      workingImage = resizedImage
      data = resizedData
    }
    
    return data
  }
}

public struct BVPhotoSize: Codable {
  public let sizeId: String?
  public let url: BVCodableSafe<URL>?
  
  private enum CodingKeys: String, CodingKey {
    case sizeId = "Id"
    case url = "Url"
  }
}

extension BVPhoto {
  public init(_ image: UIImage, _ caption: String? = nil, _ contentType: ContentType? = nil) {
    self.caption = caption
    self.contentType = contentType
    self.image = image
    self.photoId = nil
    self.photoSizesArray = nil
  }
}

extension BVPhoto: BVMergeable {
  internal typealias Mergeable = BVPhoto
  
  internal static func merge(from: Mergeable, into: Mergeable) -> Mergeable {
    return
      BVPhoto(
        caption: into.caption ?? from.caption ?? nil,
        contentType: into.contentType ?? from.contentType ?? nil,
        image: into.image ?? from.image ?? nil,
        photoId: into.photoId ?? from.photoId ?? nil,
        photoSizesArray: into.photoSizesArray ?? from.photoSizesArray ?? nil)
  }
  
  internal init(
    caption: String? = nil,
    contentType: BVPhoto.ContentType? = nil,
    image: UIImage? = nil,
    photoId: String? = nil,
    photoSizesArray: BVCodableDictionary<BVPhotoSize>? = nil) {
    self.caption = caption
    self.contentType = contentType
    self.image = image
    self.photoId = photoId
    self.photoSizesArray = photoSizesArray
  }
  
  internal func merge(_ into: BVPhoto) -> BVPhoto {
    return BVPhoto.merge(from: self, into: into)
  }
}

extension BVPhoto: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return "uploadphoto.json"
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}

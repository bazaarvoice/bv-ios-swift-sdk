//
//
//  BVPhotoSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal class BVPhotoSubmission: BVConversationsSubmission<BVPhoto> {
  
  override internal var contentBodyClosure:
    ((BVSubmissionableInternal) -> BVURLRequestBody?)? {
    get {
      return { (type: BVSubmissionableInternal) -> BVURLRequestBody? in
        guard let photo: BVPhoto = type as? BVPhoto,
          let photoData: Data = photo.encodeImageToData(),
          let config: BVConversationsConfiguration = self.configuration else {
            return nil
        }
        
        let checkConfigurationForSubmission = { () -> String? in
          switch config {
          case .all:
            fallthrough
          case .submission:
            return config.configurationKey
          default:
            return nil
          }
        }
        
        guard let passKey = checkConfigurationForSubmission(),
        let contentType = photo.contentType?.description else {
          return nil
        }
        
        let body: [String : Any] =
          [
            "apiversion" : "5.4",
            "passkey" : passKey,
            "contenttype" : contentType,
            "photo" : photoData
        ]
        
        return .multipart(body)
      }
    }
  }
  
  override internal var contentTypeClosure: (() -> String?)? {
    get {
      return {
        return "multipart/form-data; boundary=" +
        "\(URLRequest.defaultBoundary)"
      }
    }
  }
}

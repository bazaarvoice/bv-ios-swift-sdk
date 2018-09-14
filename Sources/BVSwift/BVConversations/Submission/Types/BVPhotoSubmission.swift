//
//
//  BVPhotoSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal class BVPhotoSubmission: BVConversationsSubmission<BVPhoto> {
  
  private var submissionBoundary: String?
  private var boundaryQueue: DispatchQueue =
    DispatchQueue(label: "com.bvswift.BVPhotoSubmission.boundaryQueue")
  
  private func generateBodyContent(
    _ type: BVSubmissionableInternal) -> [String: Any]? {
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
    
    return [
      apiVersionField: apiVersion,
      "passkey": passKey,
      "contenttype": contentType,
      "photo": photoData
    ]
  }
  
  private func generateBoundary(_ content: [String: Any]) -> String? {
    
    /// This is just in case we're changing the queue's for which these things
    /// will be initialized or kicked off from.
    boundaryQueue.sync {
      
      if nil != submissionBoundary {
        return
      }
      
      let multipartData = content.reduce(into: Data()) {
        switch $1.value {
        case let value as String:
          $0 += URLRequest
            .generateKeyValueForString(key: $1.key, string: value)
        case let value as Data:
          $0 += URLRequest
            .generateKeyValueForData(key: $1.key, data: value)
        default:
          break
        }
      }
      
      var tries = 10
      var boundary: String?
      let prefix = "----------"
      
      repeat {
        guard let candidate = String.random(20) else {
          continue
        }
        
        boundary = prefix + candidate
        guard let boundaryData = boundary?.toUTF8Data(),
          nil == multipartData.range(of: boundaryData) else {
            tries -= 1
            
            BVLogger.sharedLogger.debug(
              "Retrying multi-part boundary generation")
            
            continue
        }
        break
      } while 0 < tries
      
      submissionBoundary = boundary
    }
    
    return submissionBoundary
  }
  
  override internal var contentBodyTypeClosure: (
    (BVSubmissionableInternal) -> BVURLRequestBodyType?)? {
    return {
      guard let body = self.generateBodyContent($0),
        let boundary = self.generateBoundary(body) else {
          return nil
      }
      return .multipart(content: body, boundary: boundary)
    }
  }
}

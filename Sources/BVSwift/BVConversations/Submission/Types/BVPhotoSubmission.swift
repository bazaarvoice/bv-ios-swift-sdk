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
      
      let multipartData = content.reduce(Data())
      { (result: Data, keyValue: (key: String, value: Any)) -> Data in
        switch keyValue.value {
        case let value as String:
          return (result + URLRequest
            .generateKeyValueForString(key: keyValue.key, string: value))
        case let value as Data:
          return (result + URLRequest
            .generateKeyValueForData(key: keyValue.key, data: value))
        default:
          return result
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
  
  override internal var contentBodyClosure: (
    (BVSubmissionableInternal) -> BVURLRequestBody?)? {
    return {
      guard let body = self.generateBodyContent($0),
        let boundary = self.generateBoundary(body) else {
          return nil
      }
      return .multipart(content: body, boundary: boundary)
    }
  }
  
  override internal var contentTypeClosure: (
    (BVSubmissionableInternal) -> String?)? {
    /// Soooo 'multipart/form-data' is a tad annoying in that the boundary
    /// cannot exist anywhere within the data portion
    return {
      guard let body = self.generateBodyContent($0),
        let boundary = self.generateBoundary(body) else {
          return nil
      }
      return "multipart/form-data; boundary=" + boundary
    }
  }
}

//
//
//  BVVideoSubmission.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVVideoSubmission: BVConversationsSubmission<BVVideo> {
  
  private var submissionBoundary: String?
  private var boundaryQueue: DispatchQueue =
    DispatchQueue(label: "com.bvswift.BVVideoSubmission.boundaryQueue")
  private var fileName: String?
    
    public convenience init?(
        video: BVVideo) {
      self.init(video)
    }
    
    private override init?(_ video: BVVideo) {
      super.init(video)
    }

  private func generateBodyContent(
    _ type: BVSubmissionableInternal) -> [String: Any]? {
    guard let video: BVVideo = type as? BVVideo,
      let videoData: Data = video.encodeVideoToData() else {
        return nil
    }
    self.fileName = video.videoUrl?.value?.lastPathComponent
    
    guard let contentType = video.contentType?.description else {
        return nil
    }
    
    return [
      BVConversationsConstants.BVVideo.Keys.contentTypeKey: contentType,
      BVConversationsConstants.BVVideo.Keys.dataKey: videoData
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
                .generateKeyValueForData(key: $1.key, data: value, fileName: self.fileName ?? "upload.mp4")
        default:
          break
        }
      }
      
      var tries = 10
      var boundary: String?
      let prefix = "----------"
      
      repeat {
        boundary = prefix + URLRequest.generateBoundary(20)
        guard let boundaryData = boundary?.toUTF8Data(),
          nil == multipartData.range(of: boundaryData) else {
            tries -= 1
            
            BVLogger.sharedLogger.debug(
              BVLogMessage(
                BVConversationsConstants.bvProduct,
                msg: "Retrying multi-part boundary generation"))
            
            continue
        }
        break
      } while 0 < tries
      
      submissionBoundary = boundary
    }
    
    return submissionBoundary
  }
  
  override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
      return {
           var submissionParameters: [URLQueryItem] =
              [URLQueryItem(name: BVConversationsConstants.BVVideo.Keys.passKey,
                            value: self.configuration?.configurationKey),
               URLQueryItem(name: BVConversationsConstants.BVVideo.Keys.apiVersion,
                            value: Bundle.conversationsApiVersion)]
          return submissionParameters
      }
  }

  override internal var contentBodyTypeClosure: (
    (BVSubmissionableInternal) -> BVURLRequestBodyType?)? {
    return { [weak self] in
      guard let body = self?.generateBodyContent($0),
        let fileName = self?.fileName,
        let boundary = self?.generateBoundary(body) else {
          return nil
      }
        return .multipart(content: body, fileName: fileName, boundary: boundary)
    }
  }
}

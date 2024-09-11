//
//
//  BVMediaSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public utility class for handling Submissions with attached media
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/media)
public class
BVMediaSubmission<BVType: BVSubmissionable>: BVConversationsSubmission<BVType> {
  
  /// Private
  private var contentType: BVPhoto.ContentType? {
    switch BVType.self {
    case is BVAnswer.Type:
      return .answer
    case is BVComment.Type:
      return .comment
    case is BVQuestion.Type:
      return .question
    case is BVReview.Type:
      return .review
    default:
      return nil
    }
  }
  
  private var currentAction: BVConversationsSubmissionAction = .preview
  private var photos: [BVPhoto] = [BVPhoto]()
  private var videos: [BVVideo] = [BVVideo]()
  
  /// Internal
  final internal override
  var submissionPreflightResultsClosure: BVURLRequestablePreflightHandler? {
    switch currentAction {
    case .submit:
      let configurationHandler = {
        [weak self] () -> BVConversationsConfiguration? in
        return self?.conversationsConfiguration
      }
      
      let urlQueryItemHandler = {
        [weak self] (urlQueryItems: [URLQueryItem]?) in
        guard let items = urlQueryItems else {
          return
        }
        self?.submissionParameters ∪= items
      }
      
      return getMediaSubmissionHandler(
        configurationHandler: configurationHandler,
        urlQueryItemHandler: urlQueryItemHandler)
      
    default:
      return nil
    }
  }
  
  final internal override var submissionPostflightResultsClosure: (
    ([BVType]?) -> Void)? {
    return { [weak self] (results: [BVType]?) in
      self?.conversationsPostflightDidSubmitPhotoUpload(results)
      self?.conversationsPostflightDidSubmitVideoUpload(results)
      self?.conversationsPostflightDidSubmit(results)
    }
  }
  
  internal func conversationsPostflightDidSubmit(_ results: [BVType]?) {
    return
  }
  
  internal func conversationsPostflightDidSubmitPhotoUpload(
    _ results: [BVType]?) {
    return
  }
    
  internal func conversationsPostflightDidSubmitVideoUpload(
    _ results: [BVType]?) {
    return
  }
}

// MARK: - BVMediaSubmission: BVConversationsSubmissionActionable
extension BVMediaSubmission: BVConversationsSubmissionActionable {
  @discardableResult
  public func add(_ action: BVConversationsSubmissionAction) -> Self {
    guard let actionSet = action.urlQueryItems else {
      return self
    }
    submissionParameters = (actionSet ∪ submissionParameters)
    currentAction = action
    return self
  }
}

// MARK: - BVMediaSubmission: BVConversationsSubmissionMediable
extension BVMediaSubmission: BVConversationsSubmissionMediable {
  @discardableResult
  public func add(_ media: BVConversationsSubmissionMedia) -> Self {
    
    switch media {
    case let .photos(value):
      
      guard let type = contentType else {
        break
      }
      
      let contentTypePhoto: BVPhoto = BVPhoto(contentType: type)
      let actualPhotos: [BVPhoto] =
        value.compactMap {
          guard nil != $0.image else {
            return nil
          }
          return contentTypePhoto.merge($0)
      }
      
      photos += actualPhotos
    case let .videos(value):
        let contentTypeVideo: BVVideo = BVVideo(contentType: .review)
        let actualVideos: [BVVideo] =
          value.compactMap {
            guard nil != $0.videoUrl else {
              return nil
            }
            return contentTypeVideo.merge($0)
        }
        videos += actualVideos
    }
    
    return self
  }
}

extension BVMediaSubmission {
  internal func getMediaSubmissionHandler(
    configurationHandler: ((() -> BVConversationsConfiguration?)?),
    urlQueryItemHandler: (([URLQueryItem]?) -> Void)?) ->
    BVURLRequestablePreflightHandler? {
        
        guard let config = configurationHandler?() else {
            return nil
        }
        
        return { [weak self] handlerCompletion in
            
            guard let photos = self?.photos, let videos = self?.videos else {
                let noMediaError =
                BVCommonError.unknown(
                    "BVMediaSubmission isn't properly initialized, or it was " +
                    "reaped before it could execute.")
                handlerCompletion?(noMediaError)
                return
            }
            
            let concurrentQueue =
            DispatchQueue(
                label: "BVConversationsSubmission.BVMedia.concurrentQueue",
                qos: .userInitiated,
                attributes: .concurrent)
            
            let serialQueue =
            DispatchQueue(
                label: "BVConversationsSubmission.BVMedia.serialQueue")
            
            let concurrentGroup = DispatchGroup()
            
            concurrentQueue.async {
                
                var returnedPhotos: [BVPhoto] = []
                var returnedVideos: [BVVideo] = []
                var returnedErrors: [Error] = []
                
                for actualPhoto in photos {
                    
                    guard let photoSubmission = BVPhotoSubmission(photo: actualPhoto) else {
                        continue
                    }
                    
                    concurrentGroup.enter()
                    
                    BVLogger.sharedLogger.debug(
                        BVLogMessage(
                            BVConversationsConstants.bvProduct,
                            msg: "Attempting to Upload Photo"))
                    
                    photoSubmission
                        .configure(config)
                        .handler
                    { (result: BVConversationsSubmissionResponse<BVPhoto>) in
                        
                        if case let .failure(errors) = result {
                            serialQueue.sync {
                                returnedErrors += errors
                            }
                        }
                        
                        if case let .success(_, photo) = result {
                            serialQueue.sync {
                                returnedPhotos.append(actualPhoto.merge(photo))
                            }
                            
                            BVLogger.sharedLogger.debug(
                                BVLogMessage(
                                    BVConversationsConstants.bvProduct,
                                    msg: "Uploaded Photo"))
                        }
                        
                        concurrentGroup.leave()
                    }
                    
                    photoSubmission.async()
                }
                
                for actualVideo in videos {
                    
                    if actualVideo.uploadVideo ?? false {
                        
                        guard let videoSubmission = BVVideoSubmission(video: actualVideo) else {
                            continue
                        }
                        
                        concurrentGroup.enter()
                        
                        BVLogger.sharedLogger.debug(
                            BVLogMessage(
                                BVConversationsConstants.bvProduct,
                                msg: "Attempting to Upload Video"))
                        
                        videoSubmission
                            .configure(config)
                            .handler
                        { (result: BVConversationsSubmissionResponse<BVVideo>) in
                            
                            if case let .failure(errors) = result {
                                serialQueue.sync {
                                    returnedErrors += errors
                                }
                            }
                            
                            if case let .success(_, video) = result {
                                serialQueue.sync {
                                    returnedVideos.append(actualVideo.merge(video))
                                }
                                
                                BVLogger.sharedLogger.debug(
                                    BVLogMessage(
                                        BVConversationsConstants.bvProduct,
                                        msg: "Uploaded Video"))
                            }
                            
                            concurrentGroup.leave()
                        }
                        
                        videoSubmission.async()
                    } else {
                        returnedVideos.append(actualVideo)
                    }
                }
                
                concurrentGroup.notify(queue: concurrentQueue) {
                    if let error = returnedErrors.first {
                        handlerCompletion?(error)
                        return
                    }
                    
                    var queryItems = [URLQueryItem]()
                    queryItems = BVConversationsSubmissionMedia.photos(returnedPhotos).urlQueryItems ?? [URLQueryItem]()
                    queryItems += BVConversationsSubmissionMedia.videos(returnedVideos).urlQueryItems ?? [URLQueryItem]()
                    
                    urlQueryItemHandler?(queryItems)
                    
                    handlerCompletion?(nil)
                }
            }
        }
    }
}

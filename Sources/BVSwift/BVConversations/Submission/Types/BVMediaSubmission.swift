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
      
      return getPhotoSubmissionHandler(
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
      videos += value
    }
    
    return self
  }
}

extension BVMediaSubmission {
  internal func getPhotoSubmissionHandler(
    configurationHandler: ((() -> BVConversationsConfiguration?)?),
    urlQueryItemHandler: (([URLQueryItem]?) -> Void)?) ->
    BVURLRequestablePreflightHandler? {
      
      guard let config = configurationHandler?(),
        !photos.isEmpty else {
          return nil
      }
      
      return { [weak self] handlerCompletion in
        
        guard let photos = self?.photos,
          let videos = self?.videos else {
            let noMediaError =
              BVCommonError.unknown(
                "BVMediaSubmission isn't properly initialized, or it was " +
                "reaped before it could execute.")
            handlerCompletion?(noMediaError)
            return
        }
        
        self?.submissionParameters ∪=
          BVConversationsSubmissionMedia.videos(videos).urlQueryItems
        
        let concurrentQueue =
          DispatchQueue(
            label: "BVConversationsSubmission.BVPhoto.concurrentQueue",
            qos: .userInitiated,
            attributes: .concurrent)
        
        let serialQueue =
          DispatchQueue(
            label: "BVConversationsSubmission.BVPhoto.serialQueue")
        
        let concurrentGroup = DispatchGroup()
        
        concurrentQueue.async {
          
          var returnedPhotos: [BVPhoto] = []
          var returnedErrors: [Error] = []
          
          for actualPhoto in photos {
            
            guard let photoSubmission = BVPhotoSubmission(actualPhoto) else {
              continue
            }
            
            concurrentGroup.enter()
            
            BVLogger.sharedLogger.debug("Attempting to Upload Photo")
            
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
                  
                  BVLogger.sharedLogger.debug("Uploaded Photo")
                }
                
                concurrentGroup.leave()
            }
            
            photoSubmission.async()
          }
          
          concurrentGroup.notify(queue: concurrentQueue) {
            if let error = returnedErrors.first {
              handlerCompletion?(error)
              return
            }
            
            urlQueryItemHandler?(
              BVConversationsSubmissionMedia
                .photos(returnedPhotos).urlQueryItems)
            
            handlerCompletion?(nil)
          }
        }
      }
  }
}

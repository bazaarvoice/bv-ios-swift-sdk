//
//
//  BVMediaSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class
BVMediaSubmission<BVType: BVSubmissionable>: BVConversationsSubmission<BVType> {
  
  /// Private
  private var contentType: BVPhoto.ContentType? {
    get {
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
  }
  
  private var currentAction: BVConversationsSubmissionAction = .preview {
    didSet {
      primePreflightHandler()
    }
  }
  
  private var photos: [BVPhoto] = [] {
    didSet {
      primePreflightHandler()
    }
  }
  
  private var videos: [BVVideo] = [] {
    didSet {
      primePreflightHandler()
    }
  }
  
  /// Internal
  final internal override var conversationsPostflightResultsClosure:
    (([BVType]?) -> Swift.Void)? {
    get {
      return { (results: [BVType]?) in
        self.conversationsPostflightDidSubmitPhotoUpload(results)
        self.conversationsPostflightDidSubmit(results)
      }
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
    conversationsParameters = (actionSet ∪ conversationsParameters)
    currentAction = action
    return self
  }
}

// MARK: - BVMediaSubmission: BVConversationsSubmissionMediable
extension BVMediaSubmission: BVConversationsSubmissionMediable {
  public func add(_ media: BVConversationsSubmissionMedia) -> Self {
    
    switch media {
    case let .photos(value):
      
      guard let type = contentType else {
        break
      }
      
      let contentTypePhoto: BVPhoto = BVPhoto(contentType: type)
      let actualPhotos: [BVPhoto] =
        value.reduce([]) { (result: [BVPhoto], photo: BVPhoto) -> [BVPhoto] in
          guard let _ = photo.image else {
            return result
          }
          return result + [contentTypePhoto.merge(photo)]
      }
      
      photos += actualPhotos
      
      break
    case let .videos(value):
      videos += value
      break
    }
    
    return self
  }
  
  internal func primePreflightHandler() {
    
    switch currentAction {
    case .submit:
      let configurationHandler = { () -> BVConversationsConfiguration? in
        return self.conversationsConfiguration
      }
      
      let urlQueryItemHandler = { (urlQueryItems: [URLQueryItem]?) in
        guard let items = urlQueryItems else {
          return
        }
        self.conversationsParameters ∪= items
      }
      
      preflightHandler =
        getPhotoSubmissionHandler(
          configurationHandler: configurationHandler,
          urlQueryItemHandler: urlQueryItemHandler)
      
    default:
      preflightHandler = nil
    }
  }
}

extension BVMediaSubmission {
  internal func getPhotoSubmissionHandler(
    configurationHandler: ((() -> BVConversationsConfiguration?)?),
    urlQueryItemHandler: (([URLQueryItem]?) -> Swift.Void)?) ->
    BVURLRequestablePreflightHandler? {
      
      guard let config = configurationHandler?(),
        !photos.isEmpty else {
          return nil
      }
      
      return { handlerCompletion in
        
        self.conversationsParameters ∪=
          BVConversationsSubmissionMedia.videos(self.videos).urlQueryItems
        
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
          
          for actualPhoto in self.photos {
            
            guard let photoSubmission = BVPhotoSubmission(actualPhoto) else {
              continue
            }
            
            concurrentGroup.enter()
            
            BVLogger.sharedLogger.verbose("Attempting to Upload Photo")
            
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
                  
                  BVLogger.sharedLogger.verbose("Uploaded Photo")
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


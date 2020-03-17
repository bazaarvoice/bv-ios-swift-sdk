//
//
//  BVReviewHighlightsQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVReviewHighlightsQuery<BVType: BVQueryable>: BVQuery<BVType> {
        
    private var ignoreCompletion: Bool = false
    private var reviewHighlightsConfiguration: BVReviewHighlightsConfiguration?
    
    private func postSuperInit() {
        
        let superPreflightHandler = preflightHandler
        
        preflightHandler = { [weak self] completion in
            
            self?.reviewHighlightsQueryPreflight({ (errors: Error?) in
                /// First we call this subclass level to see if everything is alright.
                /// If not, then we call the completion handler to error out.
                guard nil == errors else {
                  completion?(errors)
                  return
                }
                
                /// There doesn't exist any super preflight, therefore, we just pass
                /// through no errors up through the completion handler.
                guard let superPreflight = superPreflightHandler else {
                  completion?(nil)
                  return
                }
                
                /// If everything is alright, then drop down to the superclass level
                /// and let it determine the fate of the preflight check.
                superPreflight(completion)
            })
        }
    }
    
    internal override init<BVTypeInternal: BVQueryableInternal>(
      _ type: BVTypeInternal.Type) {
      super.init(type)
        
     postSuperInit()
    }
    
    final internal override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
      return { [weak self] in
        return self?.queryItems
      }
    }
    
    internal var
    reviewHighlightsPreflightResultsClosure: BVURLRequestablePreflightHandler? {
      return nil
    }
    
    internal var reviewHighlightsPostflightResultsClosure: (
      ([ReviewHighlightsPostflightResult]?) -> Void)? {
      return nil
    }
}

/// Conformance with BVQueryActionable. Please see protocol definition for more
/// information.
extension BVReviewHighlightsQuery: BVQueryActionable {
  public typealias Kind = BVType
  public typealias Response = BVReviewHighlightsQueryResponse<Kind>
  
  public var ignoringCompletion: Bool {
    get {
      return ignoreCompletion
    }
    set(newValue) {
      ignoreCompletion = newValue
    }
  }
  
  @discardableResult
  public func handler(completion: @escaping ((Response) -> Void)) -> Self {
    
    responseHandler = { [weak self] in
      
      if self?.ignoreCompletion ?? true {
        return
      }
      
      switch $0 {
      case let .success(_, jsonData):
        
        #if DEBUG
        do {
          let jsonObject =
            try JSONSerialization.jsonObject(with: jsonData, options: [])
            print(jsonObject)
          BVLogger.sharedLogger.debug(
            BVLogMessage(
              BVConversationsConstants.bvProduct,
              msg: "RAW JSON:\n\(jsonObject)"))
        } catch {
          BVLogger.sharedLogger.error(
            BVLogMessage(
              BVConversationsConstants.bvProduct,
              msg: "JSON ERROR: \(error)"))
        }
        #endif
        
        guard let response: BVReviewHighlightsQueryResponseInternal<BVType> =
            try? JSONDecoder()
                .decode(
                    BVReviewHighlightsQueryResponseInternal<BVType>.self,
                    from: jsonData) else {
                        completion(
                            .failure(
                                [BVCommonError.unknown(
                                    "An Unknown parse error occurred")]))
                        return
        }
        
        guard let reviewHighlights = response.reviewHighlights else {
            completion(
            .failure(
                [BVCommonError.unknown(
                    "An Unknown parse error occurred")])
            )
            return
        }

        completion(.success(reviewHighlights))
        print(response)


//        guard let profile = response.profile else {
//          completion(
//            .failure(
//              [BVCommonError.unknown(
//                "An Unknown parse error occurred")]))
//          return
//        }
//
//        completion(.success(response, [profile]))
//        self?.recommendationsPostflight([profile])
        
      case let .failure(errors):
        completion(.failure(errors))
      }
    }
    
    return self
  }
}

// MARK: - BVRecommendationsQuery: BVConfigurableInternal
extension BVReviewHighlightsQuery: BVConfigurableInternal {
  var configuration: BVReviewHighlightsConfiguration? {
    return reviewHighlightsConfiguration
  }
}


extension BVReviewHighlightsQuery: BVConfigurable {
    
    typealias Configuration = BVReviewHighlightsConfiguration
    
    @discardableResult
    func configure(_ config: BVReviewHighlightsConfiguration) -> Self {
        assert(nil == reviewHighlightsConfiguration)
        reviewHighlightsConfiguration = config
        
        configureExistentially(config)
        
        return self
    }
    
}

// MARK: - BVReviewHighlightsQuery: BVReviewHighlightsQueryPreflightable
extension BVReviewHighlightsQuery: BVReviewHighlightsQueryPreflightable {
    
    func reviewHighlightsQueryPreflight(_ preflight: BVCompletionWithErrorsHandler?) {
        guard let preflightResultsClosure =
          reviewHighlightsPreflightResultsClosure else {
            preflight?(nil)
            return
        }
        preflightResultsClosure(preflight)
    }
}

// MARK: - BVReviewHighlightsQuery: BVReviewHighlightsQueryPostflightable
extension BVReviewHighlightsQuery: BVReviewHighlightsQueryPostflightable {
  internal typealias ReviewHighlightsPostflightResult = BVType
  
  func reviewHighlightsPostflight(_ results: [BVType]?) {
   reviewHighlightsPostflightResultsClosure?(results)
  }
}

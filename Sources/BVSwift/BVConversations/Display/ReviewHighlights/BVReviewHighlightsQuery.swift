//
//
//  BVReviewHighlightsQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVReviewHighlightsQuery<BVType: BVQueryable>: BVQuery<BVType> {
    
    public var productId: String?
    
    private var ignoreCompletion: Bool = false
    private var reviewHighlightsConfiguration: BVReviewHighlightsConfiguration?
    
    private func postSuperInit() {
        
        let superPreflightHandler = preflightHandler
        
        preflightHandler = { [weak self] completion in
            
            
        }
    }
    
    
//    public init(productId: String) {
//        self.productId = productId
//        super.init(BVReviewHighlightsQueryResponse.self)
//    }
    
    internal override init<BVTypeInternal: BVQueryableInternal>(
      _ type: BVTypeInternal.Type) {
      super.init(type)
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
          BVLogger.sharedLogger.debug(
            BVLogMessage(
              BVRecommendationsConstants.bvProduct,
              msg: "RAW JSON:\n\(jsonObject)"))
        } catch {
          BVLogger.sharedLogger.error(
            BVLogMessage(
              BVRecommendationsConstants.bvProduct,
              msg: "JSON ERROR: \(error)"))
        }
        #endif
        
//        guard let response: BVRecommendationsQueryResponseInternal<BVType> =
//          try? JSONDecoder()
//            .decode(
//              BVRecommendationsQueryResponseInternal<BVType>.self,
//              from: jsonData) else {
//                completion(
//                  .failure(
//                    [BVCommonError.unknown(
//                      "An Unknown parse error occurred")]))
//                return
//        }
//
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
        
      case let .failure(errors): break
        //completion(.failure(errors))
      }
    }
    
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

//
//
//  BVRecommendationsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Base public class for handling Recommendation Queries
/// - Note:
/// \
/// This really only exists publicly as a convenience to the actual type
/// specific queries. There shouldn't be any need to subclass this if you're an
/// external developer; unless of course you're fixing bugs or extending
/// something that you want to see being made public :)
public class BVRecommendationsQuery<BVType: BVQueryable>: BVQuery<BVType> {
  private var ignoreCompletion: Bool = false
  private var recommendationsConfiguration: BVRecommendationsConfiguration?
  
  internal override init<BVTypeInternal: BVQueryableInternal>(
    _ type: BVTypeInternal.Type) {
    super.init(type)
    
    /// This entire set of client calls will leverage the cache
    usesURLCache = true
    
    add(.unsafe(sdkVersionField, sdkVersion, nil))
  }
  
  final internal override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    return {
      return self.queryItems
    }
  }
  
  internal var recommendationsPostflightResultsClosure: (
    ([RecommendationsPostflightResult]?) -> Swift.Void)? {
    return nil
  }
}

/// Conformance with BVConfigurable. Please see protocol definition for more
/// information.
extension BVRecommendationsQuery: BVConfigurable {
  public typealias Configuration = BVRecommendationsConfiguration
  
  @discardableResult
  final public func configure(_ config: Configuration) -> Self {
    
    assert(nil == recommendationsConfiguration)
    recommendationsConfiguration = config
    
    /// We update here just in case various things step on top of each
    /// other. We may want to revisit this if this becomes a pain
    /// point
    update(
      .unsafe(
        BVRecommendationsConstants.parameterKey, config.configurationKey, nil))
    update(
      .unsafe(BVRecommendationsConstants.clientKey, config.type.clientId, nil))
    
    /// Make sure we call through to the superclass
    configureExistentially(config)
    
    return self
  }
}

// MARK: - BVRecommendationsQuery: BVConfigurableInternal
extension BVRecommendationsQuery: BVConfigurableInternal {
  var configuration: BVRecommendationsConfiguration? {
    return recommendationsConfiguration
  }
}

/// Conformance with BVQueryActionable. Please see protocol definition for more
/// information.
extension BVRecommendationsQuery: BVQueryActionable {
  public typealias Kind = BVType
  public typealias Response = BVRecommendationsQueryResponse<Kind>
  
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
    
    responseHandler = {
      
      if self.ignoreCompletion {
        return
      }
      
      switch $0 {
      case let .success(_, jsonData):
        
        #if DEBUG
        do {
          let jsonObject =
            try JSONSerialization.jsonObject(with: jsonData, options: [])
          BVLogger.sharedLogger.debug("RAW JSON:\n\(jsonObject)")
        } catch {
          BVLogger.sharedLogger.error("JSON ERROR: \(error)")
        }
        #endif
        
        guard let response: BVRecommendationsQueryResponseInternal<BVType> =
          try? JSONDecoder()
            .decode(
              BVRecommendationsQueryResponseInternal<BVType>.self,
              from: jsonData) else {
                completion(
                  .failure(
                    [BVCommonError.unknown(
                      "An Unknown parse error occurred")]))
                return
        }
        
        guard let profile = response.profile else {
          completion(
            .failure(
              [BVCommonError.unknown(
                "An Unknown parse error occurred")]))
          return
        }
        
        completion(.success(response, [profile]))
        self.recommendationsPostflight([profile])
        
      case let .failure(errors):
        completion(.failure(errors))
      }
    }
    
    return self
  }
}

// MARK: - BVRecommendationsQuery: BVRecommendationsQueryPostflightable
extension BVRecommendationsQuery: BVRecommendationsQueryPostflightable {
  internal typealias RecommendationsPostflightResult = BVType
  
  func recommendationsPostflight(_ results: [BVType]?) {
    recommendationsPostflightResultsClosure?(results)
  }
}

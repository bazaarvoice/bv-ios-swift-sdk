//
//
//  BVConversationsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Base public class for handling Conversation Queries
/// - Note:
/// \
/// This really only exists publicly as a convenience to the actual type
/// specific queries. There shouldn't be any need to subclass this if you're an
/// external developer; unless of course you're fixing bugs or extending
/// something that you want to see being made public :)
public class BVConversationsQuery<BVType: BVQueryable>: BVQuery<BVType> {
  private var ignoreCompletion: Bool = false
  private var paramsPriv: [BVConversationsQueryParameter]
  private var conversationsConfiguration: BVConversationsConfiguration?
  
  internal override init<BVTypeInternal : BVQueryableInternal>(
    _ type: BVTypeInternal.Type) {
    
    paramsPriv =
      BVConversationsConstants.BVQueryable.defaultParameters
        .map { .custom($0.0, $0.1, nil) }
    
    super.init(type)
  }
  
  final internal override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    get {
      return {
        return self.queryItems
      }
    }
  }
  
  internal var conversationsPostflightResultsClosure:
    (([ConversationsPostflightResult]?) -> Swift.Void)? {
    get {
      return nil
    }
  }
}

/// Conformance with BVQueryActionable. Please see protocol definition for more
/// information.
extension BVConversationsQuery: BVQueryActionable {
  public typealias Kind = BVType
  public typealias Response =
    BVConversationsQueryResponse<Kind>
  
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
        
        guard let response: BVConversationsQueryResponseInternal<BVType> =
          try? JSONDecoder()
            .decode(
              BVConversationsQueryResponseInternal<BVType>.self,
              from: jsonData) else {
                completion(
                  .failure(
                    [BVCommonError.unknown(
                      "An Unknown parse error occurred")]))
                return
        }
        
        if let errors:[Error] = response.errors,
          !errors.isEmpty {
          completion(.failure(errors))
          return
        }
        
        if let hasErrors:Bool = response.hasErrors {
          assert(!hasErrors, "Weird, we have an error flag set but no errors?")
        }
        
        completion(.success(response, response.results ?? []))
        self.conversationsPostflight(response.results)
        
        break
      case let .failure(errors):
        completion(.failure(errors))
      }
    }
    
    return self
  }
}

/// Conformance with BVConfigurable. Please see protocol definition for more
/// information.
extension BVConversationsQuery: BVConfigurable {
  public typealias Configuration = BVConversationsConfiguration
  
  @discardableResult
  final public func configure(_ config: Configuration) -> Self {
    
    assert(nil == conversationsConfiguration)
    conversationsConfiguration = config
    
    /// We update here just in case various things step on top of each
    /// other. We may want to revisit this if this becomes a pain
    /// point
    update(
      .custom(
        BVConversationsConstants.parameterKey,
        config.configurationKey, nil))
    update(
      .custom(
        BVConversationsConstants.clientKey,
        config.type.clientId, nil))
    
    /// Make sure we call through to the superclass
    configureExistentially(config)
    
    return self
  }
}

//// Conformance with BVConversationsQueryCustomizable. Please see protocol
/// definition for more information.
extension BVConversationsQuery: BVConversationsQueryCustomizable {
  @discardableResult
  final public func custom(
    _ field: CustomStringConvertible, value: CustomStringConvertible) -> Self {
    let custom:BVConversationsQueryParameter = .custom(field, value, nil)
    add(custom)
    return self
  }
}

// MARK: - BVConversationsQuery: BVConversationsQueryPostflightable
extension BVConversationsQuery: BVConversationsQueryPostflightable {
  internal typealias ConversationsPostflightResult = BVType
  
  func conversationsPostflight(_ results: [BVType]?) {
    conversationsPostflightResultsClosure?(results)
  }
}

// MARK: - BVConversationsQuery: BVConfigurableInternal
extension BVConversationsQuery: BVConfigurableInternal {
  var configuration: BVConversationsConfiguration? {
    get {
      return conversationsConfiguration
    }
  }
}

// MARK: - BVConversationsQuery: BVURLParameterableInternal
extension BVConversationsQuery: BVURLParameterableInternal {
  
  final internal var parameters: [BVConversationsQueryParameter] {
    get {
      return paramsPriv
    }
  }
  
  final internal func add(
    _ parameter: BVConversationsQueryParameter, coalesce: Bool = false) {
    
    guard coalesce else {
      if 0 == paramsPriv.filter({ $0 === parameter }).count {
        paramsPriv.append(parameter)
      }
      return
    }
    
    var coalesceList:[BVConversationsQueryParameter] = []
    var otherList:[BVConversationsQueryParameter] = []
    paramsPriv.forEach { (param: BVConversationsQueryParameter) in
      if param %% parameter {
        coalesceList.append(param)
      } else {
        otherList.append(param)
      }
    }
    
    let coalesce:BVConversationsQueryParameter =
      coalesceList.reduce(parameter, +)
    otherList.append(coalesce)
    
    paramsPriv = otherList
  }
  
  final internal func update(_ parameter: BVConversationsQueryParameter) {
    var paramsTemp:[BVConversationsQueryParameter] =
      paramsPriv.filter { $0 != parameter }
    paramsTemp.append(parameter)
    
    paramsPriv = paramsTemp
  }
}

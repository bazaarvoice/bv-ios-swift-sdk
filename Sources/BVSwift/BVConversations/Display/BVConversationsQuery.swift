//
//
//  BVConversationsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

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

// MARK: - BVConversationsQuery: BVConversationsQueryPostflightable
extension BVConversationsQuery: BVConversationsQueryPostflightable {
  internal typealias ConversationsPostflightResult = BVType
  
  func conversationsPostflight(_ results: [BVType]?) {
    conversationsPostflightResultsClosure?(results)
  }
}

// MARK: - BVConversationsQuery: BVQueryActionable
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
  
  @discardableResult public func handler(
    completion: @escaping ((Response) -> Void)) -> Self {
    
    responseHandler = {
      
      if self.ignoreCompletion {
        return
      }
      
      switch $0 {
      case let .success(_, data):
        
        guard let response: BVConversationsQueryResponseInternal<BVType> =
          try? JSONDecoder()
            .decode(
              BVConversationsQueryResponseInternal<BVType>.self,
              from: data) else {
                var err = BVCommonError.unknown("N/A")
                
                #if DEBUG
                  do {
                    let _ = try JSONDecoder()
                      .decode(
                        BVConversationsQueryResponseInternal<BVType>.self,
                        from: data)
                  } catch {
                    err = BVCommonError.parse(error)
                  }
                #endif
                
                completion(.failure([err]))
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

// MARK: - BVConversationsQuery: BVConfigurable
extension BVConversationsQuery: BVConfigurable {
  public typealias Configuration = BVConversationsConfiguration
  
  @discardableResult final public func configure(
    _ config: Configuration) -> Self {
    
    assert(nil == conversationsConfiguration)
    conversationsConfiguration = config
    
    /// We update here just in case various things step on top of each
    /// other. We may want to revisit this if this becomes a pain
    /// point
    update(parameter: .custom(
      BVConstants.BVConversations.parameterKey, config.configurationKey, nil))
    update(parameter:
      .custom(
        BVConfigurationType.clientKey, config.type.clientId, nil))
    
    /// Make sure we call through to the superclass
    configureExistentially(config)
    
    return self
  }
}

// MARK: - BVConversationsQuery: BVConfigurableInternal
extension BVConversationsQuery: BVConfigurableInternal {
  var configuration: BVConversationsConfiguration? {
    return conversationsConfiguration
  }
}

// MARK: - BVConversationsQuery: BVConversationsQueryCustomizable
extension BVConversationsQuery: BVConversationsQueryCustomizable {
  @discardableResult final public func custom(
    _ field: CustomStringConvertible, value: CustomStringConvertible) -> Self {
    let custom:BVConversationsQueryParameter = .custom(field, value, nil)
    add(parameter: custom)
    return self
  }
}

// MARK: - BVQuery: BVURLParameterableInternal
extension BVConversationsQuery: BVURLParameterableInternal {
  
  final internal var parameters: [BVConversationsQueryParameter] {
    return paramsPriv
  }
  
  final internal func add(
    parameter: BVConversationsQueryParameter, coalesce: Bool = false) {
    
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
  
  final internal func update(parameter: BVConversationsQueryParameter) {
    var paramsTemp:[BVConversationsQueryParameter] =
      paramsPriv.filter { $0 != parameter }
    paramsTemp.append(parameter)
    
    paramsPriv = paramsTemp
  }
}

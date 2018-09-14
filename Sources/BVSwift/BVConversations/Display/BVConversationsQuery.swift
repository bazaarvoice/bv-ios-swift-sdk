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
  private var conversationsConfiguration: BVConversationsConfiguration?
  
  private func postSuperInit() {
    defaultSDKParameters.forEach { add(.unsafe($0.0, $0.1, nil)) }
    
    /// We do this after super.init() so that in the future we can capture any
    /// call being set from below.
    let superPreflightHandler = preflightHandler
    
    /// We have to make sure that we don't "own" ourself to create a retain
    /// cycle.
    preflightHandler = { [unowned self] completion in
      self.conversationsQueryPreflight { (errors: Error?) in
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
      }
    }
  }
  
  internal override init<BVTypeInternal: BVQueryableInternal>(
    _ type: BVTypeInternal.Type) {
    super.init(type)
    postSuperInit()
  }
  
  final internal override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    return {
      return self.queryItems
    }
  }
  
  internal var queryPreflightResultsClosure: BVURLRequestablePreflightHandler? {
    return nil
  }
  
  internal var queryPostflightResultsClosure: (
    ([ConversationsQueryPostflightResult]?) -> Swift.Void)? {
    return nil
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
        
        if let errors: [Error] = response.errors,
          !errors.isEmpty {
          completion(.failure(errors))
          return
        }
        
        if let hasErrors: Bool = response.hasErrors {
          assert(!hasErrors, "Weird, we have an error flag set but no errors?")
        }
        
        completion(.success(response, response.results ?? []))
        self.conversationsQueryPostflight(response.results)
        
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
      .unsafe(
        BVConversationsConstants.parameterKey,
        config.configurationKey, nil))
    update(
      .unsafe(
        BVConversationsConstants.clientKey,
        config.type.clientId, nil))
    
    /// Make sure we call through to the superclass
    configureExistentially(config)
    
    return self
  }
}

/// Conformance with BVQueryUnsafeField. Please see protocol
/// definition for more information.
extension BVConversationsQuery: BVQueryUnsafeField {
  @discardableResult
  final public func unsafe(
    _ field: CustomStringConvertible, value: CustomStringConvertible) -> Self {
    let custom: BVURLParameter = .unsafe(field, value, nil)
    add(custom)
    return self
  }
}

// MARK: - BVConversationsQuery: BVConversationsQueryPreflightable
extension BVConversationsQuery: BVConversationsQueryPreflightable {
  func conversationsQueryPreflight(
    _ preflight: BVCompletionWithErrorsHandler?) {
    /// We have to make sure to call through, else the preflight chain will not
    /// end up firing through to the superclass.
    guard let preflightResultsClosure = queryPreflightResultsClosure else {
      preflight?(nil)
      return
    }
    preflightResultsClosure(preflight)
  }
}

// MARK: - BVConversationsQuery: BVConversationsQueryPostflightable
extension BVConversationsQuery: BVConversationsQueryPostflightable {
  internal typealias ConversationsQueryPostflightResult = BVType
  
  func conversationsQueryPostflight(_ results: [BVType]?) {
    queryPostflightResultsClosure?(results)
  }
}

// MARK: - BVConversationsQuery: BVConfigurableInternal
extension BVConversationsQuery: BVConfigurableInternal {
  var configuration: BVConversationsConfiguration? {
    return conversationsConfiguration
  }
}

/// Helper class method for coalescing the filters
extension BVConversationsQuery {
  internal class func
    groupFilters<Filter: BVQueryFilter>(
    _ list: [(Filter, BVConversationsFilterOperator)]) ->
    [[(Filter, BVConversationsFilterOperator)]] {
      let accum = [String: [(Filter, BVConversationsFilterOperator)]]()
      return Array(list.reduce(into: accum) {
        var result: [(Filter, BVConversationsFilterOperator)]
        switch $1.1 {
        case .equalTo:
          fallthrough
        case .notEqualTo:
          result = [$1] + ($0["\($1.0):\($1.1)"] ?? [])
        default:
          result = [$1]
        }
        
        $0["\($1.0):\($1.1)"] = result
        }.values)
  }
}

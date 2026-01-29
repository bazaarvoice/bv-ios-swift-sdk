//
//
//  BVContentCoachQuery.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Base public class for handling Content Coach Queries
/// - Note:
/// \
/// This really only exists publicly as a convenience to the actual type
/// specific queries. There shouldn't be any need to subclass this if you're an
/// external developer; unless of course you're fixing bugs or extending
/// something that you want to see being made public :)
///

public class BVContentCoachQuery<BVType: BVQueryable>: BVQuery<BVType> {
        
    private var ignoreCompletion: Bool = false
    private var contentCoachConfiguration: BVConversationsConfiguration?
    
    private func postSuperInit() {
        defaultSDKParameters.forEach { add(.unsafe($0.0, $0.1, nil)) }

        /// We do this after super.init() so that in the future we can capture any
        /// call being set from below.
        let superPreflightHandler = preflightHandler
        
        /// We have to make sure that we don't "own" ourself to create a retain
        /// cycle.
        preflightHandler = { [weak self] completion in
            
            self?.contentCoachQueryPreflight({ (errors: Error?) in
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
    
    internal var contentCoachPreflightResultsClosure: BVURLRequestablePreflightHandler? {
      return nil
    }
    
    internal var contentCoachPostflightResultsClosure: (
      (ContentCoachPostflightResult?) -> Void)? {
      return nil
    }
}

/// Conformance with BVQueryActionable. Please see protocol definition for more
/// information.
extension BVContentCoachQuery: BVQueryActionable {
  public typealias Kind = BVType
  public typealias Response = BVContentCoachQueryResponse<Kind>
  
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
                BVConversationsConstants.bvProduct,
                msg: "RAW JSON:\n\(jsonObject)"))
          } catch {
            BVLogger.sharedLogger.error(
              BVLogMessage(
                BVConversationsConstants.bvProduct, msg: "JSON ERROR: \(error)"))
          }
          #endif
          
          guard let response: BVType = try? JSONDecoder().decode(BVType.self, from: jsonData) else {
                  completion(.failure(
                      [BVCommonError.unknown("An Unknown parse error occurred")]))
                  return
          }

            completion(.success(response))
            self?.contentCoachPostflight(response)
          
        case let .failure(errors):
          completion(.failure(errors))
        }
      }
    
    return self
  }
}

// MARK: - BVContentCoachQuery: BVConfigurableInternal
extension BVContentCoachQuery: BVConfigurableInternal {
  var configuration: BVConversationsConfiguration? {
    return contentCoachConfiguration
  }
}

/// Conformance with BVConfigurable. Please see protocol definition for more
/// information.
extension BVContentCoachQuery: BVConfigurable {
    
    
    public typealias Configuration = BVConversationsConfiguration
    
    @discardableResult
    final public func configure(_ config: BVConversationsConfiguration) -> Self {
        assert(nil == contentCoachConfiguration)
        contentCoachConfiguration = config
        
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

// MARK: - BVContentCoachQuery: BVContentCoachQueryPreflightable
extension BVContentCoachQuery: BVContentCoachQueryPreflightable {
    
    func contentCoachQueryPreflight(_ preflight: BVCompletionWithErrorsHandler?) {
        /// We have to make sure to call through, else the preflight chain will not
        /// end up firing through to the superclass.
        guard let preflightResultsClosure =
          contentCoachPreflightResultsClosure else {
            preflight?(nil)
            return
        }
        preflightResultsClosure(preflight)
    }
}

// MARK: - BVContentCoachQuery: BVContentCoachQueryPostflightable
extension BVContentCoachQuery: BVContentCoachQueryPostflightable {
  internal typealias ContentCoachPostflightResult = BVType
  
  func contentCoachPostflight(_ contentCoach: BVType?) {
   contentCoachPostflightResultsClosure?(contentCoach)
  }
}

/// Conformance with BVQueryUnsafeField. Please see protocol
/// definition for more information.
extension BVContentCoachQuery: BVQueryUnsafeField {
  @discardableResult
  final public func unsafe(
    _ field: CustomStringConvertible, value: CustomStringConvertible) -> Self {
    let custom: BVURLParameter = .unsafe(field, value, nil)
    add(custom)
    return self
  }
}

extension BVContentCoachQuery {
    public func formatType(_ value: BVFormatStatsType) -> Self {
        let formatType: BVURLParameter = .field(BVFormatStats(value), nil)
        add(formatType)
        return self
    }
}

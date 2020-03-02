//
//
//  BVCurationsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Base public class for handling Curations Queries
/// - Note:
/// \
/// This really only exists publicly as a convenience to the actual type
/// specific queries. There shouldn't be any need to subclass this if you're an
/// external developer; unless of course you're fixing bugs or extending
/// something that you want to see being made public :)
public class BVCurationsQuery<BVType: BVQueryable>: BVQuery<BVType> {
  private var ignoreCompletion: Bool = false
  private var curationsConfiguration: BVCurationsConfiguration?
  
  internal override init<BVTypeInternal: BVQueryableInternal>(
    _ type: BVTypeInternal.Type) {
    super.init(type)
  }
  
  final internal override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    return { [weak self] in
      return self?.queryItems
    }
  }
  
  internal var curationsPostflightResultsClosure: (
    ([CurationsPostflightResult]?) -> Void)? {
    return nil
  }
}

/// Conformance with BVConfigurable. Please see protocol definition for more
/// information.
extension BVCurationsQuery: BVConfigurable {
  public typealias Configuration = BVCurationsConfiguration
  
  @discardableResult
  final public func configure(_ config: Configuration) -> Self {
    
    assert(nil == curationsConfiguration)
    curationsConfiguration = config
    
    /// We update here just in case various things step on top of each
    /// other. We may want to revisit this if this becomes a pain
    /// point
    update(
      .unsafe(BVCurationsConstants.parameterKey, config.configurationKey, nil))
    update(
      .unsafe(BVCurationsConstants.clientKey, config.type.clientId, nil))
    
    /// Make sure we call through to the superclass
    configureExistentially(config)
    
    return self
  }
}

// MARK: - BVCurationsQuery: BVConfigurableInternal
extension BVCurationsQuery: BVConfigurableInternal {
  var configuration: BVCurationsConfiguration? {
    return curationsConfiguration
  }
}

/// Conformance with BVQueryActionable. Please see protocol definition for more
/// information.
extension BVCurationsQuery: BVQueryActionable {
  public typealias Kind = BVType
  public typealias Response = BVCurationsQueryResponse<Kind>
  
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
              BVCurationsConstants.bvProduct, msg: "RAW JSON:\n\(jsonObject)"))
        } catch {
          BVLogger.sharedLogger.error(
            BVLogMessage(
              BVCurationsConstants.bvProduct, msg: "JSON ERROR: \(error)"))
        }
        #endif
        
        do {
          
          let response: BVCurationsQueryResponseInternal<BVType> =
            try JSONDecoder()
              .decode(
                BVCurationsQueryResponseInternal<BVType>.self,
                from: jsonData)
          
          if let errors: [Error] = response.errors,
            !errors.isEmpty {
            completion(.failure(errors))
            return
          }
          
          if let code = response.code,
            let status = response.status,
            200 < code {
            let statusError = BVCurationsError.status(UInt16(code), status)
            completion(
              .failure([BVCurationsError.query(statusError)]))
            return
          }
          
          completion(.success(response, response.results ?? []))
          self?.curationsPostflight(response.results)
          
        } catch {
          
          /// The JSON parsing failed but let's make sure it's because we
          /// weren't sent JSON and therefore can assume an API error and not
          /// some malformed object or mismatched internal JSON types.
          guard let decodingError = error as? DecodingError,
            case .dataCorrupted = decodingError else {
              completion(
                .failure(
                  [BVCommonError.unknown(
                    "An Unknown parse error occurred")]))
              return
          }
          
          /// Check to see if we're dealing with XML
          guard nil != BVXMLParser().parse(jsonData) else {
            
            var errMessage = "An Unknown parse error occurred"
            if let msg = String(bytes: jsonData, encoding: .utf8),
              msg.lowercased() ==
                BVCurationsConstants
                  .ErrorMessages.invalidApproveOrBypassField {
              errMessage = "A non-Boolean is in the approve " +
              "or bypass parameter(s)"
            }
            
            let invalidParameter =
              BVCurationsError.invalidParameter(errMessage)
            completion(
              .failure(
                [BVCurationsError.query(invalidParameter)]))
            return
          }
          
          /// For now we ignore the XML results since the only error value can
          /// be the invalid passkey.
          let invalidPasskey =
            BVCurationsError.invalidPasskey
          completion(
            .failure(
              [BVCurationsError.query(invalidPasskey)]))
          return
        }
      case let .failure(errors):
        completion(.failure(errors))
      }
    }
    
    return self
  }
}

// MARK: - BVCurationsQuery: BVCurationsQueryPostflightable
extension BVCurationsQuery: BVCurationsQueryPostflightable {
  internal typealias CurationsPostflightResult = BVType
  
  func curationsPostflight(_ results: [BVType]?) {
    curationsPostflightResultsClosure?(results)
  }
}

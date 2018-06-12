//
//
//  BVCurationsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVCurationsQuery<BVType: BVQueryable>: BVQuery<BVType> {
  private var ignoreCompletion: Bool = false
  private var paramsPriv: [BVCurationsQueryParameter] = []
  private var curationsConfiguration: BVCurationsConfiguration?
  
  internal override init<BVTypeInternal : BVQueryableInternal>(
    _ type: BVTypeInternal.Type) {
    super.init(type)
  }
  
  final internal override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    get {
      return {
        return self.queryItems
      }
    }
  }
  
  internal var curationsPostflightResultsClosure:
    (([CurationsPostflightResult]?) -> Swift.Void)? {
    get {
      return nil
    }
  }
}

// MARK: - BVCurationsQuery: BVURLParameterableInternal
extension BVCurationsQuery: BVURLParameterableInternal {
  
  final internal var parameters: [BVCurationsQueryParameter] {
    get {
      return paramsPriv
    }
  }
  
  func add(_ parameter: BVCurationsQueryParameter, coalesce: Bool = false) {
    if coalesce {
      BVLogger.sharedLogger.debug(
        "BVCurationsQuery.add() doesn't support coalescing")
    }
    paramsPriv += [parameter]
  }
  
  func update(_ parameter: BVCurationsQueryParameter) {
    var paramsTemp:[BVCurationsQueryParameter] =
      paramsPriv.filter { $0 != parameter }
    paramsTemp.append(parameter)
    
    paramsPriv = paramsTemp
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
      .custom(BVCurationsConstants.parameterKey, config.configurationKey))
    update(
      .custom(BVCurationsConstants.clientKey, config.type.clientId))
    
    /// Make sure we call through to the superclass
    configureExistentially(config)
    
    return self
  }
}

// MARK: - BVCurationsQuery: BVConfigurableInternal
extension BVCurationsQuery: BVConfigurableInternal {
  var configuration: BVCurationsConfiguration? {
    get {
      return curationsConfiguration
    }
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
        
        do {
          
          let response: BVCurationsQueryResponseInternal<BVType> =
            try JSONDecoder()
              .decode(
                BVCurationsQueryResponseInternal<BVType>.self,
                from: jsonData)
          
          if let errors:[Error] = response.errors,
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
          self.curationsPostflight(response.results)
          
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
          guard let _ = BVXMLParser().parse(jsonData) else {
            
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
        
        break
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

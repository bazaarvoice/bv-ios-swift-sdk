//
//
//  BVCurationsSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Base public class for handling Curation Submissions
/// - Note:
/// \
/// This really only exists publicly as a convenience to the actual type
/// specific submissions. There shouldn't be any need to subclass this if
/// you're an external developer; unless of course you're fixing bugs or
/// extending something that you want to see being made public :)
internal class
BVCurationsSubmission<BVType: BVSubmissionable>: BVSubmission {
  
  /// Private
  private var ignoreCompletion: Bool = false
  private var curationsConfiguration: BVCurationsConfiguration?
  
  /// Internal
  internal init(_ submissionableInternal: BVSubmissionableInternal) {
    super.init(internalType: submissionableInternal)
  }
  
  internal init?(_ submissionable: BVType) {
    guard let internalType = submissionable as? BVSubmissionableInternal else {
      return nil
    }
    super.init(internalType: internalType)
  }
  
  final internal override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    return {
      return self.queryItems
    }
  }
  
  override var contentBodyClosure: ((BVSubmissionableInternal) -> BVURLRequestBody?)? {
    return { (_) -> BVURLRequestBody? in
      guard var submissionableType = self.submissionableInternal else {
        return nil
      }
      
      var id: String?
      if let config = self.configuration {
        id = config.type.clientId
      }
      
      if let raw = self.rawConfiguration {
        id = raw.type.clientId
      }
      
      guard let clientId = id else {
        return nil
      }
      
      let updateDictionary: [String: String] =
        [BVCurationsConstants.clientKey: clientId]
      submissionableType.update(updateDictionary)
      
      guard let body: Data =
        try? JSONEncoder().encode(submissionableType as? BVType) else {
          return nil
      }
      
      #if DEBUG
      do {
        let jsonObject =
          try JSONSerialization.jsonObject(with: body, options: [])
        print(jsonObject)
      } catch {
        fatalError()
      }
      #endif
      
      
      return .raw(body)
    }
  }
  
  override var contentTypeClosure: (() -> String?)? {
    return {
      return "application/json"
    }
  }
  
  internal var curationsPostflightResultsClosure: (([CurationsPostflightResult]?) -> Swift.Void)? {
    return nil
  }
  
  internal var submissionable: BVType? {
    return submissionableInternal as? BVType
  }
}

// MARK: - BVCurationsSubmission: BVConfigurable
extension BVCurationsSubmission: BVConfigurable {
  public typealias Configuration = BVCurationsConfiguration
  
  @discardableResult
  final public func configure(_ config: Configuration) -> Self {
    
    assert(nil == curationsConfiguration)
    curationsConfiguration = config
    
    /// Might as well add the parameter as well...
    let checkConfigurationForSubmission = { () -> String? in
      switch config {
      case .all:
        fallthrough
      case .submission:
        return config.configurationKey
      default:
        return nil
      }
    }
    
    /// We update here just in case various things step on top of each
    /// other. We may want to revisit this if this becomes a pain
    /// point
    if let passKey = checkConfigurationForSubmission() {
      update(
        .unsafe(
          BVCurationsConstants.parameterKey, passKey, nil))
    }
    
    /// Make sure we call through to the superclass
    configureExistentially(config)
    
    return self
  }
}

// MARK: - BVCurationsSubmission: BVConfigurableInternal
extension BVCurationsSubmission: BVConfigurableInternal {
  var configuration: BVCurationsConfiguration? {
    return curationsConfiguration
  }
}

// MARK: - BVCurationsSubmission: BVSubmissionActionable
extension BVCurationsSubmission: BVSubmissionActionable {
  public typealias Response = BVCurationsSubmissionResponse
  
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
          
          let response: BVCurationsSubmissionResponseInternal =
            try JSONDecoder()
              .decode(
                BVCurationsSubmissionResponseInternal.self,
                from: jsonData)
          
          /// Construct errors if there are any in the response...
          if let code = response.code,
            let status = response.status,
            200 < code {
            let statusError = BVCurationsError.status(UInt16(code), status)
            completion(
              .failure([BVCurationsError.submission(statusError)]))
            return
          }
          
          completion(.success(response, Data()))
          
          if let type = self.submissionable {
            self.curationsPostflight([type])
          }
          
        } catch {
          
          #if DEBUG
          do {
            _ =
              try JSONDecoder()
                .decode(
                  BVCurationsSubmissionResponseInternal.self,
                  from: jsonData)
          } catch {
            BVLogger.sharedLogger.error("JSON ERROR: \(error)")
          }
          #endif
          
          
          /// The JSON parsing failed but let's make sure it's because we
          /// weren't sent JSON and therefore can assume an API error and not
          /// some malformed object or mismatched internal JSON types.
          guard let decodingError = error as? DecodingError,
            case .dataCorrupted = decodingError else {
              completion(
                .failure(
                  [BVCommonError.unknown(error.localizedDescription)]))
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
                [BVCurationsError.submission(invalidParameter)]))
            return
          }
          
          /// For now we ignore the XML results since the only error value can
          /// be the invalid passkey.
          let invalidPasskey =
            BVCurationsError.invalidPasskey
          completion(
            .failure(
              [BVCurationsError.submission(invalidPasskey)]))
          return
        }
      case let .failure(errors):
        completion(.failure(errors))
      }
    }
    return self
  }
}

// MARK: - BVCurationsSubmission: BVCurationsSubmissionPostflightable
extension BVCurationsSubmission: BVCurationsSubmissionPostflightable {
  internal typealias CurationsPostflightResult = BVType
  
  func curationsPostflight(_ results: [BVType]?) {
    curationsPostflightResultsClosure?(results)
  }
}

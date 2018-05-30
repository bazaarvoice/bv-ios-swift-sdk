//
//  BVConversationsSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Base public class for handling Conversation Submissions
/// - Note:
/// \
/// This really only exists publicly as a convenience to the actual type
/// specific submissions. There shouldn't be any need to subclass this if
/// you're an external developer; unless of course you're fixing bugs or
/// extending something that you want to see being made public :)
public class
BVConversationsSubmission<BVType: BVSubmissionable>: BVSubmission {
  
  /// Private
  private var ignoreCompletion: Bool = false
  internal private(set) var conversationsConfiguration:
  BVConversationsConfiguration?
  private var submissionParameters: [URLQueryItem] =
    [URLQueryItem(name: "apiversion", value: "5.4")]
  private var customSubmissionParameters: [URLQueryItem]?
  
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
  
  override var contentBodyClosure:
    ((BVSubmissionableInternal) -> BVURLRequestBody?)? {
    get {
      return { (_) -> BVURLRequestBody? in
        
        guard var container: URLComponents =
          URLComponents(string: "http://bazaarvoice.com") else {
            return nil
        }
        
        container.queryItems =
          (self.conversationsParameters ∪ self.customConversationsParameters)
        
        guard let query: Data = container.query?.data(using: .utf8) else {
          return nil
        }
        
        return .raw(query)
      }
    }
  }
  
  override var contentTypeClosure: (() -> String?)? {
    get {
      return {
        return "application/x-www-form-urlencoded"
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

// MARK: - BVConversationsSubmission: BVConversationsSubmissionPostflightable
extension BVConversationsSubmission: BVConversationsSubmissionPostflightable {
  internal typealias ConversationsPostflightResult = BVType
  
  final func conversationsPostflight(_ results: [BVType]?) {
    conversationsPostflightResultsClosure?(results)
  }
}

// MARK: - BVConversationsSubmission: BVConversationsSubmissionable
extension BVConversationsSubmission: BVConversationsSubmissionable {
  internal var conversationsParameters: [URLQueryItem] {
    get {
      return submissionParameters
    }
    set(newValue) {
      submissionParameters = newValue
    }
  }
  
  internal var customConversationsParameters: [URLQueryItem]? {
    get {
      return customSubmissionParameters
    }
    set(newValue) {
      customSubmissionParameters = newValue
    }
  }
}

// MARK: - BVConversationsSubmission: BVConversationsSubmissionParameterable
extension BVConversationsSubmission: BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      return conversationsParameters
    }
  }
}

// MARK: - BVConversationsSubmission: BVSubmissionActionable
extension BVConversationsSubmission: BVSubmissionActionable {
  public typealias Response = BVConversationsSubmissionResponse<BVType>
  
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
      case let .success(_, jsonData):
        
        guard let response =
          try? JSONDecoder()
            .decode(
              BVConversationsSubmissionResponseInternal<BVType>.self,
              from: jsonData) else {
                
                #if DEBUG
                  
                  do {
                    let _ = try JSONDecoder()
                      .decode(
                        BVConversationsSubmissionResponseInternal<BVType>
                          .self,
                        from: jsonData)
                  } catch {
                    BVLogger.sharedLogger.error("Error: \(error)")
                  }
                  
                #endif
                
                completion(
                  .failure(
                    [BVCommonError.unknown(
                      "An Unknown parse error occurred")]))
                return
        }
        
        guard let result = response.result,
          !response.hasErrors else {
            var errors: [BVError] = []
            errors += (response.errors ?? []) as [BVError]
            errors += (response.formFieldErrors ?? []) as [BVError]
            completion(.failure(errors))
            return
        }
        
        /*
         do {
         let jsonObject =
         try JSONSerialization.jsonObject(with: jsonData, options: [])
         print(jsonObject)
         } catch {
         BVLogger.sharedLogger.error("Error: \(error)")
         }
         */
        
        completion(.success(response, result))
        self.conversationsPostflight([result])
        break
      case let .failure(errors):
        completion(.failure(errors))
        break
      }
    }
    return self
  }
}

// MARK: - BVConversationsSubmission: BVConfigurable
extension BVConversationsSubmission: BVConfigurable {
  public typealias Configuration = BVConversationsConfiguration
  
  @discardableResult final public func configure(
    _ config: Configuration) -> Self {
    
    /// Squirrel this away so we can access it for whatever our needs
    assert(nil == conversationsConfiguration)
    conversationsConfiguration = config
    
    /// Make sure we call through to the superclass
    configureExistentially(config)
    
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
    
    if let passKey = checkConfigurationForSubmission() {
      conversationsParameters += [URLQueryItem(name: "passkey", value: passKey)]
    }
    
    return self
  }
}

// MARK: - BVConversationsSubmission: BVConfigurableInternal
extension BVConversationsSubmission: BVConfigurableInternal {
  var configuration: BVConversationsConfiguration? {
    return conversationsConfiguration
  }
}

// MARK: - BVConversationsSubmission: BVConversationsSubmissionCustomizeable
extension BVConversationsSubmission: BVConversationsSubmissionCustomizeable {
  @discardableResult
  public func add(_ customFields: [String : String]) -> Self {
    guard var customParams = customConversationsParameters else {
      customConversationsParameters = customFields.toBVURLQueryItems()
      return self
    }
    customParams ∪= customFields.toBVURLQueryItems()
    customConversationsParameters = customParams
    return self
  }
}


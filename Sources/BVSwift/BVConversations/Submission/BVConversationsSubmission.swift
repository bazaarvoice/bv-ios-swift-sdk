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
  internal private(set) var conversationsConfiguration: BVConversationsConfiguration?
  private var customSubmissionParameters: [URLQueryItem]?
  
  private func postSuperInit() {
    /// We do this after super.init() so that in the future we can capture any
    /// call being set from below.
    let superPreflightHandler = preflightHandler
    
    /// We have to make sure that we don't "own" ourself to create a retain
    /// cycle.
    preflightHandler = { [unowned self] completion in
      self.conversationsSubmissionPreflight { (errors: Error?) in
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
  
  /// Internal
  internal var submissionParameters: [URLQueryItem] =
    [URLQueryItem(name: apiVersionField, value: apiVersion)]
  
  internal var submissionable: BVType? {
    return submissionableInternal as? BVType
  }
  
  internal init(_ submissionableInternal: BVSubmissionableInternal) {
    super.init(internalType: submissionableInternal)
    postSuperInit()
  }
  
  internal init?(_ submissionable: BVType) {
    guard let internalType = submissionable as? BVSubmissionableInternal else {
      return nil
    }
    super.init(internalType: internalType)
    postSuperInit()
  }
  
  override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    return {
      /// Unused for now...
      return nil
    }
  }
  
  override var contentBodyClosure: (
    (BVSubmissionableInternal) -> BVURLRequestBody?)? {
    return { (_) -> BVURLRequestBody? in
      
      guard var container: URLComponents =
        URLComponents(string: "http://bazaarvoice.com") else {
          return nil
      }
      
      container.queryItems =
        (self.submissionParameters ∪ self.customSubmissionParameters)
      
      guard let query: Data = container.query?.data(using: .utf8) else {
        return nil
      }
      
      return .raw(query)
    }
  }
  
  override var contentTypeClosure: (() -> String?)? {
    return {
      return "application/x-www-form-urlencoded"
    }
  }
  
  internal var submissionPreflightResultsClosure: BVURLRequestablePreflightHandler? {
    return nil
  }
  
  internal var submissionPostflightResultsClosure: (
    ([ConversationsSubmissionPostflightResult]?) -> Swift.Void)? {
    return nil
  }
}

// MARK: - BVConversationsSubmission: BVConfigurable
extension BVConversationsSubmission: BVConfigurable {
  public typealias Configuration = BVConversationsConfiguration
  
  @discardableResult
  final public func configure(_ config: Configuration) -> Self {
    
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
      submissionParameters +=
        [URLQueryItem(name: "passkey", value: passKey)]
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
  public func add(_ fields: [String: String]) -> Self {
    guard var customParams = customSubmissionParameters else {
      customSubmissionParameters = fields.toBVURLQueryItems()
      return self
    }
    customParams ∪= fields.toBVURLQueryItems()
    customSubmissionParameters = customParams
    return self
  }
}

// MARK: - BVConversationsSubmission: BVConversationsSubmissionPreflightable
extension BVConversationsSubmission: BVConversationsSubmissionPreflightable {
  func conversationsSubmissionPreflight(
    _ preflight: BVCompletionWithErrorsHandler?) {
    /// We have to make sure to call through, else the preflight chain will not
    /// end up firing through to the superclass.
    guard let preflightResultsClosure = submissionPreflightResultsClosure else {
      preflight?(nil)
      return
    }
    preflightResultsClosure(preflight)
  }
}

// MARK: - BVConversationsSubmission: BVConversationsSubmissionPostflightable
extension BVConversationsSubmission: BVConversationsSubmissionPostflightable {
  internal typealias ConversationsSubmissionPostflightResult = BVType
  
  final func conversationsSubmissionPostflight(_ results: [BVType]?) {
    submissionPostflightResultsClosure?(results)
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
          BVLogger.sharedLogger.debug("RAW JSON: \(jsonObject)")
        } catch {
          BVLogger.sharedLogger.error("JSON ERROR: \(error)")
        }
        #endif
        
        guard let response =
          try? JSONDecoder()
            .decode(
              BVConversationsSubmissionResponseInternal<BVType>.self,
              from: jsonData) else {
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
        
        completion(.success(response, result))
        self.conversationsSubmissionPostflight([result])
      case let .failure(errors):
        completion(.failure(errors))
      }
    }
    return self
  }
}

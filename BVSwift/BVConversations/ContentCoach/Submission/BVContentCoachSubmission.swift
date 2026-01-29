//
//
//  BVContentCoachSubmission.swift
//  BVSwift
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

import Foundation

/// Base public class for handling Content Coach Submissions
/// - Note:
/// \
/// This really only exists publicly as a convenience to the actual type
/// specific submissions. There shouldn't be any need to subclass this if
/// you're an external developer; unless of course you're fixing bugs or
/// extending something that you want to see being made public :)
/// - Important:
/// \
/// submissionParameters here are sent in the URL query string.
/// customSubmissionParameters are sent in the body of the request.
public class
BVContentCoachSubmission<BVType: BVSubmissionable>: BVSubmission {
    
    /// Private
    private var ignoreCompletion: Bool = false
    internal private(set)
    var contentCoachConfiguration: BVConversationsConfiguration?
    internal var customSubmissionParameters: [String: Any]?
    
    private func postSuperInit() {
        /// We do this after super.init() so that in the future we can capture any
        /// call being set from below.
        let superPreflightHandler = preflightHandler
        
        /// We have to make sure that we don't "own" ourself to create a retain
        /// cycle.
        preflightHandler = { [weak self] completion in
            self?.contentCoachSubmissionPreflight { (errors: Error?) in
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
    internal var submissionParameters: [URLQueryItem] = [URLQueryItem(name: "apiversion",
                                                                      value: "5.4")]
    
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
    
    final internal override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
        return {
            return self.submissionParameters
        }
    }
    
    override var contentBodyTypeClosure: (
        (BVSubmissionableInternal) -> BVURLRequestBodyType?)? {
            return { [weak self] (_) -> BVURLRequestBodyType? in
                let bodyParams = (self?.customSubmissionParameters ?? [:])
                do {
                    let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                    return .json(data)
                } catch {
                    print("NSError serializing JSON: \(error)")
                    return nil
                }
            }
        }
    
    internal
    var submissionPreflightResultsClosure: BVURLRequestablePreflightHandler? {
        return nil
    }
    
    internal var submissionPostflightResultsClosure: (
        ([ContentCoachSubmissionPostflightResult]?) -> Void)? {
            return nil
        }
}

// MARK: - BVContentCoachSubmission: BVConfigurable
extension BVContentCoachSubmission: BVConfigurable {
    public typealias Configuration = BVConversationsConfiguration
    
    @discardableResult
    final public func configure(_ config: Configuration) -> Self {
        
        /// Squirrel this away so we can access it for whatever our needs
        assert(nil == contentCoachConfiguration)
        contentCoachConfiguration = config
        
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

// MARK: - BVContentCoachSubmission: BVConfigurableInternal
extension BVContentCoachSubmission: BVConfigurableInternal {
    var configuration: BVConversationsConfiguration? {
        return contentCoachConfiguration
    }
}

// MARK: - BVContentCoachSubmission: BVContentCoachSubmissionCustomizeable
extension BVContentCoachSubmission: BVContentCoachSubmissionCustomizeable {
    @discardableResult
    public func add(_ fields: [String: String]) -> Self {
        guard var customParams = customSubmissionParameters else {
            customSubmissionParameters = fields
            return self
        }
        customParams += fields
        customSubmissionParameters = customParams
        return self
    }
}

// MARK: - BVContentCoachSubmission: BVContentCoachSubmissionPreflightable
extension BVContentCoachSubmission: BVContentCoachSubmissionPreflightable {
    func contentCoachSubmissionPreflight(
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

// MARK: - BVContentCoachSubmission: BVContentCoachSubmissionPostflightable
extension BVContentCoachSubmission: BVContentCoachSubmissionPostflightable {
    internal typealias ContentCoachSubmissionPostflightResult = BVType
    
    final func contentCoachSubmissionPostflight(_ results: [BVType]?) {
        submissionPostflightResultsClosure?(results)
    }
}

// MARK: - BVContentCoachSubmission: BVConversationsSubmissionLocaleable
extension BVContentCoachSubmission: BVContentCoachSubmissionLocaleable {
    @discardableResult
    public func add(_ locale: BVContentCoachSubmissionLocale) -> Self {
        submissionParameters ∪= locale.urlQueryItems
        return self
    }
}

// MARK: - BVContentCoachSubmission: BVSubmissionActionable
extension BVContentCoachSubmission: BVSubmissionActionable {
    public typealias Response = BVContentCoachSubmissionResponse<BVType>
    
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
                            msg: "RAW JSON: \(jsonObject)"))
                } catch {
                    BVLogger.sharedLogger.error(
                        BVLogMessage(
                            BVConversationsConstants.bvProduct, msg: "JSON ERROR: \(error)"))
                }
#endif
                
                guard let response = try? JSONDecoder().decode(BVType.self, from: jsonData) else {
                    completion(.failure([BVCommonError.unknown("An Unknown parse error occurred")]))
                    return
                }
                completion(.success(response))
                self?.contentCoachSubmissionPostflight([response])
            case let .failure(errors):
                completion(.failure(errors))
            }
        }
        return self
    }
}

//
//
//  BVMultiProductQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import UIKit
//obj-cBVInitiateSubmitRequest
public class BVMultiProductQuery: BVSubmission {
    var conversationsConfiguration: BVConversationsConfiguration?
    private var ignoreCompletion: Bool = false
    public var hostedAuth: Bool = false

    /// The initializer for BVReviewSubmission
    /// - Parameters:
    ///   - productIds: The Product identifiersto submit against
    ///   - locale: The locale of the submission
    ///   - userToken: the user token associated with the submission
    public convenience init?(
        productIds: [String],
        locale: String,
        userToken: String?,
        userId: String?){
        self.init(
            BVMultiProduct(
                productIds: productIds,
                locale: locale,
                userToken: userToken,
                userId: userId))
    }
    
    public init?(_ multiProduct: BVMultiProduct) {
      self.hostedAuth = multiProduct.hostedAuth
        super.init(internalType: multiProduct)
    }
    
    override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
        return {
             var submissionParameters: [URLQueryItem] =
                [URLQueryItem(name: "siteName",
                              value: "main_site"),
                 URLQueryItem(name: "PassKey",
                              value: self.configuration?.configurationKey),
                 URLQueryItem(name: "apiversion",
                              value: "5.4"),]
                if self.hostedAuth {
                    submissionParameters += [URLQueryItem(name: "hostedauth",
                                                          value: "true")]
                }
            
            return submissionParameters
        }
    }
}

// MARK: - BVConversationsSubmission: BVConfigurable
extension BVMultiProductQuery: BVConfigurable {
    public typealias Configuration = BVConversationsConfiguration
    
    @discardableResult
    final public func configure(_ config: Configuration) -> Self {
        
        /// Squirrel this away so we can access it for whatever our needs
        assert(nil == conversationsConfiguration)
        conversationsConfiguration = config
        
        /// Make sure we call through to the superclass
        configureExistentially(config)
        
        return self
    }
}

// MARK: - BVConversationsSubmission: BVConfigurableInternal
extension BVMultiProductQuery: BVConfigurableInternal {
    var configuration: BVConversationsConfiguration? {
        return conversationsConfiguration
    }
}

extension BVMultiProductQuery: BVSubmissionActionable {
    public typealias Response = BVMultiProductQueryResponse<BVMultiProduct>

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

                guard let response =
                    try? JSONDecoder()
                        .decode(
                            BVMultiProductQueryResponseInternal<BVMultiProduct>.self,
                            from: jsonData) else {
                                completion(
                                    .failure(
                                        [BVCommonError.unknown(
                                            "An Unknown parse error occurred")]))
                                return
                }

                guard let result = response.result,
                    !response.hasErrors else {
                        var errors: [BVError]
                        errors = (response.errors)!
                        completion(.failure(errors))
                        return
                }
                completion(.success(response, result))
                
            case let .failure(errors):
                completion(.failure(errors))
            }
        }
        return self
    }
}

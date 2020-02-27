//
//
//  BVProgressiveReviewSubmission.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVProgressiveReviewSubmission: BVSubmission {
    var conversationsConfiguration: BVConversationsConfiguration?
    private var ignoreCompletion: Bool = false
    private var extendedResponse: Bool = false
    private var includeFields: Bool = false
    private var isPreview: Bool = false
    
    public init?(_ progressiveReview: BVProgressiveReview) {
        self.extendedResponse = progressiveReview.extendedResponse
        self.includeFields = progressiveReview.includeFields
        self.isPreview = progressiveReview.isPreview
        super.init(internalType: progressiveReview)
    }
    
    override var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
        return {
            var submissionParameters: [URLQueryItem] =
                [URLQueryItem(name: "siteName",
                              value: "main_site"),
                 URLQueryItem(name: "PassKey",
                              value: self.configuration?.configurationKey),
                 URLQueryItem(name: "apiversion",
                              value: "5.4")]
            if self.extendedResponse {
                submissionParameters += [URLQueryItem(name: "extended",
                value: nil)]
            }
            if self.includeFields {
                submissionParameters += [URLQueryItem(name: "fields",
                value: nil)]
            }
            if self.isPreview {
                submissionParameters += [URLQueryItem(name: "preview",
                value: nil)]
            }
            return submissionParameters
        }
    }
}

// MARK: - BVConversationsSubmission: BVConfigurable
extension BVProgressiveReviewSubmission: BVConfigurable {
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
extension BVProgressiveReviewSubmission: BVConfigurableInternal {
    var configuration: BVConversationsConfiguration? {
        return conversationsConfiguration
    }
}

extension BVProgressiveReviewSubmission: BVSubmissionActionable {
    public typealias Response = BVMultiProductQueryResponse<BVProgressiveReview>

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

                guard let response =
                    try? JSONDecoder()
                        .decode(
                            BVMultiProductQueryResponseInternal<BVProgressiveReview>.self,
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

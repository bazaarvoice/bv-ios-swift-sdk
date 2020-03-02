//
//
//  BVProgressiveReview.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVProgressiveReview: BVSubmissionable {
    
    public static var singularKey: String {
        return BVConversationsConstants.BVProgressiveReviewSubmission.singularKey
    }
    public static var pluralKey: String {
        return BVConversationsConstants.BVProgressiveReviewSubmission.pluralKey
    }
    
    public var productId: String?
    public var locale: String?
    public var userToken: String?
    public var userId: String?
    public var submissionSessionToken: String?
    public var submissionId: String?
    public var userEmail: String?
    public var review: BVProgressiveReviewSummary?
    public var submissionFields:BVProgressiveReviewFields?
    public var formFieldErrors: [BVMultiProductError]?
    public let fieldsOrder: [String]?
    public var fields: [BVMultiProductFormField]? {
      return fieldsArray?.array
    }
    private let fieldsArray: BVCodableDictionary<BVMultiProductFormField>?
    public var isFormComplete: Bool?
    public var extendedResponse: Bool = false
    public var includeFields: Bool = false
    public var isPreview: Bool = false

    private enum CodingKeys: String, CodingKey {
        case productId = "productId"
        case locale = "locale"
        case userToken = "userToken"
        case formFieldErrors = "formValidationErrors"
        case review = "review"
        case userId = "userId"
        case userEmail = "useremail"
        case isFormComplete = "isFormComplete"
        case submissionSessionToken = "submissionSessionToken"
        case submissionId = "submissionId"
        case fieldsOrder = "fieldsOrder"
        case fieldsArray = "fields"
        case submissionFields = "submissionFields"
       }
}

extension BVProgressiveReview {
    public init(productId: String, submissionFields: BVProgressiveReviewFields) {
        self.productId = productId
        self.submissionFields = submissionFields
        self.locale = nil
        self.userToken = nil
        self.userId = nil
        self.userEmail = nil
        self.review = nil
        self.submissionSessionToken = nil
        self.isFormComplete = nil
        self.submissionId = nil
        self.formFieldErrors = nil
        self.fieldsOrder = nil
        self.fieldsArray = nil
    }
}

extension BVProgressiveReview: BVSubmissionableInternal {
    internal static var postResource: String? {
        return BVConversationsConstants.BVProgressiveReviewSubmission.postResource
    }
    internal func update(_ values: [String: Encodable]?) { }
}

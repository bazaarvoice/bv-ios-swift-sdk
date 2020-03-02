//
//
//  ProgressiveSubmissionReview.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct ProgressiveSubmissionReview: BVAuxiliaryable {
    
    public let review: BVReview?
    public let fieldsOrder: [String]?
    public let submissionSessionToken: String?
    public var fields: [BVFormField]? {
      return fieldsArray?.array
    }
    private let fieldsArray: BVCodableDictionary<BVFormField>?
    
    private enum CodingKeys: String, CodingKey {
        case review = "review"
        case fieldsOrder = "fieldsOrder"
        case fieldsArray = "fields"
        case submissionSessionToken = "submissionSessionToken"
    }
}

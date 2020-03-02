//
//
//  BVMultiProductFormData.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVMultiProductFormData: BVAuxiliaryable {
    
    public let review: BVMultiProductReviewSummary?
    public let fieldsOrder: [String]?
    public let submissionSessionToken: String?
    public var fields: [BVMultiProductFormField]? {
      return fieldsArray?.array
    }
    private let fieldsArray: BVCodableDictionary<BVMultiProductFormField>?
    
    private enum CodingKeys: String, CodingKey {
        case review = "review"
        case fieldsOrder = "fieldsOrder"
        case fieldsArray = "fields"
        case submissionSessionToken = "submissionSessionToken"
    }
}

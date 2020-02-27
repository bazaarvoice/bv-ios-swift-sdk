//
//
//  BVMultiproduct.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVMultiProduct: BVSubmissionable {

    public static var singularKey: String {
        return BVConversationsConstants.BVMultiProductQuery.singularKey
    }
    public static var pluralKey: String {
        return BVConversationsConstants.BVMultiProductQuery.pluralKey
    }
    
    public let productIds: [String]?
    public let locale: String?
    public let userToken: String?
    public let userId: String?
    public var errors: [BVMultiProductError]?
    public let userNickname: String?
    public var productFormData: [BVMultiProductFormData]? {
      return productFormDataArray?.array
    }
    private let productFormDataArray: BVCodableDictionary<BVMultiProductFormData>?

    private enum CodingKeys: String, CodingKey {
        case productIds = "productIds"
        case locale = "locale"
        case userToken = "userToken"
        case userId = "userId"
        case errors = "formValidationErrors"
        
        case userNickname = "userNickname"
        case productFormDataArray = "productFormData"
    }
}

extension BVMultiProduct {
    public init(productIds: [String],
                locale: String,
                userToken: String? = nil,
                userId: String? = nil) {
        self.productIds = productIds
        self.locale = locale
        self.userToken = userToken
        self.userId = userId
        self.errors = nil
        self.userNickname = nil
        self.productFormDataArray = nil
    }
}

extension BVMultiProduct: BVSubmissionableInternal {
    internal static var postResource: String? {
        return BVConversationsConstants.BVMultiProductQuery.postResource
    }
    internal func update(_ values: [String: Encodable]?) { }
}

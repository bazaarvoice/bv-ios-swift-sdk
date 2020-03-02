//
//
//  BVMultiProductQueryResponse.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for MultiProductQuery
public protocol BVMultiProductQueryResponseMetaData {
    
    /// Flag for the existence of errors
    var hasErrors: Bool { get }
}

/// Public return type for all BVConversation Submissions
/// - Note:
/// \
/// The result type must always be a BVSubmissionable type.
public enum BVMultiProductQueryResponse
<BVType: BVSubmissionable>: BVURLRequestableResponse {
    public typealias ResponseType = BVType
    public typealias MetaType = BVMultiProductQueryResponseMetaData
    
    public var success: Bool {
        guard case .success = self else {
            return false
        }
        return true
    }
    
    public var errors: [Error]? {
        guard case let .failure(errors) = self else {
            return nil
        }
        return errors
    }
    
    case success(MetaType, ResponseType)
    case failure([Error])
}

internal struct BVMultiProductQueryResponseInternal
<BVType: BVSubmissionable>: Codable, BVMultiProductQueryResponseMetaData {
    let hasErrors: Bool
    let result: BVType?
    let errors: [BVMultiProductError]?

    
    private enum CodingKeys: String, CodingKey {
        case hasErrors = "hasErrors"
        case result = "response"
        case errors = "errors"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errors  = try container.decodeIfPresent([BVMultiProductError].self, forKey: .errors)
        if errors != nil {
            hasErrors = true
        }else {
            hasErrors = false
        }
        result  = try container.decodeIfPresent(BVType.self, forKey: .result)

    }
}

//
//
//  BVContentCoachSubmissionResponse.swift
//  BVSwift
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

import Foundation

/// Public return type for all BVConversation Submissions
/// - Note:
/// \
/// The result type must always be a BVSubmissionable type.

/// Protocol defining the meta-data header for submissions
public protocol BVContentCoachSubmissionMetaData {
    
    /// Status for the submission
    var status: Int? { get }
    
    /// Type for the submission
    var type: String? { get }
    
    /// Title for the submission
    var title: String? { get }
    
    /// Detail for the submission
    var detail: String? { get }
}


public enum BVContentCoachSubmissionResponse
<BVType: BVSubmissionable>: BVURLRequestableResponse {
    public typealias ResponseType = BVType
    public typealias MetaType = BVContentCoachSubmissionMetaData
    
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
    
    case success(ResponseType)
    case failure([Error])
}

internal struct BVContentCoachSubmissionResponseInternal
<BVType: BVSubmissionable>: Codable, BVContentCoachSubmissionMetaData {
    let data: BVType?
    let status: Int?
    let type: String?
    let title: String?
    let detail: String?
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case status = "status"
        case type = "type"
        case title = "title"
        case detail = "detail"
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError("What are you doing? This isn't implemented yet.")
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultContainer = try decoder.container(keyedBy: BVCodingKey.self)
        
        // The interesting suspects...
        if let dataKey: BVCodingKey =
            BVCodingKey(stringValue: BVType.singularKey) {
            data =
            try resultContainer.decodeIfPresent(BVType.self, forKey: dataKey)
        } else {
            data = nil
        }
        
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        detail = try container.decodeIfPresent(String.self, forKey: .detail)
    }
}

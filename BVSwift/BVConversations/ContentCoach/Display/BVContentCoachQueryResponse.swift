//
//
//  BVContentCoachQueryResponse.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for ContentCoach
public protocol BVContentCoachQueryResponseMetaData { }

/// Public return type for all BVContentCoach query responses
/// - Note:
/// \
/// The result type must always be a BVQueryable type.
public enum BVContentCoachQueryResponse
<BVType: BVQueryable>: BVURLRequestableResponse {
    public typealias ResponseType = BVType
    public typealias MetaType = BVContentCoachQueryResponseMetaData
    
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

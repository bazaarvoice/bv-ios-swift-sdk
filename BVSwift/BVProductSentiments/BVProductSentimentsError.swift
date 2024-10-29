//
//
//  BVProductSentimentsError.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVProductSentimentsError {
    /// No content in response
    /// - Note:
    /// \
    /// ERROR_NO_CONTENT
    case noContent(String?)

    /// Authentication token is invalid, missing or the user has already been
    /// authenticated
    /// - Note:
    /// \
    /// ERROR_BAD_REQUEST
    case badRequest(String?)

    /// Insufficient privileges to perform the operation
    /// - Note:
    /// \
    /// ERROR_ACCESS_DENIED
    case accessDenied(String?)
    
    /// Rate limiting error, i.e. too many requests per time interval
    /// - Note:
    /// \
    /// ERROR_REQUEST_LIMIT_REACHED
    case requestLimitReached(String?)
    
    /// Unknown error (internal server error, for instance)
    /// - Note:
    /// \
    /// ERROR_UNKNOWN
    case unknown(String?)

    private enum CodingKeys: CodingKey {
        case code
        case type
        case title
        case detail
    }
}

extension BVProductSentimentsError: Codable {
    /// Conformance with Encodable. Currently it isn't implemented and therefore
    /// shouldn't be used. It will fatalError to remind you :)
    /// - Note:
    /// \
    /// Please see the plethora of information regarding this protocol.
    public func encode(to encoder: Encoder) throws {
        fatalError("This isn't implemented, nor will it be.")
    }
    
    /// Conformance with Decodable. Used to hydrate from the json returned from
    /// the various API calls.
    /// - Note:
    /// \
    /// Please see the plethora of information regarding this protocol.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let code = try container.decodeIfPresent(Int.self, forKey: .code)
        let title = try container.decodeIfPresent(String.self, forKey: .title)
        
        switch (code, title) {
        case let (.some(code), title) where 204 == code:
            self = .noContent(title)
        case let (.some(code), title) where 400 == code:
            self = .badRequest(title)
        case let (.some(code), title) where 403 == code:
            self = .accessDenied(title)
        case let (.some(code), title) where 429 == code:
            self = .requestLimitReached(title)
            /// Non-standard default "catch all" unknown errors
        case let (_, title):
            self = .unknown(title)
        }
    }
}

/// Conformance with the BVError Protocol
extension BVProductSentimentsError: BVError {
    public var message: String {
        switch self {
        case .accessDenied(.some(let title)): return title
        case .badRequest(.some(let title)): return title
        case .noContent(.some(let title)): return title
        case .requestLimitReached(.some(let title)): return title
        case .unknown(.some(let title)): return title
        default:
            return "No error message."
        }
    }
    
    public var description: String {
        return localizedDescription
    }
    
    public var debugDescription: String {
        return "Code: \(code), Message: \(message)"
    }
    
    
    public var code: String {
        switch self {
        case .accessDenied: return "ERROR_ACCESS_DENIED"
        case .badRequest: return "ERROR_BAD_REQUEST"
        case .noContent(_): return "ERROR_UNSUPPORTED"
        case .requestLimitReached(_): return "ERROR_REQUEST_LIMIT_REACHED"
        case .unknown(_): return "ERROR_UNKNOWN"
        }
    }
}

extension BVProductSentimentsError {
    internal init?(_ code: String, message: String? = nil) {
        switch code {
        case "204":
            self = .noContent(message)
        case "400":
            self = .badRequest(message)
        case "403":
            self = .accessDenied(message)
        case "429":
            self = .requestLimitReached(message)
        /// Non-standard default "catch all" unknown errors
        default:
            self = .unknown(message)
        }
    }
}

//
//
//  BVProgressiveReviewFields.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

/// - Adds `set(name:value:)` / `get(name:)` for dynamic fields (e.g., "photourl_1")
public struct BVProgressiveReviewFields: BVAuxiliaryable {
    // MARK: Typed fields (keep your existing ones)
    public var rating: Int?
    public var title: String?
    public var reviewtext: String?
    public var agreedToTerms: Bool?
    public var isRecommended: Bool?
    public var sendEmailAlert: Bool?
    public var hostedAuthenticationEmail: String?
    public var hostedAuthenticationCallbackurl: String?

    /// Dynamic/additional fields merged into payload on encode.
    /// e.g., "photourl_1", "contextdatavalue_<id>", custom form fields, etc.
    private var additional: [String: String] = [:]

    // MARK: Init
    public init() {}

    // MARK: Dynamic setters/getters
    /// Set an arbitrary field by name (e.g., "photourl_1")
    public mutating func set(name: String, value: String) {
        additional[name] = value
    }

    /// Read an arbitrary field
    public func get(name: String) -> String? {
        additional[name]
    }

    /// Remove an arbitrary field
    public mutating func remove(name: String) {
        additional.removeValue(forKey: name)
    }

    /// Inspect all additional fields (read-only)
    public var allAdditional: [String: String] { additional }
}

// MARK: - Custom Coding (flatten typed + dynamic)
extension BVProgressiveReviewFields: Codable {
    private enum CodingKeys: String, CodingKey {
        case rating = "rating"
        case title = "title"
        case reviewtext = "reviewtext"
        case agreedToTerms = "agreedtotermsandconditions"
        case isRecommended = "isrecommended"
        case sendEmailAlert = "sendemailalertwhenpublished"
        case hostedAuthenticationEmail = "hostedauthentication_authenticationemail"
        case hostedAuthenticationCallbackurl = "hostedauthentication_callbackurl"
    }

    public func encode(to encoder: Encoder) throws {
        // Encode typed keys first using their API field names…
        var keyed = encoder.container(keyedBy: CodingKeys.self)
        try keyed.encodeIfPresent(rating, forKey: .rating)
        try keyed.encodeIfPresent(title, forKey: .title)
        try keyed.encodeIfPresent(reviewtext, forKey: .reviewtext)
        try keyed.encodeIfPresent(agreedToTerms, forKey: .agreedToTerms)
        try keyed.encodeIfPresent(isRecommended, forKey: .isRecommended)
        try keyed.encodeIfPresent(sendEmailAlert, forKey: .sendEmailAlert)
        try keyed.encodeIfPresent(hostedAuthenticationEmail, forKey: .hostedAuthenticationEmail)
        try keyed.encodeIfPresent(hostedAuthenticationCallbackurl, forKey: .hostedAuthenticationCallbackurl)

        // …then merge dynamic keys
        var dyn = encoder.container(keyedBy: DynamicCodingKeys.self)
        for (k, v) in additional {
            try dyn.encode(v, forKey: .init(stringValue: k)!)
        }
    }

    public init(from decoder: Decoder) throws {
        // Decode known keys
        let keyed = try decoder.container(keyedBy: CodingKeys.self)
        rating = try keyed.decodeIfPresent(Int.self, forKey: .rating)
        title = try keyed.decodeIfPresent(String.self, forKey: .title)
        reviewtext = try keyed.decodeIfPresent(String.self, forKey: .reviewtext)
        agreedToTerms = try keyed.decodeIfPresent(Bool.self, forKey: .agreedToTerms)
        isRecommended = try keyed.decodeIfPresent(Bool.self, forKey: .isRecommended)
        sendEmailAlert = try keyed.decodeIfPresent(Bool.self, forKey: .sendEmailAlert)
        hostedAuthenticationEmail = try keyed.decodeIfPresent(String.self, forKey: .hostedAuthenticationEmail)
        hostedAuthenticationCallbackurl = try keyed.decodeIfPresent(String.self, forKey: .hostedAuthenticationCallbackurl)

        // Collect everything else as strings into `additional`
        additional = [:]
        let dyn = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in dyn.allKeys {
            // Skip any keys already mapped to typed fields
            if CodingKeys(rawValue: key.stringValue) != nil { continue }

            // Be forgiving: try String first, then Int/Bool -> String
            if let s = try? dyn.decode(String.self, forKey: key) {
                additional[key.stringValue] = s
            } else if let i = try? dyn.decode(Int.self, forKey: key) {
                additional[key.stringValue] = String(i)
            } else if let b = try? dyn.decode(Bool.self, forKey: key) {
                additional[key.stringValue] = b ? "true" : "false"
            }
        }
    }

    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int? { nil }
        init?(intValue: Int) { nil }
    }
}


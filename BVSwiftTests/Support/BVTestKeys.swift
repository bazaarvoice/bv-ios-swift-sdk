//
//
//  BVTestKeys.swift
//  BVSwift
//
//  Copyright © 2023 Bazaarvoice. All rights reserved.
// 

import Foundation
class BVTestKeys {
    /// Staging conversations API key used across all test files
    static let conversationsKey = "kuy3zj9pr3n7i0wxajrzj04xo"
    
    enum testTokenKeys: String {
        case validUser = "validUser"
        case invalidUser = "invalidUser"
        case multiProductUser = "multiProductUser"
        case progressiveReviewUser = "progressiveReviewUser"
        case buildRequestSession = "buildRequestSession"
        case buildHostedRequestFailureSession = "buildHostedRequestFailureSession"
        case buildHostedRequestSuccessSession = "buildHostedRequestSuccessSession"
    }
    
    func loadKey(key: testTokenKeys) -> String {
        guard let resourceURL =
                Bundle(
                    for: BVTestKeys.self)
                    .url(
                        forResource: "testTokens",
                        withExtension: ".json") else {
            return ""
        }
        do {
            let data = try Data(contentsOf: resourceURL, options: [])
            if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                return json[key.rawValue] as? String ?? ""
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
}

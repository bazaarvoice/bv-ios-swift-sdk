//
//
//  BVTestKeys.swift
//  BVSwift
//
//  Copyright © 2023 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVTestKeys {
    enum idJson: String {
        case userIdJSON = "userIdJSON"
        case sessionTokenJSON = "sessionIdJSON"
    }
    
    enum userIdKeys: String {
        case validUserId = "validUserId"
        case invalidUserId = "invalidUserId"
    }
    
    enum sessionTokenKeys: String {
        case buildRequest = "buildRequest"
        case buildRequestHostedAuthFailure = "buildRequestHostedAuthFailure"
        case buildRequestHostedAuthSuccess = "buildRequestHostedAuthSuccess"
    }
    
    func loadKeyForId(fromJSON: idJson, forId: String) -> String {
        guard let resourceURL =
                Bundle(
                    for: BVTestKeys.self)
                    .url(
                        forResource: fromJSON.rawValue,
                        withExtension: ".json") else {
            return ""
        }
        do {
            let data = try Data(contentsOf: resourceURL, options: [])
            if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                return json[forId] as? String ?? ""
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
}

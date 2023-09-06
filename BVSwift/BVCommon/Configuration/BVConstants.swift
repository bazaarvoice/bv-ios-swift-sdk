//
//  BVConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal let cfBundleVersionString = "CFBundleShortVersionString"

internal struct BVConstants {
    static let bvProduct: String = "Common"
    static let bvFrameworkBundleIndentifier: String = "BVSwift"
    static let apiClientId: String = "clientId"
    static let apiVersionField: String = "apiversion"
    static let appIdField: String = "_appId"
    static let appVersionField: String = "_appVersion"
    static let buildNumberField: String = "_buildNumber"
    static let sdkVersionField: String = "_bvIosSwiftSdkVersion"
    static let bvSwiftSDKVersion: String = "1.11.4"
    
}

internal extension Bundle {
    class var bvBundle: Bundle {
        guard let bundle = Bundle
            .allFrameworks
            .filter({ $0.bundleIdentifier?
                .contains(BVConstants.bvFrameworkBundleIndentifier) ?? false })
            .first else {
                fatalError("Improper configuration of BVSwift bundle")
        }
        return bundle
    }
    
    class var bvSdkVersion: String {
        return BVConstants.bvSwiftSDKVersion
    }
}

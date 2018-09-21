//
//  BVConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal typealias BVURLParameters = [String: String]

internal let apiVersion: String = "5.4"
internal let sdkVersion: String = "0.2.3"
internal let apiClientId: String = "clientId"

internal let apiVersionField: String = "apiversion"
internal let appIdField: String = "_appId"
internal let appVersionField: String = "_appVersion"
internal let buildNumberField: String = "_buildNumber"
internal let sdkVersionField: String = "_bvIosSwiftSdkVersion"

internal let defaultSDKParameters: BVURLParameters =
  [
    apiVersionField: apiVersion,
    appIdField: Bundle.mainBundleIdentifier,
    appVersionField: Bundle.releaseVersionNumber,
    buildNumberField: Bundle.buildVersionNumber,
    sdkVersionField: sdkVersion
]

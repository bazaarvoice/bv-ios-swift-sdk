//
//  BVConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal let cfBundleVersionString = "CFBundleShortVersionString"

internal struct BVConstants {
  static let bvFrameworkBundleIndentifier = "BVSwift"
  static let apiClientId: String = "clientId"
  static let apiVersionField: String = "apiversion"
  static let appIdField: String = "_appId"
  static let appVersionField: String = "_appVersion"
  static let buildNumberField: String = "_buildNumber"
  static let sdkVersionField: String = "_bvIosSwiftSdkVersion"
}

internal extension Bundle {
  class internal var bvBundle: Bundle {
    guard let bundle = Bundle
      .allFrameworks
      .filter({ $0.bundleIdentifier?
        .contains(BVConstants.bvFrameworkBundleIndentifier) ?? false })
      .first else {
      fatalError("Improper configuration of BVSwift bundle")
    }
    return bundle
  }
  
  class internal var bvSdkVersion: String {
    guard let version =
      bvBundle.infoDictionary?[cfBundleVersionString] as? String else {
        fatalError("Improper configuration of BVSwift bundle version")
    }
    return version
  }
}

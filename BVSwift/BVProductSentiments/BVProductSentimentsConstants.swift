//
//
//  BVProductSentimentsConstants.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVProductSentimentsConstants {
    static let bvProduct: String = "ProductSentiments"
    static let apiVersion: String = "v1"
    static let parameterKey: String = "passkey"
    static let stagingEndpoint: String =
    "https://stg.api.bazaarvoice.com/sentiment/v1/"
    static let productionEndpoint: String =
    "https://api.bazaarvoice.com/sentiment/v1/"
    
    internal struct BVProductSentimentsErrorInternal {
        static let key: String = "Errors"
        static let message: String = "Message"
        static let code: String = "Code"
    }
    
    internal struct BVQueryType {
        internal struct Keys {
            static let productId: String = "productId"
            static let limit: String = "limit"
            static let embed: String = "embed"
            static let feature: String = "feature"
        }
    }
    
    internal struct BVSummarisedFeatures {
        static let getResource: String = "summarised-features"
    }
    
    internal struct BVSummarisedFeaturesQuotes {
        static let getResource: String = "quotes"
    }
    
    internal struct BVProductFeatures {
        static let getResource: String = "features"
    }
    
    internal struct BVQuotes {
        static let getResource: String = "quotes"
    }
    
    
    internal struct BVExpressions {
        static let getResource: String = "expressions"
    }
}

internal extension Bundle {
    class var productSentimentsApiVersion: String {
      return BVProductSentimentsConstants.apiVersion
  }
}

internal let defaultPSSDKParameters: BVURLParameters =
  [
    BVConstants.apiVersionField: Bundle.productSentimentsApiVersion,
    BVConstants.appIdField: Bundle.mainBundleIdentifier,
    BVConstants.appVersionField: Bundle.releaseVersionNumber,
    BVConstants.buildNumberField: Bundle.buildVersionNumber,
    BVConstants.sdkVersionField: Bundle.bvSdkVersion
]

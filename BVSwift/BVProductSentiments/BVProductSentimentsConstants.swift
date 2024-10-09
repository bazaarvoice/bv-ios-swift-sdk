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
    
    internal struct BVSummarisedFeatures {
        //    static let singularKey: String = "Video"
        //    static let pluralKey: String = "Videos"
        static let getResource: String = "summarised-features/"

        static let singularKey: String = "response"
        static let pluralKey: String = "responses"

        internal struct Keys {
            static let passKey: String = "passkey"
            static let productId: String = "productId"
            static let embed: String = "embed"
            static let language: String = "language"
        }
    }
    
    internal struct BVSummarisedFeaturesQuotes {
        //    static let singularKey: String = "Video"
        //    static let pluralKey: String = "Videos"
        static let getResource: String = "quotes" // "summarised-features" + featureId + "quotes"
        
        internal struct Keys {
            static let passKey: String = "passkey"
            static let featureId: String = "featureId"
            static let productId: String = "productId"
            static let limit: String = "limit"
            static let language: String = "language"
        }
    }
    
    internal struct BVProductFeatures {
        //    static let singularKey: String = "Video"
        //    static let pluralKey: String = "Videos"
        static let getResource: String = "features"
        
        internal struct Keys {
            static let passKey: String = "passkey"
            static let productId: String = "productId"
            static let language: String = "language"
            static let limit: String = "limit"
        }
    }
    
    internal struct BVProductQuotes {
        //    static let singularKey: String = "Video"
        //    static let pluralKey: String = "Videos"
        static let getResource: String = "quotes"
        
        internal struct Keys {
            static let passKey: String = "passkey"
            static let productId: String = "productId"
            static let language: String = "language"
            static let limit: String = "limit"
        }
    }
    
    
    internal struct BVProductExpressions {
        //    static let singularKey: String = "Video"
        //    static let pluralKey: String = "Videos"
        static let getResource: String = "expressions"
        
        internal struct Keys {
            static let passKey: String = "passkey"
            static let productId: String = "productId"
            static let feature: String = "feature"
            static let language: String = "language"
            static let limit: String = "limit"
        }
    }
}

internal extension Bundle {
    class var productSentimentsApiVersion: String {
      return BVProductSentimentsConstants.apiVersion
  }
}

internal let defaultPSSDKParameters: BVURLParameters =
  [
    BVConstants.apiVersionField: Bundle.conversationsApiVersion,
    BVConstants.appIdField: Bundle.mainBundleIdentifier,
    BVConstants.appVersionField: Bundle.releaseVersionNumber,
    BVConstants.buildNumberField: Bundle.buildVersionNumber,
    BVConstants.sdkVersionField: Bundle.bvSdkVersion
]

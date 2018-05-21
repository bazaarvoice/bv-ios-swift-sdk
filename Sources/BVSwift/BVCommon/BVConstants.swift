//
//  BVConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal typealias BVURLParameters = [String : String]

internal let apiVersion: String = "5.4"
internal let sdkVersion: String = "7.0.0"

internal struct BVConstants {
  static let clientKey: String = "clientId"
  
  struct BVAnalytics {
    static let localeKey: String = "analyticsLocaleIdentifier"
    static let dryRunKey: String = "dryRunAnalytics"
    static let key: String = "bvanalytics"
    static let eu: String = "eu"
    static let productionEndpoint: String =
    "https://network.bazaarvoice.com/"
    static let stagingEndpoint: String =
    "https://network-stg.bazaarvoice.com/"
    static let productionEndpointEU: String =
    "https://network-eu.bazaarvoice.com/"
    static let stagingEndpointEU: String =
    "https://network-eu-stg.bazaarvoice.com/"
  }
  
  struct BVConversations {
    static let apiKey: String = "apiKeyConversations"
    static let parameterKey: String = "passkey"
    static let stagingEndpoint: String =
    "https://stg.api.bazaarvoice.com/data/"
    static let productionEndpoint: String =
    "https://api.bazaarvoice.com/data/"
  }
  
  struct BVLocaleServiceManager {
    static let resourceProduction: String = "production"
    static let resourceStaging: String = "staging"
    static let resourceDefault: String = "default"
    static let resourceValues: String = "values"
    static let resourceMappings: String = "mappings"
  }
}

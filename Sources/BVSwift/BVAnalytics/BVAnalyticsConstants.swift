//
//
//  BVAnalyticsConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation


internal struct BVAnalyticsConstants {
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
  
  struct BVAnalyticsLocaleService {
    static let resourceProduction: String = "production"
    static let resourceStaging: String = "staging"
    static let resourceDefault: String = "default"
    static let resourceValues: String = "values"
    static let resourceMappings: String = "mappings"
  }
}

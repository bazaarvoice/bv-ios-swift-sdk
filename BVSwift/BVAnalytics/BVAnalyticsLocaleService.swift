//
//
//  BVAnalyticsLocaleService.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal enum BVAnalyticsLocaleService {
  case `default`(BVConfigurationType)
  case eu(BVConfigurationType)
  
  init(locale: Locale, config: BVConfigurationType) {
    guard let region = locale.regionCode else {
      self = .default(config)
      return
    }
    
    switch region {
    case "AT" :   // Austria
      fallthrough
    case "BE" :   // Belgium
      fallthrough
    case "BG" :   // Bulgaria
      fallthrough
    case "CH" :   // Switzerland
      fallthrough
    case "CY" :   // Republic of Cyprus
      fallthrough
    case "CZ" :   // Czech Republic
      fallthrough
    case "DE" :   // Germany
      fallthrough
    case "DK" :   // Denmark
      fallthrough
    case "ES" :   // Spain
      fallthrough
    case "EE" :   // Estonia
      fallthrough
    case "FI" :   // Finland
      fallthrough
    case "FR" :   // France
      fallthrough
    case "GB" :   // Great Britain/ UK
      fallthrough
    case "GR" :   // Greece
      fallthrough
    case "HR" :   // Croatia
      fallthrough
    case "HU" :   // Hungary
      fallthrough
    case "IE" :   // Ireland
      fallthrough
    case "IS" :   // Iceland
      fallthrough
    case "IT" :   // Italy
      fallthrough
    case "LI" :   // Liechtenstein
      fallthrough
    case "LT" :   // Lithuania
      fallthrough
    case "LU" :   // Luxembourg
      fallthrough
    case "LV" :   // Latvia
      fallthrough
    case "MT" :   // Malta
      fallthrough
    case "NL" :   // Netherlands
      fallthrough
    case "NO" :   // Norway
      fallthrough
    case "PL" :   // Poland
      fallthrough
    case "PT" :   // Portugal
      fallthrough
    case "RO" :   // Romania
      fallthrough
    case "SE" :   // Sweden
      fallthrough
    case "SI" :   // Slovenia
      fallthrough
    case "SK" :   // Slovakia
      self = .eu(config)
    default:
      self = .default(config)
    }
  }
  
  var resource: String {
    switch self {
    case .eu(.production):
      return BVAnalyticsConstants.productionEndpointEU
    case .eu(.staging):
      return BVAnalyticsConstants.stagingEndpointEU
    case .default(.production):
      return BVAnalyticsConstants.productionEndpoint
    case .default(.staging):
      return BVAnalyticsConstants.stagingEndpoint
    }
  }
}

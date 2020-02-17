//
//
//  BVReviewHighlightsConfiguration.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum ReviewHighlightsConfiguration: BVConfiguration {
    
    case display(
        clientKey: String,
        configType: BVConfigurationType,
        analyticsConfig: BVAnalyticsConfiguration)
    
    public var configurationKey: String {
        switch self {
        case let .display(clientKey, _, _):
            return clientKey
        }
    }
    
    public var endpoint: String {
        return "https://rh.nexus.bazaarvoice.com"
    }
    
    public var type: BVConfigurationType {
        switch self {
        case let .display(_, configType, _):
            return configType
        }
    }
    
    internal var analyticsConfiguration: BVAnalyticsConfiguration {
        switch self {
        case let .display(_, _, analyticsConfig):
          return analyticsConfig
        }
    }
}

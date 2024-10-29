//
//
//  BVProductSentimentsConfiguration.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The main BVConfiguration implementation for Conversations
///
/// - Note:
/// \
/// The conversations configuration has a single sub-configuration dependency
/// on BVAnalytics.
public enum BVProductSentimentsConfiguration: BVConfiguration {
    
    /// This configuration allows for both submission and display request
    /// configurations. Consumers of this module will most likely just use this
    /// configuration value as they probably use both display AND submission.
    /// - Parameters:
    ///   - clientKey: The client conversations API key
    ///   - configType: The base BVConfigurationType for this conversations
    ///     configuration.
    ///   - analyticsConfig: The BVAnalyticsConfiguration used mosty for
    ///     debugging as well as setting proper locales for user data policies.
    case display(
        clientKey: String,
        configType: BVConfigurationType,
        analyticsConfig: BVAnalyticsConfiguration)
    
    /// See Protocol Definition for more info
    public var configurationKey: String {
        switch self {
        case let .display(clientKey, _, _):
            return clientKey
        }
    }
    
    /// See Protocol Definition for more info
    public var type: BVConfigurationType {
        switch self {
        case let .display(_, configType, _):
            return configType
        }
    }
    
    /// See Protocol Definition for more info
    public var endpoint: String {
      guard case .staging(_) = self.type else {
        return
          BVProductSentimentsConstants.productionEndpoint
      }
      
      return BVProductSentimentsConstants.stagingEndpoint
    }
    
    internal var analyticsConfiguration: BVAnalyticsConfiguration {
      switch self {
      case let .display(_, _, analyticsConfig):
        return analyticsConfig
      }
    }
}

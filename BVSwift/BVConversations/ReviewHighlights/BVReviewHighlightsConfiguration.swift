//
//
//  BVReviewHighlightsConfiguration.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVReviewHighlightsConfiguration: BVConfiguration {
    
    case display(
        configType: BVConfigurationType,
        analyticsConfig: BVAnalyticsConfiguration)
    
    // TODO:- Configuration Key is not required for ReviewHighlights. Need to confirm.
    /// See Protocol Definition for more info
    public var configurationKey: String {
        return ""
    }
    
    /// See Protocol Definition for more info
    public var endpoint: String {
        guard case .staging(_) = self.type else {
            return BVConversationsConstants.BVReviewHighlights.productionEndpoint
            
        }
        return BVConversationsConstants.BVReviewHighlights.stagingEndpoint
    }
    
    /// See Protocol Definition for more info
    public var type: BVConfigurationType {
        switch self {
        case let .display(configType, _):
            return configType
        }
    }
    
    internal var analyticsConfiguration: BVAnalyticsConfiguration {
        switch self {
        case let .display(_, analyticsConfig):
          return analyticsConfig
        }
    }
}

/// Conformance to Equatable
extension BVReviewHighlightsConfiguration: Equatable {
  public static func == (lhs: BVReviewHighlightsConfiguration,
                         rhs: BVReviewHighlightsConfiguration) -> Bool {
    
    if lhs.hashValue != rhs.hashValue {
      return false
    }
    
    switch (lhs, rhs) {
    case let (.display(lhsType, lhsAnalytics),
              .display(rhsType, rhsAnalytics)) where
        lhsType == rhsType &&
        lhsAnalytics == rhsAnalytics:
      return true
    default:
      return false
    }
  }
}

/// Conformance to Hashable
extension BVReviewHighlightsConfiguration: Hashable {
  public func hash(into hasher: inout Hasher) {
    switch self {
    case let .display(configType, analyticsConfig):
      hasher.combine("display")
      hasher.combine(configType)
      hasher.combine(analyticsConfig)
    }
  }
}



extension BVReviewHighlightsConfiguration: BVConfigurationInternal {
  
  /// The only sub-configuration that exists for reviewHighlights is the
  /// BVAnalyticsConfiguration.
  internal var subConfigurations: [BVConfigurationInternal]? {
    return [analyticsConfiguration]
  }
  
  internal init?(_ config: BVConfigurationType, keyValues: [String: Any]?) {
    
    guard let reviewHighlightsKeyValues = keyValues else {
      return nil
    }
    
    guard let analytics =
      BVAnalyticsConfiguration(config, keyValues: reviewHighlightsKeyValues) else {
        return nil
    }
    
    self = .display(configType: config,
                    analyticsConfig: analytics)
  }
  
  internal func isSameTypeAs(_ config: BVConfiguration) -> Bool {
    guard let reviewHighlightsConfig =
      config as? BVReviewHighlightsConfiguration else {
        return false
    }
    return self == reviewHighlightsConfig
  }
}

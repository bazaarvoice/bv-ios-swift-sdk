//
//
//  BVRecommendationsConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The main BVConfiguration implementation for Recommendations
///
/// - Note:
/// \
/// The recommendations configuration has a single sub-configuration dependency
/// on BVAnalytics.
public enum BVRecommendationsConfiguration: BVConfiguration {
  
  /// This configuration allows for ONLY display request configurations.
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
        BVRecommendationsConstants.productionEndpoint
    }
    
    return BVRecommendationsConstants.stagingEndpoint
  }
  
  internal var analyticsConfiguration: BVAnalyticsConfiguration {
    switch self {
    case let .display(_, _, analyticsConfig):
      return analyticsConfig
    }
  }
}

/// Conformance to Equatable
extension BVRecommendationsConfiguration: Equatable {
  public static func == (lhs: BVRecommendationsConfiguration,
                         rhs: BVRecommendationsConfiguration) -> Bool {
    
    if lhs.hashValue != rhs.hashValue {
      return false
    }
    
    switch (lhs, rhs) {
    case let (.display(lhsClientKey, lhsType, lhsAnalytics),
              .display(rhsClientKey, rhsType, rhsAnalytics)) where
      lhsClientKey == rhsClientKey &&
        lhsType == rhsType &&
        lhsAnalytics == rhsAnalytics:
      return true
    default:
      return false
    }
  }
}

/// Conformance to Hashable
extension BVRecommendationsConfiguration: Hashable {
  public var hashValue: Int {
    switch self {
    case let .display(clientKey, configType, analyticsConfig):
      return
        "display".djb2hash ^
          clientKey.hashValue ^
          configType.hashValue ^
          analyticsConfig.hashValue
    }
  }
}

extension BVRecommendationsConfiguration: BVConfigurationInternal {
  
  /// The only sub-configuration that exists for converrsations is the
  /// BVAnalyticsConfiguration.
  internal var subConfigurations: [BVConfigurationInternal]? {
    return [analyticsConfiguration]
  }
  
  internal init?(_ config: BVConfigurationType, keyValues: [String: Any]?) {
    
    guard let recommendationsKeyValues = keyValues else {
      return nil
    }
    
    guard let analytics =
      BVAnalyticsConfiguration(config, keyValues: keyValues) else {
        return nil
    }
    
    guard let clientKey: String =
      recommendationsKeyValues[BVRecommendationsConstants.apiKey] as? String
      else {
        return nil
    }
    
    self = .display(clientKey: clientKey,
                    configType: config,
                    analyticsConfig: analytics)
  }
  
  internal func isSameTypeAs(_ config: BVConfiguration) -> Bool {
    guard let recommendationsConfig =
      config as? BVRecommendationsConfiguration else {
        return false
    }
    return self == recommendationsConfig
  }
}

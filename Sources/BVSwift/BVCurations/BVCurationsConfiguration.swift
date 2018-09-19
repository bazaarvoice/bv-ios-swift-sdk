//
//
//  BVCurationsConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The main BVConfiguration implementation for Curations
///
/// - Note:
/// \
/// The curations configuration has a single sub-configuration dependency
/// on BVAnalytics.
public enum BVCurationsConfiguration: BVConfiguration {
  
  /// This configuration allows for both submission and display request
  /// configurations. Consumers of this module will most likely just use this
  /// configuration value as they probably use both display AND submission.
  /// - Parameters:
  ///   - clientKey: The client curations API key
  ///   - configType: The base BVConfigurationType for this curations
  ///     configuration.
  ///   - analyticsConfig: The BVAnalyticsConfiguration used mosty for
  ///     debugging as well as setting proper locales for user data policies.
  case all(
    clientKey: String,
    configType: BVConfigurationType,
    analyticsConfig: BVAnalyticsConfiguration)
  
  /// This configuration allows for ONLY display request configurations.
  /// - Parameters:
  ///   - clientKey: The client curations API key
  ///   - configType: The base BVConfigurationType for this curations
  ///     configuration.
  ///   - analyticsConfig: The BVAnalyticsConfiguration used mosty for
  ///     debugging as well as setting proper locales for user data policies.
  case display(
    clientKey: String,
    configType: BVConfigurationType,
    analyticsConfig: BVAnalyticsConfiguration)
  
  /// This configuration allows for ONLY submission request configurations.
  /// - Parameters:
  ///   - clientKey: The client curations API key
  ///   - configType: The base BVConfigurationType for this curations
  ///     configuration.
  ///   - analyticsConfig: The BVAnalyticsConfiguration used mosty for
  ///     debugging as well as setting proper locales for user data policies.
  case submission(
    clientKey: String,
    configType: BVConfigurationType,
    analyticsConfig: BVAnalyticsConfiguration)
  
  /// See Protocol Definition for more info
  public var configurationKey: String {
    switch self {
    case let .all(clientKey, _, _):
      return clientKey
    case let .display(clientKey, _, _):
      return clientKey
    case let .submission(clientKey, _, _):
      return clientKey
    }
  }
  
  /// See Protocol Definition for more info
  public var type: BVConfigurationType {
    switch self {
    case let .all(_, configType, _):
      return configType
    case let .display(_, configType, _):
      return configType
    case let .submission(_, configType, _):
      return configType
    }
  }
  
  /// See Protocol Definition for more info
  public var endpoint: String {
    guard case .staging(_) = self.type else {
      return BVCurationsConstants.productionEndpoint
    }
    
    return BVCurationsConstants.stagingEndpoint
  }
  
  internal var analyticsConfiguration: BVAnalyticsConfiguration {
    switch self {
    case let .all(_, _, analyticsConfig):
      return analyticsConfig
    case let .display(_, _, analyticsConfig):
      return analyticsConfig
    case let .submission(_, _, analyticsConfig):
      return analyticsConfig
    }
  }
}

/// Conformance to Equatable
extension BVCurationsConfiguration: Equatable {
  public static func == (lhs: BVCurationsConfiguration,
                         rhs: BVCurationsConfiguration) -> Bool {
    
    if lhs.hashValue != rhs.hashValue {
      return false
    }
    
    switch (lhs, rhs) {
    case let (.all(lhsClientKey, lhsType, lhsAnalytics),
              .all(rhsClientKey, rhsType, rhsAnalytics)) where
      lhsClientKey == rhsClientKey &&
        lhsType == rhsType &&
        lhsAnalytics == rhsAnalytics:
      return true
    case let (.display(lhsClientKey, lhsType, lhsAnalytics),
              .display(rhsClientKey, rhsType, rhsAnalytics)) where
      lhsClientKey == rhsClientKey &&
        lhsType == rhsType &&
        lhsAnalytics == rhsAnalytics:
      return true
    case let (.submission(lhsClientKey, lhsType, lhsAnalytics),
              .submission(rhsClientKey, rhsType, rhsAnalytics)) where
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
extension BVCurationsConfiguration: Hashable {
  public func hash(into hasher: inout Hasher) {
    switch self {
    case let .all(clientKey, configType, analyticsConfig):
      hasher.combine("all")
      hasher.combine(clientKey)
      hasher.combine(configType)
      hasher.combine(analyticsConfig)
    case let .display(clientKey, configType, analyticsConfig):
      hasher.combine("display")
      hasher.combine(clientKey)
      hasher.combine(configType)
      hasher.combine(analyticsConfig)
    case let .submission(clientKey, configType, analyticsConfig):
      hasher.combine("submission")
      hasher.combine(clientKey)
      hasher.combine(configType)
      hasher.combine(analyticsConfig)
    }
  }
}

extension BVCurationsConfiguration: BVConfigurationInternal {
  
  /// The only sub-configuration that exists for converrsations is the
  /// BVAnalyticsConfiguration.
  internal var subConfigurations: [BVConfigurationInternal]? {
    return [analyticsConfiguration]
  }
  
  internal init?(_ config: BVConfigurationType, keyValues: [String: Any]?) {
    
    guard let curationsKeyValues = keyValues else {
      return nil
    }
    
    guard let analytics =
      BVAnalyticsConfiguration(config, keyValues: keyValues) else {
        return nil
    }
    
    guard let clientKey: String =
      curationsKeyValues[BVCurationsConstants.apiKey] as? String
      else {
        return nil
    }
    
    self = .all(clientKey: clientKey,
                configType: config,
                analyticsConfig: analytics)
  }
  
  internal func isSameTypeAs(_ config: BVConfiguration) -> Bool {
    guard let curationsConfig =
      config as? BVCurationsConfiguration else {
        return false
    }
    return self == curationsConfig
  }
}

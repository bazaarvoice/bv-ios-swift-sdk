//
//
//  BVConversationsConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The main BVConfiguration implementation for Conversations
///
/// - Note:
/// \
/// The conversations configuration has a single sub-configuration dependency
/// on BVAnalytics.
public enum BVConversationsConfiguration: BVConfiguration {
  
  /// This configuration allows for both submission and display request
  /// configurations. Consumers of this module will most likely just use this
  /// configuration value as they probably use both display AND submission.
  /// - Parameters:
  ///   - clientKey: The client conversations API key
  ///   - configType: The base BVConfigurationType for this conversations
  ///     configuration.
  ///   - analyticsConfig: The BVAnalyticsConfiguration used mosty for
  ///     debugging as well as setting proper locales for user data policies.
  case all(
    clientKey: String,
    configType: BVConfigurationType,
    analyticsConfig: BVAnalyticsConfiguration)
  
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
  
  /// This configuration allows for ONLY submission request configurations.
  /// - Parameters:
  ///   - clientKey: The client conversations API key
  ///   - configType: The base BVConfigurationType for this conversations
  ///     configuration.
  ///   - analyticsConfig: The BVAnalyticsConfiguration used mosty for
  ///     debugging as well as setting proper locales for user data policies.
  case submission(
    clientKey: String,
    configType: BVConfigurationType,
    analyticsConfig: BVAnalyticsConfiguration)
  
  /// See Protocol Definition for more info
  public var configurationKey: String {
    get {
      switch self {
      case let .all(clientKey, _, _):
        return clientKey
      case let .display(clientKey, _, _):
        return clientKey
      case let .submission(clientKey, _, _):
        return clientKey
      }
    }
  }
  
  /// See Protocol Definition for more info
  public var type: BVConfigurationType {
    get {
      switch self {
      case let .all(_, configType, _):
        return configType
      case let .display(_, configType, _):
        return configType
      case let .submission(_, configType, _):
        return configType
      }
    }
  }
  
  /// See Protocol Definition for more info
  public var endpoint: String {
    get {
      guard case .staging(_) = self.type else {
        return
          BVConversationsConstants.productionEndpoint
      }
      
      return BVConversationsConstants.stagingEndpoint
    }
  }
  
  internal var analyticsConfiguration: BVAnalyticsConfiguration {
    get {
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
}

/// Conformance to Equatable
extension BVConversationsConfiguration: Equatable {
  public static func ==
    (lhs: BVConversationsConfiguration,
     rhs: BVConversationsConfiguration) -> Bool {
    
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
extension BVConversationsConfiguration: Hashable {
  public var hashValue: Int {
    switch self {
    case let .all(clientKey, configType, analyticsConfig):
      return
        "all".djb2hash ^
          clientKey.hashValue ^
          configType.hashValue ^
          analyticsConfig.hashValue
    case let .display(clientKey, configType, analyticsConfig):
      return
        "display".djb2hash ^
          clientKey.hashValue ^
          configType.hashValue ^
          analyticsConfig.hashValue
    case let .submission(clientKey, configType, analyticsConfig):
      return
        "submission".djb2hash ^
          clientKey.hashValue ^
          configType.hashValue ^
          analyticsConfig.hashValue
    }
  }
}

extension BVConversationsConfiguration: BVConfigurationInternal {
  
  /// The only sub-configuration that exists for converrsations is the
  /// BVAnalyticsConfiguration.
  internal var subConfigurations: [BVConfigurationInternal]? {
    get {
      return [analyticsConfiguration]
    }
  }
  
  internal init?(_ config: BVConfigurationType, keyValues: [String : Any]?) {
    
    guard let conversationsKeyValues = keyValues else {
      return nil
    }
    
    guard let analytics =
      BVAnalyticsConfiguration(config, keyValues: keyValues) else {
        return nil
    }
    
    guard let clientKey: String =
      conversationsKeyValues[BVConversationsConstants.apiKey] as? String
      else {
        return nil
    }
    
    self = .all(clientKey: clientKey,
                configType: config,
                analyticsConfig: analytics)
  }
  
  internal func isSameTypeAs(_ config: BVConfiguration) -> Bool {
    guard let conversationsConfig =
      config as? BVConversationsConfiguration else {
        return false
    }
    return self == conversationsConfig
  }
}

//
//
//  BVConversationsConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVConversationsConfiguration: BVConfiguration {
  
  case all(
    clientKey: String,
    configType: BVConfigurationType,
    analyticsConfig: BVAnalyticsConfiguration)
  case display(
    clientKey: String,
    configType: BVConfigurationType,
    analyticsConfig: BVAnalyticsConfiguration)
  case submission(
    clientKey: String,
    configType: BVConfigurationType,
    analyticsConfig: BVAnalyticsConfiguration)
  
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
  
  public var subConfigurations: [BVConfiguration]? {
    get {
      switch self {
      case let .all(_, _, analyticsConfig):
        return [analyticsConfig]
      case let .display(_, _, analyticsConfig):
        return [analyticsConfig]
      case let .submission(_, _, analyticsConfig):
        return [analyticsConfig]
      }
    }
  }
  
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
  
  public var endpoint: String {
    get {
      guard case .staging(_) = self.type else {
        return
          BVConstants.BVConversations.productionEndpoint
      }
      
      return BVConstants.BVConversations.stagingEndpoint
    }
  }
  
  public init?(_ config: BVConfigurationType, keyValues: [String : Any]?) {
    
    guard let conversationsKeyValues = keyValues else {
      return nil
    }
    
    guard let analytics =
      BVAnalyticsConfiguration(config, keyValues: keyValues) else {
        return nil
    }
    
    guard let clientId: String =
      conversationsKeyValues[BVConstants.clientKey] as? String else {
        return nil
    }
    
    self = .all(clientKey: clientId,
                configType: config,
                analyticsConfig: analytics)
  }
  
  public func isSameTypeAs(_ config: BVConfiguration) -> Bool {
    guard let conversationsConfig =
      config as? BVConversationsConfiguration else {
        return false
    }
    return self == conversationsConfig
  }
}

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

//
//
//  BVAnalyticsConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVAnalyticsConfiguration: BVConfiguration {
  
  case configuration(locale: Locale?, configType: BVConfigurationType)
  case dryRun(configType: BVConfigurationType)
  
  public var configurationKey: String {
    get {
      return type.clientId
    }
  }
  
  public var subConfigurations: [BVConfiguration]? {
    get {
      return nil
    }
  }
  
  public var type: BVConfigurationType {
    get {
      switch self {
      case let .configuration(_, configType):
        return configType
      case let .dryRun(configType):
        return configType
      }
    }
  }
  
  public var endpoint: String {
    get {
      return BVAnalyticsLocaleService(
        locale: locale, config: type).resource
    }
  }
  
  internal var locale: Locale {
    get {
      switch self {
      case let .configuration(.some(locale), _):
        return locale
      default:
        return Locale.autoupdatingCurrent
      }
    }
  }
  
  public init?(_ config: BVConfigurationType, keyValues: [String : Any]?) {
    
    guard let analyticKeyValues = keyValues else {
      self = .dryRun(configType: config)
      return
    }
    
    if let dryRun: Bool =
      analyticKeyValues[BVConstants.BVAnalytics.dryRunKey] as? Bool,
      dryRun {
      self = .dryRun(configType: config)
      return
    }
    
    guard let localeIdentifier: String =
      analyticKeyValues[BVConstants.BVAnalytics.localeKey] as? String else {
        self =
          .configuration(locale: nil, configType: config)
        return
    }
    
    self =
      .configuration(
        locale: Locale(identifier: localeIdentifier), configType: config)
  }
  
  public func isSameAs(_ config: BVConfiguration) -> Bool {
    guard let analyticsConfig =
      config as? BVAnalyticsConfiguration else {
        return false
    }
    return self == analyticsConfig
  }
}

extension BVAnalyticsConfiguration: Equatable {
  public static func ==
    (lhs: BVAnalyticsConfiguration, rhs: BVAnalyticsConfiguration) -> Bool {
    
    switch (lhs, rhs) {
    case let (.configuration(lhsLocale, lhsType),
              .configuration(rhsLocale, rhsType)) where
      lhsLocale == rhsLocale && lhsType == rhsType:
      return true
    case let (.dryRun(lhsType),
              .dryRun(rhsType)) where lhsType == rhsType:
      return true
    default:
      return false
    }
  }
}


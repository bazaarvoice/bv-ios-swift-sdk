//
//
//  BVAnalyticsConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The BVAnalytics BVConfiguration Conformance enum
///
/// This configuration is necessary for all analytics related submissions
public enum BVAnalyticsConfiguration: BVConfiguration {
  
  /// Main configuration
  /// - Parameters:
  ///   - locale: Locale used in determining analytics routing
  ///   - configType: Type of base configuration, e.g., production, etc.
  case configuration(locale: Locale?, configType: BVConfigurationType)
  
  /// Supplimentary configuration mostly used just for debugging and for
  /// silencing any analytics that you don't want leaking out into the wild.
  /// - Parameters:
  ///   - configType: Type of base configuration, e.g., production, etc.
  case dryRun(configType: BVConfigurationType)
  
  /// See Protocol Definition for more info
  public var configurationKey: String {
    get {
      return type.clientId
    }
  }
  
  /// See Protocol Definition for more info
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
  
  /// See Protocol Definition for more info
  public var endpoint: String {
    get {
      return BVAnalyticsLocaleService(
        locale: locale, config: type).resource
    }
  }
  
  /// See above enum documentation
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
}

/// Conformance to Equatable
extension BVAnalyticsConfiguration: Equatable {
  public static func ==
    (lhs: BVAnalyticsConfiguration, rhs: BVAnalyticsConfiguration) -> Bool {
    
    if lhs.hashValue != rhs.hashValue {
      return false
    }
    
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

/// Conformance to Hashable
extension BVAnalyticsConfiguration: Hashable {
  public var hashValue: Int {
    switch self {
    case let .configuration(locale, configType):
      var localeHash: Int = 17
      
      if let lc = locale {
        localeHash = lc.hashValue
      }
      
      return localeHash ^ configType.hashValue
    case let .dryRun(configType):
      return "dryRun".djb2hash ^ configType.hashValue
    }
  }
}

extension BVAnalyticsConfiguration: BVConfigurationInternal {
  
  /// There is no sub-configuration for analytics.
  internal var subConfigurations: [BVConfigurationInternal]? {
    get {
      return nil
    }
  }
  
  internal init?(_ config: BVConfigurationType, keyValues: [String : Any]?) {
    
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
  
  internal func isSameTypeAs(_ config: BVConfiguration) -> Bool {
    guard let analyticsConfig =
      config as? BVAnalyticsConfiguration else {
        return false
    }
    return self == analyticsConfig
  }
}


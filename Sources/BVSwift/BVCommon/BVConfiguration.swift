//
//  BVConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The main protocol used for defining configuration across the different
/// BV module features.
public protocol BVConfiguration {
  
  /// The key associated with the particular feature set
  var configurationKey: String { get }
  
  /// The base endpoint URL for use with the feature set
  var endpoint: String { get }
  
  /// The base type of configuration, i.e., prod or staging
  var type: BVConfigurationType { get }
}

/// The base configuration enum for all BVConfigurations
public enum BVConfigurationType {
  internal static let clientKey: String = apiClientId
  
  /// THe production configuration with BV client id
  case production(clientId: String)
  
  /// THe staging configuration with BV client id
  case staging(clientId: String)
  
  internal var clientId: String {
    get {
      switch self {
      case let .production(clientId):
        return clientId
      case let .staging(clientId):
        return clientId
      }
    }
  }
}

/// The protocol used to determine whether something is configurable or it can
/// take a configuration for whatever use.
public protocol BVConfigurable {
  associatedtype Configuration: BVConfiguration
  func configure(_ config: Configuration) -> Self
}

extension BVConfigurationType: Equatable {
  public static 
    func ==(lhs: BVConfigurationType, rhs: BVConfigurationType) -> Bool {
    switch (lhs, rhs) {
    case (.production, .production):
      fallthrough
    case (.staging, .staging):
      return true
    default:
      return false
    }
  }
}

extension  BVConfigurationType: Hashable {
  public var hashValue: Int {
    get {
      switch self {
      case let .production(clientId):
        return "production".djb2hash ^ clientId.hashValue
      case let .staging(clientId):
        return "staging".djb2hash ^ clientId.hashValue
      }
    }
  }
}

internal protocol BVConfigureExistentially {
  func configureExistentially(_ config: BVConfiguration) -> Self
}

internal protocol BVConfigurableInternal {
  associatedtype Configuration: BVConfiguration
  var configuration: Configuration? { get }
}

internal protocol BVConfigurationInternal: BVConfiguration {
  
  /// Any configurations that are related to or a subject of the feature set
  var subConfigurations: [BVConfigurationInternal]? { get }
  
  /// Initializer to be used for configuration files or structured responses
  /// from endpoints.
  /// - Parameters:
  ///   - configType: The base configuration
  ///   - keyValues: The key values used in a configuration initialization that
  ///     will be needed to determine the type of configuration for this
  ///     instance.
  init?(_ configType: BVConfigurationType, keyValues: [String : Any]?)
  
  /// Comparitor of the type of the configuration used to help sort them out
  /// from a list, array, set, etc.
  /// - Parameters:
  ///   - config: The configuration to be compared against
  func isSameTypeAs(_ config: BVConfiguration) -> Bool
}

internal struct BVRawConfiguration: BVConfigurationInternal {
  
  init?(_ configType: BVConfigurationType, keyValues: [String : Any]?) {
    return nil
  }
  
  func isSameTypeAs(_ config: BVConfiguration) -> Bool {
    guard let rawConfig = config as? BVRawConfiguration else {
      return false
    }
    return self == rawConfig
  }
  
  var configurationKey: String
  var endpoint: String
  var type: BVConfigurationType
  var subConfigurations: [BVConfigurationInternal]?
  
  init(
    key: String,
    endpoint: String,
    type: BVConfigurationType,
    subConfigs: [BVConfigurationInternal]? = nil) {
    self.configurationKey = key
    self.endpoint = endpoint
    self.type = type
    self.subConfigurations = subConfigs
  }
}

extension BVRawConfiguration: Equatable {
  public static func ==
    (lhs: BVRawConfiguration,
     rhs: BVRawConfiguration) -> Bool {
    return lhs.configurationKey == rhs.configurationKey &&
      lhs.endpoint == rhs.endpoint &&
      lhs.type == rhs.type
  }
}

internal protocol BVConfigureRaw {
  var rawConfiguration: BVRawConfiguration? { get }
  func configureRaw(_ config: BVRawConfiguration) -> Self
}

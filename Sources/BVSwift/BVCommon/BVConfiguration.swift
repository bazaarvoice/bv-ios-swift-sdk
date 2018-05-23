//
//  BVConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public protocol BVConfiguration {
  var configurationKey: String { get }
  var endpoint: String { get }
  var subConfigurations: [BVConfiguration]? { get }
  var type: BVConfigurationType { get }
  init?(_ configType: BVConfigurationType, keyValues: [String : Any]?)
  func isSameTypeAs(_ config: BVConfiguration) -> Bool
}

public enum BVConfigurationType {
  internal static let clientKey: String = BVConstants.clientKey
  
  case production(clientId: String)
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

public protocol BVConfigurable {
  associatedtype Configuration: BVConfiguration
  func configure(_ config: Configuration) -> Self
}

internal protocol BVConfigurableInternal {
  associatedtype Configuration: BVConfiguration
  var configuration: Configuration? { get }
}

internal protocol BVConfigureExistentially {
  func configureExistentially(_ config: BVConfiguration) -> Self
}

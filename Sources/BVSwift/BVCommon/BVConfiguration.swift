//
//  BVConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public protocol BVConfiguration {
  var configurationKey: String { get }
  var type: BVConfigurationType { get }
  var endpoint: String { get }
  init?(_ configType: BVConfigurationType, keyValues: [String : Any]?)
  func isSameAs(_ config: BVConfiguration) -> Bool
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

internal func ==
  (lhs: BVConfigurationType, rhs: BVConfigurationType) -> Bool {
  switch (lhs, rhs) {
  case (.production, .production):
    fallthrough
  case (.staging, .staging):
    return true
  default:
    return false
  }
}

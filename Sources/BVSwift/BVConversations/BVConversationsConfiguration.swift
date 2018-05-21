//
//
//  BVConversationsConfiguration.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVConversationsConfiguration: BVConfiguration {
  
  case all(clientKey: String, configType: BVConfigurationType)
  case display(clientKey: String, configType: BVConfigurationType)
  case submission(clientKey: String, configType: BVConfigurationType)
  
  public var configurationKey: String {
    get {
      switch self {
      case let .all(clientKey, _):
        return clientKey
      case let .display(clientKey, _):
        return clientKey
      case let .submission(clientKey, _):
        return clientKey
      }
    }
  }
  
  public var type: BVConfigurationType {
    get {
      switch self {
      case let .all(_, configType):
        return configType
      case let .display(_, configType):
        return configType
      case let .submission(_, configType):
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
    
    guard let clientId: String =
      conversationsKeyValues[BVConstants.clientKey] as? String else {
        return nil
    }
    
    self = .all(clientKey: clientId, configType: config)
  }
  
  public func isSameAs(_ config: BVConfiguration) -> Bool {
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
    switch (lhs, rhs) {
    case let (.all(lhsClientKey, lhsType),
              .all(rhsClientKey, rhsType)) where
      lhsClientKey == rhsClientKey && lhsType == rhsType:
      return true
    case let (.display(lhsClientKey, lhsType),
              .display(rhsClientKey, rhsType)) where
      lhsClientKey == rhsClientKey && lhsType == rhsType:
      return true
    case let (.submission(lhsClientKey, lhsType),
              .submission(rhsClientKey, rhsType)) where
      lhsClientKey == rhsClientKey && lhsType == rhsType:
      return true
    default:
      return false
    }
  }
}

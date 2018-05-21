//
//  BVError.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public protocol BVError: Error, CustomStringConvertible,
CustomDebugStringConvertible {
  var code: String { get }
  var message: String { get }
}

public enum BVCommonError: BVError {
  case limit(Int)
  case network(Int, String)
  case noData
  case parse(Error)
  case unknown(String)
  
  var localizedDescription: String {
    get {
      return description
    }
  }
  
  public var description: String {
    get {
      switch self {
      case .limit(let limit):
        return "Invalid `limit` value: Parameter 'limit' has invalid value:" +
        "\(limit) - must be between 1 and 100."
      case .network(let code, let msg):
        return "HTTP response status code: \(code) with error: \(msg)"
      case .noData:
        return "No JSON data body found from response."
      case .parse(let suberr):
        return "An unknown parsing error occurred: \(suberr)"
      case .unknown(let msg):
        return "An unknown error has occurred: \(msg)"
      }
    }
  }
  
  public var debugDescription: String {
    get {
      return self.description
    }
  }
  
  public var code: String {
    get {
      switch self {
      case .limit:
        return "LIMIT"
      case .network:
        return "NETWORK"
      case .noData:
        return "NO_DATA"
      case .parse:
        return "PARSE"
      case .unknown:
        return "UNKNOWN"
      }
    }
  }
  
  public var message: String {
    get {
      return description
    }
  }
}

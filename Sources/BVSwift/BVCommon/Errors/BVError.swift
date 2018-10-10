//
//  BVError.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// A protocol to represent all the basic errors that are returned/thrown
public protocol BVError: Error, CustomStringConvertible,
CustomDebugStringConvertible {
  var code: String { get }
  var message: String { get }
}

/// The basic error type of this module
/// - Note:
/// \
/// This is mostly used as very top level errors where we can't figure out
/// the specifics of what's going on or they're errors that are very close
/// to being fatal, however, are still recoverable.
public enum BVCommonError: BVError {
  case limit(Int)
  case network(Int, String)
  case noData
  case parse(Error)
  case unknown(String)
  
  var localizedDescription: String {
    return description
  }
  
  public var description: String {
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
  
  public var debugDescription: String {
    return self.description
  }
  
  public var code: String {
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
  
  public var message: String {
    return description
  }
}

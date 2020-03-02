//
//
//  BVCurationsError.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The return errors for Curations
///
/// - Note:
/// \
/// The query and submission indirect enum cases are only ever one level deep
/// in recursion. They're merely a wrapper for mirrored errors coming from two
/// different paths.
public indirect enum BVCurationsError: Error {
  
  /// A parameter is missing/erroneous or the value is missing/erroneous
  case invalidParameter(String)
  
  /// An invalid key was used for this client
  case invalidPasskey
  
  /// Wrapper case for errors eminating from a query request
  case query(BVCurationsError)
  
  /// Status for a request
  case status(UInt16?, String)
  
  /// Wrapper case for errors eminating from a submission request
  /// - Note:
  /// \
  /// Currently unused, saving for potential future usage
  case submission(BVCurationsError)
  
  /// Catch-all for any unknown or undocumented errors
  case unknown(String?)
  
  private enum CodingKeys: String, CodingKey {
    case message
  }
}

extension BVCurationsError: Equatable {
  public
  static func == (lhs: BVCurationsError, rhs: BVCurationsError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidParameter, .invalidParameter):
      fallthrough
    case (.invalidPasskey, .invalidPasskey):
      return true
    case let (.status(lhsCode, lhsMsg), .status(rhsCode, rhsMsg))
      where lhsMsg == rhsMsg:
      guard let lcode = lhsCode, let rcode = rhsCode else {
        return nil == lhsCode && nil == rhsCode
      }
      return lcode == rcode
    case let (.unknown(lhsMsg), .unknown(rhsMsg))
      where lhsMsg == rhsMsg:
      return true
    default:
      return false
    }
  }
}

extension BVCurationsError: Codable {
  /// Conformance with Encodable. Currently it isn't implemented and therefore
  /// shouldn't be used. It will fatalError to remind you :)
  /// - Note:
  /// \
  /// Please see the plethora of information regarding this protocol.
  public func encode(to encoder: Encoder) throws {
    fatalError("This isn't implemented, nor will it be.")
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let message = try container.decodeIfPresent(String.self, forKey: .message)
    
    switch message {
    case let .some(message):
      self = .status(nil, message)
    default:
      self = .unknown(message)
    }
  }
}

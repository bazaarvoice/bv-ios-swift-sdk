//
//
//  BVCurationsError.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public indirect enum BVCurationsError: Error {
  
  case invalidParameter(String)
  case invalidPasskey
  case query(BVCurationsError)
  case status(UInt16?, String)
  case submission(BVCurationsError)
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

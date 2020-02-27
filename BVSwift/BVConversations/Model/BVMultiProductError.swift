//
//
//  BVMultiProductError.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVMultiProductError: BVError {
    
    public var code: String
    public var message: String
    public var description: String
    public var debugDescription: String
    public var field: String?

    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case field = "field"
    }
}

extension BVMultiProductError: Codable {
  /// Conformance with Encodable. Currently it isn't implemented and therefore
  /// shouldn't be used. It will fatalError to remind you :)
  /// - Note:
  /// \
  /// Please see the plethora of information regarding this protocol.
  public func encode(to encoder: Encoder) throws {
    fatalError("This isn't implemented, nor will it be.")
  }
  
  /// Conformance with Decodable. Used to hydrate from the json returned from
  /// the various API calls.
  /// - Note:
  /// \
  /// Please see the plethora of information regarding this protocol.
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    if let code = try container.decodeIfPresent(String.self, forKey: .code) {
        self.code = code
    } else {
        self.code = ""
    }
    if let message = try container.decodeIfPresent(String.self, forKey: .message) {
        self.message = message
    } else{
        self.message = ""
    }
    let field = try container.decodeIfPresent(String.self, forKey: .field)
    self.field = field
    self.description = message
    self.debugDescription = ""
    
  }
}

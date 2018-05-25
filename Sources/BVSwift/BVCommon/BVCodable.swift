//
//
//  BVCodable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// A protocol to help match the naming taxonomy of objects
///
/// - Note:
/// \
/// Many BVSwift objects conform to this protocol as a lot of the backend
/// objects take on the form of single requests and bulk requests
/// cooresponding to respective responses of object(s).
public protocol BVResourceable: Codable {
  static var singularKey: String { get }
  static var pluralKey: String { get }
}

/// We use this to consolidate BV Objects since most of them have a collection
/// of let ivars. We do this to keep the door open to "immutability" if we ever
/// want to go down the Rx route and to also protect against coding instability
/// and anti-patterns by the consumers of the module.
internal protocol BVMergeable: Codable {
  associatedtype Mergeable = BVMergeable
  static func merge(from: Mergeable, into: Mergeable) -> Mergeable
  func merge(_ into: Mergeable) -> Mergeable
}

/// Type erasure because Encoders and Decoders need concrete types defined when
/// inside various container types.
internal struct BVAnyCodable<T : Codable>: Codable {
  private var box: T?
  var value: T? {
    get {
      return box
    }
  }
  
  init(_ codable: T) {
    self.box = codable
  }
  
  public init(from decoder: Decoder) throws {
    box = try T(from: decoder)
  }
  
  public func encode(to encoder: Encoder) throws {
    guard let encodableBox = box else {
      return
    }
    try encodableBox.encode(to: encoder)
  }
}

internal struct BVAnyEncodable: Encodable {
  private var box: Encodable?
  var value: Encodable? {
    get {
      return box
    }
  }
  
  init(_ encodable: Encodable) {
    self.box = encodable
  }
  
  public func encode(to encoder: Encoder) throws {
    guard let encodableBox = box else {
      return
    }
    try encodableBox.encode(to: encoder)
  }
}

internal struct BVAnyDecodable<T : Decodable>: Decodable {
  private var box: Decodable?
  var value: Decodable? {
    get {
      return box
    }
  }
  
  public init(from decoder: Decoder) throws {
    box = try T(from: decoder)
  }
}

internal struct BVCodingKey : CodingKey {
  var stringValue: String = String.empty
  var intValue: Int?
  
  init?(stringValue: String) {
    self.stringValue = stringValue
  }
  
  init?(intValue: Int) {
    self.intValue = intValue
  }
}

/// So far this only does decoding
internal struct BVCodableDictionary<T: Codable>: Codable {
  var array:[T]?
  let dictionary: [String : T]?
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: BVCodingKey.self)
    
    var foundDict: [String : T] = [:]
    var foundArray: [T] = []
    for key in container.allKeys {
      let object: T = try container.decode(T.self, forKey: key)
      foundArray.append(object)
      foundDict[key.stringValue] = object
    }
    array = foundArray
    dictionary = foundDict
  }
}

/// So far this only does decoding
internal struct BVCodableRawDecoder: Codable {
  let decoder:Decoder?
  
  public init(from decoder: Decoder) throws {
    self.decoder = decoder
  }
  
  public func encode(to encoder: Encoder) throws {
    assert(false, "encode isn't supported, so nothing will be encoded.")
  }
}

/// So far this only does decoding
internal struct BVCodableWrapper<T: Codable>: Codable {
  let unwrapped:T?
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: BVCodingKey.self)
    
    var found: T? = nil
    if let key = container.allKeys.first {
      let object:T = try container.decode(T.self, forKey: key)
      found = object
    }
    unwrapped = found
  }
}

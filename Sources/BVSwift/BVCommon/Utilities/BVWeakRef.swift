//
//
//  BVWeakRef.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

prefix operator **

internal struct BVWeakRef {
  private weak var instance: AnyObject?
  
  static prefix func ** (weakRef: BVWeakRef) -> AnyObject? {
    return weakRef.instance
  }
  
  init() {
    self.instance = nil
  }
  
  init(_ instanceType: AnyObject) {
    self.instance = instanceType
  }
}

extension BVWeakRef: Hashable {
  var hashValue: Int {
    guard let inst = instance else {
      return 0
    }
    return unsafeBitCast(inst, to: Int.self)
  }
  
  static func == (lhs: BVWeakRef, rhs: BVWeakRef) -> Bool {
    switch (**lhs, **rhs) {
    case (.some, .some) where lhs.hashValue == rhs.hashValue:
      return true
    case (.none, .none):
      return true
    default:
      return false
    }
  }
}

internal struct BVPRNG: RandomNumberGenerator {
  private static let alignment: Int = MemoryLayout<UInt8>.alignment
  private static let byteStride: Int = MemoryLayout<UInt64>.size
  private static let byteCount: Int = (1 << byteStride)
  private var randBag: [UInt64] = []
  private let buffer: UnsafeMutableRawPointer
  
  private mutating func replenishBuffer() {
    if errSecSuccess !=
      SecRandomCopyBytes(kSecRandomDefault, BVPRNG.byteCount, buffer) {
      /// We somehow failed here but nonetheless we can fallback to another,
      /// albeit, less desirable entropy source
      arc4random_buf(buffer, BVPRNG.byteCount)
    }
    
    var offset: Int = 0x0
    let bufferPointer =
      UnsafeRawBufferPointer(start: buffer, count: BVPRNG.byteCount)
    
    while offset < bufferPointer.count {
      randBag.append(
        bufferPointer.load(fromByteOffset: offset, as: UInt64.self))
      offset += BVPRNG.byteStride
    }
  }
  
  internal init(_ size: UInt = UInt(BVPRNG.byteCount)) {
    buffer = UnsafeMutableRawPointer.allocate(
      byteCount: BVPRNG.byteCount, alignment: BVPRNG.alignment)
  }
  
  public mutating func next() -> UInt64 {
    if randBag.isEmpty {
      replenishBuffer()
    }
    return randBag.removeFirst()
  }
}

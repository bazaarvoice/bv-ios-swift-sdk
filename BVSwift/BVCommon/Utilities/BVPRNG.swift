//
//
//  BVPRNG.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVPRNG: RandomNumberGenerator {
  private typealias XoshiroStateType = (UInt64, UInt64, UInt64, UInt64)
  private var state: XoshiroStateType = (0, 0, 0, 0)
  
  internal init() {
    let byteCount = withUnsafeMutableBytes(of: &state) { $0.count }
    withUnsafeMutablePointer(to: &state) {
      let bufferPtr = UnsafeMutableRawPointer($0)
      if errSecSuccess !=
        SecRandomCopyBytes(kSecRandomDefault, byteCount, bufferPtr) {
        /// We somehow failed here but nonetheless we can fallback to another,
        /// albeit, less desirable entropy source
        arc4random_buf(bufferPtr, byteCount)
      }
    }
  }
  
  public mutating func next() -> UInt64 {
    // http://xoshiro.di.unimi.it
    let x = state.1 &* 5
    let t = state.1 &<< 17
    state.2 ^= state.0
    state.3 ^= state.1
    state.1 ^= state.2
    state.0 ^= state.3
    state.2 ^= t
    state.3 = (state.3 &<< 45) | (state.3 &>> 19)
    return ((x &<< 7) | (x &>> 57)) &* 9
  }
}

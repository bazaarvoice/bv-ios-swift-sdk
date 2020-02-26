//
//
//  BVLogMessage.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVLogMessage: CustomStringConvertible {
  private let msg: String?
  internal let bvProduct: String
  
  var description: String {
    return "\(msg ?? "")"
  }
  
  init(_ bvProduct: String, msg: String? = "") {
    self.bvProduct = bvProduct
    self.msg = msg
  }
}

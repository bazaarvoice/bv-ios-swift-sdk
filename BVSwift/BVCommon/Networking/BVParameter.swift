//
//  BVParameter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal protocol BVParameter {
  var name: String { get }
  var value: String { get }
}

internal protocol BVCustomStringConvertible: CustomStringConvertible {
  var internalDescription: String { get }
}

internal extension URLQueryItem {
    init(_ bvParameter: BVParameter) {
    self.init(name: bvParameter.name, value: bvParameter.value)
  }
}

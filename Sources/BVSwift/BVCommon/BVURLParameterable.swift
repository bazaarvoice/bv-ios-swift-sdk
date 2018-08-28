//
//
//  BVURLParameterable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal protocol BVURLQueryItemable {
  var urlQueryItems: [URLQueryItem]? { get }
}

internal protocol BVURLParameterable: BVURLQueryItemable {
  var parameters: [BVURLParameter] { get }
  func add(_ parameter: BVURLParameter, coalesce: Bool)
  func set(_ parameters: [BVURLParameter])
  func update(_ parameter: BVURLParameter)
}

internal extension BVURLParameterable {
  var queryItems: [URLQueryItem]? {
    return parameters.map(URLQueryItem.init)
  }
}

extension BVURLParameterable {
  func add(
    _ parameter: BVURLParameter, coalesce: Bool = false) {
    guard coalesce else {
      if 0 == parameters.filter({ $0 === parameter }).count {
        var paramsTemp = parameters
        paramsTemp.append(parameter)
        set(paramsTemp)
      }
      return
    }
    
    var coalesceList: [BVURLParameter] = []
    var otherList: [BVURLParameter] = []
    parameters.forEach { (param: BVURLParameter) in
      if param %% parameter {
        coalesceList.append(param)
      } else {
        otherList.append(param)
      }
    }
    
    let coalesce: BVURLParameter =
      coalesceList.reduce(parameter, +~)
    otherList.append(coalesce)
    
    set(otherList)
  }
  
  func update(_ parameter: BVURLParameter) {
    var paramsTemp: [BVURLParameter] =
      parameters.filter { $0 !%% parameter }
    paramsTemp.append(parameter)
    
    set(paramsTemp)
  }
}

//
//
//  BVEmployeeStat.swift
//  BVSwift
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVEmployeeStat: BVQueryStat {
  
  case employeeId
  case name
  case salary
  case currency
    
  
  public static var statPrefix: String {
    return "include"
  }
  
  public var description: String {
    return internalDescription
  }
}

extension BVEmployeeStat: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .employeeId:
        return "id"
        
    case .name:
        return "name"
        
    case .salary:
        return "employeeSal"
        
    case .currency:
        return "currency"
    }
  }
}

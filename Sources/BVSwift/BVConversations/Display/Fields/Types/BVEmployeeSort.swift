//
//
//  BVEmployeeSort.swift
//  BVSwift
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVEmployeeSort: BVQuerySort {
    
    case employeeId
    case employeeName
    case employeeSalary
    case currency
    
    public static var sortPrefix: String {
        return "sort"
    }
    
    public static var sortTypeSeparator: String {
        return "_"
    }
    
    public static var sortValueSeparator: String {
        return ":"
    }
    
    public var description: String {
        return internalDescription
    }
}

extension BVEmployeeSort: BVConversationsQueryValue {
    
    var internalDescription: String {
        switch  self {
        case .employeeId:
            return "id"
            
        case .employeeName:
            return "name"
            
        case .employeeSalary:
            return "employeeSal"
            
        case .currency:
            return "currency"
        }
    }
}

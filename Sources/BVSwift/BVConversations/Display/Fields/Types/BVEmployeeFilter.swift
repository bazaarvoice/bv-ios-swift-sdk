//
//
//  BVEmployeeFilter.swift
//  BVSwift
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVEmployeeFilter: BVQueryFilter {
    
    case employeeId(UInt16)
    case employeeName(String)
    case employeeSalary(UInt16)
    case currency(String)
    
    public static var filterPrefix: String {
        return "filter"
    }
    
    public static var filterTypeSeparator: String {
        return "_"
    }
    
    public static var filterValueSeparator: String {
        return ":"
    }
    
    public var representedValue: CustomStringConvertible {
        switch self {
        case let .employeeId(filter):
            return filter
        case let .employeeName(filter):
            return filter
        case let .employeeSalary(filter):
            return filter
        case let .currency(filter):
            return filter
        }
    }
    
    public var description: String {
        return internalDescription
    }
}

extension BVEmployeeFilter: BVConversationsQueryValue {
    var internalDescription: String {
        switch self {
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

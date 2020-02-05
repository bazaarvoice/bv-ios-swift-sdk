//
//
//  BVEmployee.swift
//  BVSwift
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVEmployee: BVQueryable {
    
    public static var singularKey: String {
        return BVConversationsConstants.BVEmployees.singularKey
    }
    
    public static var pluralKey: String {
        return BVConversationsConstants.BVEmployees.pluralKey
    }
    
    public let employeeId: UInt16?
    public let employeeName: String?
    public let employeeSalary: UInt16?
    public let currency: String?
    
    private enum CodingKeys: String, CodingKey {
        case employeeId = "id"
        case employeeName = "name"
        case employeeSalary = "employeeSal"
        case currency = "currency"
        
    }
}

extension BVEmployee: BVQueryableInternal {
    static var getResource: String? {
        return BVConversationsConstants.BVEmployees.getResource
    }
}

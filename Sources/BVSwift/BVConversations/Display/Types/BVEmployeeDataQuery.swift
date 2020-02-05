//
//
//  BVEmployeeDataQuery.swift
//  BVSwift
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVEmployeeDataQuery: BVConversationsQuery<BVEmployee> {    
    public init() {
        super.init(BVEmployee.self)
    }
}

extension BVEmployeeDataQuery: BVQueryStatable {
    public typealias Stat = BVEmployeeStat
    
    @discardableResult
    public func stats(_ for: BVEmployeeDataQuery.Stat) -> Self {
        let internalStat: BVURLParameter = .stats(`for`, nil)
        add(internalStat)
        return self
    }
}

extension BVEmployeeDataQuery: BVQueryFilterable {
    public typealias Filter = BVEmployeeFilter
    
    public typealias Operator = BVConversationsFilterOperator
    
    @discardableResult
    public func filter(_ apply: (Filter, Operator)...) -> Self {
      type(of: self).groupFilters(apply).forEach { group in
        let expr: BVQueryFilterExpression<Filter, Operator> =
          1 < group.count ? .or(group) : .and(group)
        flatten(expr).forEach { add($0) }
      }
      return self
    }
}

extension BVEmployeeDataQuery: BVQuerySortable {
    public typealias Sort = BVEmployeeSort
    
    public typealias Order = BVConversationsSortOrder
    
    @discardableResult
    public func sort(_ on: Sort, order: Order) -> Self {
      let internalSort: BVURLParameter = .sort(on, order, nil)
      add(internalSort)
      return self
    }
}

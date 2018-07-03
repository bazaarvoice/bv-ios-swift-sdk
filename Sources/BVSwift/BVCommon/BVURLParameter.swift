//
//  BVURLParameter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

// MARK: - BVURLParameter
internal indirect enum BVURLParameter: BVParameter {
  case unsafe(
    CustomStringConvertible,
    CustomStringConvertible,
    BVURLParameter?)
  case field(
    BVQueryField,
    BVURLParameter?)
  case filter(
    BVQueryFilter,
    BVQueryfiltererator,
    BVURLParameter?)
  case filterType(
    BVQueryFilter,
    BVQueryFilter,
    BVQueryfiltererator,
    BVURLParameter?)
  case include(BVQueryInclude, BVURLParameter?)
  case includeLimit(
    BVQueryInclude, UInt16, BVURLParameter?)
  case sort(
    BVQuerySort,
    BVQuerySortOrder,
    BVURLParameter?)
  case sortType(
    BVQuerySort,
    BVQuerySort,
    BVQuerySortOrder,
    BVURLParameter?)
  case stats(BVQueryStat, BVURLParameter?)
  
  var name: String {
    switch self {
    case .unsafe(let field, _, _):
      return field.description
    case .field(let field, _):
      return field.description.escaping()
    case .filter(let filter, _, _):
      return type(of: filter).filterPrefix.escaping()
    case .filterType(let filter, _, _, _):
      let separator = type(of: filter).filterTypeSeparator
      return
        [type(of: filter).filterPrefix.escaping(),
         filter.description.escaping()]
          .joined(separator: separator)
    case .include(let include, _):
      return type(of: include).includePrefix.escaping()
    case .includeLimit(let include, _, _):
      let limitKey = type(of: include).includeLimitKey
      let separator = type(of: include).includeLimitSeparator
      return [limitKey,
              include.description.escaping()].joined(separator: separator)
    case .sort(let sort, _, _):
      return type(of: sort).sortPrefix.escaping()
    case .sortType(let sort, _, _, _):
      let separator = type(of: sort).sortTypeSeparator
      return
        [type(of: sort).sortPrefix.escaping(),
         sort.description.escaping()]
          .joined(separator: separator)
    case .stats(let stats, _):
      return type(of: stats).statPrefix.escaping()
    }
  }
  
  var value: String {
    
    var final: String = ""
    
    switch self {
    case .unsafe(_, let value, _):
      final = value.description
    case .field(let field, _):
      final = field.representedValue.description.escaping()
    case .filter(let filter, let op, _):
      let separator = type(of: filter).filterValueSeparator
      final =
        [filter.description.escaping(),
         op.description.escaping(),
         "\(filter.representedValue)".escaping()]
          .joined(separator: separator)
    case .filterType(_, let filter, let op, _):
      let separator = type(of: filter).filterValueSeparator
      final =
        [filter.description,
         op.description,
         "\(filter.representedValue)".escaping()]
          .joined(separator: separator)
    case .include(let include, _):
      final = include.description
    case .includeLimit(_, let limit, _):
      final = limit.description
    case .sort(let sort, let order, _):
      let separator = type(of: sort).sortValueSeparator
      final =
        [sort.description, order.description].joined(separator: separator)
    case .sortType(_, let sort, let order, _):
      let separator = type(of: sort).sortValueSeparator
      final =
        [sort.description, order.description].joined(separator: separator)
    case .stats(let stats, _):
      final = stats.description
    }
    
    guard let next = child else {
      return final
    }
    
    return [next.value, final].joined(separator: ",")
  }
  
  private init(
    parent: BVURLParameter,
    child: BVURLParameter?) {
    
    /// If we don't have an orphan just return parent.
    if nil != parent.child {
      self = parent
    }
    
    /// We have a valid child but it's not the same genus.
    if let unwrapChild = child, parent != unwrapChild {
      self = parent
    }
    
    switch parent {
    case let .unsafe(field, value, _):
      self = .unsafe(field, value, child)
    case let .field(field, _):
      self = .field(field, child)
    case let .filter(filter, op, _):
      self = .filter(filter, op, child)
    case let .filterType(typefilter, filter, op, _):
      self = .filterType(typefilter, filter, op, child)
    case let .include(inc, _):
      self = .include(inc, child)
    case let .includeLimit(inc, limit, _):
      self = .includeLimit(inc, limit, child)
    case let .sort(sort, op, _):
      self = .sort(sort, op, child)
    case let .sortType(type, sort, op, _):
      self = .sortType(type, sort, op, child)
    case let .stats(stats, _):
      self = .stats(stats, child)
    }
  }
  
  private var peek: String {
    switch self {
    case .unsafe(_, let value, _):
      return value.description.escaping()
    case .field(let value, _):
      return value.description.escaping()
    case .filter(let filter, let op, _):
      let separator = type(of: filter).filterValueSeparator
      return
        [filter.description,
         op.description,
         "\(filter.representedValue)".escaping()].joined(separator: separator)
    case .filterType(_, let filter, let op, _):
      let separator = type(of: filter).filterValueSeparator
      return
        [filter.description,
         op.description,
         "\(filter.representedValue)".escaping()].joined(separator: separator)
    case .include(let include, _):
      return include.description
    case .includeLimit(_, let limit, _):
      return limit.description
    case .sort(let sort, let order, _):
      let separator = type(of: sort).sortValueSeparator
      return
        [sort.description, order.description].joined(separator: separator)
    case .sortType(_, let sort, let order, _):
      let separator = type(of: sort).sortValueSeparator
      return
        [sort.description, order.description].joined(separator: separator)
    case .stats(let stats, _):
      return stats.description
    }
  }
  
  private var pop: BVURLParameter {
    switch self {
    case let .unsafe(field, value, _):
      return .unsafe(field, value, nil)
    case let .field(field, _):
      return .field(field, nil)
    case let .filter(filter, op, _):
      return .filter(filter, op, nil)
    case let .filterType(typefilter, filter, op, _):
      return .filterType(typefilter, filter, op, nil)
    case let .include(inc, _):
      return .include(inc, nil)
    case let .includeLimit(inc, limit, _):
      return .includeLimit(inc, limit, nil)
    case let .sort(sort, op, _):
      return .sort(sort, op, nil)
    case let .sortType(type, sort, op, _):
      return .sortType(type, sort, op, nil)
    case let .stats(stats, _):
      return .stats(stats, nil)
    }
  }
  
  private var child: BVURLParameter? {
    switch self {
    case .unsafe(_, _, let child):
      return child
    case .field(_, let child):
      return child
    case .filter(_, _, let child):
      return child
    case .filterType(_, _, _, let child):
      return child
    case .include(_, let child):
      return child
    case .includeLimit(_, _, let child):
      return child
    case .sort(_, _, let child):
      return child
    case .sortType(_, _, _, let child):
      return child
    case .stats(_, let child):
      return child
    }
  }
  
  private var children: [BVURLParameter] {
    var list: [BVURLParameter] =
      [BVURLParameter]()
    var cursor: BVURLParameter? = self.child
    
    while let sub = cursor {
      list.append(BVURLParameter(parent: sub, child: nil))
      cursor = sub.child
    }
    
    return list
  }
}

extension BVURLParameter: Hashable {
  var hashValue: Int {
    return name.djb2hash ^ value.hashValue
  }
}

/*
 * It's not clear whether these definitions overload externally so we'll just
 * be careful and use extra characters in an attempt to mitigate collisions.
 */
infix operator ~~ : AdditionPrecedence
infix operator +~ : AdditionPrecedence
infix operator %% : ComparisonPrecedence
infix operator !%% : ComparisonPrecedence

extension BVURLParameter: Equatable {
  
  /*
   * `%%` runs off of the logic of comparing only genus of enum.
   */
  static internal func %% (lhs: BVURLParameter, rhs: BVURLParameter) -> Bool {
    switch (lhs, rhs) {
    case (.unsafe, .unsafe) where lhs.name == rhs.name:
      return true
    case (.field, .field) where lhs.name == rhs.name:
      return true
    case (.filter, .filter) where lhs.name == rhs.name:
      return true
    case (.filterType, .filterType) where lhs.name == rhs.name:
      return true
    case (.include, .include) where lhs.name == rhs.name:
      return true
    case (.includeLimit, .includeLimit) where lhs.name == rhs.name:
      return true
    case (.sort, .sort) where lhs.name == rhs.name:
      return true
    case (.sortType, .sortType) where lhs.name == rhs.name:
      return true
    case (.stats, .stats) where lhs.name == rhs.name:
      return true
    default:
      return false
    }
  }
  
  static internal func !%% (lhs: BVURLParameter, rhs: BVURLParameter) -> Bool {
    return !(lhs %% rhs)
  }
  
  /*
   * `~=` runs off of the logic of comparing genus and first level value of
   * enum.
   */
  static internal func ~= (lhs: BVURLParameter, rhs: BVURLParameter) -> Bool {
    
    guard lhs %% rhs else {
      return false
    }
    
    switch (lhs, rhs) {
    case (.unsafe, .unsafe) where lhs.peek == rhs.peek:
      return true
    case (.field, .field) where lhs.peek == rhs.peek:
      return true
    case (.filter, .filter) where lhs.peek == rhs.peek:
      return true
    case (.filterType, .filterType) where lhs.peek == rhs.peek:
      return true
    case (.include, .include) where lhs.peek == rhs.peek:
      return true
    case (.includeLimit, .includeLimit) where lhs.peek == rhs.peek:
      return true
    case (.sort, .sort) where lhs.peek == rhs.peek:
      return true
    case (.sortType, .sortType) where lhs.peek == rhs.peek:
      return true
    case (.stats, .stats) where lhs.peek == rhs.peek:
      return true
    default:
      return false
    }
  }
  
  /*
   * `~~` runs off of the logic of substring comparing the value and returning
   * the substring valued parameter.
   */
  static internal func ~~ (lhs: BVURLParameter,
                           rhs: BVURLParameter) -> BVURLParameter? {
    
    if lhs %% rhs {
      if nil != lhs.value.range(of: rhs.value) {
        return rhs
      }
      
      if nil != rhs.value.range(of: lhs.value) {
        return lhs
      }
    }
    
    return nil
  }
  
  /*
   * `==` runs off of the logic of colescing the field value
   * not necessarily matching on the values of the parameter.
   */
  static internal func == (lhs: BVURLParameter,
                           rhs: BVURLParameter) -> Bool {
    return (lhs %% rhs) && (lhs.value == rhs.value)
  }
  
  static internal func != (lhs: BVURLParameter,
                           rhs: BVURLParameter) -> Bool {
    return !(lhs == rhs)
  }
  
  /*
   * `===` runs off of the logic of matching the entirety of the name and value
   * tree.
   */
  static internal func === (lhs: BVURLParameter,
                            rhs: BVURLParameter) -> Bool {
    
    if lhs !%% rhs {
      return false
    }
    
    if lhs.peek != rhs.peek {
      return false
    }
    
    let lhsChildren: [BVURLParameter] = lhs.children
    let rhsChildren: [BVURLParameter] = rhs.children
    
    if lhsChildren.count != rhsChildren.count {
      return false
    }
    
    if 0 == lhsChildren.filter({ rhsChildren.contains($0) }).count {
      return false
    }
    
    return true
  }
  
  static internal func !== (lhs: BVURLParameter,
                            rhs: BVURLParameter) -> Bool {
    return !(lhs === rhs)
  }
  
  static internal func + (lhs: BVURLParameter,
                          rhs: BVURLParameter) -> BVURLParameter {
    return merge(lhs: lhs, rhs: rhs)
  }
  
  static internal func +~ (lhs: BVURLParameter,
                           rhs: BVURLParameter) -> BVURLParameter {
    return merge(lhs: lhs, rhs: rhs, unique: true)
  }
  
  static private func merge(lhs: BVURLParameter,
                            rhs: BVURLParameter,
                            unique: Bool = false) -> BVURLParameter {
    
    /// Not the same genus, pass.
    if lhs !%% rhs {
      return lhs
    }
    
    /// They're completely the same, pass.
    if lhs === rhs {
      return lhs
    }
    
    /// O.K., time to concatenate! We're following left to right precedence
    /// which means that we actually attach the reverse based on how we will
    /// be coalescing
    
    var left: [BVURLParameter] = lhs.children
    var right: BVURLParameter = rhs
    
    /// If we're unique-ing the merge then we take the union and then build
    /// back up from there.
    if unique {
      
      /// Slowpath, have to union everything together
      let rhsSet = Set<BVURLParameter>(rhs.children + [rhs.pop])
      let lhsSet = Set<BVURLParameter>(lhs.children + [lhs.pop])
      
      var merge = Array(lhsSet.union(rhsSet))
        .sorted { (lhs: BVURLParameter, rhs: BVURLParameter) -> Bool in
          return lhs.value < rhs.value
      }
      
      let candidate = merge.remove(at: 0)
      
      left = merge
      right = candidate
    } else {
      
      /// Fastpaths, just append root child to nil child list
      if nil == rhs.child {
        return BVURLParameter(parent: rhs, child: lhs)
      }
      
      if nil == lhs.child {
        return BVURLParameter(parent: lhs, child: rhs)
      }
      
      /// Obviously, shouldn't happen
      guard let rightChild = rhs.child else {
        fatalError(
          "BVURLParameter: right-hand side shouldn't be nil.")
      }
      
      right = rightChild
    }
    
    /// Slowpath, have to walk left children and append new child list
    return left.reduce(right) {
      (previous: BVURLParameter, next: BVURLParameter) -> BVURLParameter in
      return BVURLParameter(parent: next, child: previous)
    }
  }
}

//
//  BVURLParameter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

// MARK: - BVURLParameter
internal indirect enum BVURLParameter: BVParameter {
  case field(
    BVQueryField,
    BVURLParameter?)
  case filter(
    BVQueryFilter,
    BVQueryFilterOperator,
    BVURLParameter?)
  case filterType(
    BVQueryFilter,
    BVQueryFilter,
    BVQueryFilterOperator,
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
  case unsafe(
    CustomStringConvertible,
    CustomStringConvertible,
    BVURLParameter?)
  
  var name: String {
    switch self {
    case .field(let field, _):
      return field.description.escaping()
    case .filter(let filter, _, _):
      return type(of: filter).filterPrefix.escaping()
    case .filterType(let filter, _, _, _):
      let prefix = type(of: filter).filterPrefix.escaping()
      let separator = type(of: filter).filterTypeSeparator
      return [prefix, filter.description.escaping()]
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
      let prefix = type(of: sort).sortPrefix.escaping()
      let separator = type(of: sort).sortTypeSeparator
      return
        [prefix, sort.description.escaping()].joined(separator: separator)
    case .stats(let stats, _):
      return type(of: stats).statPrefix.escaping()
    case .unsafe(let field, _, _):
      return field.description.escaping()
    }
  }
  
  var value: String {
    return ([self] + children)
      .reduce([String: [String]]()) { result, param in
        var ret = result
        ret[param.headValue] =
          (param.tailValue.map { return [$0] } ?? []) +
          (ret[param.headValue] ?? [])
        return ret
      }.map {
        return $0.0 + $0.1.sorted().joined(separator: ",")
      }
      .sorted()
      .joined(separator: ",")
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
    case let .unsafe(field, value, _):
      self = .unsafe(field, value, child)
    }
  }
  
  private var headValue: String {
    switch self {
    case let .filter(filter, op, _):
      let separator = type(of: filter).filterValueSeparator
      return [filter.description.escaping(),
              op.description.escaping(),
              String.empty]
        .joined(separator: separator)
    case let .filterType(_, filter, op, _):
      let separator = type(of: filter).filterValueSeparator
      return [filter.description.escaping(),
              op.description.escaping(),
              String.empty]
        .joined(separator: separator)
    default:
      return peek
    }
  }
  
  private var tailValue: String? {
    switch self {
    case let .filter(filter, _, _):
      return "\(filter.representedValue)".escaping()
    case let .filterType(_, filter, _, _):
      return "\(filter.representedValue)".escaping()
    default:
      return nil
    }
  }
  
  private var peek: String {
    switch self {
    case .field(let value, _):
      return value.representedValue.description.escaping()
    case .filter(let filter, let op, _):
      let separator = type(of: filter).filterValueSeparator
      return
        [filter.description.escaping(),
         op.description.escaping(),
         "\(filter.representedValue)".escaping()].joined(separator: separator)
    case .filterType(_, let filter, let op, _):
      let separator = type(of: filter).filterValueSeparator
      return
        [filter.description.escaping(),
         op.description.escaping(),
         "\(filter.representedValue)".escaping()].joined(separator: separator)
    case .include(let include, _):
      return include.description.escaping()
    case .includeLimit(_, let limit, _):
      return limit.description.escaping()
    case .sort(let sort, let order, _):
      let separator = type(of: sort).sortValueSeparator
      return
        [sort.description.escaping(),
         order.description.escaping()].joined(separator: separator)
    case .sortType(_, let sort, let order, _):
      let separator = type(of: sort).sortValueSeparator
      return
        [sort.description.escaping(),
         order.description.escaping()].joined(separator: separator)
    case .stats(let stats, _):
      return stats.description.escaping()
    case .unsafe(_, let value, _):
      return value.description.escaping()
    }
  }
  
  private var pop: BVURLParameter {
    switch self {
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
    case let .unsafe(field, value, _):
      return .unsafe(field, value, nil)
    }
  }
  
  private var child: BVURLParameter? {
    switch self {
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
    case .unsafe(_, _, let child):
      return child
    }
  }
  
  private var children: [BVURLParameter] {
    var list: [BVURLParameter] = [BVURLParameter]()
    var cursor: BVURLParameter? = self.child
    
    while let sub = cursor {
      list.append(BVURLParameter(parent: sub, child: nil))
      cursor = sub.child
    }
    return list
  }
}

extension BVURLParameter {
  internal func contains(_ parameter: BVURLParameter) -> Bool {
    return children.reduce(parameter == pop) {
      return $0 || parameter == $1
    }
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
infix operator %% : ComparisonPrecedence
infix operator !%% : ComparisonPrecedence

extension BVURLParameter: Equatable {
  
  /*
   * `%%` runs off of the logic of comparing only genus of enum.
   */
  static internal func %% (lhs: BVURLParameter, rhs: BVURLParameter) -> Bool {
    switch (lhs, rhs) {
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
    case (.unsafe, .unsafe) where lhs.name == rhs.name:
      return true
    default:
      return false
    }
  }
  
  static internal func !%% (lhs: BVURLParameter, rhs: BVURLParameter) -> Bool {
    return !(lhs %% rhs)
  }
  
  /*
   * `~=` runs off of the logic of comparing genus and first level value
   * construction of the enum.
   */
  static internal func ~= (lhs: BVURLParameter, rhs: BVURLParameter) -> Bool {
    
    guard lhs %% rhs else {
      return false
    }
    
    switch (lhs, rhs) {
    case (.filter, .filter):
      fallthrough
    case (.filterType, .filterType):
      return lhs.headValue == rhs.headValue
    default:
      return true
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
    
    /// Silly optimization, since we already compared the genus, we just need
    /// to check the value.
    if lhs.peek != rhs.peek {
      return false
    }
    
    if lhs.children.count != rhs.children.count {
      return false
    }
    
    let lhsChildren = Set<BVURLParameter>(lhs.children)
    let rhsChildren = Set<BVURLParameter>(rhs.children)
    
    return lhsChildren == rhsChildren
  }
  
  static internal func !== (lhs: BVURLParameter,
                            rhs: BVURLParameter) -> Bool {
    return !(lhs === rhs)
  }
  
  static internal func += (lhs: inout BVURLParameter,
                           rhs: BVURLParameter) {
    lhs = (lhs + rhs)
  }
  
  static internal func + (lhs: BVURLParameter,
                          rhs: BVURLParameter) -> BVURLParameter {
    
    /// Not the same genus, pass.
    if lhs !%% rhs {
      return lhs
    }
    
    /// Fastpaths, just append root child to nil child list
    if nil == lhs.child {
      return rhs.contains(lhs) ? rhs : BVURLParameter(parent: lhs, child: rhs)
    }
    
    if nil == rhs.child {
      return lhs.contains(rhs) ? lhs : BVURLParameter(parent: rhs, child: lhs)
    }
    
    /// Slowpath, have to toss everything into a Set and filter based on
    /// whether there are subset matching. Else, we end up union'ing the sets
    /// to get back a re-constructed coalesced object.
    let rhsSet = Set<BVURLParameter>(rhs.children + [rhs.pop])
    let lhsSet = Set<BVURLParameter>(lhs.children + [lhs.pop])
    
    /// They're strict [sub/super]sets or completely the same, pass.
    ///
    /// We do this in here so we hopefully don't have to allocate buffers to
    /// make the merge. Sure, the compiler should probably be smart, but we're
    /// going to assume a dumb compiler just in case.
    if lhsSet.isSuperset(of: rhsSet) {
      return lhs
    }
    
    if rhsSet.isSuperset(of: lhsSet) {
      return rhs
    }
    
    /// O.K., time to union! We're following left to right precedence
    /// which means that we actually attach the reverse based on how we will
    /// be coalescing, however, the returned values are sorted before being
    /// returned so it doesn't really matter the construction.
    
    return lhsSet
      .union(rhsSet)
      .reduce(nil) { return BVURLParameter(parent: $1, child: $0) } ?? lhs
  }
}

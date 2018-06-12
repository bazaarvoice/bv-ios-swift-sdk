//
//  BVConversationsQueryParameter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

// MARK: - BVConversationsQueryParameter
internal indirect enum BVConversationsQueryParameter: BVParameter {
  case custom(
    CustomStringConvertible,
    CustomStringConvertible,
    BVConversationsQueryParameter?)
  case customField(
    BVConversationsQueryField,
    BVConversationsQueryParameter?)
  case filter(
    BVConversationsQueryFilter,
    BVConversationsQueryFilterOperator,
    BVConversationsQueryParameter?)
  case filterType(
    BVConversationsQueryFilter,
    BVConversationsQueryFilter,
    BVConversationsQueryFilterOperator,
    BVConversationsQueryParameter?)
  case include(BVConversationsQueryInclude, BVConversationsQueryParameter?)
  case includeLimit(
    BVConversationsQueryInclude, UInt16, BVConversationsQueryParameter?)
  case sort(
    BVConversationsQuerySort,
    BVConversationsQuerySortOrder,
    BVConversationsQueryParameter?)
  case sortType(
    BVConversationsQuerySort,
    BVConversationsQuerySort,
    BVConversationsQuerySortOrder,
    BVConversationsQueryParameter?)
  case stats(BVConversationsQueryStat, BVConversationsQueryParameter?)
  
  var name: String {
    get {
      switch self {
      case .custom(let field, _, _):
        return field.description.escaping()
      case .customField(let field, _):
        return type(of: field).fieldPrefix.escaping()
      case .filter(let filter, _, _):
        return type(of: filter).filterPrefix.escaping()
      case .filterType(let filter, _, _, _):
        return
          [type(of: filter).filterPrefix.escaping(),
           filter.description.escaping()]
            .joined(separator: "_")
      case .include(let include, _):
        return type(of: include).includePrefix.escaping()
      case .includeLimit(let include, _, _):
        let limitKey:String =
          BVConversationsConstants.BVQueryType.Keys.limit.escaping()
        return [limitKey,
                include.description.escaping()].joined(separator: "_")
      case .sort(let sort, _, _):
        return type(of: sort).sortPrefix.escaping()
      case .sortType(let sort, _, _, _):
        return
          [type(of: sort).sortPrefix.escaping(),
           sort.description.escaping()]
            .joined(separator: "_")
      case .stats(let stats, _):
        return type(of: stats).statPrefix.escaping()
      }
    }
  }
  
  var value: String {
    get {
      
      var final:String = ""
      
      switch self {
      case .custom(_, let value, _):
        final = value.description
        break
      case .customField(let field, _):
        final = field.description
        break
      case .filter(let filter, let op, _):
        final =
          [filter.description.escaping(),
           op.description.escaping(),
           "\(filter.representedValue)".escaping()].joined(separator: ":")
        break
      case .filterType(_, let filter, let op, _):
        final =
          [filter.description,
           op.description,
           "\(filter.representedValue)".escaping()].joined(separator: ":")
        break
      case .include(let include, _):
        final = include.description
        break
      case .includeLimit(_, let limit, _):
        final = limit.description
        break
      case .sort(let sort, let order, _):
        final =
          [sort.description, order.description].joined(separator: ":")
        break
      case .sortType(_, let sort, let order, _):
        final =
          [sort.description, order.description].joined(separator: ":")
        break
      case .stats(let stats, _):
        final = stats.description
        break
      }
      
      guard let next = child else {
        return final
      }
      
      return [next.value, final].joined(separator: ",")
    }
  }
  
  private init(
    parent: BVConversationsQueryParameter,
    child: BVConversationsQueryParameter?) {
    
    /// If we don't have an orphan just return parent.
    if let _ = parent.child {
      self = parent
    }
    
    /// We have a valid child but it's not the same genus.
    if let unwrapChild = child, parent != unwrapChild {
      self = parent
    }
    
    switch parent {
    case let .custom(field, value, _):
      self = .custom(field, value, child)
      break
    case let .customField(field, _):
      self = .customField(field, child)
      break
    case let .filter(filter, op, _):
      self = .filter(filter, op, child)
      break
    case let .filterType(typefilter, filter, op, _):
      self = .filterType(typefilter, filter, op, child)
      break
    case let .include(inc, _):
      self = .include(inc, child)
      break
    case let .includeLimit(inc, limit, _):
      self = .includeLimit(inc, limit, child)
      break
    case let .sort(sort, op, _):
      self = .sort(sort, op, child)
      break
    case let .sortType(type, sort, op, _):
      self = .sortType(type, sort, op, child)
      break
    case let .stats(stats, _):
      self = .stats(stats, child)
      break
    }
  }
  
  private var peek: String {
    switch self {
    case .custom(_, let value, _):
      return value.description.escaping()
    case .customField(let value, _):
      return value.description.escaping()
    case .filter(let filter, let op, _):
      return
        [filter.description,
         op.description,
         "\(filter.representedValue)".escaping()].joined(separator: ":")
    case .filterType(_, let filter, let op, _):
      return
        [filter.description,
         op.description,
         "\(filter.representedValue)".escaping()].joined(separator: ":")
    case .include(let include, _):
      return include.description
    case .includeLimit(_, let limit, _):
      return limit.description
    case .sort(let sort, let order, _):
      return
        [sort.description, order.description].joined(separator: ":")
    case .sortType(_, let sort, let order, _):
      return
        [sort.description, order.description].joined(separator: ":")
    case .stats(let stats, _):
      return stats.description
    }
  }
  
  private var child: BVConversationsQueryParameter? {
    get {
      switch self {
      case .custom(_, _, let child):
        return child
      case .customField(_, let child):
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
  }
  
  private var children: [BVConversationsQueryParameter] {
    get {
      var list:[BVConversationsQueryParameter] =
        [BVConversationsQueryParameter]()
      var cursor:BVConversationsQueryParameter? = self.child
      
      while let sub = cursor {
        list.append(BVConversationsQueryParameter(parent: sub, child: nil))
        cursor = sub.child
      }
      
      return list
    }
  }
}

/*
 * It's not clear whether these definitions overload externally so we'll just
 * be careful and use extra characters in an attempt to mitigate collisions.
 */
infix operator ~~ : AdditionPrecedence
infix operator %% : ComparisonPrecedence
infix operator !%% : ComparisonPrecedence

extension BVConversationsQueryParameter: Equatable {
  
  /*
   * `%%` runs off of the logic of comparing only genus of enum.
   */
  static internal func %%
    (lhs: BVConversationsQueryParameter,
     rhs: BVConversationsQueryParameter) -> Bool {
    switch (lhs, rhs) {
    case (.custom, .custom) where lhs.name == rhs.name:
      return true
    case (.customField, .customField) where lhs.name == rhs.name:
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
  
  static internal func !%%
    (lhs: BVConversationsQueryParameter,
     rhs: BVConversationsQueryParameter) -> Bool {
    return !(lhs %% rhs)
  }
  
  /*
   * `~~` runs off of the logic of substring comparing the value and returning
   * the substring valued parameter.
   */
  static internal func ~~
    (lhs: BVConversationsQueryParameter,
     rhs: BVConversationsQueryParameter) -> BVConversationsQueryParameter? {
    
    if lhs %% rhs {
      if let _ = lhs.value.range(of: rhs.value) {
        return rhs
      }
      
      if let _ = rhs.value.range(of: lhs.value) {
        return lhs
      }
    }
    
    return nil
  }
  
  /*
   * `==` runs off of the logic of colescing the field value
   * not necessarily matching on the values of the parameter.
   */
  static internal func ==
    (lhs: BVConversationsQueryParameter,
     rhs: BVConversationsQueryParameter) -> Bool {
    return (lhs %% rhs) && (lhs.value == rhs.value)
  }
  
  static internal func !=
    (lhs: BVConversationsQueryParameter,
     rhs: BVConversationsQueryParameter) -> Bool {
    return !(lhs == rhs)
  }
  
  /*
   * `===` runs off of the logic of matching the entirety of the name and value
   * tree.
   */
  static internal func ===
    (lhs: BVConversationsQueryParameter,
     rhs: BVConversationsQueryParameter) -> Bool {
    
    if lhs !%% rhs {
      return false
    }
    
    if lhs.peek != rhs.peek {
      return false
    }
    
    let lhsChildren: [BVConversationsQueryParameter] = lhs.children
    let rhsChildren: [BVConversationsQueryParameter] = rhs.children
    
    if lhsChildren.count != rhsChildren.count {
      return false
    }
    
    if 0 == lhsChildren.filter({ rhsChildren.contains($0) }).count {
      return false
    }
    
    return true
  }
  
  static internal func !==
    (lhs: BVConversationsQueryParameter,
     rhs: BVConversationsQueryParameter) -> Bool {
    return !(lhs === rhs)
  }
  
  static internal func +
    (lhs: BVConversationsQueryParameter,
     rhs: BVConversationsQueryParameter) -> BVConversationsQueryParameter {
    
    /// Not the same genus, pass.
    if lhs !%% rhs {
      return lhs
    }
    
    /// They're completely the same, pass.
    if lhs === rhs {
      return lhs
    }
    
    /// O.K., time to concatenate! We're following left to right precedence
    /// which means that we actually attach the reverse based on how we will be
    /// coalescing
    if nil == rhs.child {
      return BVConversationsQueryParameter(parent: rhs, child: lhs)
    }
    
    /// Fastpaths, just append root child to nil child list
    if nil == lhs.child {
      return BVConversationsQueryParameter(parent: lhs, child: rhs)
    }
    
    /// Obviously, shouldn't happen
    guard let right = rhs.child else {
      fatalError(
        "BVConversationsQueryParameter: right-hand side shouldn't be nil.")
    }
    
    /// Slowpath, have to walk left children and append new child list
    return lhs.children.reduce(right) {
      (previous: BVConversationsQueryParameter,
      next: BVConversationsQueryParameter) -> BVConversationsQueryParameter in
      return BVConversationsQueryParameter(parent: next, child: previous)
    }
  }
}

extension BVConversationsQueryParameter: Hashable {
  var hashValue: Int {
    return name.djb2hash ^ value.hashValue
  }
}

// MARK: - BVSearchQueryField
internal struct BVSearchQueryField: BVConversationsQueryField {
  
  static var fieldPrefix: String {
    get {
      return BVConversationsConstants.BVQuerySearch.defaultField
    }
  }
  
  var internalDescription: String
  
  var description: String {
    get {
      return internalDescription
    }
  }
  
  init(_ searchQuery: String) {
    internalDescription = searchQuery
  }
}

// MARK: - BVLimitQueryField
internal struct BVLimitQueryField: BVConversationsQueryField {
  
  static var fieldPrefix: String {
    get {
      return BVConversationsConstants.BVQueryType.Keys.limit
    }
  }
  
  var internalDescription: String
  
  var description: String {
    get {
      return internalDescription
    }
  }
  
  init(_ limit: UInt16) {
    internalDescription = "\(limit)"
  }
}

// MARK: - BVOffsetQueryField
internal struct BVOffsetQueryField: BVConversationsQueryField {
  
  static var fieldPrefix: String {
    get {
      return BVConversationsConstants.BVQueryType.Keys.offset
    }
  }
  
  var internalDescription: String
  
  var description: String {
    get {
      return internalDescription
    }
  }
  
  init(_ offset: UInt16) {
    internalDescription = "\(offset)"
  }
}

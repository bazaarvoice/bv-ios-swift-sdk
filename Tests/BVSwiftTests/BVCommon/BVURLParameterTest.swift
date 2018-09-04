//
//
//  BVURLParameterTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVURLParameterTest: XCTestCase {
  
  private enum BVURLParameterTestValue:
    BVQueryFilter,
    BVQueryInclude,
    BVQuerySort,
  BVQueryStat {
    
    static var filterPrefix: String {
      get {
        return "Filter"
      }
    }
    
    static var filterTypeSeparator: String {
      get {
        return "_"
      }
    }
    
    static var filterValueSeparator: String {
      get {
        return ":"
      }
    }
    
    static var includePrefix: String {
      get {
        return "Include"
      }
    }
    
    static var includeLimitKey: String {
      get {
        return "Limit"
      }
    }
    
    static var includeLimitSeparator: String {
      get {
        return "_"
      }
    }
    
    static var sortPrefix: String {
      get {
        return "Sort"
      }
    }
    
    static var sortTypeSeparator: String {
      get {
        return "_"
      }
    }
    
    static var sortValueSeparator: String {
      get {
        return ":"
      }
    }
    
    static var statPrefix: String {
      get {
        return "Stats"
      }
    }
    
    case un(String)
    case deux(String)
    case trois(String)
    case quatre(String)
    
    var description: String {
      get {
        switch self {
        case .un:
          return "Un"
        case .deux:
          return "Deux"
        case .trois:
          return "Trois"
        case .quatre:
          return "Quatre"
        }
      }
    }
    
    var representedValue: CustomStringConvertible {
      get {
        switch self {
        case let .un(value):
          return value
        case let .deux(value):
          return value
        case let .trois(value):
          return value
        case let .quatre(value):
          return value
        }
      }
    }
  }
  
  private enum BVURLParameterTestOperator:
    String,
    BVQueryFilterOperator,
  BVQuerySortOrder {
    case plus
    case moins
    case egale
    case non
    
    var description: String {
      get {
        return rawValue
      }
    }
  }
  
  func testURLParameterCustom() {
    
    let un: BVURLParameter =
      .unsafe(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.plus,
              nil)
    
    let deux: BVURLParameter =
      .unsafe(BVURLParameterTestValue.deux("2"),
              BVURLParameterTestOperator.moins,
              nil)
    
    let trois: BVURLParameter =
      .unsafe(BVURLParameterTestValue.trois("3"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let quatre: BVURLParameter =
      .unsafe(BVURLParameterTestValue.quatre("4"),
              BVURLParameterTestOperator.non,
              nil)
    
    XCTAssertEqual(un.name, "Un")
    XCTAssertEqual(deux.name, "Deux")
    XCTAssertEqual(trois.name, "Trois")
    XCTAssertEqual(quatre.name, "Quatre")
    
    XCTAssertEqual(un.value, "plus")
    XCTAssertEqual(deux.value, "moins")
    XCTAssertEqual(trois.value, "egale")
    XCTAssertEqual(quatre.value, "non")
  }
  
  func testURLParameterCustomCoalesce() {
    
    let un: BVURLParameter =
      .unsafe(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.plus,
              nil)
    
    let deux: BVURLParameter =
      .unsafe(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.moins,
              nil)
    
    let trois: BVURLParameter =
      .unsafe(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let quatre: BVURLParameter =
      .unsafe(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.non,
              nil)
    
    
    let coalesced: BVURLParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Un")
    XCTAssertEqual(coalesced.value,
                   "egale,moins,non,plus")
  }
  
  func testURLParameterCustomCoalesceUnique() {
    
    let un: BVURLParameter =
      .unsafe(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.plus,
              nil)
    
    let deux: BVURLParameter =
      .unsafe(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.moins,
              nil)
    
    let trois: BVURLParameter =
      .unsafe(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.egale,
              nil)
    
    
    let coalesced: BVURLParameter = un +~ deux +~ deux +~ deux +~ trois
    
    XCTAssertEqual(coalesced.name, "Un")
    XCTAssertEqual(coalesced.value, "egale,moins,plus")
  }
  
  func testURLParameterFilter() {
    
    let un: BVURLParameter =
      .filter(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let deux: BVURLParameter =
      .filter(BVURLParameterTestValue.deux("2"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let trois: BVURLParameter =
      .filter(BVURLParameterTestValue.trois("3"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let quatre: BVURLParameter =
      .filter(BVURLParameterTestValue.quatre("4"),
              BVURLParameterTestOperator.egale,
              nil)
    
    XCTAssertEqual(un.name, "Filter")
    XCTAssertEqual(deux.name, "Filter")
    XCTAssertEqual(trois.name, "Filter")
    XCTAssertEqual(quatre.name, "Filter")
    
    XCTAssertEqual(un.value, "Un:egale:1")
    XCTAssertEqual(deux.value, "Deux:egale:2")
    XCTAssertEqual(trois.value, "Trois:egale:3")
    XCTAssertEqual(quatre.value, "Quatre:egale:4")
  }
  
  func testURLParameterFilterCoalesce() {
    
    let un: BVURLParameter =
      .filter(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let deux: BVURLParameter =
      .filter(BVURLParameterTestValue.deux("2"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let trois: BVURLParameter =
      .filter(BVURLParameterTestValue.trois("3"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let quatre: BVURLParameter =
      .filter(BVURLParameterTestValue.quatre("4"),
              BVURLParameterTestOperator.egale,
              nil)
    
    
    let coalesced: BVURLParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Filter")
    XCTAssertEqual(coalesced.value,
                   "Deux:egale:2,Quatre:egale:4,Trois:egale:3,Un:egale:1")
  }
  
  func testURLParameterFilterCoalesceSame() {
    
    let un: BVURLParameter =
      .filter(BVURLParameterTestValue.un("1"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let deux: BVURLParameter =
      .filter(BVURLParameterTestValue.un("2"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let trois: BVURLParameter =
      .filter(BVURLParameterTestValue.un("3"),
              BVURLParameterTestOperator.egale,
              nil)
    
    let quatre: BVURLParameter =
      .filter(BVURLParameterTestValue.un("4"),
              BVURLParameterTestOperator.egale,
              nil)
    
    
    let coalesced: BVURLParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Filter")
    XCTAssertEqual(coalesced.value,
                   "Un:egale:1,2,3,4")
  }
  
  func testURLParameterFilterType() {
    
    let filterTypeUnDeux: BVURLParameter =
      .filterType(BVURLParameterTestValue.un("1"),
                  BVURLParameterTestValue.deux("2"),
                  BVURLParameterTestOperator.egale,
                  nil)
    
    let filterTypeTroisQuatre: BVURLParameter =
      .filterType(BVURLParameterTestValue.trois("3"),
                  BVURLParameterTestValue.quatre("4"),
                  BVURLParameterTestOperator.egale,
                  nil)
    
    XCTAssertEqual(filterTypeUnDeux.name, "Filter_Un")
    XCTAssertEqual(filterTypeUnDeux.value, "Deux:egale:2")
    XCTAssertEqual(filterTypeTroisQuatre.name, "Filter_Trois")
    XCTAssertEqual(filterTypeTroisQuatre.value, "Quatre:egale:4")
  }
  
  func testURLParameterFilterTypeCoalesce() {
    
    let filterTypeUnDeux: BVURLParameter =
      .filterType(BVURLParameterTestValue.un("1"),
                  BVURLParameterTestValue.deux("2"),
                  BVURLParameterTestOperator.egale,
                  nil)
    
    let filterTypeUnTrois: BVURLParameter =
      .filterType(BVURLParameterTestValue.un("1"),
                  BVURLParameterTestValue.trois("3"),
                  BVURLParameterTestOperator.egale,
                  nil)
    
    let filterTypeUnQuatre: BVURLParameter =
      .filterType(BVURLParameterTestValue.un("1"),
                  BVURLParameterTestValue.quatre("4"),
                  BVURLParameterTestOperator.egale,
                  nil)
    
    let coalesced: BVURLParameter =
      filterTypeUnDeux + filterTypeUnTrois + filterTypeUnQuatre
    
    XCTAssertEqual(coalesced.name, "Filter_Un")
    XCTAssertEqual(coalesced.value,
                   "Deux:egale:2,Quatre:egale:4,Trois:egale:3")
  }
  
  func testURLParameterInclude() {
    
    let un: BVURLParameter =
      .include(BVURLParameterTestValue.un("1"), nil)
    
    let unLimit: BVURLParameter =
      .includeLimit(BVURLParameterTestValue.un("1"), 10, nil)
    
    let deux: BVURLParameter =
      .include(BVURLParameterTestValue.deux("2"), nil)
    
    let deuxLimit: BVURLParameter =
      .includeLimit(BVURLParameterTestValue.deux("2"), 10, nil)
    
    let trois: BVURLParameter =
      .include(BVURLParameterTestValue.trois("3"), nil)
    
    let troisLimit: BVURLParameter =
      .includeLimit(BVURLParameterTestValue.trois("3"), 10, nil)
    
    let quatre: BVURLParameter =
      .include(BVURLParameterTestValue.quatre("4"), nil)
    
    let quatreLimit: BVURLParameter =
      .includeLimit(BVURLParameterTestValue.quatre("4"), 10, nil)
    
    XCTAssertEqual(un.name, "Include")
    XCTAssertEqual(deux.name, "Include")
    XCTAssertEqual(trois.name, "Include")
    XCTAssertEqual(quatre.name, "Include")
    
    XCTAssertEqual(unLimit.name, "Limit_Un")
    XCTAssertEqual(deuxLimit.name, "Limit_Deux")
    XCTAssertEqual(troisLimit.name, "Limit_Trois")
    XCTAssertEqual(quatreLimit.name, "Limit_Quatre")
    
    XCTAssertEqual(un.value, "Un")
    XCTAssertEqual(deux.value, "Deux")
    XCTAssertEqual(trois.value, "Trois")
    XCTAssertEqual(quatre.value, "Quatre")
    
    XCTAssertEqual(unLimit.value, "10")
    XCTAssertEqual(deuxLimit.value, "10")
    XCTAssertEqual(troisLimit.value, "10")
    XCTAssertEqual(quatreLimit.value, "10")
  }
  
  func testURLParameterIncludeCoalesce() {
    
    let un: BVURLParameter =
      .include(BVURLParameterTestValue.un("1"), nil)
    
    let deux: BVURLParameter =
      .include(BVURLParameterTestValue.deux("2"), nil)
    
    let trois: BVURLParameter =
      .include(BVURLParameterTestValue.trois("3"), nil)
    
    let quatre: BVURLParameter =
      .include(BVURLParameterTestValue.quatre("4"), nil)
    
    let coalesced: BVURLParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Include")
    XCTAssertEqual(coalesced.value, "Deux,Quatre,Trois,Un")
  }
  
  func testURLParameterSort() {
    
    let un: BVURLParameter =
      .sort(BVURLParameterTestValue.un("1"),
            BVURLParameterTestOperator.egale,
            nil)
    
    let deux: BVURLParameter =
      .sort(BVURLParameterTestValue.deux("2"),
            BVURLParameterTestOperator.egale,
            nil)
    
    let trois: BVURLParameter =
      .sort(BVURLParameterTestValue.trois("3"),
            BVURLParameterTestOperator.egale,
            nil)
    
    let quatre: BVURLParameter =
      .sort(BVURLParameterTestValue.quatre("4"),
            BVURLParameterTestOperator.egale,
            nil)
    
    XCTAssertEqual(un.name, "Sort")
    XCTAssertEqual(deux.name, "Sort")
    XCTAssertEqual(trois.name, "Sort")
    XCTAssertEqual(quatre.name, "Sort")
    
    XCTAssertEqual(un.value, "Un:egale")
    XCTAssertEqual(deux.value, "Deux:egale")
    XCTAssertEqual(trois.value, "Trois:egale")
    XCTAssertEqual(quatre.value, "Quatre:egale")
  }
  
  func testURLParameterSortCoalesce() {
    
    let un: BVURLParameter =
      .sort(BVURLParameterTestValue.un("1"),
            BVURLParameterTestOperator.egale,
            nil)
    
    let deux: BVURLParameter =
      .sort(BVURLParameterTestValue.deux("2"),
            BVURLParameterTestOperator.egale,
            nil)
    
    let trois: BVURLParameter =
      .sort(BVURLParameterTestValue.trois("3"),
            BVURLParameterTestOperator.egale,
            nil)
    
    let quatre: BVURLParameter =
      .sort(BVURLParameterTestValue.quatre("4"),
            BVURLParameterTestOperator.egale,
            nil)
    
    
    let coalesced: BVURLParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Sort")
    XCTAssertEqual(coalesced.value,
                   "Deux:egale,Quatre:egale,Trois:egale,Un:egale")
  }
  
  func testURLParameterSortType() {
    
    let sortTypeUnDeux: BVURLParameter =
      .sortType(BVURLParameterTestValue.un("1"),
                BVURLParameterTestValue.deux("2"),
                BVURLParameterTestOperator.egale,
                nil)
    
    let sortTypeTroisQuatre: BVURLParameter =
      .sortType(BVURLParameterTestValue.trois("3"),
                BVURLParameterTestValue.quatre("4"),
                BVURLParameterTestOperator.egale,
                nil)
    
    XCTAssertEqual(sortTypeUnDeux.name, "Sort_Un")
    XCTAssertEqual(sortTypeUnDeux.value, "Deux:egale")
    XCTAssertEqual(sortTypeTroisQuatre.name, "Sort_Trois")
    XCTAssertEqual(sortTypeTroisQuatre.value, "Quatre:egale")
  }
  
  func testURLParameterSortTypeCoalesce() {
    
    let sortTypeUnDeux: BVURLParameter =
      .sortType(BVURLParameterTestValue.un("1"),
                BVURLParameterTestValue.deux("2"),
                BVURLParameterTestOperator.egale,
                nil)
    
    let sortTypeUnTrois: BVURLParameter =
      .sortType(BVURLParameterTestValue.un("1"),
                BVURLParameterTestValue.trois("3"),
                BVURLParameterTestOperator.egale,
                nil)
    
    let sortTypeUnQuatre: BVURLParameter =
      .sortType(BVURLParameterTestValue.un("1"),
                BVURLParameterTestValue.quatre("4"),
                BVURLParameterTestOperator.egale,
                nil)
    
    let coalesced: BVURLParameter =
      sortTypeUnDeux + sortTypeUnTrois + sortTypeUnQuatre
    
    XCTAssertEqual(coalesced.name, "Sort_Un")
    XCTAssertEqual(coalesced.value,
                   "Deux:egale,Quatre:egale,Trois:egale")
  }
  
  func testURLParameterStat() {
    
    let un: BVURLParameter =
      .stats(BVURLParameterTestValue.un("1"), nil)
    
    let deux: BVURLParameter =
      .stats(BVURLParameterTestValue.deux("2"), nil)
    
    let trois: BVURLParameter =
      .stats(BVURLParameterTestValue.trois("3"), nil)
    
    let quatre: BVURLParameter =
      .stats(BVURLParameterTestValue.quatre("4"), nil)
    
    XCTAssertEqual(un.name, "Stats")
    XCTAssertEqual(deux.name, "Stats")
    XCTAssertEqual(trois.name, "Stats")
    XCTAssertEqual(quatre.name, "Stats")
    
    XCTAssertEqual(un.value, "Un")
    XCTAssertEqual(deux.value, "Deux")
    XCTAssertEqual(trois.value, "Trois")
    XCTAssertEqual(quatre.value, "Quatre")
  }
  
  func testURLParameterStatCoalesce() {
    
    let un: BVURLParameter =
      .stats(BVURLParameterTestValue.un("1"), nil)
    
    let deux: BVURLParameter =
      .stats(BVURLParameterTestValue.deux("2"), nil)
    
    let trois: BVURLParameter =
      .stats(BVURLParameterTestValue.trois("3"), nil)
    
    let quatre: BVURLParameter =
      .stats(BVURLParameterTestValue.quatre("4"), nil)
    
    let coalesced: BVURLParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Stats")
    XCTAssertEqual(coalesced.value, "Deux,Quatre,Trois,Un")
  }
}

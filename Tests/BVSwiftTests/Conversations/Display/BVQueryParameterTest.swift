//
//
//  BVQueryParameterTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVQueryParameterTest: XCTestCase {
  
  private enum BVQueryParameterTestValue:
    BVConversationsQueryFilter,
    BVConversationsQueryInclude,
    BVConversationsQuerySort,
  BVConversationsQueryStat {
    
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
  
  private enum BVQueryParameterTestOperator:
    String,
    BVConversationsQueryFilterOperator,
  BVConversationsQuerySortOrder {
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
  
  func testQueryParameterCustom() {
    
    let un: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.un("1"),
              BVQueryParameterTestOperator.plus,
              nil)
    
    let deux: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.deux("2"),
              BVQueryParameterTestOperator.moins,
              nil)
    
    let trois: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.trois("3"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    let quatre: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.quatre("4"),
              BVQueryParameterTestOperator.non,
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
  
  func testQueryParameterCustomCoalesce() {
    
    let un: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.un("1"),
              BVQueryParameterTestOperator.plus,
              nil)
    
    let deux: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.un("1"),
              BVQueryParameterTestOperator.moins,
              nil)
    
    let trois: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.un("1"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    let quatre: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.un("1"),
              BVQueryParameterTestOperator.non,
              nil)
    
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Un")
    XCTAssertEqual(coalesced.value,
                   "plus,moins,egale,non")
  }
  
  func testQueryParameterFilter() {
    
    let un: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.un("1"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    let deux: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.deux("2"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    let trois: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.trois("3"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    let quatre: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.quatre("4"),
              BVQueryParameterTestOperator.egale,
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
  
  func testQueryParameterFilterCoalesce() {
    
    let un: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.un("1"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    let deux: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.deux("2"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    let trois: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.trois("3"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    let quatre: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.quatre("4"),
              BVQueryParameterTestOperator.egale,
              nil)
    
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Filter")
    XCTAssertEqual(coalesced.value,
                   "Un:egale:1,Deux:egale:2,Trois:egale:3,Quatre:egale:4")
  }
  
  func testQueryParameterFilterType() {
    
    let filterTypeUnDeux: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.un("1"),
                  BVQueryParameterTestValue.deux("2"),
                  BVQueryParameterTestOperator.egale,
                  nil)
    
    let filterTypeTroisQuatre: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.trois("3"),
                  BVQueryParameterTestValue.quatre("4"),
                  BVQueryParameterTestOperator.egale,
                  nil)
    
    XCTAssertEqual(filterTypeUnDeux.name, "Filter_Un")
    XCTAssertEqual(filterTypeUnDeux.value, "Deux:egale:2")
    XCTAssertEqual(filterTypeTroisQuatre.name, "Filter_Trois")
    XCTAssertEqual(filterTypeTroisQuatre.value, "Quatre:egale:4")
  }
  
  func testQueryParameterFilterTypeCoalesce() {
    
    let filterTypeUnDeux: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.un("1"),
                  BVQueryParameterTestValue.deux("2"),
                  BVQueryParameterTestOperator.egale,
                  nil)
    
    let filterTypeUnTrois: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.un("1"),
                  BVQueryParameterTestValue.trois("3"),
                  BVQueryParameterTestOperator.egale,
                  nil)
    
    let filterTypeUnQuatre: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.un("1"),
                  BVQueryParameterTestValue.quatre("4"),
                  BVQueryParameterTestOperator.egale,
                  nil)
    
    let coalesced: BVConversationsQueryParameter =
      filterTypeUnDeux + filterTypeUnTrois + filterTypeUnQuatre
    
    XCTAssertEqual(coalesced.name, "Filter_Un")
    XCTAssertEqual(coalesced.value,
                   "Deux:egale:2,Trois:egale:3,Quatre:egale:4")
  }
  
  func testQueryParameterInclude() {
    
    let un: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.un("1"), nil)
    
    let unLimit: BVConversationsQueryParameter =
      .includeLimit(BVQueryParameterTestValue.un("1"), 10, nil)
    
    let deux: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.deux("2"), nil)
    
    let deuxLimit: BVConversationsQueryParameter =
      .includeLimit(BVQueryParameterTestValue.deux("2"), 10, nil)
    
    let trois: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.trois("3"), nil)
    
    let troisLimit: BVConversationsQueryParameter =
      .includeLimit(BVQueryParameterTestValue.trois("3"), 10, nil)
    
    let quatre: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.quatre("4"), nil)
    
    let quatreLimit: BVConversationsQueryParameter =
      .includeLimit(BVQueryParameterTestValue.quatre("4"), 10, nil)
    
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
  
  func testQueryParameterIncludeCoalesce() {
    
    let un: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.un("1"), nil)
    
    let deux: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.deux("2"), nil)
    
    let trois: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.trois("3"), nil)
    
    let quatre: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.quatre("4"), nil)
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Include")
    XCTAssertEqual(coalesced.value, "Un,Deux,Trois,Quatre")
  }
  
  func testQueryParameterSort() {
    
    let un: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.un("1"),
            BVQueryParameterTestOperator.egale,
            nil)
    
    let deux: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.deux("2"),
            BVQueryParameterTestOperator.egale,
            nil)
    
    let trois: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.trois("3"),
            BVQueryParameterTestOperator.egale,
            nil)
    
    let quatre: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.quatre("4"),
            BVQueryParameterTestOperator.egale,
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
  
  func testQueryParameterSortCoalesce() {
    
    let un: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.un("1"),
            BVQueryParameterTestOperator.egale,
            nil)
    
    let deux: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.deux("2"),
            BVQueryParameterTestOperator.egale,
            nil)
    
    let trois: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.trois("3"),
            BVQueryParameterTestOperator.egale,
            nil)
    
    let quatre: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.quatre("4"),
            BVQueryParameterTestOperator.egale,
            nil)
    
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Sort")
    XCTAssertEqual(coalesced.value,
                   "Un:egale,Deux:egale,Trois:egale,Quatre:egale")
  }
  
  func testQueryParameterSortType() {
    
    let sortTypeUnDeux: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.un("1"),
                BVQueryParameterTestValue.deux("2"),
                BVQueryParameterTestOperator.egale,
                nil)
    
    let sortTypeTroisQuatre: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.trois("3"),
                BVQueryParameterTestValue.quatre("4"),
                BVQueryParameterTestOperator.egale,
                nil)
    
    XCTAssertEqual(sortTypeUnDeux.name, "Sort_Un")
    XCTAssertEqual(sortTypeUnDeux.value, "Deux:egale")
    XCTAssertEqual(sortTypeTroisQuatre.name, "Sort_Trois")
    XCTAssertEqual(sortTypeTroisQuatre.value, "Quatre:egale")
  }
  
  func testQueryParameterSortTypeCoalesce() {
    
    let sortTypeUnDeux: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.un("1"),
                BVQueryParameterTestValue.deux("2"),
                BVQueryParameterTestOperator.egale,
                nil)
    
    let sortTypeUnTrois: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.un("1"),
                BVQueryParameterTestValue.trois("3"),
                BVQueryParameterTestOperator.egale,
                nil)
    
    let sortTypeUnQuatre: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.un("1"),
                BVQueryParameterTestValue.quatre("4"),
                BVQueryParameterTestOperator.egale,
                nil)
    
    let coalesced: BVConversationsQueryParameter =
      sortTypeUnDeux + sortTypeUnTrois + sortTypeUnQuatre
    
    XCTAssertEqual(coalesced.name, "Sort_Un")
    XCTAssertEqual(coalesced.value,
                   "Deux:egale,Trois:egale,Quatre:egale")
  }
  
  func testQueryParameterStat() {
    
    let un: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.un("1"), nil)
    
    let deux: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.deux("2"), nil)
    
    let trois: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.trois("3"), nil)
    
    let quatre: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.quatre("4"), nil)
    
    XCTAssertEqual(un.name, "Stats")
    XCTAssertEqual(deux.name, "Stats")
    XCTAssertEqual(trois.name, "Stats")
    XCTAssertEqual(quatre.name, "Stats")
    
    XCTAssertEqual(un.value, "Un")
    XCTAssertEqual(deux.value, "Deux")
    XCTAssertEqual(trois.value, "Trois")
    XCTAssertEqual(quatre.value, "Quatre")
  }
  
  func testQueryParameterStatCoalesce() {
    
    let un: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.un("1"), nil)
    
    let deux: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.deux("2"), nil)
    
    let trois: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.trois("3"), nil)
    
    let quatre: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.quatre("4"), nil)
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Stats")
    XCTAssertEqual(coalesced.value, "Un,Deux,Trois,Quatre")
  }
}

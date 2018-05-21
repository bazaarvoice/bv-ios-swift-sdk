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
    String,
    BVConversationsQueryFilter,
    BVConversationsQueryInclude,
    BVConversationsQuerySort,
  BVConversationsQueryStat {
    
    case un = "Un"
    case deux = "Deux"
    case trois = "Trois"
    case quatre = "Quatre"
    
    var description: String {
      get {
        return rawValue
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
      .custom(BVQueryParameterTestValue.un,
              BVQueryParameterTestOperator.plus,
              nil)
    
    let deux: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.deux,
              BVQueryParameterTestOperator.moins,
              nil)
    
    let trois: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.trois,
              BVQueryParameterTestOperator.egale,
              nil)
    
    let quatre: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.quatre,
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
      .custom(BVQueryParameterTestValue.un,
              BVQueryParameterTestOperator.plus,
              nil)
    
    let deux: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.un,
              BVQueryParameterTestOperator.moins,
              nil)
    
    let trois: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.un,
              BVQueryParameterTestOperator.egale,
              nil)
    
    let quatre: BVConversationsQueryParameter =
      .custom(BVQueryParameterTestValue.un,
              BVQueryParameterTestOperator.non,
              nil)
    
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Un")
    XCTAssertEqual(coalesced.value,
                   "plus,moins,egale,non")
  }
  
  func testQueryParameterFilter() {
    
    let un: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.un,
              BVQueryParameterTestOperator.egale,
              ["1"],
              nil)
    
    let deux: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.deux,
              BVQueryParameterTestOperator.egale,
              ["2"],
              nil)
    
    let trois: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.trois,
              BVQueryParameterTestOperator.egale,
              ["3"],
              nil)
    
    let quatre: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.quatre,
              BVQueryParameterTestOperator.egale,
              ["4"],
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
      .filter(BVQueryParameterTestValue.un,
              BVQueryParameterTestOperator.egale,
              ["1"],
              nil)
    
    let deux: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.deux,
              BVQueryParameterTestOperator.egale,
              ["2"],
              nil)
    
    let trois: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.trois,
              BVQueryParameterTestOperator.egale,
              ["3"],
              nil)
    
    let quatre: BVConversationsQueryParameter =
      .filter(BVQueryParameterTestValue.quatre,
              BVQueryParameterTestOperator.egale,
              ["4"],
              nil)
    
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Filter")
    XCTAssertEqual(coalesced.value,
                   "Un:egale:1,Deux:egale:2,Trois:egale:3,Quatre:egale:4")
  }
  
  func testQueryParameterFilterType() {
    
    let filterTypeUnDeux: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.un,
                  BVQueryParameterTestValue.deux,
                  BVQueryParameterTestOperator.egale,
                  ["2"],
                  nil)
    
    let filterTypeTroisQuatre: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.trois,
                  BVQueryParameterTestValue.quatre,
                  BVQueryParameterTestOperator.egale,
                  ["4"],
                  nil)
    
    XCTAssertEqual(filterTypeUnDeux.name, "Filter_Un")
    XCTAssertEqual(filterTypeUnDeux.value, "Deux:egale:2")
    XCTAssertEqual(filterTypeTroisQuatre.name, "Filter_Trois")
    XCTAssertEqual(filterTypeTroisQuatre.value, "Quatre:egale:4")
  }
  
  func testQueryParameterFilterTypeCoalesce() {
    
    let filterTypeUnDeux: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.un,
                  BVQueryParameterTestValue.deux,
                  BVQueryParameterTestOperator.egale,
                  ["2"],
                  nil)
    
    let filterTypeUnTrois: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.un,
                  BVQueryParameterTestValue.trois,
                  BVQueryParameterTestOperator.egale,
                  ["3"],
                  nil)
    
    let filterTypeUnQuatre: BVConversationsQueryParameter =
      .filterType(BVQueryParameterTestValue.un,
                  BVQueryParameterTestValue.quatre,
                  BVQueryParameterTestOperator.egale,
                  ["4"],
                  nil)
    
    let coalesced: BVConversationsQueryParameter =
      filterTypeUnDeux + filterTypeUnTrois + filterTypeUnQuatre
    
    XCTAssertEqual(coalesced.name, "Filter_Un")
    XCTAssertEqual(coalesced.value,
                   "Deux:egale:2,Trois:egale:3,Quatre:egale:4")
  }
  
  func testQueryParameterInclude() {
    
    let un: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.un, nil)
    
    let unLimit: BVConversationsQueryParameter =
      .includeLimit(BVQueryParameterTestValue.un, 10, nil)
    
    let deux: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.deux, nil)
    
    let deuxLimit: BVConversationsQueryParameter =
      .includeLimit(BVQueryParameterTestValue.deux, 10, nil)
    
    let trois: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.trois, nil)
    
    let troisLimit: BVConversationsQueryParameter =
      .includeLimit(BVQueryParameterTestValue.trois, 10, nil)
    
    let quatre: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.quatre, nil)
    
    let quatreLimit: BVConversationsQueryParameter =
      .includeLimit(BVQueryParameterTestValue.quatre, 10, nil)
    
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
      .include(BVQueryParameterTestValue.un, nil)
    
    let deux: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.deux, nil)
    
    let trois: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.trois, nil)
    
    let quatre: BVConversationsQueryParameter =
      .include(BVQueryParameterTestValue.quatre, nil)
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Include")
    XCTAssertEqual(coalesced.value, "Un,Deux,Trois,Quatre")
  }
  
  func testQueryParameterSort() {
    
    let un: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.un,
            BVQueryParameterTestOperator.egale,
            nil)
    
    let deux: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.deux,
            BVQueryParameterTestOperator.egale,
            nil)
    
    let trois: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.trois,
            BVQueryParameterTestOperator.egale,
            nil)
    
    let quatre: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.quatre,
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
      .sort(BVQueryParameterTestValue.un,
            BVQueryParameterTestOperator.egale,
            nil)
    
    let deux: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.deux,
            BVQueryParameterTestOperator.egale,
            nil)
    
    let trois: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.trois,
            BVQueryParameterTestOperator.egale,
            nil)
    
    let quatre: BVConversationsQueryParameter =
      .sort(BVQueryParameterTestValue.quatre,
            BVQueryParameterTestOperator.egale,
            nil)
    
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Sort")
    XCTAssertEqual(coalesced.value,
                   "Un:egale,Deux:egale,Trois:egale,Quatre:egale")
  }
  
  func testQueryParameterSortType() {
    
    let sortTypeUnDeux: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.un,
                BVQueryParameterTestValue.deux,
                BVQueryParameterTestOperator.egale,
                nil)
    
    let sortTypeTroisQuatre: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.trois,
                BVQueryParameterTestValue.quatre,
                BVQueryParameterTestOperator.egale,
                nil)
    
    XCTAssertEqual(sortTypeUnDeux.name, "Sort_Un")
    XCTAssertEqual(sortTypeUnDeux.value, "Deux:egale")
    XCTAssertEqual(sortTypeTroisQuatre.name, "Sort_Trois")
    XCTAssertEqual(sortTypeTroisQuatre.value, "Quatre:egale")
  }
  
  func testQueryParameterSortTypeCoalesce() {
    
    let sortTypeUnDeux: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.un,
                BVQueryParameterTestValue.deux,
                BVQueryParameterTestOperator.egale,
                nil)
    
    let sortTypeUnTrois: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.un,
                BVQueryParameterTestValue.trois,
                BVQueryParameterTestOperator.egale,
                nil)
    
    let sortTypeUnQuatre: BVConversationsQueryParameter =
      .sortType(BVQueryParameterTestValue.un,
                BVQueryParameterTestValue.quatre,
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
      .stats(BVQueryParameterTestValue.un, nil)
    
    let deux: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.deux, nil)
    
    let trois: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.trois, nil)
    
    let quatre: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.quatre, nil)
    
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
      .stats(BVQueryParameterTestValue.un, nil)
    
    let deux: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.deux, nil)
    
    let trois: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.trois, nil)
    
    let quatre: BVConversationsQueryParameter =
      .stats(BVQueryParameterTestValue.quatre, nil)
    
    let coalesced: BVConversationsQueryParameter = un + deux + trois + quatre
    
    XCTAssertEqual(coalesced.name, "Stats")
    XCTAssertEqual(coalesced.value, "Un,Deux,Trois,Quatre")
  }
}

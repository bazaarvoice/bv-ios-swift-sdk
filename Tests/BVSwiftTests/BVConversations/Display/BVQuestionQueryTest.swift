//
//
//  BVQuestionQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVQuestionQueryTest: XCTestCase {
  
  private static var config: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "apitestcustomer"))
    
    return BVConversationsConfiguration.display(
      clientKey: "kuy3zj9pr3n7i0wxajrzj04xo",
      configType: .staging(clientId: "apitestcustomer"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var privateSession:URLSession = {
    return URLSession(configuration: .default)
  }()
  
  override class func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override class func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  func testtQuestionQueryConstruction() {
    
    let questionQuery =
      BVQuestionQuery(productId: "test1", limit: 10, offset: 0)
        .configure(BVQuestionQueryTest.config)
        .filter((.categoryAncestorId("testID1"), .equalTo),
                (.categoryAncestorId("testID2"), .equalTo),
                (.categoryAncestorId("testID3"), .equalTo),
                (.categoryAncestorId("testID4"), .notEqualTo),
                (.categoryAncestorId("testID5"), .notEqualTo))
    
    guard let url = questionQuery.request?.url else {
      XCTFail()
      return
    }
    
    print(url.absoluteString)
    
    XCTAssertTrue(url.absoluteString.contains(
      "CategoryAncestorId:eq:testID1,testID2,testID3"))
    XCTAssertTrue(url.absoluteString.contains(
      "CategoryAncestorId:neq:testID4,testID5"))
  }
  
  func testQuestionQueryDisplay() {
    
    let expectation =
      self.expectation(description: "testQuestionQueryDisplay")
    
    let questionQuery =
      BVQuestionQuery(productId: "test1", limit: 10, offset: 0)
        .include(.answers)
        .filter(((.hasAnswers(true), .equalTo)))
        .configure(BVQuestionQueryTest.config)
        .handler { (response: BVConversationsQueryResponse<BVQuestion>) in
          
          
          if case .failure(let error) = response {
            print(error)
            XCTFail()
            expectation.fulfill()
            return
          }
          
          guard case let .success(_, questions) = response else {
            XCTFail()
            expectation.fulfill()
            return
          }
          
          guard let question: BVQuestion = questions.first,
            let answers: [BVAnswer] = question.answers,
            let answerIds: [String] = question.answerIds else {
              XCTFail()
              expectation.fulfill()
              return
          }
          
          XCTAssertEqual(questions.count, 10)
          
          XCTAssertEqual(question.questionSummary, "Das ist mein test :)")
          XCTAssertEqual(question.questionDetails, "Das ist mein test :)")
          XCTAssertEqual(question.userNickname, "123thisisme")
          XCTAssertEqual(question.authorId, "eplz083100g")
          XCTAssertEqual(question.moderationStatus, "APPROVED")
          XCTAssertEqual(question.questionId, "14828")
          
          let questionAnswers: [BVAnswer] =
            answers.filter { (answer: BVAnswer) -> Bool in
              guard let answerId: String = answer.answerId else {
                return false
              }
              return answerIds.contains(answerId)
          }
          
          guard let firstQuestionAnswer: BVAnswer = questionAnswers.first else {
            XCTFail()
            expectation.fulfill()
            return
          }
          
          XCTAssertEqual(questionAnswers.count, 1)
          
          XCTAssertEqual(firstQuestionAnswer.userNickname, "asdfasdfasdfasdf")
          XCTAssertEqual(firstQuestionAnswer.questionId, "14828")
          XCTAssertEqual(firstQuestionAnswer.authorId, "c6ryqeb2bq0")
          XCTAssertEqual(firstQuestionAnswer.moderationStatus, "APPROVED")
          XCTAssertEqual(firstQuestionAnswer.answerId, "16292")
          XCTAssertEqual(
            firstQuestionAnswer.answerText,
            "zxnc,vznxc osaidmf oaismdfo ims adoifmaosidmfoiamsdfimasdf")
          
          questions.forEach { (question) in
            XCTAssertEqual(question.productId, "test1")
          }
          
          expectation.fulfill()
    }
    
    guard let req = questionQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    questionQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}

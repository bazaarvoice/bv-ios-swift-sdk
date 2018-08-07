//
//  BVQuestionSearchQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

import XCTest
@testable import BVSwift

class BVQuestionSearchQueryTest: XCTestCase {
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
  
  func testQuestionSearchQueryDisplay() {
    
    let expectation =
      self.expectation(description: "testQuestionSearchQueryDisplay")
    
    let questionSearchQuery =
      BVQuestionSearchQuery(
        productId: "test1", searchQuery: "Pellentesque", limit: 10, offset: 0)
        .include(.answers)
        .filter(.hasAnswers(true))
        .configure(BVQuestionSearchQueryTest.config)
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
          
          XCTAssertEqual(questions.count, 6)
          
          XCTAssertEqual(
            question.questionSummary, "Ut pellentesque volutpat placerat.")
          XCTAssertEqual(
            question.questionDetails,
            "In vitae fringilla nisl? Proin adipiscing nisl eget augue " +
            "mattis interdum. Quisque ullamcorper amet.")
          XCTAssertEqual(question.userNickname, "Armand")
          XCTAssertEqual(question.authorId, "563ox86lxc0")
          XCTAssertEqual(question.moderationStatus, "APPROVED")
          XCTAssertEqual(question.questionId, "14822")
          
          let questionAnswers: [BVAnswer] =
            answers.filter { (answer: BVAnswer) -> Bool in
              guard let answerId: String = answer.answerId else {
                return false
              }
              return answerIds.contains(answerId)
          }
          
          guard let firstQuestionAnswer: BVAnswer =
            questionAnswers.first else {
              XCTFail()
              expectation.fulfill()
              return
          }
          
          XCTAssertEqual(questionAnswers.count, 2)
          
          XCTAssertEqual(
            firstQuestionAnswer.userNickname, "vasdfaosdfimoasdifmsa")
          XCTAssertEqual(firstQuestionAnswer.questionId, "14822")
          XCTAssertEqual(firstQuestionAnswer.authorId, "iv5d43wqvc")
          XCTAssertEqual(firstQuestionAnswer.moderationStatus, "APPROVED")
          XCTAssertEqual(firstQuestionAnswer.answerId, "16280")
          XCTAssertEqual(
            firstQuestionAnswer.answerText,
            "asdf zoxjcovizmzo iamosdimfaosidmfaosdifmaosdimfasdf")
          
          questions.forEach { (question) in
            XCTAssertEqual(question.productId, "test1")
          }
          
          expectation.fulfill()
    }
    
    guard let req = questionSearchQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    questionSearchQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}

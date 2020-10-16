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
    
    private static var syndicationSourceConfig: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .staging(clientId: "testcust-contentoriginsynd"))
        
        return BVConversationsConfiguration.display(
            clientKey: "carz85SqKJp9FrZgeb2irdiEBT4b0DSe7m1KUm18elijE",
            configType: .staging(clientId: "testcust-contentoriginsynd"),
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
  
  func testQuestionSearchQueryConstruction() {
    
    let questionSearchQuery =
      BVQuestionSearchQuery(
        productId: "test1", searchQuery: "Pellentesque", limit: 10, offset: 0)
        .configure(BVQuestionSearchQueryTest.config)
        .filter((.categoryAncestorId("testID1"), .equalTo),
                (.categoryAncestorId("testID2"), .equalTo),
                (.categoryAncestorId("testID3"), .equalTo),
                (.categoryAncestorId("testID4"), .notEqualTo),
                (.categoryAncestorId("testID5"), .notEqualTo))
    
    guard let url = questionSearchQuery.request?.url else {
      XCTFail()
      return
    }
    
    print(url.absoluteString)
    
    XCTAssertTrue(url.absoluteString.contains(
      "CategoryAncestorId:eq:testID1,testID2,testID3"))
    XCTAssertTrue(url.absoluteString.contains(
      "CategoryAncestorId:neq:testID4,testID5"))
  }
  
  func testQuestionSearchQueryDisplay() {
    
    let expectation =
      self.expectation(description: "testQuestionSearchQueryDisplay")
    
    let questionSearchQuery =
      BVQuestionSearchQuery(
        productId: "test1", searchQuery: "Pellentesque", limit: 10, offset: 0)
        .include(.answers)
        .filter((.hasAnswers(true), .equalTo))
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
            question.questionSummary,
            "Suspendisse elementum est vitae metus lacinia bibendum?")
          XCTAssertEqual(
            question.questionDetails,
            "Pellentesque posuere tristique urna eget sodales. " +
            "In at leo quis leo pulvinar imperdiet non id amet.")
          XCTAssertEqual(question.userNickname, "PreciAmalia")
          XCTAssertEqual(question.authorId, "ja9f8irjno8")
          XCTAssertEqual(question.moderationStatus, "APPROVED")
          XCTAssertEqual(question.questionId, "14826")
          
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
          
          XCTAssertEqual(questionAnswers.count, 7)
          
          XCTAssertEqual(
            firstQuestionAnswer.userNickname, "asdfasdfasdf")
          XCTAssertEqual(firstQuestionAnswer.questionId, "14826")
          XCTAssertEqual(firstQuestionAnswer.authorId, "7jhyc8a44cg")
          XCTAssertEqual(firstQuestionAnswer.moderationStatus, "APPROVED")
          XCTAssertEqual(firstQuestionAnswer.answerId, "16291")
          XCTAssertEqual(
            firstQuestionAnswer.answerText,
            "asdjfoaisjdfo asdoifmaosidfmoasid mfoiamsdf imasodfmiasdf")
          
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
    
    func testQuestionSearchQuerySyndicationSource() {
        
        let expectation =
            self.expectation(description: "testQuestionSearchQuerySyndicationSource")
        
        let questionQuery =
            BVQuestionSearchQuery(productId: "Concierge-Common-Product-1", searchQuery: "several dozen huge yellow chunky slablike", limit: 10, offset: 0)
                .include(.answers)
                .filter(((.hasAnswers(true), .equalTo)))
                .configure(BVQuestionSearchQueryTest.syndicationSourceConfig)
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
                    
                    guard let question: BVQuestion = questions.first(where: { $0.questionId == "1536656" }) else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    //Source Client
                    XCTAssertEqual(question.sourceClient, "testcust-contentorigin")
                    
                    //Syndicated Source
                    XCTAssertNotNil(question.syndicationSource)
                    XCTAssertEqual(question.syndicationSource?.logoImageUrl, "https://contentorigin-stg.bazaarvoice.com/testsynd-origin/en_US/SYND1_SKY.png")
                    XCTAssertEqual(question.syndicationSource?.name, "TestCustomer-Contentorigin_Synd_en_US")
                    
                    
                    guard let answer: BVAnswer = question.answers?.first(where: { $0.answerId == "1577185" }) else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    //Source Client
                    XCTAssertEqual(answer.sourceClient, "testcust-contentorigin")
                    
                    //Syndicated Source
                    XCTAssertNotNil(answer.syndicationSource)
                    XCTAssertEqual(answer.syndicationSource?.logoImageUrl, "https://contentorigin-stg.bazaarvoice.com/testsynd-origin/en_US/SYND1_SKY.png")
                    XCTAssertEqual(answer.syndicationSource?.name, "TestCustomer-Contentorigin_Synd_en_US")
                    
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

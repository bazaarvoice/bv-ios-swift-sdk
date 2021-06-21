//
//
//  BVQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVQueryTest: XCTestCase {
  
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
  
  func testProductQueryDisplay() {
    
    let expectation =
      self.expectation(description: "testProductQueryDisplay")
    
    let productQuery = BVProductQuery(productId: "test1")
      .include(.reviews, limit: 10)
      .include(.questions, limit: 5)
      .configure(BVQueryTest.config)
      .handler { (response: BVConversationsQueryResponse<BVProduct>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, products) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard let product: BVProduct = products.first,
          let brand: BVBrand = product.brand else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        guard let reviews: [BVReview] = product.reviews,
          let questions: [BVQuestion] = product.questions else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        XCTAssertEqual(brand.brandId, "cskg0snv1x3chrqlde0zklodb")
        XCTAssertEqual(brand.name, "mysh")
        XCTAssertEqual(
          product.productDescription,
          "Our pinpoint oxford is crafted from only the finest 80\'s " +
            "two-ply cotton fibers.Single-needle stitching on all seams for " +
            "a smooth flat appearance. Tailored with our Traditional\n" +
            "                straight collar and button cuffs. " +
          "Machine wash. Imported.")
        XCTAssertEqual(product.brandExternalId, "cskg0snv1x3chrqlde0zklodb")
        XCTAssertEqual(
          product.imageUrl?.value?.absoluteString,
          "http://myshco.com/productImages/shirt.jpg")
        XCTAssertEqual(product.name, "Dress Shirt")
        XCTAssertEqual(product.categoryId, "testCategory1031")
        XCTAssertEqual(product.productId, "test1")
        XCTAssertEqual(reviews.count, 10)
        XCTAssertEqual(questions.count, 5)
        
        expectation.fulfill()
    }
    
    guard let req = productQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productQuery.async(urlSession: BVQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
 func testQuestionQueryDisplay() {
    
    let expectation =
      self.expectation(description: "testQuestionQueryDisplay")
    
    let questionQuery =
      BVQuestionQuery(productId: "test1", limit: 10, offset: 0)
        .include(.answers)
        .filter((.hasAnswers(true), .equalTo))
        .configure(BVQueryTest.config)
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
          
          guard let firstQuestionAnswer: BVAnswer =
            questionAnswers.first else {
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
  
  func testProductStatisticsQueryDisplayOneProduct() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryDisplayOneProduct")
    
    let usLocale: Locale = Locale(identifier: "en_US")
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: ["test3"]) else {
        XCTFail()
        return
    }
    productStatisticsQuery
      .filter((.contentLocale(usLocale), .equalTo))
      .stats(.nativeReviews)
      .stats(.reviews)
      .configure(BVQueryTest.config)
      .handler {
        (response: BVConversationsQueryResponse<BVProductStatistics>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, productStatistics) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard let firstProductStatistic: BVProductStatistics =
          productStatistics.first,
          let reviewStatistics =
          firstProductStatistic.reviewStatistics,
          let nativeReviewStatistics =
          firstProductStatistic.nativeReviewStatistics else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        XCTAssertEqual(productStatistics.count, 1)
        
        XCTAssertEqual(firstProductStatistic.productId, "test3")
        XCTAssertEqual(reviewStatistics.totalReviewCount, 29)
        XCTAssertNotNil(reviewStatistics.averageOverallRating)
        XCTAssertEqual(reviewStatistics.overallRatingRange, 5)
        XCTAssertEqual(nativeReviewStatistics.totalReviewCount, 29)
        XCTAssertEqual(nativeReviewStatistics.overallRatingRange, 5)
        
        expectation.fulfill()
    }
    
    guard let req = productStatisticsQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productStatisticsQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProductStatisticsQueryDisplayMultipleProducts() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryDisplayMultipleProducts")
    
    let usLocale: Locale = Locale(identifier: "en_US")
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: ["test1", "test2", "test3"]) else {
        XCTFail()
        expectation.fulfill()
        return
    }
    
    productStatisticsQuery
      .stats(.nativeReviews)
      .stats(.reviews)
      .filter((.contentLocale(usLocale), .equalTo))
      .configure(BVQueryTest.config)
      .handler {
        (response: BVConversationsQueryResponse<BVProductStatistics>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, productStatistics) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        XCTAssertEqual(productStatistics.count, 3)
        expectation.fulfill()
    }
    
    guard let req = productStatisticsQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productStatisticsQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProductStatisticsQueryTooManyProductsTimeout() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryTooManyProductsTimeout")
    
    var tooManyProductIds: [String] = []
    
    for index in 1 ... 110 {
      tooManyProductIds += ["ProductId\(index)"]
    }
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: ["product1"])?
        .configure(BVQueryTest.config) else {
          XCTFail()
          return
    }
    
    let productIdFilterTuple = tooManyProductIds.map {
      return (BVConversationsQueryFilter.productId($0),
              BVConversationsFilterOperator.equalTo)
    }
    
    BVProductStatisticsQuery
      .groupFilters(productIdFilterTuple).forEach { group in
        let expr: BVQueryFilterExpression<BVConversationsQueryFilter,
          BVConversationsFilterOperator> =
          1 < group.count ? .or(group) : .and(group)
        productStatisticsQuery.flatten(expr).forEach
          { productStatisticsQuery.add($0) }
    }
    
    guard let url = productStatisticsQuery.request?.url else {
      XCTFail()
      return
    }
    
    expectation.fulfill()
    print(url)
    
    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProductStatisticsQueryTooManyProductsError() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryTooManyProductsError")
    
    var tooManyProductIds: [String] = []
    
    for index in 1 ... 110 {
      tooManyProductIds += ["ProductId\(index)"]
    }
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: tooManyProductIds) else {
        XCTFail()
        expectation.fulfill()
        return
    }
    
    productStatisticsQuery
      .stats(.nativeReviews)
      .stats(.reviews)
      .configure(BVQueryTest.config)
      .handler {
        (response: BVConversationsQueryResponse<BVProductStatistics>) in
        
        if case .failure(let error) = response {
          print(error)
          expectation.fulfill()
          return
        }
        
        if case let .success(_, productStatistics) = response,
          0 == productStatistics.count {
          expectation.fulfill()
          return
        }
        
        XCTFail()
    }
    
    guard let req = productStatisticsQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productStatisticsQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}

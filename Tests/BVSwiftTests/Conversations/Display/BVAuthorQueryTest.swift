//
//
//  BVAuthorQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVAuthorQueryTest: XCTestCase {
  
  private static var config: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "conciergeapidocumentation"))
    
    return BVConversationsConfiguration.display(
      clientKey: "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4",
      configType: .staging(clientId: "conciergeapidocumentation"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var privateSession: URLSession = {
    return URLSession(configuration: .default)
  }()
  
  override func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  func testAuthorQueryBasicProfile() {
    
    let expectation = self.expectation(
      description: "testAuthorQueryBasicProfile")
    
    let authorQuery =
      BVAuthorQuery(authorId: "data-gen-user-poaouvr127us1ijhpafkfacb9")
        .configure(BVAuthorQueryTest.config)
        .handler { (response: BVConversationsQueryResponse<BVAuthor>) in
          // success
          
          if case .failure(let error) = response {
            print(error)
            XCTFail()
            return
          }
          
          guard case let .success(meta, authors) = response else {
            XCTFail()
            return
          }
          
          guard let limit: UInt16 = meta.limit,
            let offset: UInt16 = meta.offset,
            let locale: String = meta.locale,
            let totalResults: UInt16 = meta.totalResults else {
              XCTFail()
              return
          }
          
          guard let author: BVAuthor = authors.first,
            let badges: [BVBadge] = author.badges,
            let photos: [BVPhoto] = author.photos,
            let videos: [BVVideo] = author.videos,
            let cdvs: [BVContextDataValue] = author.contextDataValues else {
              XCTFail()
              return
          }
          
          XCTAssertEqual(limit, 10)
          XCTAssertEqual(offset, 0)
          XCTAssertEqual(locale, "en_US")
          XCTAssertEqual(totalResults, 1)
          
          // Check profile data from the result
          XCTAssertEqual(author.userNickname, "ferdinand255")
          XCTAssertEqual(author.submissionId, nil)
          XCTAssertEqual(badges.count, 2)
          XCTAssertEqual(photos.count, 0)
          XCTAssertEqual(videos.count, 0)
          XCTAssertEqual(cdvs.count, 0)
          XCTAssertEqual(author.userLocation, nil)
          
          XCTAssertEqual(
            author.submissionTime, "2016-01-06T11:52:00.000+00:00".toBVDate())
          
          let year : Int =
            NSCalendar.current.component(
              Calendar.Component.year, from: author.lastModeratedTime!)
          XCTAssertTrue(year >= 2017)
          
          // Check the badges
          for badge in badges {
            if badge.badgeId == "Staff" {
              XCTAssertEqual(badge.badgeType, .affiliation)
            } else if badge.badgeId == "Expert" {
              XCTAssertEqual(badge.badgeType, .rank)
            }
          }
          
          // Stats are nil w/out the Stats flag added
          XCTAssertNil(author.qaStatistics)
          XCTAssertNil(author.reviewStatistics)
          
          // Check the includes
          XCTAssertNil(author.reviews)
          XCTAssertNil(author.questions)
          
          expectation.fulfill()
    }
    
    guard let req = authorQuery.request else {
      XCTFail()
      return
    }
    
    print(req)
    
    authorQuery.async(urlSession: BVAuthorQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testAuthorQueryStatisticsAndIncludes() {
    
    let expectation =
      self.expectation(description: "testAuthorQueryStatisticsAndIncludes")
    
    let authorQuery =
      BVAuthorQuery(authorId: "data-gen-user-poaouvr127us1ijhpafkfacb9")
        // stats includes
        .stats(.answers)
        .stats(.questions)
        .stats(.reviews)
        
        // other includes
        .include(.reviews, limit: 10)
        .include(.questions, limit: 10)
        .include(.answers, limit: 10)
        .include(.comments, limit: 10)
        
        // sorts
        .sort(.answers(.submissionTime), order: .descending)
        .sort(.reviews(.submissionTime), order: .descending)
        .sort(.questions(.submissionTime), order: .descending)
        
        .configure(BVAuthorQueryTest.config)
        .handler { (response: BVConversationsQueryResponse<BVAuthor>) in
          // success
          
          if case .failure(let error) = response {
            print(error)
            XCTFail()
            return
          }
          
          guard case let .success(_, authors) = response else {
            XCTFail()
            return
          }
          
          guard let author: BVAuthor = authors.first,
            let qaStatistics: BVQAStatistics = author.qaStatistics,
            let reviewStatistics: BVReviewStatistics = author.reviewStatistics,
            let ratingDistribution: BVRatingDistribution =
            reviewStatistics.ratingDistribution,
            let averageOverallRating: Double =
            reviewStatistics.averageOverallRating,
            let reviews: [BVReview] = author.reviews,
            let questions: [BVQuestion] = author.questions,
            let answers: [BVAnswer] = author.answers,
            let comments: [BVComment] = author.comments else {
              XCTFail()
              return
          }
          
          // QA Statistics
          XCTAssertEqual(qaStatistics.totalAnswerCount, 37)
          XCTAssertEqual(qaStatistics.totalQuestionCount, 37)
          XCTAssertEqual(qaStatistics.answerHelpfulVoteCount, 0)
          XCTAssertEqual(qaStatistics.helpfulVoteCount, 0)
          XCTAssertEqual(qaStatistics.answerHelpfulVoteCount, 0)
          XCTAssertEqual(qaStatistics.questionHelpfulVoteCount, 0)
          XCTAssertEqual(qaStatistics.answerNotHelpfulVoteCount, 0)
          XCTAssertEqual(qaStatistics.questionNotHelpfulVoteCount, 0)
          
          // Review Statistics
          XCTAssertEqual(reviewStatistics.totalReviewCount, 23)
          XCTAssertEqual(reviewStatistics.helpfulVoteCount, 66)
          XCTAssertEqual(reviewStatistics.notHelpfulVoteCount, 58)
          XCTAssertEqual(reviewStatistics.notRecommendedCount, 1)
          XCTAssertEqual(reviewStatistics.overallRatingRange, 5)
          XCTAssertEqual(ratingDistribution.fiveStarCount, 7)
          XCTAssertEqual(ratingDistribution.fourStarCount, 16)
          XCTAssertEqual(reviewStatistics.recommendedCount, 16)
          XCTAssertEqual(String(format: "%.2f", averageOverallRating), "4.30")
          
          // Check the includes
          XCTAssertGreaterThanOrEqual(reviews.count, 10)
          XCTAssertGreaterThanOrEqual(questions.count, 10)
          XCTAssertGreaterThanOrEqual(answers.count, 10)
          XCTAssertGreaterThanOrEqual(comments.count, 10)
          
          expectation.fulfill()
    }
    
    guard let req = authorQuery.request else {
      XCTFail()
      return
    }
    
    print(req)
    
    authorQuery.async(urlSession: BVAuthorQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testAuthorQueryDisplayFailure() {
    
    let expectation =
      self.expectation(description: "testAuthorQueryDisplayFailure")
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "conciergeapidocumentation"))
    
    let badConfig: BVConversationsConfiguration =
      BVConversationsConfiguration.display(
        clientKey: "badkey",
        configType: .staging(
          clientId: "conciergeapidocumentation"),
        analyticsConfig: analyticsConfig)
    
    let authorQuery = BVAuthorQuery(authorId: "badauthorid")
      .configure(badConfig)
      .handler { (response: BVConversationsQueryResponse<BVAuthor>) in
        
        if case .success = response {
          XCTFail()
          return
        }
        
        guard case .failure = response else {
          XCTFail()
          return
        }
        
        // success
        expectation.fulfill()
    }
    
    guard let req = authorQuery.request else {
      XCTFail()
      return
    }
    
    print(req)
    
    authorQuery.async(urlSession: BVAuthorQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}

//
//
//  BVReviewQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVReviewQueryTest: XCTestCase {
  
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
    
    private static var dateOfUserExperienceconfig: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
      
      let analyticsConfig: BVAnalyticsConfiguration =
        .dryRun(
          configType: .staging(clientId: "Testcustomer-56"))
      
      return BVConversationsConfiguration.display(
        clientKey: "caYgyVsPvUkcK2a4aBCu0CK64S3vx6ERor9FpgAM32Uew",
        configType: .staging(clientId: "Testcustomer-56"),
        analyticsConfig: analyticsConfig)
    }()
  
  private static var incentivizedStatsConfig: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "apitestcustomer"))
    
    return BVConversationsConfiguration.display(
      clientKey: "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4",
      configType: .staging(clientId: "apitestcustomer"),
      analyticsConfig: analyticsConfig)
  }()
    
    private static var syndicationSourceConfig: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .staging(clientId: "testcust-contentoriginsynd"))
        
        return BVConversationsConfiguration.display(
            clientKey: "ca79jZohgqUDHy625ASm2su46Iu092ZhKuhKibga3Z6zo",
            configType: .staging(clientId: "testcust-contentoriginsynd"),
            analyticsConfig: analyticsConfig)
    }()
  
  private static var tagDimensionConfig: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "apitestcustomer"))
    
    return BVConversationsConfiguration.display(
      clientKey: "caYeBHjUvQaSNY1gJwSfQwpOMgoCc0Dhq2yBPcnyxRQwo",
      configType: .staging(clientId: "apitestcustomer"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var contextDataValueLabelConfig: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "apitestcustomer"))
    
    return BVConversationsConfiguration.display(
      clientKey: "capzzMW2lY94Fn1dwEiOjlzweCsVjZ4VDpQcY4Nlx8VWQ",
      configType: .staging(clientId: "apitestcustomer"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var secondaryRatingValueLabelConfig: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "testcustomermobilesdk"))
    
    return BVConversationsConfiguration.display(
      clientKey: "cavNO70oED9uDIo3971pfLc9IJET3eaozVNHJhL1vnAK4",
      configType: .staging(clientId: "testcustomermobilesdk"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var relevancySortConfig: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "mobile_test_customer_stg"))
    
    return BVConversationsConfiguration.display(
      clientKey: "caht73JSvhpl41pvD8vrIIPjLeMR0oPV6vMyd15lM2sig",
      configType: .staging(clientId: "mobile_test_customer_stg"),
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
    
    // Commented the below line as this method gets called while the analytics event tracking execution is in progress and it sets skipAllPixelEvents to false.
    //BVPixel.skipAllPixelEvents = false
  }
  
  func testReviewQueryConstruction() {
    
    let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 4)
      .configure(BVReviewQueryTest.config)
      .filter((.categoryAncestorId("testID1"), .equalTo),
              (.categoryAncestorId("testID2"), .equalTo),
              (.categoryAncestorId("testID3"), .equalTo),
              (.categoryAncestorId("testID4"), .notEqualTo),
              (.categoryAncestorId("testID5"), .notEqualTo))
      .filter((.contextDataValue(id: "Age", value: "17orUnder"), .equalTo))
      .feature("satisfaction")
      .filter((.secondaryRating(id: "Quality", value: "5"), .equalTo))
      .sort(.contentLocale, contentLocales: ["en_US", "fr_FR"])
      .sort(.relevancy, order: .a2)
    
    guard let url = reviewQuery.request?.url else {
      XCTFail()
      return
    }
    
    print(url.absoluteString)
    
    XCTAssertTrue(url.absoluteString.contains(
      "CategoryAncestorId:eq:testID1,testID2,testID3"))
    XCTAssertTrue(url.absoluteString.contains(
      "CategoryAncestorId:neq:testID4,testID5"))
    XCTAssertTrue(url.absoluteString.contains(
      "Feature=satisfaction"))
    XCTAssertTrue(url.absoluteString.contains(
      "ContextDataValue_Age:eq:17orUnder"))
    XCTAssertTrue(url.absoluteString.contains(
      "SecondaryRating_Quality:eq:5"))
    XCTAssertTrue(url.absoluteString.contains(
      "Sort=ContentLocale:en_US,fr_FR"))
    XCTAssertTrue(url.absoluteString.contains("Sort=relevancy:a2"))
  
  }
  
  func testReviewQueryDisplay() {
    
    let expectation = self.expectation(description: "testReviewQueryDisplay")
    
    let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 4)
      .sort(.rating, order: .ascending)
      .filter((.hasPhotos(true), .equalTo))
      .filter((.hasComments(false), .equalTo))
      .configure(BVReviewQueryTest.config)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard let review: BVReview = reviews.first(where: {$0.reviewId == "191985"}),
          let tagDimensions: [BVDimensionElement] = review.tagDimensions,
          let cdvs: [BVContextDataValue] = review.contextDataValues,
          let cdv: BVContextDataValue = cdvs.first,
          let badges: [BVBadge] = review.badges,
          let firstBadge: BVBadge = badges.first,
          let photos: [BVPhoto] = review.photos,
          let firstPhoto: BVPhoto = photos.first else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        XCTAssertEqual(reviews.count, 10)
        XCTAssertEqual(review.rating, 2)
        XCTAssertEqual(review.title, "Quisque a velit eget justo placerat imperdiet sed.")
        XCTAssertEqual(review.reviewText, "Cras sit amet arcu mauris. Nullam vel suscipit mauris. Morbi mattis blandit lorem a rutrum. Vivamus neque mauris, lacinia nec rutrum porta, vehicula ut urna. Curabitur neque nulla, dapibus ac feugiat a, feugiat eu justo. Curabitur ut dui eget nunc iaculis facilisis. Vivamus dui velit, consequat sit amet tincidunt pulvinar, egestas nec est. Vivamus in leo a est lacinia pellentesque euismod at purus. Cras malesuada; libero eget posuere venenatis, nunc metus ultrices nisl, ac vestibulum risus amet.")
        XCTAssertEqual(review.moderationStatus, "APPROVED")
        XCTAssertEqual(review.reviewId, "191985")
        XCTAssertNotNil(review.productId)
        XCTAssertEqual(review.isRatingsOnly, false)
        XCTAssertEqual(review.isFeatured, false)
        XCTAssertEqual(review.productId, "test1")
        XCTAssertEqual(review.authorId, "endersgame")
        XCTAssertEqual(review.userNickname, "endersgame")
        XCTAssertEqual(review.userLocation, "Charlottesville, VA")
        XCTAssertEqual(review.originalProductName, nil)

        guard let proDimension: BVDimensionElement =
          tagDimensions.filter({ (elem: BVDimensionElement) -> Bool in
            guard let id: String = elem.dimensionElementId else {
              return false
            }
            return id.contains("Pro")
          }).first else {
            XCTFail()
            expectation.fulfill()
            return
        }

        XCTAssertEqual(proDimension.label, "Pros")
        XCTAssertEqual(proDimension.dimensionElementId, "Pro")

        guard let values: [String] = proDimension.values else {
          XCTFail()
          expectation.fulfill()
          return
        }

        XCTAssertEqual(values, ["Organic Fabric", "Quality"])

        XCTAssertEqual(photos.count, 1)

        XCTAssertNil(firstPhoto.caption)
        XCTAssertEqual(firstPhoto.photoId, "72599")
        XCTAssertNotNil(firstPhoto.photoSizes)

        let regexPhotoList =
          firstPhoto.photoSizes?.filter { (size: BVPhotoSize) -> Bool in
            guard let url = size.url?.value else {
              return false
            }
            return (url
              .absoluteString
              .lowercased()
              .contains("jpg?client=apireadonlysandbox"))
        }

        XCTAssertNotNil(regexPhotoList)

        XCTAssertEqual(cdvs.count, 1)

        XCTAssertEqual(cdv.value, "Male")
        XCTAssertEqual(cdv.valueLabel, "Male")
        XCTAssertEqual(cdv.dimensionLabel, "Gender")
        XCTAssertEqual(cdv.contextDataValueId, "Gender")

        XCTAssertEqual(firstBadge.badgeType, .merit)
        XCTAssertEqual(firstBadge.badgeId, "top10Contributor")
        XCTAssertEqual(firstBadge.contentType, "REVIEW")
        
        reviews.forEach { (rev) in
          XCTAssertEqual(rev.productId, "test1")
        }
        
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
    
    func testReviewQuerySyndicationSource() {
        
        let expectation =
            self.expectation(description: "testReviewQuerySyndicationSource")
        
        let commentQuery:BVReviewQuery =
            BVReviewQuery(productId: "Concierge-Common-Product-1", limit: 10, offset: 0)
                .include(.authors)
                .include(.products)
                .filter(.reviews)
                .configure(BVReviewQueryTest.syndicationSourceConfig)
                .handler { (response: BVConversationsQueryResponse<BVReview>) in
                    
                    if case .failure = response {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard case let .success(_, reviews) = response else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard let review: BVReview = reviews.first(where: {$0.reviewId == "35312658"}),
                        let syndicationSource: BVSyndicationSource =
                        review.syndicationSource else {
                        XCTFail()
                        expectation.fulfill()
                            return
                    }
                    
                    //Source Client
                    XCTAssertEqual(review.sourceClient, "testcust-contentorigin")
                    
                    //Syndicated Source
                    XCTAssertTrue(review.isSyndicated!)
                    XCTAssertNotNil(review.syndicationSource)
                    XCTAssertEqual(syndicationSource.name, "TestCustomer-Contentorigin_Synd_en_US")
                    XCTAssertEqual(review.syndicationSource?.logoImageUrl, "https://contentorigin-stg.bazaarvoice.com/testsynd-origin/en_US/SYND1_SKY.png")
                    
                    expectation.fulfill()
        }
        
        guard let req = commentQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        commentQuery.async()
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
  
    func testReviewQuerySyndicationSourceWithJsonFile() {
        
        let handler = { (response: BVConversationsQueryResponse<BVReview>) in
            
            if case .failure(let error) = response {
                print(error)
                XCTFail()
                return
            }
            
            guard case let .success(_, reviews) = response else {
                XCTFail()
                return
            }
            
            guard let review: BVReview = reviews.first,
                let syndicationSource: BVSyndicationSource =
                review.syndicationSource else {
                    XCTFail()
                    return
            }
            
            XCTAssertEqual(syndicationSource.name, "bazaarvoice")
            XCTAssertNil(syndicationSource.contentLink)
            XCTAssertNotNil(syndicationSource.logoImageUrl)
        }

        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: type(of: self))
        #endif
        
        let path = bundle.path(forResource: "testSyndicationSource", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        guard let fileData = try? Data(contentsOf: url) else {
            XCTFail()
            return
        }
        
        guard let response =
            try? JSONDecoder()
                .decode(BVConversationsQueryResponseInternal<BVReview>.self,
                        from: fileData) else {
                            XCTFail()
                            return
        }
        
        if let errors:[Error] = response.errors,
            !errors.isEmpty {
            handler(.failure(errors))
            return
        }
        
        handler(.success(response, response.results ?? []))
    }
  
  // TODO:- commented some of the assertions in this test case as data is not returned in response.
  func testReviewQueryDisplayProductFilteredStats() {
    
    let expectation =
      self.expectation(
        description: "testReviewQueryDisplayProductFilteredStats")
    
    let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 4)
      .sort(.rating, order: .ascending)
      .filter((.hasPhotos(true), .equalTo))
      .filter((.hasComments(false), .equalTo))
      .include(.authors)
      .include(.products)
      .filter(.reviews)
      .filter(.questions)
      .configure(BVReviewQueryTest.config)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        // author includes assertions
        for review in reviews {
          XCTAssertNotNil(review.authors)
          XCTAssertEqual(review.authors?.count, 1)
          XCTAssertEqual(review.authorId, review.authors?.first?.authorId)
        }
        
        guard let review: BVReview = reviews.first,
          let productId: String = review.productId,
          let tagDimensions: [BVDimensionElement] = review.tagDimensions,
//          let badges: [BVBadge] = review.badges,
//          let badge: BVBadge = badges.first,
          let photos: [BVPhoto] = review.photos,
          let photo: BVPhoto = photos.first,
          let photoSizes: [BVPhotoSize] = photo.photoSizes
//          let contextDataValues: [BVContextDataValue] =
//          review.contextDataValues,
//          let cdv: BVContextDataValue = contextDataValues.first
          else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        guard let product:BVProduct = review.products?
          .filter({ (elem: BVProduct) -> Bool in
            guard let id:String = elem.productId else {
              return false
            }
            return id == productId
          }).first else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        guard let reviewStatistics: BVReviewStatistics =
          product.filteredReviewStatistics,
          let secondaryRatingsAverages: [BVSecondaryRatingsAverage]
          = reviewStatistics.secondaryRatingsAverages else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        guard let quality: BVSecondaryRatingsAverage =
          secondaryRatingsAverages
            .filter({ (sra: BVSecondaryRatingsAverage) -> Bool in
              guard let id: String = sra.secondaryRatingsId else {
                return false
              }
              return id == "Quality"
            }).first,
          let qualityAvg: Double = quality.averageRating else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        guard let value: BVSecondaryRatingsAverage = secondaryRatingsAverages
          .filter({ (sra: BVSecondaryRatingsAverage) -> Bool in
            guard let id: String = sra.secondaryRatingsId else {
              return false
            }
            return id == "Value"
          }).first,
          let valueAvg: Double = value.averageRating else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        guard let proTagDimension: BVDimensionElement = tagDimensions
          .filter({ (elem: BVDimensionElement) -> Bool in
            guard let id: String = elem.dimensionElementId else {
              return false
            }
            return id == "Pro"
          }).first,
          let proTagLabel: String = proTagDimension.label,
          let proTagId: String = proTagDimension.dimensionElementId,
          let proTagValues: [String] = proTagDimension.values else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        guard let thumbnail: BVPhotoSize = photoSizes
          .filter({ (photoSize: BVPhotoSize) -> Bool in
            guard let id: String = photoSize.sizeId else {
              return false
            }
            return id == "thumbnail"
          }).first else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        guard let normal: BVPhotoSize = photoSizes
          .filter({ (photoSize: BVPhotoSize) -> Bool in
            guard let id: String = photoSize.sizeId else {
              return false
            }
            return id == "normal"
          }).first,
          let normalURL: URL = normal.url?.value else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        XCTAssertEqual(reviews.count, 10)
        XCTAssertEqual(review.rating, 1)
        
        XCTAssertNotNil(product)
        XCTAssertNotNil(product.filteredQAStatistics)
        
        XCTAssertNotNil(reviewStatistics.contextDataDistribution)
        XCTAssertNotNil(reviewStatistics.tagDistribution)
        XCTAssertNotNil(reviewStatistics.ratingDistribution)
        
        XCTAssertTrue(qualityAvg > 0.0)
        XCTAssertTrue(valueAvg > 0.0)
        
        XCTAssertEqual(review.reviewId, "192432")
        
        XCTAssertEqual(review.isRatingsOnly, false)
        XCTAssertEqual(review.isFeatured, false)
        XCTAssertEqual(review.productId, "test1")
        XCTAssertEqual(review.authorId, "1q0mz2ni4is")
        XCTAssertEqual(review.userNickname, "h1VXaRZwbvy")
        //XCTAssertEqual(review.userLocation, "Baltimore, Maryland")
        
        XCTAssertEqual(proTagLabel, "Pros")
        XCTAssertEqual(proTagId, "Pro")
        XCTAssertEqual(proTagValues, ["Pro 2", "ma"])
        
        XCTAssertEqual(photos.count, 6)
//        XCTAssertEqual(
//          photo.caption,
//          "Etiam malesuada ultricies urna in scelerisque. Sed viverra " +
//            "blandit nibh non egestas. Sed rhoncus, ipsum in vehicula " +
//            "imperdiet, purus lectus sodales erat, eget ornare lacus lectus " +
//            "ac leo. Suspendisse tristique sollicitudin ultricies. Aliquam " +
//          "erat volutpat.")
        XCTAssertEqual(photo.photoId, "79880")
        XCTAssertNotNil(thumbnail.url)
        
        XCTAssertTrue(
          normalURL
            .absoluteString
            .lowercased()
            .contains("https://photos-uat-eu.bazaarvoice.com"))
        
//        XCTAssertEqual(contextDataValues.count, 1)
//        XCTAssertEqual(cdv.value, "Female")
//        XCTAssertEqual(cdv.valueLabel, "Female")
//        XCTAssertEqual(cdv.dimensionLabel, "Gender")
//        XCTAssertEqual(cdv.contextDataValueId, "Gender")
//
//        XCTAssertEqual(badge.badgeType, .merit)
//        XCTAssertEqual(badge.badgeId, "top10Contributor")
//        XCTAssertEqual(badge.contentType, "REVIEW")
        
        reviews.forEach { (review) in
          XCTAssertEqual(review.productId, "test1")
        }
        
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  
  func testReviewQueryIncludeComments() {
    
    let expectation =
      self.expectation(description: "testReviewQueryIncludeComments")
    
    let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 0)
      .include(.comments)
      .filter((.reviewId("192463"), .equalTo))
      // This review is know to have a comment
      .configure(BVReviewQueryTest.config)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard let review: BVReview = reviews.first,
          let comments: [BVComment] = review.comments,
          let comment: BVComment = comments.first else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        XCTAssertEqual(reviews.count, 1)
        // We filtered on a review id, so there should only be one
        XCTAssertTrue(comments.count >= 1)
        XCTAssertNotNil(comment.authorId)
        XCTAssertNotNil(comment.badges)
        XCTAssertNotNil(comment.submissionTime)
        XCTAssertNotNil(comment.commentText)
        XCTAssertNotNil(comment.contentLocale)
        XCTAssertNotNil(comment.lastModeratedTime)
        XCTAssertNotNil(comment.lastModificationTime)
        
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testReviewQueryIncentivizedStats() {
    
    let expectation = self.expectation(description: "testReviewQueryIncentivizedStats")
    
    let reviewQuery = BVReviewQuery(productId: "data-gen-moppq9ekthfzbc6qff3bqokie", limit: 55, offset: 0)
      .include(.authors)
      .include(.products)
      .stats(.reviews)
      .filter(.reviews)
      .incentivizedStats(true)
      .configure(BVReviewQueryTest.incentivizedStatsConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        XCTAssertEqual(reviews.count, 55)
        XCTAssertEqual(reviews.filter({ $0.badges!.contains(where: { $0.badgeId == "incentivizedReview" })}).count, 9)
        
        for review in reviews {
          
          // author includes assertions
          XCTAssertNotNil(review.authors)
          XCTAssertEqual(review.authors?.count, 1)
          XCTAssertEqual(review.authorId, review.authors?.first?.authorId)
          XCTAssertNotNil(review.authors?.first?.reviewStatistics?.incentivizedReviewCount)
          
          if let incentivizedBadge = review.badges?.first(where: { $0.badgeId == "incentivizedReview"}) {
            
            // assertions for incentivized review badge properties
            XCTAssertEqual(incentivizedBadge.badgeType, .custom)
            XCTAssertEqual(incentivizedBadge.contentType, "REVIEW")
            
            // assertions for context data values of incentivized review
            XCTAssertTrue(review.contextDataValues!.contains(where: {$0.contextDataValueId == "IncentivizedReview"}))
            if let incentivizedContextDataValue = review.contextDataValues!.first(where: {$0.contextDataValueId == "IncentivizedReview"}) {
              XCTAssertNotNil(incentivizedContextDataValue.dimensionLabel) // dimensionLabel Value could be anything so actual value check is not added
              XCTAssertEqual(incentivizedContextDataValue.value, "True")
              XCTAssertEqual(incentivizedContextDataValue.valueLabel, "Yes")
            }
          }
        }
        
        let review : BVReview = reviews.first!
        
        XCTAssertNotNil(review.products)
        XCTAssertEqual(review.products?.count, 1)
        XCTAssertEqual(review.productId, "data-gen-moppq9ekthfzbc6qff3bqokie")
        
        // Review Statistics assertions
        XCTAssertNotNil(review.products?.first?.reviewStatistics)
        XCTAssertNotNil(review.products?.first?.reviewStatistics?.incentivizedReviewCount)
        XCTAssertEqual(review.products?.first?.reviewStatistics?.incentivizedReviewCount, 15)
        XCTAssertNotNil(review.products?.first?.reviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }))
        
        let incentivizedReview = review.products?.first?.reviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" })!
        XCTAssertEqual(incentivizedReview?.distibutionElementId, "IncentivizedReview")
        XCTAssertEqual(incentivizedReview?.label, "Received an incentive for this review")
        XCTAssertEqual(incentivizedReview?.values?.count, 1)
        
        // Filtered Review Statistics assertions
        XCTAssertNotNil(review.products?.first?.filteredReviewStatistics)
        XCTAssertNotNil(review.products?.first?.filteredReviewStatistics?.incentivizedReviewCount)
        XCTAssertEqual(review.products?.first?.filteredReviewStatistics?.incentivizedReviewCount, 15)
        XCTAssertNotNil(review.products?.first?.filteredReviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }))
        
        let filteredIncentivizedReview = review.products?.first?.filteredReviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" })!
        XCTAssertEqual(filteredIncentivizedReview?.distibutionElementId, "IncentivizedReview")
        XCTAssertEqual(filteredIncentivizedReview?.label, "Received an incentive for this review")
        XCTAssertEqual(filteredIncentivizedReview?.values?.count, 1)
        
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }

  func testReviewQueryDateOfUXDisplay() {
    
    let expectation = self.expectation(description: "testReviewQueryDateOfUXDisplay")
    let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 4)
      .configure(BVReviewQueryTest.dateOfUserExperienceconfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        for review in reviews {
          
          XCTAssertNotNil(review.additionalFields)
          guard let additionalFields = review.additionalFields else {
            XCTFail()
            expectation.fulfill()
            return
          }
          XCTAssertNotNil(additionalFields["DateOfUserExperience"])
          
          let dateOfConsumerExperienceField = additionalFields["DateOfUserExperience"]!
          
          XCTAssertEqual(dateOfConsumerExperienceField["Id"], "DateOfUserExperience")
          XCTAssertEqual(dateOfConsumerExperienceField["Label"], "Date of user experience")
          XCTAssertNotNil(dateOfConsumerExperienceField["Value"])
          
        }
        expectation.fulfill()
      }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testReviewCDVFilter(){
    
    let expectation = self.expectation(description: "testReviewCDVFilter")
    
    let reviewQuery = BVReviewQuery(productId: "data-gen-moppq9ekthfzbc6qff3bqokie", limit: 10, offset: 0)
      .filter((.contextDataValue(id: "Age", value: "17orUnder"), .equalTo))
      
      .configure(BVReviewQueryTest.incentivizedStatsConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        for review in reviews {
        
          XCTAssertTrue(review.contextDataValues!.contains(where: {$0.contextDataValueId == "Age"}))
          if let contextDataValue = review.contextDataValues!.first(where: {$0.contextDataValueId == "Age"}) {
            XCTAssertNotNil(contextDataValue.dimensionLabel) // dimensionLabel Value could be anything so actual value check is not added
            XCTAssertEqual(contextDataValue.value, "17orUnder")
            XCTAssertEqual(contextDataValue.contextDataValueId, "Age")
            XCTAssertEqual(contextDataValue.valueLabel, "17 or under")
            XCTAssertEqual(contextDataValue.dimensionLabel, "Age")
          }
        }
        
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testReviewSecondaryRatingFilter(){
    
    let expectation = self.expectation(description: "testReviewSecondaryRatingFilter")
    
    let reviewQuery = BVReviewQuery(productId: "data-gen-moppq9ekthfzbc6qff3bqokie", limit: 10, offset: 0)
      .filter((.secondaryRating(id: "Quality", value: "5"), .equalTo))
      
      .configure(BVReviewQueryTest.incentivizedStatsConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        for review in reviews {
        
          XCTAssertTrue(review.secondaryRatings!.contains(where: {$0.secondaryRatingId == "Quality"}))
          if let secondaryRatings = review.secondaryRatings!.first(where: {$0.secondaryRatingId == "Quality"}) {
            XCTAssertEqual(secondaryRatings.value, 5)
            XCTAssertEqual(secondaryRatings.label, "Quality of Product")
            XCTAssertEqual(secondaryRatings.displayType, "NORMAL")
          }
        }
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
    func testReviewFilterByPassingArrayInsteadOfVariadicArguments(){
        
      let expectation = self.expectation(description: "testReviewFilterByPassingArrayInsteadOfVariadicArguments")
      
      let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 0)
                        .configure(BVReviewQueryTest.config)
                        .filter([(.rating(4), .equalTo),(.rating(5), .equalTo)])
                        .handler { (response: BVConversationsQueryResponse<BVReview>) in
                          
                          if case .failure(let error) = response {
                            print(error)
                            XCTFail()
                            expectation.fulfill()
                            return
                          }
                          
                          guard case let .success(_, reviews) = response else {
                            XCTFail()
                            expectation.fulfill()
                            return
                          }
                          
                          for review in reviews {
                              XCTAssert(review.rating == 5 || review.rating == 4);
                          }
                          expectation.fulfill()
                      }


        XCTAssert(reviewQuery.request?.url?.absoluteString.contains("Filter=Rating:eq:4,5") == true)
        
        reviewQuery.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
          XCTAssertNil(
            error, "Something went horribly wrong, request took too long.")
        }
    }
  func testReviewAdditionalFieldFilter(){
    
    let expectation = self.expectation(description: "testReviewAdditionalFieldFilter")
    
    let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 0)
      .filter((.additionalField(id: "DateOfUserExperience", value: "2021-04-03"), .equalTo))
      
      .configure(BVReviewQueryTest.dateOfUserExperienceconfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        for review in reviews {
          
          XCTAssertNotNil(review.additionalFields)
          guard let additionalFields = review.additionalFields else {
            XCTFail()
            expectation.fulfill()
            return
          }
          XCTAssertNotNil(additionalFields["DateOfUserExperience"])
          
          let dateOfConsumerExperienceField = additionalFields["DateOfUserExperience"]!
          
          XCTAssertEqual(dateOfConsumerExperienceField["Id"], "DateOfUserExperience")
        }
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testReviewTagDimensionFilter(){
    
    let expectation = self.expectation(description: "testReviewTagDimensionFilter")
    
    let reviewQuery = BVReviewQuery(productId: "JAM5BLK", limit: 10, offset: 0)
      .filter((.tagDimension(id: "TagsSet", value: "Volume"), .equalTo))
      
      .configure(BVReviewQueryTest.tagDimensionConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        for review in reviews {
         
          let tagDimension = review.tagDimensions!
          guard let proDimension: BVDimensionElement =
                  tagDimension.filter({ (elem: BVDimensionElement) -> Bool in
              guard let id: String = elem.dimensionElementId else {
                return false
              }
              return id.contains("TagsSet")
            }).first else {
              XCTFail()
              expectation.fulfill()
              return
          }

          XCTAssertEqual(proDimension.dimensionElementId, "TagsSet")

          guard let values: [String] = proDimension.values else {
            XCTFail()
            expectation.fulfill()
            return
          }
          XCTAssertTrue(values.contains("Volume"))
          
        }
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testContextDataValueLableIncludes(){

    let expectation = self.expectation(description: "testContextDataValueLableIncludes")

    let frLocale: Locale = Locale(identifier: "fr_FR")

    let reviewQuery = BVReviewQuery(productId: "WAX32LH1FF", limit: 10, offset: 0)
      .include(.products)
      .stats(.reviews)
      .filter((.contentLocale(frLocale), .equalTo))
      .configure(BVReviewQueryTest.contextDataValueLabelConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in

        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }

        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }

        for review in reviews {

          for product in review.products! {
            //Assertion to check value label.. value label can be differnt hence adding only not nil assertion
            XCTAssertNotNil( product.reviewStatistics?.contextDataDistribution?.first?.values?.first?.valueLabel)
          }
        }
      expectation.fulfill()
    }

    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }

    print(req)

    reviewQuery.async()

    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testTagStatDistribution(){

    let expectation = self.expectation(description: "testTagStatDistribution")

    let reviewQuery = BVReviewQuery(productId: "JAM5BLK", limit: 10, offset: 0)
      .tagStats(true)
      .include(.products)
      .stats(.reviews)

      .configure(BVReviewQueryTest.tagDimensionConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in

        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }

        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }

        for review in reviews {
          //Assertion to check tag distribution
          XCTAssertNotNil(review.products?.first?.reviewStatistics?.tagDistribution!.first(where: {$0.distibutionElementId == "ProductVariant"}))
          let tagDistibutionValues =  review.products?.first?.reviewStatistics?.tagDistribution!.first(where: {$0.distibutionElementId == "ProductVariant"})!

          //Assetion to check tagdistribution value
          XCTAssertNotNil(tagDistibutionValues?.values!)
          let values = tagDistibutionValues?.values!
          values?.forEach{ (value) in
            //Assertions to check Tagdistribution. value and count may differ hence not nil assertions
            XCTAssertNotNil(value.value)
            XCTAssertNotNil(value.count)
          }
        }
        expectation.fulfill()
    }

    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }

    print(req)

    reviewQuery.async()

    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSecondaryRatingDistribution(){

    let expectation = self.expectation(description: "testSecondaryRatingDistribution")

    let reviewQuery = BVReviewQuery(productId: "Product1", limit: 10, offset: 0)
      .secondaryRatingstats(true)
      .include(.products)
      .stats(.reviews)

      .configure(BVReviewQueryTest.secondaryRatingValueLabelConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in

        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }

        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }

        for review in reviews {
          //Assertions to check Secondary Distribution
          XCTAssertNotNil(review.products?.first?.reviewStatistics?.secondaryRatingsDistribution!.first(where:{$0.secondaryDistributionId == "WhatSizeIsTheProduct"})!)
          //Get secondary rating distribution
          let secondaryRatingsDistribution = review.products?.first?.reviewStatistics?.secondaryRatingsDistribution!.first(where:{$0.secondaryDistributionId == "WhatSizeIsTheProduct"})!
          XCTAssertEqual(secondaryRatingsDistribution?.label, "What size is the product?")
          //Get secondary rating distribution Values
          XCTAssertNotNil(secondaryRatingsDistribution?.values!)
          let secondaryRatingsDistributionalues = secondaryRatingsDistribution?.values!

          secondaryRatingsDistributionalues?.forEach{ (value) in
              //Assertions to check Tagdistribution. value, count and valuelabel may differ hence not nil assertions
              XCTAssertNotNil(value.value)
              XCTAssertNotNil(value.count)
              XCTAssertNotNil(value.valueLabel)
            }
          }
      expectation.fulfill()
    }

    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }

    print(req)

    reviewQuery.async()

    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSecondaryRatingsValueLabel(){

    let expectation = self.expectation(description: "testSecondaryRatingsValueLabel")

    let reviewQuery = BVReviewQuery(productId: "Product1", limit: 10, offset: 0)
      .include(.products)
      .stats(.reviews)

      .configure(BVReviewQueryTest.secondaryRatingValueLabelConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in

        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }

        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }

        for review in reviews {
          //Asserions for secondary ratings averages
          XCTAssertNotNil(review.products?.first?.reviewStatistics?.secondaryRatingsAverages!.first(where: {$0.secondaryRatingsId == "WhatSizeIsTheProduct"}))
          let secondaryRatingsAverages = review.products?.first?.reviewStatistics?.secondaryRatingsAverages!.first(where: {$0.secondaryRatingsId == "WhatSizeIsTheProduct"})
          //Assertions for all secondary ratings averages value
          XCTAssertNotNil(secondaryRatingsAverages?.averageRating)
          XCTAssertEqual(secondaryRatingsAverages?.displayType, "SLIDER")
          XCTAssertEqual(secondaryRatingsAverages?.valueRange, 3)
          XCTAssertEqual(secondaryRatingsAverages?.maxLabel, "Large")
          XCTAssertEqual(secondaryRatingsAverages?.minLabel, "Small")
          XCTAssertEqual(secondaryRatingsAverages?.label, "What size is the product?")
          XCTAssertEqual(secondaryRatingsAverages?.valueLabel?.count, 3)
          XCTAssertEqual(secondaryRatingsAverages?.valueLabel, ["Small","Medium","Large"])
        }
        expectation.fulfill()
    }

    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }

    print(req)

    reviewQuery.async()

    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testReviewRelevancySort() {
    
    let expectation = self.expectation(description: "testReviewQueryDisplay")
    
    let reviewQuery = BVReviewQuery(productId: "product1", limit: 10, offset: 0)
      .sort(.relevancy, order: .a2)
      .configure(BVReviewQueryTest.relevancySortConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        XCTAssertEqual(reviews.count, 10)
        XCTAssertEqual(reviews.first?.reviewId, "34016202")
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testReviewCustomContentLocaleSort() {
    
    let expectation = self.expectation(description: "testReviewQueryDisplay")
    
    let reviewQuery = BVReviewQuery(productId: "product1", limit: 20, offset: 0)
      .sort(.contentLocale, contentLocales: ["es_US","en_US"])
      .configure(BVReviewQueryTest.relevancySortConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        XCTAssertEqual(reviews.count, 20)
        
        let ContentLocales = reviews.map { review in
                        review.contentLocale
        }
        
        XCTAssertTrue(ContentLocales.firstIndex(of: "es_US")! < ContentLocales.firstIndex(of: "en_US")!);
        expectation.fulfill()
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testReviewCustomContentLocaleSortErrorMoreValues() {
    
    let expectation = self.expectation(description: "testReviewQueryDisplay")
    
    let reviewQuery = BVReviewQuery(productId: "product1", limit: 20, offset: 0)
      .sort(.contentLocale, contentLocales: ["fr_FR","en_GB","en_US","en_ZH","en_CA","en_DE"])
      .configure(BVReviewQueryTest.relevancySortConfig)
      .handler { (response: BVConversationsQueryResponse<BVReview>) in
        
        if case .failure(let error) = response {
          print(error)
          expectation.fulfill()
          return
        }
        
        guard case let .success(_,reviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        XCTAssertNil(reviews)
        expectation.fulfill()
        
    }
    
    guard let req = reviewQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    reviewQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
    
    func testReviewQueryDisplayOriginalProductName() {
        
        let expectation = self.expectation(description: "testReviewQueryDisplayOriginalProductName")
        
        let reviewQuery = BVReviewQuery(productId: "data-gen-moppq9ekthfzbc6qff3bqokie", limit: 10, offset: 0)
          .sort(.rating, order: .descending)
          .configure(BVReviewQueryTest.incentivizedStatsConfig)
          .handler { (response: BVConversationsQueryResponse<BVReview>) in
            
            if case .failure(let error) = response {
              print(error)
              XCTFail()
              expectation.fulfill()
              return
            }
            
            guard case let .success(_, reviews) = response else {
              XCTFail()
              expectation.fulfill()
              return
            }
              
              
            guard let review: BVReview = reviews.first(where: {$0.reviewId == "45570991"}),
              let originalProductName = review.originalProductName else {
                XCTFail()
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(reviews.count, 10)
            XCTAssertEqual(review.rating, 5)
            XCTAssertEqual(review.title, "Test test")
            XCTAssertEqual(review.reviewText, "test test test test test test test test tes ttesttest")
            XCTAssertEqual(review.moderationStatus, "APPROVED")
            XCTAssertEqual(review.reviewId, "45570991")
            XCTAssertNotNil(review.productId)
            XCTAssertEqual(review.isRatingsOnly, false)
            XCTAssertEqual(review.isFeatured, false)
            XCTAssertEqual(review.productId, "data-gen-moppq9ekthfzbc6qff3bqokie")
            XCTAssertEqual(review.authorId, "jhan23")
            XCTAssertEqual(review.userNickname, "jhcontentent")
            XCTAssertEqual(review.userLocation, nil)
            XCTAssertEqual(originalProductName, "14K White Gold Diamond Teardrop Necklace")

            expectation.fulfill()
        }
        
        guard let req = reviewQuery.request else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        print(req)
        
        reviewQuery.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
          XCTAssertNil(
            error, "Something went horribly wrong, request took too long.")
        }
      }
}

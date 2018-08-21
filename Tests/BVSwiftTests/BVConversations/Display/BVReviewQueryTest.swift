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
        
        guard let review: BVReview = reviews.first,
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
        XCTAssertEqual(review.rating, 1)
        XCTAssertEqual(
          review.title, "Morbi nibh risus, mattis id placerat a massa nunc.")
        XCTAssertEqual(
          review.reviewText,
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed " +
            "rhoncus scelerisque semper. Morbi in sapien sit amet justo " +
            "eleifend pellentesque! Cras sollicitudin, quam in ullamcorper " +
            "faucibus, augue metus blandit justo, vitae ullamcorper tellus " +
            "quam non purus. Fusce gravida rhoncus placerat. Integer tempus " +
            "nunc sed elit mollis ut venenatis felis volutpat. Sed a velit " +
            "et lacus lobortis aliquet? Donec dolor quam, pharetra vitae " +
            "commodo et, mattis quis nibh? Quisque ultrices neque et lacus " +
          "volutpat.")
        XCTAssertEqual(review.moderationStatus, "APPROVED")
        XCTAssertEqual(review.reviewId, "191975")
        XCTAssertNotNil(review.productId)
        XCTAssertEqual(review.isRatingsOnly, false)
        XCTAssertEqual(review.isFeatured, false)
        XCTAssertEqual(review.productId, "test1")
        XCTAssertEqual(review.authorId, "endersgame")
        XCTAssertEqual(review.userNickname, "endersgame")
        XCTAssertEqual(review.userLocation, "San Fransisco, California")
        
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
        
        XCTAssertEqual(
          firstPhoto.caption,
          "Etiam malesuada ultricies urna in scelerisque. Sed viverra " +
            "blandit nibh non egestas. Sed rhoncus, ipsum in vehicula " +
            "imperdiet, purus lectus sodales erat, eget ornare lacus lectus " +
            "ac leo. Suspendisse tristique sollicitudin ultricies. Aliquam " +
          "erat volutpat.")
        XCTAssertEqual(firstPhoto.photoId, "72586")
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
        
        XCTAssertEqual(cdv.value, "Female")
        XCTAssertEqual(cdv.valueLabel, "Female")
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
    
    let path =
      Bundle(for: type(of: self))
        .path(forResource: "testSyndicationSource", ofType: "json")!
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
  
  func testReviewQueryDisplayProductFilteredStats() {
    
    let expectation =
      self.expectation(
        description: "testReviewQueryDisplayProductFilteredStats")
    
    let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 4)
      .sort(.rating, order: .ascending)
      .filter((.hasPhotos(true), .equalTo))
      .filter((.hasComments(false), .equalTo))
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
        
        guard let review: BVReview = reviews.first,
          let productId: String = review.productId,
          let tagDimensions: [BVDimensionElement] = review.tagDimensions,
          let badges: [BVBadge] = review.badges,
          let badge: BVBadge = badges.first,
          let photos: [BVPhoto] = review.photos,
          let photo: BVPhoto = photos.first,
          let photoSizes: [BVPhotoSize] = photo.photoSizes,
          let contextDataValues: [BVContextDataValue] =
          review.contextDataValues,
          let cdv: BVContextDataValue = contextDataValues.first else {
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
        
        XCTAssertEqual(review.reviewId, "191975")
        
        XCTAssertEqual(review.isRatingsOnly, false)
        XCTAssertEqual(review.isFeatured, false)
        XCTAssertEqual(review.productId, "test1")
        XCTAssertEqual(review.authorId, "endersgame")
        XCTAssertEqual(review.userNickname, "endersgame")
        XCTAssertEqual(review.userLocation, "San Fransisco, California")
        
        XCTAssertEqual(proTagLabel, "Pros")
        XCTAssertEqual(proTagId, "Pro")
        XCTAssertEqual(proTagValues, ["Organic Fabric", "Quality"])
        
        XCTAssertEqual(photos.count, 1)
        XCTAssertEqual(
          photo.caption,
          "Etiam malesuada ultricies urna in scelerisque. Sed viverra " +
            "blandit nibh non egestas. Sed rhoncus, ipsum in vehicula " +
            "imperdiet, purus lectus sodales erat, eget ornare lacus lectus " +
            "ac leo. Suspendisse tristique sollicitudin ultricies. Aliquam " +
          "erat volutpat.")
        XCTAssertEqual(photo.photoId, "72586")
        XCTAssertNotNil(thumbnail.url)
        
        XCTAssertTrue(
          normalURL
            .absoluteString
            .lowercased()
            .contains("https://photos-uat-eu.bazaarvoice.com"))
        
        XCTAssertEqual(contextDataValues.count, 1)
        XCTAssertEqual(cdv.value, "Female")
        XCTAssertEqual(cdv.valueLabel, "Female")
        XCTAssertEqual(cdv.dimensionLabel, "Gender")
        XCTAssertEqual(cdv.contextDataValueId, "Gender")
        
        XCTAssertEqual(badge.badgeType, .merit)
        XCTAssertEqual(badge.badgeId, "top10Contributor")
        XCTAssertEqual(badge.contentType, "REVIEW")
        
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
}

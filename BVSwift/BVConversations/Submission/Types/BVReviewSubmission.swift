//
//
//  BVReviewSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVReview Submissions
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/reviews/review-submission)
public class BVReviewSubmission: BVMediaSubmission<BVReview> {
  
  /// The Product identifier to submit against
  public var productId: String? {
    guard let review = submissionable else {
      return nil
    }
    return review.productId
  }
  
  /// The Product identifier to submit against
  public var reviewTitle: String? {
    guard let review = submissionable else {
      return nil
    }
    return review.title
  }
  
  /// The Product identifier to submit against
  public var reviewText: String? {
    guard let review = submissionable else {
      return nil
    }
    return review.reviewText
  }
  
  /// The Product identifier to submit against
  public var reviewRating: Int? {
    guard let review = submissionable else {
      return nil
    }
    return review.rating
  }
  
  /// The initializer for BVReviewSubmission
  /// - Parameters:
  ///   - productId: The Product identifier to submit against
  ///   - reviewTitle: The Review title content text to submit
  ///   - reviewText: The Review text content text to submit
  ///   - reviewRating: The Review rating value to submit
  public convenience init?(
    productId: String,
    reviewText: String,
    reviewTitle: String,
    reviewRating: Int) {
    self.init(
      BVReview(
        productId: productId,
        reviewText: reviewText,
        reviewTitle: reviewTitle,
        reviewRating: reviewRating))
  }
  
  /// The initializer for BVReviewSubmission
  /// - Parameters:
  ///   - review: The BVReview object containing a product id, review text,
  ///     review title text, and review rating value to submit against.
  public override init?(_ review: BVReview) {
    guard let title = review.title,
      let text = review.reviewText,
      let rating = review.rating,
      let productId = review.productId else {
        return nil
    }
    super.init(review)
    
    submissionParameters ∪= [
      URLQueryItem(name: "productId", value: productId.urlEncode()),
      URLQueryItem(name: "rating", value: "\(rating)".urlEncode()),
      URLQueryItem(name: "reviewtext", value: text.urlEncode()),
      URLQueryItem(name: "title", value: title.urlEncode())
    ]
  }
    
  public init?(productId: String) {
    
    super.init(BVReview(productId: productId))
    
    submissionParameters ∪= [
      URLQueryItem(name: "productId", value: productId.urlEncode())
    ]
  }
  
  override func conversationsPostflightDidSubmit(_ results: [BVReview]?) {
    guard nil != results,
      let id = self.productId else {
        return
    }
    
    let analyticsEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .reviews,
        name: .writeReview,
        productId: id,
        brand: nil,
        additional: nil)
    BVPixel.track(
      analyticsEvent,
      analyticConfiguration: self.configuration?.analyticsConfiguration)
  }
  
  override func conversationsPostflightDidSubmitPhotoUpload(
    _ results: [BVReview]?) {
    guard nil != results,
      let id = self.productId else {
        return
    }
    
    let analyticsEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .reviews,
        name: .photo,
        productId: id,
        brand: nil,
        additional: nil)
    BVPixel.track(
      analyticsEvent,
      analyticConfiguration: self.configuration?.analyticsConfiguration)
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionAlertable
extension BVReviewSubmission: BVConversationsSubmissionAlertable {
  @discardableResult
  public func add(_ alert: BVConversationsSubmissionAlerts) -> Self {
    submissionParameters ∪= alert.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionAuthenticityable
extension BVReviewSubmission: BVConversationsSubmissionAuthenticityable {
  @discardableResult
  public func add(
    _ authenticity: BVConversationsSubmissionAuthenticity) -> Self {
    submissionParameters ∪= authenticity.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionFieldTypeable
extension BVReviewSubmission: BVConversationsSubmissionFieldTypeable {
  @discardableResult
  public func add(_ fieldType: BVConversationsSubmissionFieldTypes) -> Self {
    submissionParameters ∪= fieldType.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionHostedAuthenticatable
extension BVReviewSubmission: BVConversationsSubmissionHostedAuthenticatable {
  @discardableResult
  public func add(
    _ hostedAuth: BVConversationsSubmissionHostedAuthenticated) -> Self {
    submissionParameters ∪= hostedAuth.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionLocaleable
extension BVReviewSubmission: BVConversationsSubmissionLocaleable {
  @discardableResult
  public func add(_ locale: BVConversationsSubmissionLocale) -> Self {
    submissionParameters ∪= locale.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionRatable
extension BVReviewSubmission: BVConversationsSubmissionRatable {
  @discardableResult
  public func add(_ rate: BVConversationsSubmissionRating) -> Self {
    submissionParameters ∪= rate.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionTaggable
extension BVReviewSubmission: BVConversationsSubmissionTaggable {
  @discardableResult
  public func add(_ tag: BVConversationsSubmissionTag) -> Self {
    submissionParameters ∪= tag.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionTermsAndConditionsable
extension BVReviewSubmission: BVConversationsSubmissionTermsAndConditionsable {
  @discardableResult
  public func add(
    _ termsAndConditions: BVConversationsSubmissionTermsAndConditions) -> Self {
    submissionParameters ∪= termsAndConditions.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionUserAuthenticatedStringable
extension BVReviewSubmission:
BVConversationsSubmissionUserAuthenticatedStringable {
  @discardableResult
  public func add(
    _ uas: BVConversationsSubmissionUserAuthenticatedString) -> Self {
    submissionParameters ∪= uas.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionUserInformationable
extension BVReviewSubmission: BVConversationsSubmissionUserInformationable {
  @discardableResult
  public func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self {
    submissionParameters ∪= userInfo.urlQueryItems
    return self
  }
}

//
//
//  BVReviewSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVReviewSubmission: BVMediaSubmission<BVReview> {
  
  private var productId: String?
  
  public override init?(_ review: BVReview) {
    guard let title = review.title,
      let text = review.reviewText,
      let rating = review.rating,
      let productId = review.productId else {
        return nil
    }
    
    self.productId = productId
    super.init(review)
    
    conversationsParameters ∪= [
      URLQueryItem(name: "productId", value: productId.urlEncode()),
      URLQueryItem(name: "rating", value: "\(rating)".urlEncode()),
      URLQueryItem(name: "reviewtext", value: text.urlEncode()),
      URLQueryItem(name: "title", value: title.urlEncode())
    ]
  }
  
  override func conversationsPostflightDidSubmit(_ results: [BVReview]?) {
    guard let _ = results,
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
    BVPixel.track(analyticsEvent)
  }
  
  override func conversationsPostflightDidSubmitPhotoUpload(
    _ results: [BVReview]?) {
    guard let _ = results,
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
    BVPixel.track(analyticsEvent)
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionAlertable
extension BVReviewSubmission: BVConversationsSubmissionAlertable {
  @discardableResult
  public func add(_ alert: BVConversationsSubmissionAlerts) -> Self {
    conversationsParameters ∪= alert.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionAuthenticityable
extension BVReviewSubmission: BVConversationsSubmissionAuthenticityable {
  @discardableResult
  public func add(
    _ authenticity: BVConversationsSubmissionAuthenticity) -> Self {
    conversationsParameters ∪= authenticity.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionFieldTypeable
extension BVReviewSubmission: BVConversationsSubmissionFieldTypeable {
  @discardableResult
  public func add(_ fieldType: BVConversationsSubmissionFieldTypes) -> Self {
    conversationsParameters ∪= fieldType.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionHostedAuthenticatable
extension BVReviewSubmission: BVConversationsSubmissionHostedAuthenticatable {
  @discardableResult
  public func add(
    _ hostedAuth: BVConversationsSubmissionHostedAuthenticated) -> Self {
    conversationsParameters ∪= hostedAuth.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionLocaleable
extension BVReviewSubmission: BVConversationsSubmissionLocaleable {
  @discardableResult
  public func add(_ locale: BVConversationsSubmissionLocale) -> Self {
    conversationsParameters ∪= locale.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionRatable
extension BVReviewSubmission: BVConversationsSubmissionRatable {
  @discardableResult
  public func add(_ rate: BVConversationsSubmissionRating) -> Self {
    conversationsParameters ∪= rate.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionTaggable
extension BVReviewSubmission: BVConversationsSubmissionTaggable {
  @discardableResult
  public func add(_ tag: BVConversationsSubmissionTag) -> Self {
    conversationsParameters ∪= tag.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionTermsAndConditionsable
extension BVReviewSubmission: BVConversationsSubmissionTermsAndConditionsable {
  @discardableResult
  public func add(
    _ termsAndConditions: BVConversationsSubmissionTermsAndConditions) -> Self {
    conversationsParameters ∪= termsAndConditions.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionUserAuthenticatedStringable
extension BVReviewSubmission:
BVConversationsSubmissionUserAuthenticatedStringable {
  @discardableResult
  public func add(
    _ uas: BVConversationsSubmissionUserAuthenticatedString) -> Self {
    conversationsParameters ∪= uas.urlQueryItems
    return self
  }
}

// MARK: - BVReviewSubmission: BVConversationsSubmissionUserInformationable
extension BVReviewSubmission: BVConversationsSubmissionUserInformationable {
  @discardableResult
  public func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self {
    conversationsParameters ∪= userInfo.urlQueryItems
    return self
  }
}

//
//
//  BVQuestionSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVQuestionSubmission: BVMediaSubmission<BVQuestion> {
  
  public let productId: String?
  
  public override init?(_ question: BVQuestion) {
    guard let isUserAnonymous = question.isUserAnonymous,
      let productId = question.productId,
      let details = question.questionDetails,
      let summary = question.questionSummary else {
        return nil
    }
    
    self.productId = productId
    super.init(question)
    
    conversationsParameters ∪= [
      URLQueryItem(name: "isuseranonymous", value: "\(isUserAnonymous)"),
      URLQueryItem(name: "productId", value: productId.urlEncode()),
      URLQueryItem(name: "questiondetails", value: details.urlEncode()),
      URLQueryItem(name: "questionsummary", value: summary.urlEncode())
    ]
  }
  
  override func conversationsPostflightDidSubmit(_ results: [BVQuestion]?) {
    guard let _ = results,
      let id = self.productId else {
        return
    }
    
    let analyticsEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .reviews,
        name: .askQuestion,
        productId: id,
        brand: nil,
        additional: nil)
    BVPixel.track(
      analyticsEvent,
      analyticConfiguration: self.configuration?.analyticsConfiguration)
  }
  
  override func conversationsPostflightDidSubmitPhotoUpload(
    _ results: [BVQuestion]?) {
    guard let _ = results,
      let id = self.productId else {
        return
    }
    
    let analyticsEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .question,
        name: .photo,
        productId: id,
        brand: nil,
        additional: nil)
    BVPixel.track(
      analyticsEvent,
      analyticConfiguration: self.configuration?.analyticsConfiguration)
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionAlertable
extension BVQuestionSubmission: BVConversationsSubmissionAlertable {
  @discardableResult
  public func add(_ alert: BVConversationsSubmissionAlerts) -> Self {
    conversationsParameters ∪= alert.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionAuthenticityable
extension BVQuestionSubmission: BVConversationsSubmissionAuthenticityable {
  @discardableResult
  public func add(
    _ authenticity: BVConversationsSubmissionAuthenticity) -> Self {
    conversationsParameters ∪= authenticity.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionHostedAuthenticatable
extension BVQuestionSubmission: BVConversationsSubmissionHostedAuthenticatable {
  @discardableResult
  public func add(
    _ hostedAuth: BVConversationsSubmissionHostedAuthenticated) -> Self {
    conversationsParameters ∪= hostedAuth.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionLocaleable
extension BVQuestionSubmission: BVConversationsSubmissionLocaleable {
  @discardableResult
  public func add(_ locale: BVConversationsSubmissionLocale) -> Self {
    conversationsParameters ∪= locale.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionTaggable
extension BVQuestionSubmission: BVConversationsSubmissionTaggable {
  @discardableResult
  public func add(_ tag: BVConversationsSubmissionTag) -> Self {
    conversationsParameters ∪= tag.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionTermsAndConditionsable
extension BVQuestionSubmission: BVConversationsSubmissionTermsAndConditionsable {
  @discardableResult
  public func add(
    _ termsAndConditions: BVConversationsSubmissionTermsAndConditions) -> Self {
    conversationsParameters ∪= termsAndConditions.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionUserAuthenticatedStringable
extension BVQuestionSubmission:
BVConversationsSubmissionUserAuthenticatedStringable {
  @discardableResult
  public func add(
    _ uas: BVConversationsSubmissionUserAuthenticatedString) -> Self {
    conversationsParameters ∪= uas.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionUserInformationable
extension BVQuestionSubmission: BVConversationsSubmissionUserInformationable {
  @discardableResult
  public func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self {
    conversationsParameters ∪= userInfo.urlQueryItems
    return self
  }
}

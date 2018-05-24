//
//
//  BVAnswerSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVAnswerSubmission: BVMediaSubmission<BVAnswer> {
  
  public let questionId: String?
  
  public convenience init?(questionId: String, answerText: String) {
    self.init(BVAnswer(questionId: questionId, answerText: answerText))
  }
  
  public override init?(_ answer: BVAnswer) {
    guard let questionId = answer.questionId?.urlEncode(),
      let text = answer.answerText?.urlEncode() else {
        return nil
    }
    
    self.questionId = questionId
    super.init(answer)
    
    conversationsParameters ∪= [
      URLQueryItem(name: "answertext", value: text),
      URLQueryItem(name: "questionid", value: questionId)
    ]
  }
  
  /// Internal
  override func conversationsPostflightDidSubmit(_ results: [BVAnswer]?) {
    guard let _ = results,
      let id = self.questionId else {
        return
    }
    
    let analyticsEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .reviews,
        name: .answerQuestion,
        productId: id,
        brand: nil,
        additional: nil)
    BVPixel.track(
      analyticsEvent,
      analyticConfiguration: self.configuration?.analyticsConfiguration)
  }
  
  override func conversationsPostflightDidSubmitPhotoUpload(
    _ results: [BVAnswer]?) {
    guard let _ = results,
      let id = self.questionId else {
        return
    }
    
    let analyticsEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .question,
        name: .photo,
        productId: id,
        brand: nil,
        additional: ["detail1" : "Answer"])
    BVPixel.track(
      analyticsEvent,
      analyticConfiguration: self.configuration?.analyticsConfiguration)
  }
}

// MARK: - BVAnswerSubmission: BVConversationsSubmissionAlertable
extension BVAnswerSubmission: BVConversationsSubmissionAlertable {
  @discardableResult
  public func add(_ alert: BVConversationsSubmissionAlerts) -> Self {
    conversationsParameters ∪= alert.urlQueryItems
    return self
  }
}

// MARK: - BVAnswerSubmission: BVConversationsSubmissionAuthenticityable
extension BVAnswerSubmission: BVConversationsSubmissionAuthenticityable {
  @discardableResult
  public func add(
    _ authenticity: BVConversationsSubmissionAuthenticity) -> Self {
    conversationsParameters ∪= authenticity.urlQueryItems
    return self
  }
}

// MARK: - BVAnswerSubmission: BVConversationsSubmissionHostedAuthenticatable
extension BVAnswerSubmission: BVConversationsSubmissionHostedAuthenticatable {
  @discardableResult
  public func add(
    _ hostedAuth: BVConversationsSubmissionHostedAuthenticated) -> Self {
    conversationsParameters ∪= hostedAuth.urlQueryItems
    return self
  }
}

// MARK: - BVAnswerSubmission: BVConversationsSubmissionLocaleable
extension BVAnswerSubmission: BVConversationsSubmissionLocaleable {
  @discardableResult
  public func add(_ locale: BVConversationsSubmissionLocale) -> Self {
    conversationsParameters ∪= locale.urlQueryItems
    return self
  }
}

// MARK: - BVAnswerSubmission: BVConversationsSubmissionTaggable
extension BVAnswerSubmission: BVConversationsSubmissionTaggable {
  @discardableResult
  public func add(_ tag: BVConversationsSubmissionTag) -> Self {
    conversationsParameters ∪= tag.urlQueryItems
    return self
  }
}

// MARK: - BVAnswerSubmission: BVConversationsSubmissionTermsAndConditionsable
extension BVAnswerSubmission: BVConversationsSubmissionTermsAndConditionsable {
  @discardableResult
  public func add(
    _ termsAndConditions: BVConversationsSubmissionTermsAndConditions) -> Self {
    conversationsParameters ∪= termsAndConditions.urlQueryItems
    return self
  }
}

// MARK: - BVAnswerSubmission: BVConversationsSubmissionUserAuthenticatedStringable
extension BVAnswerSubmission:
BVConversationsSubmissionUserAuthenticatedStringable {
  @discardableResult
  public func add(
    _ uas: BVConversationsSubmissionUserAuthenticatedString) -> Self {
    conversationsParameters ∪= uas.urlQueryItems
    return self
  }
}

// MARK: - BVAnswerSubmission: BVConversationsSubmissionUserInformationable
extension BVAnswerSubmission: BVConversationsSubmissionUserInformationable {
  @discardableResult
  public func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self {
    conversationsParameters ∪= userInfo.urlQueryItems
    return self
  }
}

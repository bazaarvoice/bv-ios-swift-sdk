//
//
//  BVAnswerSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVAnswer Submissions
/// - Note:
/// \
/// For more information please see the [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/answers/answer-submission)
public class BVAnswerSubmission: BVMediaSubmission<BVAnswer> {
  
  /// The Question identifier to submit against
  public var questionId: String? {
    get {
      guard let answer = submissionable else {
        return nil
      }
      return answer.questionId
    }
  }
  
  /// The Answer Text to submit against
  public var answerText: String? {
    get {
      guard let answer = submissionable else {
        return nil
      }
      return answer.answerText
    }
  }
  
  /// The initializer for BVAnswerSubmission
  /// - Parameters:
  ///   - questionId: The Question identifier to submit against
  ///   - answerText: The Answer content text to submit
  public convenience init?(questionId: String, answerText: String) {
    self.init(BVAnswer(questionId: questionId, answerText: answerText))
  }
  
  /// The initializer for BVAnswerSubmission
  /// - Parameters:
  ///   - answer: The BVAnswer object containing a question id and answer text
  ///     to submit against.
  public override init?(_ answer: BVAnswer) {
    guard let questionId = answer.questionId?.urlEncode(),
      let text = answer.answerText?.urlEncode() else {
        return nil
    }
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

//
//
//  BVQuestionSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVQuestion Submissions
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/questions/question-submission)
public class BVQuestionSubmission: BVMediaSubmission<BVQuestion> {
  
  /// The Product identifier to submit against
  public var productId: String? {
    guard let question = submissionable else {
      return nil
    }
    return question.productId
  }
  
  /// The Question details content text to submit
  public var questionDetails: String? {
    guard let question = submissionable else {
      return nil
    }
    return question.questionDetails
  }
  
  /// The Question summary content text to submit
  public var questionSummary: String? {
    guard let question = submissionable else {
      return nil
    }
    return question.questionSummary
  }
  
  /// The user anonymity flag to submit
  public var isUserAnonymous: Bool? {
    guard let question = submissionable else {
      return nil
    }
    return question.isUserAnonymous
  }
  
  /// The initializer for BVQuestionSubmission
  /// - Parameters:
  ///   - productId: The Product identifier to submit against
  ///   - questionDetails: The Question details content text to submit
  ///   - questionSummary: The Question summary content text to submit
  ///   - isUserAnonymous: The user anonymity flag to submit
  public convenience init?(
    productId: String,
    questionDetails: String,
    questionSummary: String,
    isUserAnonymous: Bool = false) {
    self.init(
      BVQuestion(
        productId: productId,
        questionDetails: questionDetails,
        questionSummary: questionSummary,
        isUserAnonymous: isUserAnonymous))
  }
  
  /// The initializer for BVQuestionSubmission
  /// - Parameters:
  ///   - question: The BVQuestion object containing a product id, question
  ///     details text, and question summary text, and whether the user is
  ///     anonymous to submit against.
  public override init?(_ question: BVQuestion) {
    guard let isUserAnonymous = question.isUserAnonymous,
      let productId = question.productId,
      let details = question.questionDetails,
      let summary = question.questionSummary else {
        return nil
    }
    super.init(question)
    
    submissionParameters ∪= [
      URLQueryItem(name: "isuseranonymous", value: "\(isUserAnonymous)"),
      URLQueryItem(name: "productId", value: productId.urlEncode()),
      URLQueryItem(name: "questiondetails", value: details.urlEncode()),
      URLQueryItem(name: "questionsummary", value: summary.urlEncode())
    ]
  }
  
  override func conversationsPostflightDidSubmit(_ results: [BVQuestion]?) {
    guard nil != results,
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
    guard nil != results,
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
    submissionParameters ∪= alert.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionAuthenticityable
extension BVQuestionSubmission: BVConversationsSubmissionAuthenticityable {
  @discardableResult
  public func add(
    _ authenticity: BVConversationsSubmissionAuthenticity) -> Self {
    submissionParameters ∪= authenticity.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionHostedAuthenticatable
extension
BVQuestionSubmission: BVConversationsSubmissionHostedAuthenticatable {
  @discardableResult
  public func add(
    _ hostedAuth: BVConversationsSubmissionHostedAuthenticated) -> Self {
    submissionParameters ∪= hostedAuth.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionLocaleable
extension BVQuestionSubmission: BVConversationsSubmissionLocaleable {
  @discardableResult
  public func add(_ locale: BVConversationsSubmissionLocale) -> Self {
    submissionParameters ∪= locale.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionTaggable
extension BVQuestionSubmission: BVConversationsSubmissionTaggable {
  @discardableResult
  public func add(_ tag: BVConversationsSubmissionTag) -> Self {
    submissionParameters ∪= tag.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionTermsAndConditionsable
extension
BVQuestionSubmission: BVConversationsSubmissionTermsAndConditionsable {
  @discardableResult
  public func add(
    _ termsAndConditions: BVConversationsSubmissionTermsAndConditions) -> Self {
    submissionParameters ∪= termsAndConditions.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionUserAuthenticatedStringable
extension BVQuestionSubmission:
BVConversationsSubmissionUserAuthenticatedStringable {
  @discardableResult
  public func add(
    _ uas: BVConversationsSubmissionUserAuthenticatedString) -> Self {
    submissionParameters ∪= uas.urlQueryItems
    return self
  }
}

// MARK: - BVQuestionSubmission: BVConversationsSubmissionUserInformationable
extension BVQuestionSubmission: BVConversationsSubmissionUserInformationable {
  @discardableResult
  public func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self {
    submissionParameters ∪= userInfo.urlQueryItems
    return self
  }
}

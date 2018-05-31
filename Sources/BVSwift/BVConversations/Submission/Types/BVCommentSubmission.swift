//
//
//  BVCommentSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVComment Submissions
/// - Note:
/// \
/// For more information please see the [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-submission)
public class BVCommentSubmission: BVMediaSubmission<BVComment> {
  
  /// The Review identifier to submit against
  public var reviewId: String? {
    get {
      guard let comment = submissionable else {
        return nil
      }
      return comment.reviewId
    }
  }
  
  /// The Comment content text to submit
  public var commentText: String? {
    get {
      guard let comment = submissionable else {
        return nil
      }
      return comment.commentText
    }
  }
  
  /// The Comment content title to submit
  public var commentTitle: String? {
    get {
      guard let comment = submissionable else {
        return nil
      }
      return comment.title
    }
  }
  
  /// The initializer for BVCommentSubmission
  /// - Parameters:
  ///   - reviewId: The Review identifier to submit against
  ///   - commentText: The Comment content text to submit
  ///   - commentTitle: The Comment content title to submit
  public convenience init?(
    reviewId: String, commentText: String, commentTitle: String?) {
    self.init(
      BVComment(
        reviewId: reviewId,
        commentText: commentText,
        commentTitle: commentTitle))
  }
  
  /// The initializer for BVCommentSubmission
  /// - Parameters:
  ///   - comment: The BVComment object containing a review id, comment text,
  ///     and comment title to submit against.
  public override init?(_ comment: BVComment) {
    guard let reviewId = comment.reviewId?.urlEncode(),
      let text = comment.commentText?.urlEncode() else {
        return nil
    }
    super.init(comment)
    
    conversationsParameters ∪= [
      URLQueryItem(name: "commenttext", value: text),
      URLQueryItem(name: "reviewid", value: reviewId)
    ]
    
    if let commentTitle = comment.title?.urlEncode() {
      conversationsParameters ∪= [
        URLQueryItem(name: "title", value: commentTitle)
      ]
    }
  }
  
  override func conversationsPostflightDidSubmit(_ results: [BVComment]?) {
    guard let _ = results,
      let id = self.reviewId else {
        return
    }
    
    let analyticsEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .reviews,
        name: .reviewComment,
        productId: id,
        brand: nil,
        additional: nil)
    BVPixel.track(
      analyticsEvent,
      analyticConfiguration: self.configuration?.analyticsConfiguration)
  }
  
  override func conversationsPostflightDidSubmitPhotoUpload(
    _ results: [BVComment]?) {
    guard let _ = results,
      let id = self.reviewId else {
        return
    }
    
    let analyticsEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .question,
        name: .photo,
        productId: id,
        brand: nil,
        additional: ["detail1" : "Comment"])
    BVPixel.track(
      analyticsEvent,
      analyticConfiguration: self.configuration?.analyticsConfiguration)
  }
}

// MARK: - BVCommentSubmission: BVConversationsSubmissionAlertable
extension BVCommentSubmission: BVConversationsSubmissionAlertable {
  @discardableResult
  public func add(_ alert: BVConversationsSubmissionAlerts) -> Self {
    
    /// sendEmailWhenCommented doesn't make sense
    guard case .sendEmailWhenPublished = alert else {
      return self
    }
    
    conversationsParameters ∪= alert.urlQueryItems
    return self
  }
}

// MARK: - BVCommentSubmission: BVConversationsSubmissionAuthenticityable
extension BVCommentSubmission: BVConversationsSubmissionAuthenticityable {
  @discardableResult
  public func add(
    _ authenticity: BVConversationsSubmissionAuthenticity) -> Self {
    conversationsParameters ∪= authenticity.urlQueryItems
    return self
  }
}

// MARK: - BVCommentSubmission: BVConversationsSubmissionHostedAuthenticatable
extension BVCommentSubmission: BVConversationsSubmissionHostedAuthenticatable {
  @discardableResult
  public func add(
    _ hostedAuth: BVConversationsSubmissionHostedAuthenticated) -> Self {
    conversationsParameters ∪= hostedAuth.urlQueryItems
    return self
  }
}

// MARK: - BVCommentSubmission: BVConversationsSubmissionLocaleable
extension BVCommentSubmission: BVConversationsSubmissionLocaleable {
  @discardableResult
  public func add(_ locale: BVConversationsSubmissionLocale) -> Self {
    conversationsParameters ∪= locale.urlQueryItems
    return self
  }
}

// MARK: - BVCommentSubmission: BVConversationsSubmissionTaggable
extension BVCommentSubmission: BVConversationsSubmissionTaggable {
  @discardableResult
  public func add(_ tag: BVConversationsSubmissionTag) -> Self {
    conversationsParameters ∪= tag.urlQueryItems
    return self
  }
}

// MARK: - BVCommentSubmission: BVConversationsSubmissionTermsAndConditionsable
extension BVCommentSubmission: BVConversationsSubmissionTermsAndConditionsable {
  @discardableResult
  public func add(
    _ termsAndConditions: BVConversationsSubmissionTermsAndConditions) -> Self {
    conversationsParameters ∪= termsAndConditions.urlQueryItems
    return self
  }
}

// MARK: - BVCommentSubmission: BVConversationsSubmissionUserAuthenticatedStringable
extension BVCommentSubmission:
BVConversationsSubmissionUserAuthenticatedStringable {
  @discardableResult
  public func add(
    _ uas: BVConversationsSubmissionUserAuthenticatedString) -> Self {
    conversationsParameters ∪= uas.urlQueryItems
    return self
  }
}

// MARK: - BVCommentSubmission: BVConversationsSubmissionUserInformationable
extension BVCommentSubmission: BVConversationsSubmissionUserInformationable {
  @discardableResult
  public func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self {
    conversationsParameters ∪= userInfo.urlQueryItems
    return self
  }
}

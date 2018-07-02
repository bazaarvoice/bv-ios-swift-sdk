//
//  BVManagerConversationsSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Protocol defining the gestalt of submission requests. To be used as a
/// vehicle to generate types which are likely generative of all of the
/// submission types.
public protocol BVConversationsSubmissionGenerator {
  
  /// Generator for BVAnswerSubmission
  /// - Parameters:
  ///   - answer: BVAnswer object to generate submission for
  func submission(_ answer: BVAnswer) -> BVAnswerSubmission?
  
  /// Generator for BVAnswerSubmission
  /// - Parameters:
  ///   - answerQuestionId: BVQuestion subject id to submit an answer to
  ///   - answerText: Text comprising of the answer
  func submission(
    answerQuestionId: String, answerText: String) -> BVAnswerSubmission?
  
  /// Generator for BVCommentSubmission
  /// - Parameters:
  ///   - comment: BVComment object to generate submission for
  func submission(_ comment: BVComment) -> BVCommentSubmission?
  
  /// Generator for BVCommentSubmission
  /// - Parameters:
  ///   - reviewId: Review id to submit a comment to
  ///   - commentText: Text comprising of the comment
  ///   - commentTitle: Text comprising of the comment title
  func submission(
    reviewId: String,
    commentText: String,
    commentTitle: String?) -> BVCommentSubmission?
  
  /// Generator for BVFeedbackSubmission
  /// - Parameters:
  ///   - feedback: BVFeedback object to generate submission for
  func submission(_ feedback: BVFeedback) -> BVFeedbackSubmission?
  
  /// Generator for BVQuestionSubmission
  /// - Parameters:
  ///   - question: BVQuestion object to generate submission for
  func submission(_ question: BVQuestion) -> BVQuestionSubmission?
  
  /// Generator for BVQuestionSubmission
  /// - Parameters:
  ///   - productId: Product id to submit a question to
  ///   - questionDetails: Text comprising of the question details
  ///   - questionSummary: Text comprising of the question summary
  ///   - isUserAnonymous: Whether the user is to be anonymous
  func submission(
    productId: String,
    questionDetails: String,
    questionSummary: String,
    isUserAnonymous: Bool) -> BVQuestionSubmission?
  
  /// Generator for BVReviewSubmission
  /// - Parameters:
  ///   - review: BVReview object to generate submission for
  func submission(_ review: BVReview) -> BVReviewSubmission?
  
  /// Generator for BVReviewSubmission
  /// - Parameters:
  ///   - productId: Product id to submit a review to
  ///   - reviewTitle: Text comprising of the review title
  ///   - reviewText: Text comprising of the review
  ///   - reviewRating: Rating value from 1-5
  func submission(
    productId: String,
    reviewText: String,
    reviewTitle: String,
    reviewRating: Int) -> BVReviewSubmission?
  
  /// Generator for BVUASSubmission
  /// - Parameters:
  ///   - uas: BVUAS object to generate submission for
  func submission(_ uas: BVUAS) -> BVUASSubmission?
  
  /// Generator for BVUASSubmission
  /// - Parameters:
  ///   - bvAuthToken: Auth token value to authenticate against
  func submission(bvAuthToken: String) -> BVUASSubmission?
}

/// BVManager's conformance to the BVConversationsSubmissionGenerator protocol
/// - Note:
/// \
/// This is a convenience extension to generate already preconfigured
/// submission types. It's also an abstraction layer to allow for easier
/// integration with any future advamcements made in the configuration layer
/// instead of having to manually configure each type.
extension BVManager: BVConversationsSubmissionGenerator {
  public func submission(_ answer: BVAnswer) -> BVAnswerSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVAnswerSubmission(answer)?.configure(config)
  }
  
  public func submission(
    answerQuestionId: String, answerText: String) -> BVAnswerSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVAnswerSubmission(
      questionId: answerQuestionId, answerText: answerText)?.configure(config)
  }
  
  public func submission(_ comment: BVComment) -> BVCommentSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVCommentSubmission(comment)?.configure(config)
  }
  
  public func submission(
    reviewId: String,
    commentText: String,
    commentTitle: String? = nil) -> BVCommentSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVCommentSubmission(
      reviewId: reviewId,
      commentText: commentText,
      commentTitle: commentTitle)?.configure(config)
  }
  
  public func submission(_ feedback: BVFeedback) -> BVFeedbackSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVFeedbackSubmission(feedback)?.configure(config)
  }
  
  public func submission(_ question: BVQuestion) -> BVQuestionSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVQuestionSubmission(question)?.configure(config)
  }
  
  public func submission(
    productId: String,
    questionDetails: String,
    questionSummary: String,
    isUserAnonymous: Bool = false) -> BVQuestionSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVQuestionSubmission(
      productId: productId,
      questionDetails: questionDetails,
      questionSummary: questionSummary,
      isUserAnonymous: isUserAnonymous)?.configure(config)
  }
  
  public func submission(_ review: BVReview) -> BVReviewSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVReviewSubmission(review)?.configure(config)
  }
  
  public func submission(
    productId: String,
    reviewText: String,
    reviewTitle: String,
    reviewRating: Int) -> BVReviewSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVReviewSubmission(
      productId: productId,
      reviewText: reviewText,
      reviewTitle: reviewTitle,
      reviewRating: reviewRating)?.configure(config)
  }
  
  public func submission(_ uas: BVUAS) -> BVUASSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVUASSubmission(uas)?.configure(config)
  }
  
  public func submission(bvAuthToken: String) -> BVUASSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVUASSubmission(bvAuthToken: bvAuthToken)?.configure(config)
  }
}

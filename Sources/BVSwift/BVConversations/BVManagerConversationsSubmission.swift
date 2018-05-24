//
//  BVManagerConversationsSubmission.swift
//  BVSwift
//
//  Created by Michael Van Milligan on 5/24/18.
//  Copyright © 2018 Michael Van Milligan. All rights reserved.
//

import Foundation

// MARK: - BVConversationsSubmissionGenerator
public protocol BVConversationsSubmissionGenerator {
  func submission(_ answer: BVAnswer) -> BVAnswerSubmission?
  func submission(
    answerQuestionId: String, answerText: String) -> BVAnswerSubmission?
  func submission(_ comment: BVComment) -> BVCommentSubmission?
  func submission(
    reviewId: String,
    commentText: String,
    commentTitle: String?) -> BVCommentSubmission?
  func submission(_ feedback: BVFeedback) -> BVFeedbackSubmission?
  func submission(_ question: BVQuestion) -> BVQuestionSubmission?
  func submission(
    productId: String,
    questionDetails: String,
    questionSummary: String,
    isUserAnonymous: Bool) -> BVQuestionSubmission?
  func submission(_ review: BVReview) -> BVReviewSubmission?
  func submission(
    productId: String,
    reviewTitle: String,
    reviewText: String,
    reviewRating: Int) -> BVReviewSubmission?
  func submission(_ uas: BVUAS) -> BVUASSubmission?
  func submission(bvAuthToken: String) -> BVUASSubmission?
}

// MARK: - BVManager: BVConversationsSubmissionGenerator
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
    commentTitle: String?) -> BVCommentSubmission? {
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
    reviewTitle: String,
    reviewText: String,
    reviewRating: Int) -> BVReviewSubmission? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return BVReviewSubmission(
      productId: productId,
      reviewTitle: reviewTitle,
      reviewText: reviewText,
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


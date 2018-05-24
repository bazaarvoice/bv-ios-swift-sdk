//
//  BVManagerConversationsQuery.swift
//  BVSwift
//
//  Created by Michael Van Milligan on 5/24/18.
//  Copyright © 2018 Michael Van Milligan. All rights reserved.
//

import Foundation

// MARK: - BVConversationsQueryGenerator
public protocol BVConversationsQueryGenerator {
  func query(authorId: String) -> BVAuthorQuery?
  func query(commentProductId: String, commentId: String) -> BVCommentQuery?
  func query(
    commentProductId: String,
    commentReviewId: String,
    limit: UInt16,
    offset: UInt16) -> BVCommentsQuery?
  func query(productId: String) -> BVProductQuery?
  func query(productSearchQuery: String) -> BVProductSearchQuery?
  func query() -> BVProductsQuery?
  func query(productIds: [String]) -> BVProductStatisticsQuery?
  func query(
    questionProductId: String,
    limit: UInt16,
    offset: UInt16) -> BVQuestionQuery?
  func query(
    questionProductId: String,
    searchQuery: String,
    limit: UInt16,
    offset: UInt16) -> BVQuestionSearchQuery?
  func query(
    reviewProductId: String, limit: UInt16, offset: UInt16) -> BVReviewQuery?
  func query(
    reviewProductId: String,
    searchQuery: String,
    limit: UInt16,
    offset: UInt16) -> BVReviewSearchQuery?
}

// MARK: - BVManager: BVConversationsQueryGenerator
extension BVManager: BVConversationsQueryGenerator {
  
  public func query(authorId: String) -> BVAuthorQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVAuthorQuery(authorId: authorId)
        .configure(config)
  }
  
  public func query(
    commentProductId: String, commentId: String) -> BVCommentQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVCommentQuery(productId: commentProductId, commentId: commentId)
        .configure(config)
  }
  
  public func query(
    commentProductId: String,
    commentReviewId: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) -> BVCommentsQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVCommentsQuery(
        productId: commentProductId,
        reviewId: commentReviewId,
        limit: limit,
        offset: offset)
        .configure(config)
  }
  
  public func query(productId: String) -> BVProductQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVProductQuery(productId: productId)
        .configure(config)
  }
  
  public func query(productSearchQuery: String) -> BVProductSearchQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVProductSearchQuery(searchQuery: productSearchQuery)
        .configure(config)
  }
  
  public func query() -> BVProductsQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVProductsQuery().configure(config)
  }
  
  public func query(productIds: [String]) -> BVProductStatisticsQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVProductStatisticsQuery(productIds: productIds)
        .configure(config)
  }
  
  public func query(
    questionProductId: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) -> BVQuestionQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVQuestionQuery(
        productId: questionProductId, limit: limit, offset: offset)
        .configure(config)
  }
  
  public func query(
    questionProductId: String,
    searchQuery: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) -> BVQuestionSearchQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVQuestionSearchQuery(
        productId: questionProductId,
        searchQuery: searchQuery,
        limit: limit,
        offset: offset)
        .configure(config)
  }
  
  public func query(
    reviewProductId: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) -> BVReviewQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVReviewQuery(productId: reviewProductId, limit: limit, offset: offset)
        .configure(config)
  }
  
  public func query(
    reviewProductId: String,
    searchQuery: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) -> BVReviewSearchQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVReviewSearchQuery(
        productId: reviewProductId,
        searchQuery: searchQuery,
        limit: limit,
        offset: offset)
        .configure(config)
  }
}

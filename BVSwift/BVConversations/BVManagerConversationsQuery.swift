//
//  BVManagerConversationsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Protocol defining the gestalt of query requests. To be used as a vehicle to
/// generate types which are likely generative of all of the query types.
public protocol BVConversationsQueryGenerator {
  
  // Generator for BVAuthorQuery
  /// - Parameters:
  ///   - authorId: Author id to query against
  func query(productId: String) -> BVFeatureQuery?
  
  /// Generator for BVAuthorQuery
  /// - Parameters:
  ///   - authorId: Author id to query against
  func query(authorId: String) -> BVAuthorQuery?
  
  /// Generator for BVCommentQuery
  /// - Parameters:
  ///   - commentProductId: Product id to query against
  ///   - commentId: Comment id to query against
  func query(commentProductId: String, commentId: String) -> BVCommentQuery?
  
  /// Generator for BVCommentsQuery
  /// - Parameters:
  ///   - commentProductId: Product id to query against
  ///   - commentReviewId: Review id to query against
  ///   - limit: Limit value for query
  ///   - offset: Offset in paging for query
  func query(
    commentProductId: String,
    commentReviewId: String,
    limit: UInt16,
    offset: UInt16) -> BVCommentsQuery?
  
  /// Generator for BVProductQuery
  /// - Parameters:
  ///   - productId: Product id to query against
  func query(productId: String) -> BVProductQuery?
  
  /// Generator for BVProductSearchQuery
  /// - Parameters:
  ///   - productSearchQuery: Search query string to query against
  func query(productSearchQuery: String) -> BVProductSearchQuery?
  
  /// Generator for BVProductsQuery
  /// - Parameters:
  ///   - productIds: Array of product ids to query against
  func query(productIds: [String]) -> BVProductsQuery?
  
  /// Generator for BVProductStatisticsQuery
  /// - Parameters:
  ///   - productIds: Array of product ids to query against
  func query(productIds: [String]) -> BVProductStatisticsQuery?
  
  /// Generator for BVQuestionQuery
  /// - Parameters:
  ///   - questionProductId: Product id to query against
  ///   - limit: Limit value for query
  ///   - offset: Offset in paging for query
  func query(
    questionProductId: String,
    limit: UInt16,
    offset: UInt16) -> BVQuestionQuery?
  
  /// Generator for BVQuestionSearchQuery
  /// - Parameters:
  ///   - questionProductId: Product id to query against
  ///   - searchQuery: Search query string to query against
  ///   - limit: Limit value for query
  ///   - offset: Offset in paging for query
  func query(
    questionProductId: String,
    searchQuery: String,
    limit: UInt16,
    offset: UInt16) -> BVQuestionSearchQuery?
  
  /// Generator for BVReviewQuery
  /// - Parameters:
  ///   - reviewProductId: Product id to query against
  ///   - limit: Limit value for query
  ///   - offset: Offset in paging for query
  func query(
    reviewProductId: String, limit: UInt16, offset: UInt16) -> BVReviewQuery?
  
  /// Generator for BVReviewSearchQuery
  /// - Parameters:
  ///   - reviewProductId: Product id to query against
  ///   - searchQuery: Search query string to query against
  ///   - limit: Limit value for query
  ///   - offset: Offset in paging for query
  func query(
    reviewProductId: String,
    searchQuery: String,
    limit: UInt16,
    offset: UInt16) -> BVReviewSearchQuery?
    
    /// Generator for BVProductReviewHighlightsQuery
    /// - Parameters:
    ///   - clientId: Client id to query against
    ///   - productId: Product id to query against
    func query(clientId: String,
               productId: String) -> BVProductReviewHighlightsQuery?
}

/// BVManager's conformance to the BVConversationsQueryGenerator protocol
/// - Note:
/// \
/// This is a convenience extension to generate already preconfigured
/// query types. It's also an abstraction layer to allow for easier
/// integration with any future advamcements made in the configuration layer
/// instead of having to manually configure each type.
extension BVManager: BVConversationsQueryGenerator {
  
  public func query(productId: String) -> BVFeatureQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVFeatureQuery(productId: productId)
        .configure(config)
  }
  
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
  
  public func query(productIds: [String]) -> BVProductsQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVProductsQuery(productIds: productIds)?.configure(config)
  }
  
  public func query(productIds: [String]) -> BVProductStatisticsQuery? {
    guard let config = BVManager.conversationsConfiguration else {
      return nil
    }
    
    return
      BVProductStatisticsQuery(productIds: productIds)?
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
    
    public func query(clientId: String,
                      productId: String) -> BVProductReviewHighlightsQuery? {
        guard let config = BVManager.reviewHighlightsConfiguration else {
          return nil
        }
        
        return
            BVProductReviewHighlightsQuery(clientId: clientId, productId: productId)
            .configure(config)
    }
}

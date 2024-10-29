//
//  BVComment.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVComment type
/// - Note:
/// \
/// It conforms to BVQueryable and BVSubmissionable, therefore, it is used for
/// both BVQuery and BVSubmission.
public struct BVComment: BVQueryable, BVSubmissionable {
  
  public static var singularKey: String {
    return BVConversationsConstants.BVComments.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVComments.pluralKey
  }
  
  private var includedAuthors: [BVAuthor]?
  private var includedProducts: [BVProduct]?
  private var includedReviews: [BVReview]?
  
  public let authorId: String?
  public var badges: [BVBadge]? {
    return badgesArray?.array
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  public let campaignId: String?
  public let commentId: String?
  public let commentText: String?
  public let contentLocale: String?
  public let isSyndicated: Bool?
  public var lastModeratedTime: Date? {
    return lastModeratedTimeString?.toBVDate()
  }
  private let lastModeratedTimeString: String?
  public let sourceClient: String?
  public var lastModificationTime: Date? {
    return lastModificationTimeString?.toBVDate()
  }
  private let lastModificationTimeString: String?
  public let reviewId: String?
  public let submissionId: String?
  public var submissionTime: Date? {
    return submissionTimeString?.toBVDate()
  }
  private let submissionTimeString: String?
  public let syndicationSource: BVSyndicationSource?
  public let title: String?
  public let totalInappropriateFeedbackCount: UInt?
  public let totalFeedbackCount: UInt?
  public let totalNegativeFeedbackCount: UInt?
  public let totalPositiveFeedbackCount: UInt?
  public let userLocation: String?
  public let userNickname: String?
  
  private enum CodingKeys: String, CodingKey {
    case authorId = "AuthorId"
    case badgesArray = "Badges"
    case campaignId = "CampaignId"
    case commentId = "Id"
    case commentText = "CommentText"
    case contentLocale = "ContentLocale"
    case isSyndicated = "IsSyndicated"
    case lastModeratedTimeString = "LastModeratedTime"
    case lastModificationTimeString = "LastModificationTime"
    case sourceClient = "SourceClient"
    case reviewId = "ReviewId"
    case submissionId = "SubmissionId"
    case submissionTimeString = "SubmissionTime"
    case syndicationSource = "SyndicationSource"
    case title = "Title"
    case totalInappropriateFeedbackCount = "TotalInappropriateFeedbackCount"
    case totalFeedbackCount = "TotalFeedbackCount"
    case totalNegativeFeedbackCount = "TotalNegativeFeedbackCount"
    case totalPositiveFeedbackCount = "TotalPositiveFeedbackCount"
    case userLocation = "UserLocation"
    case userNickname = "UserNickname"
  }
}

extension BVComment {
  public init(
    reviewId: String, commentText: String, commentTitle: String? = nil) {
    self.reviewId = reviewId
    self.commentText = commentText
    self.title = commentTitle
    self.includedAuthors = nil
    self.includedProducts = nil
    self.includedReviews = nil
    self.authorId = nil
    self.badgesArray = nil
    self.campaignId = nil
    self.commentId = nil
    self.contentLocale = nil
    self.isSyndicated = nil
    self.lastModeratedTimeString = nil
    self.sourceClient = nil
    self.lastModificationTimeString = nil
    self.submissionId = nil
    self.submissionTimeString = nil
    self.syndicationSource = nil
    self.totalInappropriateFeedbackCount = nil
    self.totalFeedbackCount = nil
    self.totalNegativeFeedbackCount = nil
    self.totalPositiveFeedbackCount = nil
    self.userLocation = nil
    self.userNickname = nil
  }
}

// MARK: - BVComment: BVAuthorIncludable
extension BVComment: BVAuthorIncludable {
  public var authors: [BVAuthor]? {
    return includedAuthors
  }
}

// MARK: - BVComment: BVProductIncludable
extension BVComment: BVProductIncludable {
  public var products: [BVProduct]? {
    return includedProducts
  }
}

// MARK: - BVComment: BVReviewIncludable
extension BVComment: BVReviewIncludable {
  public var reviews: [BVReview]? {
    return includedReviews
  }
}

// MARK: - BVComment: BVConversationsQueryUpdateIncludable
extension BVComment: BVConversationsQueryUpdateIncludable {
  
  internal mutating
  func update(_ includable: BVConversationsQueryIncludable) {
    
    if let authors: [BVAuthor] = includable.authors {
      self.includedAuthors = authors
    }
    if let products: [BVProduct] = includable.products {
      self.includedProducts = products
    }
    if let reviews: [BVReview] = includable.reviews {
      self.includedReviews = reviews
    }
  }
}

extension BVComment: BVQueryableInternal {
  internal static var getResource: String? {
    return BVConversationsConstants.BVComments.getResource
  }
}

extension BVComment: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return BVConversationsConstants.BVComments.postResource
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}

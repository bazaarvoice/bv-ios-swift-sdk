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
    get {
      return BVConversationsConstants.BVComments.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVConversationsConstants.BVComments.pluralKey
    }
  }
  
  public private(set) var authors: [BVAuthor]? = nil
  public private(set) var products: [BVProduct]? = nil
  public private(set) var reviews: [BVReview]? = nil
  
  public let authorId: String?
  public var badges: [BVBadge]? {
    get {
      return badgesArray?.array
    }
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  public let campaignId: String?
  public let commentId: String?
  public let commentText: String?
  public let contentLocale: String?
  public let isSyndicated: Bool?
  public var lastModeratedTime: Date? {
    get {
      return lastModeratedTimeString?.toBVDate()
    }
  }
  private let lastModeratedTimeString: String?
  public var lastModificationTime: Date? {
    get {
      return lastModificationTimeString?.toBVDate()
    }
  }
  private let lastModificationTimeString: String?
  public let reviewId: String?
  public let submissionId: String?
  public var submissionTime: Date? {
    get {
      return submissionTimeString?.toBVDate()
    }
  }
  private let submissionTimeString: String?
  public let syndicationSource: BVSyndicationSource?
  public let title: String?
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
    case reviewId = "ReviewId"
    case submissionId = "SubmissionId"
    case submissionTimeString = "SubmissionTime"
    case syndicationSource = "SyndicationSource"
    case title = "Title"
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
    self.authors = nil
    self.products = nil
    self.reviews = nil
    self.authorId = nil
    self.badgesArray = nil
    self.campaignId = nil
    self.commentId = nil
    self.contentLocale = nil
    self.isSyndicated = nil
    self.lastModeratedTimeString = nil
    self.lastModificationTimeString = nil
    self.submissionId = nil
    self.submissionTimeString = nil
    self.syndicationSource = nil
    self.totalFeedbackCount = nil
    self.totalNegativeFeedbackCount = nil
    self.totalPositiveFeedbackCount = nil
    self.userLocation = nil
    self.userNickname = nil
  }
}

// MARK: - BVComment: BVAuthorIncludable
extension BVComment: BVAuthorIncludable { }

// MARK: - BVComment: BVProductIncludable
extension BVComment: BVProductIncludable { }

// MARK: - BVComment: BVReviewIncludable
extension BVComment: BVReviewIncludable { }

// MARK: - BVComment: BVConversationsUpdateIncludable
extension BVComment: BVConversationsUpdateIncludable {
  
  internal mutating
  func updateIncludable(_ includable: BVConversationsIncludable) {
    
    if let authors: [BVAuthor] = includable.authors {
      self.authors = authors
    }
    if let products: [BVProduct] = includable.products {
      self.products = products
    }
    if let reviews: [BVReview] = includable.reviews {
      self.reviews = reviews
    }
  }
}

extension BVComment: BVQueryableInternal {
  internal static var getResource: String? {
    get {
      return BVConversationsConstants.BVComments.getResource
    }
  }
}

extension BVComment: BVSubmissionableInternal {
  internal static var postResource: String? {
    get {
      return BVConversationsConstants.BVComments.postResource
    }
  }
}

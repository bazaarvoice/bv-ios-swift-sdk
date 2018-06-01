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
  
  let authorId: String?
  var badges: [BVBadge]? {
    get {
      return badgesArray?.array
    }
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  let campaignId: String?
  let commentId: String?
  let commentText: String?
  let contentLocale: String?
  let isSyndicated: Bool?
  var lastModeratedTime: Date? {
    get {
      return lastModeratedTimeString?.toBVDate()
    }
  }
  private let lastModeratedTimeString: String?
  var lastModificationTime: Date? {
    get {
      return lastModificationTimeString?.toBVDate()
    }
  }
  private let lastModificationTimeString: String?
  let reviewId: String?
  let submissionId: String?
  var submissionTime: Date? {
    get {
      return submissionTimeString?.toBVDate()
    }
  }
  private let submissionTimeString: String?
  let syndicationSource: BVSyndicationSource?
  let title: String?
  let totalFeedbackCount: UInt?
  let totalNegativeFeedbackCount: UInt?
  let totalPositiveFeedbackCount: UInt?
  let userLocation: String?
  let userNickname: String?
  
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

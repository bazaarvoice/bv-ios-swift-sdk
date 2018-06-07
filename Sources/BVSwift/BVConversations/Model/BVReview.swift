//
//  BVReview.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVReview type
/// - Note:
/// \
/// It conforms to BVQueryable and BVSubmissionable, therefore, it is used for
/// both BVQuery and BVSubmission.
public struct BVReview: BVQueryable, BVSubmissionable {
  
  public static var singularKey: String {
    get {
      return BVConversationsConstants.BVReviews.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVConversationsConstants.BVReviews.pluralKey
    }
  }
  
  public private(set) var comments: [BVComment]? = nil
  public private(set) var products: [BVProduct]? = nil
  
  public var additionalFields: Decoder? {
    get {
      return additionalFieldsDecoder?.decoder
    }
  }
  private let additionalFieldsDecoder: BVCodableRawDecoder?
  public let authorId: String?
  public var badges: [BVBadge]? {
    get {
      return badgesArray?.array
    }
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  public let campaignId: String?
  public var clientResponses: Decoder? {
    get {
      return clientResponsesDecoder?.decoder
    }
  }
  private let clientResponsesDecoder: BVCodableRawDecoder?
  public let commentIds: [String]?
  public let cons: String?
  public let contentLocale: String?
  public var contextDataValues: [BVContextDataValue]? {
    get {
      return contextDataValuesArray?.array
    }
  }
  private let contextDataValuesArray:
  BVCodableDictionary<BVContextDataValue>?
  public let helpfulness: Double?
  public let isFeatured: Bool?
  public let isRatingsOnly: Bool?
  public let isRecommended: Bool?
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
  public let moderationStatus: String?
  public let photos: [BVPhoto]?
  public let productId: String?
  public let productRecommendationIds: [String]?
  public let pros: String?
  public let rating: Int?
  public let ratingRange: Int?
  public let reviewId: String?
  public let reviewText: String?
  public var secondaryRatings: [BVSecondaryRating]? {
    get {
      return secondaryRatingsArray?.array
    }
  }
  private let secondaryRatingsArray:
  BVCodableDictionary<BVSecondaryRating>?
  public let submissionId: String?
  public var submissionTime: Date? {
    get {
      return submissionTimeString?.toBVDate()
    }
  }
  private let submissionTimeString: String?
  public let syndicationSource: BVSyndicationSource?
  public var tagDimensions: [BVDimensionElement]? {
    get {
      return tagDimensionsArray?.array
    }
  }
  private let tagDimensionsArray:
  BVCodableDictionary<BVDimensionElement>?
  public let title: String?
  public let totalCommentCount: Int?
  public let totalFeedbackCount: Int?
  public let totalNegativeFeedbackCount: Int?
  public let totalPositiveFeedbackCount: Int?
  public let userLocation: String?
  public let userNickname: String?
  public let videos: [BVVideo]?
  
  private enum CodingKeys: String, CodingKey {
    case additionalFieldsDecoder = "AdditionalFields"
    case authorId = "AuthorId"
    case badgesArray = "Badges"
    case campaignId = "CampaignId"
    case clientResponsesDecoder = "ClientResponses"
    case commentIds = "CommentIds"
    case cons = "Cons"
    case contentLocale = "ContentLocale"
    case contextDataValuesArray = "ContextDataValues"
    case helpfulness = "Helpfulness"
    case isFeatured = "IsFeatured"
    case isRatingsOnly = "IsRatingsOnly"
    case isRecommended = "IsRecommended"
    case isSyndicated = "IsSyndicated"
    case lastModeratedTimeString = "LastModeratedTime"
    case lastModificationTimeString = "LastModificationTime"
    case moderationStatus = "ModerationStatus"
    case photos = "Photos"
    case productId = "ProductId"
    case productRecommendationIds = "ProductRecommendationIds"
    case pros = "Pros"
    case rating = "Rating"
    case ratingRange = "RatingRange"
    case reviewId = "Id"
    case reviewText = "ReviewText"
    case secondaryRatingsArray = "SecondaryRatings"
    case submissionId = "SubmissionId"
    case submissionTimeString = "SubmissionTime"
    case syndicationSource = "SyndicationSource"
    case tagDimensionsArray = "TagDimensions"
    case title = "Title"
    case totalCommentCount = "TotalCommentCount"
    case totalFeedbackCount = "TotalFeedbackCount"
    case totalNegativeFeedbackCount = "TotalNegativeFeedbackCount"
    case totalPositiveFeedbackCount = "TotalPositiveFeedbackCount"
    case userLocation = "UserLocation"
    case userNickname = "UserNickname"
    case videos = "Videos"
  }
}

extension BVReview {
  public init(
    productId: String,
    reviewText: String,
    reviewTitle: String,
    reviewRating: Int) {
    self.title = reviewTitle
    self.reviewText = reviewText
    self.rating = reviewRating
    self.productId = productId
    self.comments = nil
    self.products = nil
    self.additionalFieldsDecoder = nil
    self.authorId = nil
    self.badgesArray = nil
    self.campaignId = nil
    self.clientResponsesDecoder = nil
    self.commentIds = nil
    self.cons = nil
    self.contentLocale = nil
    self.contextDataValuesArray = nil
    self.helpfulness = nil
    self.isFeatured = nil
    self.isRatingsOnly = nil
    self.isRecommended = nil
    self.isSyndicated = nil
    self.lastModeratedTimeString = nil
    self.lastModificationTimeString = nil
    self.moderationStatus = nil
    self.photos = nil
    self.productRecommendationIds = nil
    self.pros = nil
    self.ratingRange = nil
    self.reviewId = nil
    self.secondaryRatingsArray = nil
    self.submissionId = nil
    self.submissionTimeString = nil
    self.syndicationSource = nil
    self.tagDimensionsArray = nil
    self.totalCommentCount = nil
    self.totalFeedbackCount = nil
    self.totalNegativeFeedbackCount = nil
    self.totalPositiveFeedbackCount = nil
    self.userLocation = nil
    self.userNickname = nil
    self.videos = nil
  }
}

// MARK: - BVReview: BVCommentIncludable
extension BVReview: BVCommentIncludable { }

// MARK: - BVReview: BVProductIncludeable
extension BVReview: BVProductIncludable { }

// MARK: - BVReview: BVConversationsUpdateIncludable
extension BVReview: BVConversationsUpdateIncludable {
  
  internal mutating
  func updateIncludable(_ includable: BVConversationsIncludable) {
    
    if let comments: [BVComment] = includable.comments {
      self.comments = comments
    }
    if let products: [BVProduct] = includable.products {
      self.products = products
    }
  }
}

extension BVReview: BVQueryableInternal {
  internal static var getResource: String? {
    get {
      return BVConversationsConstants.BVReviews.getResource
    }
  }
}

extension BVReview: BVSubmissionableInternal {
  internal static var postResource: String? {
    get {
      return BVConversationsConstants.BVReviews.postResource
    }
  }
}

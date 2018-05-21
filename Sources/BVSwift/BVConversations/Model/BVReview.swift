//
//  BVReview.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

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
  
  var additionalFields: Decoder? {
    get {
      return additionalFieldsDecoder?.decoder
    }
  }
  private let additionalFieldsDecoder: BVCodableRawDecoder?
  let authorId: String?
  var badges: [BVBadge]? {
    get {
      return badgesArray?.array
    }
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  let campaignId: String?
  var clientResponses: Decoder? {
    get {
      return clientResponsesDecoder?.decoder
    }
  }
  private let clientResponsesDecoder: BVCodableRawDecoder?
  let commentIds: [String]?
  let cons: String?
  let contentLocale: String?
  var contextDataValues: [BVContextDataValue]? {
    get {
      return contextDataValuesArray?.array
    }
  }
  private let contextDataValuesArray:
  BVCodableDictionary<BVContextDataValue>?
  let helpfulness: Double?
  let isFeatured: Bool?
  let isRatingsOnly: Bool?
  let isRecommended: Bool?
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
  let moderationStatus: String?
  let photos: [BVPhoto]?
  let productId: String?
  let productRecommendationIds: [String]?
  let pros: String?
  let rating: Int?
  let ratingRange: Int?
  let reviewId: String?
  let reviewText: String?
  var secondaryRatings: [BVSecondaryRating]? {
    get {
      return secondaryRatingsArray?.array
    }
  }
  private let secondaryRatingsArray:
  BVCodableDictionary<BVSecondaryRating>?
  let submissionId: String?
  var submissionTime: Date? {
    get {
      return submissionTimeString?.toBVDate()
    }
  }
  private let submissionTimeString: String?
  let syndicationSource: BVSyndicationSource?
  var tagDimensions: [BVDimensionElement]? {
    get {
      return tagDimensionsArray?.array
    }
  }
  private let tagDimensionsArray:
  BVCodableDictionary<BVDimensionElement>?
  let title: String?
  let totalCommentCount: Int?
  let totalFeedbackCount: Int?
  let totalNegativeFeedbackCount: Int?
  let totalPositiveFeedbackCount: Int?
  let userLocation: String?
  let userNickname: String?
  let videos: [BVVideo]?
  
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
    reviewTitle: String,
    reviewText: String,
    reviewRating: Int,
    productId: String) {
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
  
  mutating func updateIncludable(_ includable: BVConversationsIncludable) {
    
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
  static var postResource: String? {
    get {
      return BVConversationsConstants.BVReviews.postResource
    }
  }
}

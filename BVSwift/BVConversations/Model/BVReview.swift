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
    return BVConversationsConstants.BVReviews.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVReviews.pluralKey
  }
  
  private var includedComments: [BVComment]?
  private var includedProducts: [BVProduct]?
  private var includedAuthors: [BVAuthor]?
  public var additionalFields: [String: [String: String]]? {
    return additionalFieldsDictionary?.dictionary
  }
  private let additionalFieldsDictionary: BVCodableDictionary<[String: String]>?
  public let authorId: String?
  public var badges: [BVBadge]? {
    return badgesArray?.array
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  public let campaignId: String?
  public var clientResponses: Decoder? {
    return clientResponsesDecoder?.decoder
  }
  private let clientResponsesDecoder: BVCodableRawDecoder?
  public let commentIds: [String]?
  public let cons: String?
  public let contentLocale: String?
  public var contextDataValues: [BVContextDataValue]? {
    return contextDataValuesArray?.array
  }
  private let contextDataValuesArray: BVCodableDictionary<BVContextDataValue>?
  public let helpfulness: Double?
  public let isFeatured: Bool?
  public let isRatingsOnly: Bool?
  public let isRecommended: Bool?
  public let isSyndicated: Bool?
  public var lastModeratedTime: Date? {
    return lastModeratedTimeString?.toBVDate()
  }
  private let lastModeratedTimeString: String?
  public var lastModificationTime: Date? {
    return lastModificationTimeString?.toBVDate()
  }
  private let lastModificationTimeString: String?
  public let sourceClient: String?
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
    return secondaryRatingsArray?.array
  }
  private let secondaryRatingsArray: BVCodableDictionary<BVSecondaryRating>?
  public let submissionId: String?
  public var submissionTime: Date? {
    return submissionTimeString?.toBVDate()
  }
  private let submissionTimeString: String?
  public let syndicationSource: BVSyndicationSource?
  public var tagDimensions: [BVDimensionElement]? {
    return tagDimensionsArray?.array
  }
  private let tagDimensionsArray: BVCodableDictionary<BVDimensionElement>?
  public let title: String?
  public let totalCommentCount: Int?
  public let totalFeedbackCount: Int?
  public let totalNegativeFeedbackCount: Int?
  public let totalPositiveFeedbackCount: Int?
  public let userLocation: String?
  public let userNickname: String?
  public let videos: [BVVideo]?
  
  private enum CodingKeys: String, CodingKey {
    case additionalFieldsDictionary = "AdditionalFields"
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
    case sourceClient = "SourceClient"
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
    self.includedComments = nil
    self.includedProducts = nil
    self.includedAuthors = nil
    self.additionalFieldsDictionary = nil
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
    self.sourceClient = nil
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
    
  public init(productId: String) {
    self.title = nil
    self.reviewText = nil
    self.rating = nil
    self.productId = productId
    self.includedComments = nil
    self.includedProducts = nil
    self.includedAuthors = nil
    self.additionalFieldsDictionary = nil
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
    self.sourceClient = nil
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
extension BVReview: BVCommentIncludable {
  public var comments: [BVComment]? {
    return includedComments
  }
}

// MARK: - BVReview: BVProductIncludeable
extension BVReview: BVProductIncludable {
  public var products: [BVProduct]? {
    return includedProducts
  }
}

extension BVReview: BVAuthorIncludable {
  public var authors: [BVAuthor]? {
    return includedAuthors
  }
}

// MARK: - BVReview: BVConversationsQueryUpdateIncludable
extension BVReview: BVConversationsQueryUpdateIncludable {
  
  internal mutating
  func update(_ includable: BVConversationsQueryIncludable) {
    
    if let comments: [BVComment] = includable.comments {
      self.includedComments = comments
    }
    if let products: [BVProduct] = includable.products {
      self.includedProducts = products
    }
    if let authors: [BVAuthor] = includable.authors {
      self.includedAuthors = authors
    }
  }
}

extension BVReview: BVQueryableInternal {
  internal static var getResource: String? {
    return BVConversationsConstants.BVReviews.getResource
  }
}

extension BVReview: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return BVConversationsConstants.BVReviews.postResource
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}

//
//  BVQuestion.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVQuestion type
/// - Note:
/// \
/// It conforms to BVQueryable and BVSubmissionable, therefore, it is used for
/// both BVQuery and BVSubmission.
public struct BVQuestion: BVQueryable, BVSubmissionable {
  
  public static var singularKey: String {
    get {
      return BVConversationsConstants.BVQuestions.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVConversationsConstants.BVQuestions.pluralKey
    }
  }
  
  public private(set) var answers: [BVAnswer]? = nil
  public private(set) var authors: [BVAuthor]? = nil
  public private(set) var products: [BVProduct]? = nil
  
  public var additionalFields: Decoder? {
    get {
      return additionalFieldsDecoder?.decoder
    }
  }
  private let additionalFieldsDecoder: BVCodableRawDecoder?
  public let answerIds: [String]?
  public let authorId: String?
  public var badges: [BVBadge]? {
    get {
      return badgesArray?.array
    }
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  public let campaignId: String?
  public let categoryId: String?
  public let contentLocale: String?
  public var contextDataValues: [BVContextDataValue]? {
    get {
      return contextDataValuesArray?.array
    }
  }
  private let contextDataValuesArray:
  BVCodableDictionary<BVContextDataValue>?
  public let isFeatured: Bool?
  public let isSyndicated: Bool?
  public let isUserAnonymous: Bool?
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
  public let questionDetails: String?
  public let questionId: String?
  public let questionSummary: String?
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
  public let totalAnswerCount: Int?
  public let totalFeedbackCount: Int?
  public let totalInappropriateFeedbackCount: Int?
  public let totalNegativeFeedbackCount: Int?
  public let totalPositiveFeedbackCount: Int?
  public let userLocation: String?
  public let userNickname: String?
  public let videos: [BVVideo]?
  
  private enum CodingKeys: String, CodingKey {
    case additionalFieldsDecoder = "AdditionalFields"
    case answerIds = "AnswerIds"
    case authorId = "AuthorId"
    case badgesArray = "Badges"
    case campaignId = "CampaignId"
    case categoryId = "CategoryId"
    case contentLocale = "ContentLocale"
    case contextDataValuesArray = "ContextDataValues"
    case isFeatured = "IsFeatured"
    case isSyndicated = "IsSyndicated"
    case isUserAnonymous = "IsUserAnonymous"
    case lastModeratedTimeString = "LastModeratedTime"
    case lastModificationTimeString = "LastModificationTime"
    case moderationStatus = "ModerationStatus"
    case photos = "Photos"
    case productId = "ProductId"
    case productRecommendationIds = "ProductRecommendationIds"
    case questionDetails = "QuestionDetails"
    case questionId = "Id"
    case questionSummary = "QuestionSummary"
    case submissionId = "SubmissionId"
    case submissionTimeString = "SubmissionTime"
    case syndicationSource = "SyndicationSource"
    case tagDimensionsArray = "TagDimensions"
    case totalAnswerCount = "TotalAnswerCount"
    case totalFeedbackCount = "TotalFeedbackCount"
    case totalInappropriateFeedbackCount = "TotalInappropriateFeedbackCount"
    case totalNegativeFeedbackCount = "TotalNegativeFeedbackCount"
    case totalPositiveFeedbackCount = "TotalPositiveFeedbackCount"
    case userLocation = "UserLocation"
    case userNickname = "UserNickname"
    case videos = "Videos"
  }
}

extension BVQuestion {
  public init(
    productId: String,
    questionDetails: String,
    questionSummary: String,
    isUserAnonymous: Bool) {
    self.productId = productId
    self.questionDetails = questionDetails
    self.questionSummary = questionSummary
    self.isUserAnonymous = isUserAnonymous
    self.answers = nil
    self.authors = nil
    self.products = nil
    self.additionalFieldsDecoder = nil
    self.answerIds = nil
    self.authorId = nil
    self.badgesArray = nil
    self.campaignId = nil
    self.categoryId = nil
    self.contentLocale = nil
    self.contextDataValuesArray = nil
    self.isFeatured = nil
    self.isSyndicated = nil
    self.lastModeratedTimeString = nil
    self.lastModificationTimeString = nil
    self.moderationStatus = nil
    self.photos = nil
    self.productRecommendationIds = nil
    self.questionId = nil
    self.submissionId = nil
    self.submissionTimeString = nil
    self.syndicationSource = nil
    self.tagDimensionsArray = nil
    self.totalAnswerCount = nil
    self.totalFeedbackCount = nil
    self.totalInappropriateFeedbackCount = nil
    self.totalNegativeFeedbackCount = nil
    self.totalPositiveFeedbackCount = nil
    self.userLocation = nil
    self.userNickname = nil
    self.videos = nil
  }
}

// MARK: - BVQuestion: BVAnswerIncludable
extension BVQuestion: BVAnswerIncludable { }

// MARK: - BVQuestion: BVAuthorIncludable
extension BVQuestion: BVAuthorIncludable { }

// MARK: - BVQuestion: BVProductIncludable
extension BVQuestion: BVProductIncludable { }

// MARK: - BVQuestion: BVConversationsUpdateIncludable
extension BVQuestion: BVConversationsUpdateIncludable {
  
  internal mutating
  func update(_ includable: BVConversationsIncludable) {
    
    if let answers: [BVAnswer] = includable.answers {
      self.answers = answers
    }
    if let authors: [BVAuthor] = includable.authors {
      self.authors = authors
    }
    if let products: [BVProduct] = includable.products {
      self.products = products
    }
  }
}

extension BVQuestion: BVQueryableInternal {
  internal static var getResource: String? {
    get {
      return BVConversationsConstants.BVQuestions.getResource
    }
  }
}

extension BVQuestion: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    get {
      return BVConversationsConstants.BVQuestions.postResource
    }
  }
  
  internal func update(_ values: [String : Encodable]?) { }
}

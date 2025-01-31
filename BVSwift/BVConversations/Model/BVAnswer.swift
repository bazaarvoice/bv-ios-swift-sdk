//
//  BVAnswer.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVAnswer type
/// - Note:
/// \
/// It conforms to BVQueryable and BVSubmissionable, therefore, it is used for
/// both BVQuery and BVSubmission.
public struct BVAnswer: BVQueryable, BVSubmissionable {
  
  public static var singularKey: String {
    return BVConversationsConstants.BVAnswers.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVAnswers.pluralKey
  }
  
  public var additionalFields: Decoder? {
    return additionalFieldsDecoder?.decoder
  }
  private let additionalFieldsDecoder: BVCodableRawDecoder?
  public let answerId: String?
  public let answerText: String?
  public let authorId: String?
  public var badges: [BVBadge]? {
    return badgesArray?.array
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  public let brandImageLogoURL: BVCodableSafe<URL>?
  public let campaignId: String?
  public let contentLocale: String?
  public var contextDataValues: [BVContextDataValue]? {
    return contextDataValuesArray?.array
  }
  private let contextDataValuesArray: BVCodableDictionary<BVContextDataValue>?
  public let isFeatured: Bool?
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
  public let productRecommendationIds: [String]?
  public let questionId: String?
  public let submissionId: String?
  public var submissionTime: Date? {
    return submissionTimeString?.toBVDate()
  }
  private let submissionTimeString: String?
  public let syndicationSource: BVSyndicationSource?
  public let totalInappropriateFeedbackCount: Int?
  public let totalFeedbackCount: Int?
  public let totalNegativeFeedbackCount: Int?
  public let totalPositiveFeedbackCount: Int?
  public let userLocation: String?
  public let userNickname: String?
  public let videos: [BVVideo]?
  
  private enum CodingKeys: String, CodingKey {
    case additionalFieldsDecoder = "AdditionalFields"
    case answerId = "Id"
    case answerText = "AnswerText"
    case authorId = "AuthorId"
    case badgesArray = "Badges"
    case brandImageLogoURL = "BrandImageLogoURL"
    case campaignId = "CampaignId"
    case contentLocale = "ContentLocale"
    case contextDataValuesArray = "ContextDataValues"
    case isFeatured = "IsFeatured"
    case isSyndicated = "IsSyndicated"
    case lastModeratedTimeString = "LastModeratedTime"
    case lastModificationTimeString = "LastModificationTime"
    case sourceClient = "SourceClient"
    case moderationStatus = "ModerationStatus"
    case photos = "Photos"
    case productRecommendationIds = "ProductRecommendationIds"
    case questionId = "QuestionId"
    case submissionId = "SubmissionId"
    case submissionTimeString = "SubmissionTime"
    case syndicationSource = "SyndicationSource"
    case totalInappropriateFeedbackCount = "TotalInappropriateFeedbackCount"
    case totalFeedbackCount = "TotalFeedbackCount"
    case totalNegativeFeedbackCount = "TotalNegativeFeedbackCount"
    case totalPositiveFeedbackCount = "TotalPositiveFeedbackCount"
    case userLocation = "UserLocation"
    case userNickname = "UserNickname"
    case videos = "Videos"
  }
}

extension BVAnswer {
  public init(questionId: String, answerText: String) {
    self.questionId = questionId
    self.answerText = answerText
    self.additionalFieldsDecoder = nil
    self.answerId = nil
    self.authorId = nil
    self.badgesArray = nil
    self.brandImageLogoURL = nil
    self.campaignId = nil
    self.contentLocale = nil
    self.contextDataValuesArray = nil
    self.isFeatured = nil
    self.isSyndicated = nil
    self.lastModeratedTimeString = nil
    self.sourceClient = nil
    self.lastModificationTimeString = nil
    self.moderationStatus = nil
    self.photos = nil
    self.productRecommendationIds = nil
    self.submissionId = nil
    self.submissionTimeString = nil
    self.syndicationSource = nil
    self.totalInappropriateFeedbackCount = nil
    self.totalFeedbackCount = nil
    self.totalNegativeFeedbackCount = nil
    self.totalPositiveFeedbackCount = nil
    self.userLocation = nil
    self.userNickname = nil
    self.videos = nil
  }
}

extension BVAnswer: BVQueryableInternal {
  internal static var getResource: String? {
    return BVConversationsConstants.BVAnswers.getResource
  }
}

extension BVAnswer: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return BVConversationsConstants.BVAnswers.postResource
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}

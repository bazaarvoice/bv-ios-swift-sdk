//
//  BVAnswer.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVAnswer: BVQueryable, BVSubmissionable {
  
  public static var singularKey: String {
    get {
      return BVConversationsConstants.BVAnswers.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVConversationsConstants.BVAnswers.pluralKey
    }
  }
  
  var additionalFields: Decoder? {
    get {
      return additionalFieldsDecoder?.decoder
    }
  }
  private let additionalFieldsDecoder: BVCodableRawDecoder?
  let answerId: String?
  let answerText: String?
  let authorId: String?
  var badges: [BVBadge]? {
    get {
      return badgesArray?.array
    }
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  let brandImageLogoURL: URL?
  let campaignId: String?
  let contentLocale: String?
  var contextDataValues: [BVContextDataValue]? {
    get {
      return contextDataValuesArray?.array
    }
  }
  private let contextDataValuesArray:
  BVCodableDictionary<BVContextDataValue>?
  let isFeatured: Bool?
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
  let productRecommendationIds: [String]?
  let questionId: String?
  let submissionId: String?
  var submissionTime: Date? {
    get {
      return submissionTimeString?.toBVDate()
    }
  }
  private let submissionTimeString: String?
  let syndicationSource: BVSyndicationSource?
  let totalFeedbackCount: Int?
  let totalNegativeFeedbackCount: Int?
  let totalPositiveFeedbackCount: Int?
  let userLocation: String?
  let userNickname: String?
  let videos: [BVVideo]?
  
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
    case moderationStatus = "ModerationStatus"
    case photos = "Photos"
    case productRecommendationIds = "ProductRecommendationIds"
    case questionId = "QuestionId"
    case submissionId = "SubmissionId"
    case submissionTimeString = "SubmissionTime"
    case syndicationSource = "SyndicationSource"
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
    self.lastModificationTimeString = nil
    self.moderationStatus = nil
    self.photos = nil
    self.productRecommendationIds = nil
    self.submissionId = nil
    self.submissionTimeString = nil
    self.syndicationSource = nil
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
    get {
      return BVConversationsConstants.BVAnswers.getResource
    }
  }
}

extension BVAnswer: BVSubmissionableInternal {
  internal static var postResource: String? {
    get {
      return BVConversationsConstants.BVAnswers.postResource
    }
  }
}

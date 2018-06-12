//
//  BVAuthor.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVAnswer type
/// - Note:
/// \
/// It conforms to BVQueryable and, therefore, it is used only for BVQuery.
public struct BVAuthor: BVQueryable {
  
  public static var singularKey: String {
    get {
      return BVConversationsConstants.BVAuthors.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVConversationsConstants.BVAuthors.pluralKey
    }
  }
  
  public private(set) var answers: [BVAnswer]? = nil
  public private(set) var comments: [BVComment]? = nil
  public private(set) var questions: [BVQuestion]? = nil
  public private(set) var reviews: [BVReview]? = nil
  
  public let authorId: String?
  public var badges: [BVBadge]? {
    get {
      return badgesArray?.array
    }
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  public let contentLocale: String?
  public var contextDataValues: [BVContextDataValue]? {
    get {
      return contextDataValuesArray?.array
    }
  }
  private let contextDataValuesArray:
  BVCodableDictionary<BVContextDataValue>?
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
  public let photos: [BVPhoto]?
  public let qaStatistics: BVQAStatistics?
  public let reviewStatistics: BVReviewStatistics?
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
  public let userLocation: String?
  public let userNickname: String?
  public let videos: [BVVideo]?
  
  private enum CodingKeys: String, CodingKey {
    case authorId = "Id"
    case badgesArray = "Badges"
    case contentLocale = "ContentLocale"
    case contextDataValuesArray = "ContextDataValues"
    case lastModeratedTimeString = "LastModeratedTime"
    case lastModificationTimeString = "LastModificationTime"
    case photos = "Photos"
    case qaStatistics = "QAStatistics"
    case reviewStatistics = "ReviewStatistics"
    case secondaryRatingsArray = "SecondaryRatings"
    case submissionId = "SubmissionId"
    case submissionTimeString = "SubmissionTime"
    case syndicationSource = "SyndicationSource"
    case tagDimensionsArray = "TagDimensions"
    case userLocation = "UserLocation"
    case userNickname = "UserNickname"
    case videos = "Videos"
  }
}

// MARK: - BVAuthor: BVAnswerIncludable
extension BVAuthor: BVAnswerIncludable { }

// MARK: - BVAuthor: BVCommentIncludable
extension BVAuthor: BVCommentIncludable { }

// MARK: - BVAuthor: BVQuestionIncludable
extension BVAuthor: BVQuestionIncludable { }

// MARK: - BVAuthor: BVReviewIncludable
extension BVAuthor: BVReviewIncludable { }

// MARK: - BVAuthor: BVConversationsUpdateIncludable
extension BVAuthor: BVConversationsUpdateIncludable {
  
  internal mutating
  func update(_ includable: BVConversationsIncludable) {
    
    if let answers: [BVAnswer] = includable.answers {
      self.answers = answers
    }
    if let comments: [BVComment] = includable.comments {
      self.comments = comments
    }
    if let questions: [BVQuestion] = includable.questions {
      self.questions = questions
    }
    if let reviews: [BVReview] = includable.reviews {
      self.reviews = reviews
    }
  }
}

// MARK: - BVAuthor: BVQueryableInternal
extension BVAuthor: BVQueryableInternal {
  internal static var getResource: String? {
    get {
      return BVConversationsConstants.BVAuthors.getResource
    }
  }
}

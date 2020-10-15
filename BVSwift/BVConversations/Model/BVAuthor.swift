//
//  BVAuthor.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVAuthor type
/// - Note:
/// \
/// It conforms to BVQueryable and, therefore, it is used only for BVQuery.
public struct BVAuthor: BVQueryable {
  
  public static var singularKey: String {
    return BVConversationsConstants.BVAuthors.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVAuthors.pluralKey
  }
  
  private var includedAnswers: [BVAnswer]?
  private var includedComments: [BVComment]?
  private var includedQuestions: [BVQuestion]?
  private var includedReviews: [BVReview]?
  
  public let authorId: String?
  public var badges: [BVBadge]? {
    return badgesArray?.array
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  public let contentLocale: String?
  public var contextDataValues: [BVContextDataValue]? {
    return contextDataValuesArray?.array
  }
  private let contextDataValuesArray: BVCodableDictionary<BVContextDataValue>?
  public var lastModeratedTime: Date? {
    return lastModeratedTimeString?.toBVDate()
  }
  private let lastModeratedTimeString: String?
  public let sourceClient: String?
  public var lastModificationTime: Date? {
    return lastModificationTimeString?.toBVDate()
  }
  private let lastModificationTimeString: String?
  public let photos: [BVPhoto]?
  public let qaStatistics: BVQAStatistics?
  public let reviewStatistics: BVReviewStatistics?
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
    case sourceClient = "SourceClient"
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
extension BVAuthor: BVAnswerIncludable {
  public var answers: [BVAnswer]? {
    return includedAnswers
  }
}

// MARK: - BVAuthor: BVCommentIncludable
extension BVAuthor: BVCommentIncludable {
  public var comments: [BVComment]? {
    return includedComments
  }
}

// MARK: - BVAuthor: BVQuestionIncludable
extension BVAuthor: BVQuestionIncludable {
  public var questions: [BVQuestion]? {
    return includedQuestions
  }
}

// MARK: - BVAuthor: BVReviewIncludable
extension BVAuthor: BVReviewIncludable {
  public var reviews: [BVReview]? {
    return includedReviews
  }
}

// MARK: - BVAuthor: BVConversationsQueryUpdateIncludable
extension BVAuthor: BVConversationsQueryUpdateIncludable {
  
  internal mutating
  func update(_ includable: BVConversationsQueryIncludable) {
    
    if let answers: [BVAnswer] = includable.answers {
      self.includedAnswers = answers
    }
    if let comments: [BVComment] = includable.comments {
      self.includedComments = comments
    }
    if let questions: [BVQuestion] = includable.questions {
      self.includedQuestions = questions
    }
    if let reviews: [BVReview] = includable.reviews {
      self.includedReviews = reviews
    }
  }
}

// MARK: - BVAuthor: BVQueryableInternal
extension BVAuthor: BVQueryableInternal {
  internal static var getResource: String? {
    return BVConversationsConstants.BVAuthors.getResource
  }
}

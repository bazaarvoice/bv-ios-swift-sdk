//
//  BVAuthor.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

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
  
  let authorId: String?
  var badges: [BVBadge]? {
    get {
      return badgesArray?.array
    }
  }
  private let badgesArray: BVCodableDictionary<BVBadge>?
  let contentLocale: String?
  var contextDataValues: [BVContextDataValue]? {
    get {
      return contextDataValuesArray?.array
    }
  }
  private let contextDataValuesArray:
  BVCodableDictionary<BVContextDataValue>?
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
  let photos: [BVPhoto]?
  let qaStatistics: BVQAStatistics?
  let reviewStatistics: BVReviewStatistics?
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
  let userLocation: String?
  let userNickname: String?
  let videos: [BVVideo]?
  
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
  func updateIncludable(_ includable: BVConversationsIncludable) {
    
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

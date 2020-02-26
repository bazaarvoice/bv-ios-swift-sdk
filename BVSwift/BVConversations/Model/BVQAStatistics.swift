//
//  BVQAStatistics.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVQAStatistics type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVQAStatistics: BVAuxiliaryable {
  public let answerHelpfulVoteCount: Int?
  public let answerNotHelpfulVoteCount: Int?
  public let bestAnswerCount: Int?
  public var contextDataDistribution: [BVDistributionElement]? {
    return contextDataDistributionArray?.array
  }
  private let contextDataDistributionArray: BVCodableDictionary<BVDistributionElement>?
  public let featuredAnswerCount: Int?
  public let featuredQuestionCount: Int?
  public var firstAnswerTime: Date? {
    return firstAnswerTimeString?.toBVDate()
  }
  private let firstAnswerTimeString: String?
  public var firstQuestionTime: Date? {
    return firstQuestionTimeString?.toBVDate()
  }
  private let firstQuestionTimeString: String?
  public let helpfulVoteCount: Int?
  public var lastAnswerTime: Date? {
    return lastAnswerTimeString?.toBVDate()
  }
  private let lastAnswerTimeString: String?
  public var lastQuestionAnswerTime: Date? {
    return lastQuestionAnswerTimeString?.toBVDate()
  }
  private let lastQuestionAnswerTimeString: String?
  public var lastQuestionTime: Date? {
    return lastQuestionTimeString?.toBVDate()
  }
  private let lastQuestionTimeString: String?
  public let questionHelpfulVoteCount: Int?
  public let questionNotHelpfulVoteCount: Int?
  public var tagDistribution: [BVDistributionElement]? {
    return tagDistributionArray?.array
  }
  private let tagDistributionArray: BVCodableDictionary<BVDistributionElement>?
  public let totalAnswerCount: Int?
  public let totalQuestionCount: Int?
  
  private enum CodingKeys: String, CodingKey {
    case answerHelpfulVoteCount = "AnswerHelpfulVoteCount"
    case answerNotHelpfulVoteCount = "AnswerNotHelpfulVoteCount"
    case bestAnswerCount = "BestAnswerCount"
    case contextDataDistributionArray = "ContextDataDistribution"
    case featuredAnswerCount = "FeaturedAnswerCount"
    case featuredQuestionCount = "FeaturedQuestionCount"
    case firstAnswerTimeString = "FirstAnswerTime"
    case firstQuestionTimeString = "FirstQuestionTime"
    case helpfulVoteCount = "HelpfulVoteCount"
    case lastAnswerTimeString = "LastAnswerTime"
    case lastQuestionAnswerTimeString = "LastQuestionAnswerTime"
    case lastQuestionTimeString = "LastQuestionTime"
    case questionHelpfulVoteCount = "QuestionHelpfulVoteCount"
    case questionNotHelpfulVoteCount = "QuestionNotHelpfulVoteCount"
    case tagDistributionArray = "TagDistribution"
    case totalAnswerCount = "TotalAnswerCount"
    case totalQuestionCount = "TotalQuestionCount"
  }
}

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
  let answerHelpfulVoteCount: Int?
  let answerNotHelpfulVoteCount: Int?
  let bestAnswerCount: Int?
  var contextDataDistribution: [BVDistributionElement]? {
    get {
      return contextDataDistributionArray?.array
    }
  }
  private let contextDataDistributionArray:
  BVCodableDictionary<BVDistributionElement>?
  let featuredAnswerCount: Int?
  let featuredQuestionCount: Int?
  var firstAnswerTime: Date? {
    get {
      return firstAnswerTimeString?.toBVDate()
    }
  }
  private let firstAnswerTimeString: String?
  var firstQuestionTime: Date? {
    get {
      return firstQuestionTimeString?.toBVDate()
    }
  }
  private let firstQuestionTimeString: String?
  let helpfulVoteCount: Int?
  var lastAnswerTime: Date? {
    get {
      return lastAnswerTimeString?.toBVDate()
    }
  }
  private let lastAnswerTimeString: String?
  var lastQuestionAnswerTime: Date? {
    get {
      return lastQuestionAnswerTimeString?.toBVDate()
    }
  }
  private let lastQuestionAnswerTimeString: String?
  var lastQuestionTime: Date? {
    get {
      return lastQuestionTimeString?.toBVDate()
    }
  }
  private let lastQuestionTimeString: String?
  let questionHelpfulVoteCount: Int?
  let questionNotHelpfulVoteCount: Int?
  var tagDistribution: [BVDistributionElement]? {
    get {
      return contextDataDistributionArray?.array
    }
  }
  private let tagDistributionArray:
  BVCodableDictionary<BVDistributionElement>?
  let totalAnswerCount: Int?
  let totalQuestionCount: Int?
  
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

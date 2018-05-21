//
//
//  BVAnalyticsTypes.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVAnalyticsFeatureType: Encodable {
  case answerQuestion
  case askQuestion
  case contentClick
  case feedback
  case inappropriate
  case inView
  case photo
  case profile
  case reviewComment
  case scrolled
  case writeReview
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .answerQuestion:
      try "Answer".encode(to: encoder)
      break
    case .askQuestion:
      try "Question".encode(to: encoder)
      break
    case .contentClick:
      try "Click".encode(to: encoder)
      break
    case .feedback:
      try "Helpfulness".encode(to: encoder)
      break
    case .inappropriate:
      try "Inappropriate".encode(to: encoder)
      break
    case .inView:
      try "InView".encode(to: encoder)
      break
    case .photo:
      try "Photo".encode(to: encoder)
      break
    case .profile:
      try "Profile".encode(to: encoder)
      break
    case .reviewComment:
      try "Comment".encode(to: encoder)
      break
    case .scrolled:
      try "Scrolled".encode(to: encoder)
      break
    case .writeReview:
      try "Write".encode(to: encoder)
      break
    }
  }
}

public enum BVAnalyticsImpressionType: Encodable {
  case answer
  case comment
  case feedItem
  case productRecommendation
  case question
  case review
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .answer:
      try "Answer".encode(to: encoder)
      break
    case .comment:
      try "Comment".encode(to: encoder)
      break
    case .feedItem:
      try "SocialPost".encode(to: encoder)
      break
    case .productRecommendation:
      try "Recommendation".encode(to: encoder)
      break
    case .question:
      try "Question".encode(to: encoder)
      break
    case .review:
      try "Review".encode(to: encoder)
      break
    }
  }
}

public enum BVAnalyticsProductType: Encodable {
  case curations
  case profile
  case question
  case recommendations
  case reviews
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .curations:
      try "Curations".encode(to: encoder)
      break
    case .profile:
      try "Profiles".encode(to: encoder)
      break
    case .question:
      try "AskAndAnswer".encode(to: encoder)
      break
    case .recommendations:
      try "Curations".encode(to: encoder)
      break
    case .reviews:
      try "Curations".encode(to: encoder)
      break
    }
  }
}

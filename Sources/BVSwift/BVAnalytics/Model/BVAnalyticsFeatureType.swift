//
//
//  BVAnalyticsFeatureType.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The BVAnalyticsFeatureType enum to be used within the
/// BVAnalyticsEvent feature type.
public enum BVAnalyticsFeatureType: Encodable {
  
  /// Type when conversations answer has been generated
  case answerQuestion
  
  /// Type when conversations question has been generated
  case askQuestion
  
  /// Type when content has been clicked on
  case contentClick
  
  /// Type when conversations feedback has been generated
  case feedback
  
  /// Type when conversations inappropriate feedback has been flagged
  case inappropriate
  
  /// Type when consumer-generated content is made visible
  case inView
  
  /// Type when user photo has been uploaded
  case photo
  
  /// Type when user profile has been viewed, edited, etc.
  case profile
  
  /// Type when conversations comment has been generated
  case reviewComment
  
  /// Type when content has scrolled
  case scrolled
  
  /// Type when conversations review has been generated
  case writeReview
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .answerQuestion:
      try "Answer".encode(to: encoder)
    case .askQuestion:
      try "Question".encode(to: encoder)
    case .contentClick:
      try "Click".encode(to: encoder)
    case .feedback:
      try "Helpfulness".encode(to: encoder)
    case .inappropriate:
      try "Inappropriate".encode(to: encoder)
    case .inView:
      try "InView".encode(to: encoder)
    case .photo:
      try "Photo".encode(to: encoder)
    case .profile:
      try "Profile".encode(to: encoder)
    case .reviewComment:
      try "Comment".encode(to: encoder)
    case .scrolled:
      try "Scrolled".encode(to: encoder)
    case .writeReview:
      try "Write".encode(to: encoder)
    }
  }
}

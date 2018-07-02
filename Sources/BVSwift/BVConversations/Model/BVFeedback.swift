//
//
//  BVFeedback.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVFeedback type
/// - Note:
/// \
/// It conforms to BVSubmissionable and, therefore, it is used only for
/// BVSubmission.
public enum BVFeedback: BVSubmissionable {
  
  public static var singularKey: String {
    return BVConversationsConstants.BVFeedback.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVFeedback.pluralKey
  }
  
  case helpfulness(
    vote: Vote,
    authorId: String,
    contentId: String?,
    contentType: ContentType?)
  
  case inappropriate(
    reason: String,
    authorId: String,
    contentId: String?,
    contentType: ContentType?)
  
  internal var urlQueryItems: [URLQueryItem]? {
    switch self {
    case let .helpfulness(
      vote, _, .some(contentId), .some(contentType)):
      return [
        URLQueryItem(name: "contentId", value: contentId.urlEncode()),
        URLQueryItem(name: "contentType", value: contentType.rawValue),
        URLQueryItem(name: "feedbackType", value: "helpfulness"),
        URLQueryItem(name: "vote", value: vote.rawValue)
      ]
    case let .inappropriate(
      reason, _, .some(contentId), .some(contentType)):
      return [
        URLQueryItem(name: "contentId", value: contentId.urlEncode()),
        URLQueryItem(name: "contentType", value: contentType.rawValue),
        URLQueryItem(name: "feedbackType", value: "inappropriate"),
        URLQueryItem(name: "reasonText", value: reason)
      ]
    default:
      return nil
    }
  }
  
  internal var contentId: String? {
    switch self {
    case let .helpfulness(_, _, .some(contentId), _):
      return contentId
    case let .inappropriate(_, _, .some(contentId), _):
      return contentId
    default:
      return nil
    }
  }
  
  internal var contentType: ContentType? {
    switch self {
    case let .helpfulness(_, _, _, .some(contentType)):
      return contentType
    case let .inappropriate(_, _, _, .some(contentType)):
      return contentType
    default:
      return nil
    }
  }
  
  public enum ContentType {
    case answer
    case question
    case review
    
    internal var rawValue: String {
      switch self {
      case .answer:
        return "answer"
      case .question:
        return "question"
      case .review:
        return "review"
      }
    }
  }
  
  public enum Vote {
    case positive
    case negative
    
    internal init?(_ voteString: String) {
      switch voteString.lowercased() {
      case "positive":
        self = .positive
      case "negative":
        self = .negative
      default:
        return nil
      }
    }
    
    internal var rawValue: String {
      switch self {
      case .positive:
        return "positive"
      case .negative:
        return "negative"
      }
    }
  }
  
  private enum CodingKeys: String, CodingKey {
    case inappropriate = "Inappropriate"
    case helpfulness = "Helpfulness"
  }
  
  private enum ContentCodingKeys: String, CodingKey {
    case authorId = "AuthorId"
    case reason = "ReasonText"
    case vote = "Vote"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    if container.contains(.helpfulness) {
      let keyedContainer =
        try container.nestedContainer(
          keyedBy: ContentCodingKeys.self, forKey: .helpfulness)
      
      let authorId: String? =
        try keyedContainer.decodeIfPresent(String.self, forKey: .authorId)
      
      let voteString: String? =
        try keyedContainer.decodeIfPresent(String.self, forKey: .vote)
      
      guard let vote = Vote(voteString ?? "") else {
        throw BVCommonError.unknown("Vote field is of unknown value")
      }
      
      self =
        .helpfulness(
          vote: vote,
          authorId: authorId ?? "",
          contentId: nil,
          contentType: nil)
      return
    }
    
    if container.contains(.inappropriate) {
      let keyedContainer =
        try container.nestedContainer(
          keyedBy: ContentCodingKeys.self, forKey: .inappropriate)
      
      let authorId: String? =
        try keyedContainer.decodeIfPresent(String.self, forKey: .authorId)
      
      let reasonText: String? =
        try keyedContainer.decodeIfPresent(String.self, forKey: .reason)
      
      self =
        .inappropriate(
          reason: reasonText ?? "",
          authorId: authorId ?? "",
          contentId: nil,
          contentType: nil)
      return
    }
    
    throw BVCommonError.unknown("Feedback field is of unknown value")
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    switch self {
    case let .helpfulness(vote, authorId, _, _):
      
      var keyedContainer =
        container.nestedContainer(
          keyedBy: ContentCodingKeys.self, forKey: .helpfulness)
      
      try keyedContainer.encode(authorId, forKey: .authorId)
      try keyedContainer.encode(vote.rawValue, forKey: .vote)
    case let .inappropriate(reason, authorId, _, _):
      var keyedContainer =
        container.nestedContainer(
          keyedBy: ContentCodingKeys.self, forKey: .inappropriate)
      
      try keyedContainer.encode(authorId, forKey: .authorId)
      try keyedContainer.encode(reason, forKey: .reason)
    }
  }
}

extension BVFeedback: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return BVConversationsConstants.BVFeedback.postResource
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}

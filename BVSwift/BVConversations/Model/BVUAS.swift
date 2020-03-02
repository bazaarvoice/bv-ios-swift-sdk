//
//
//  BVUAS.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVUAS type
/// - Note:
/// \
/// It conforms to BVSubmissionable and, therefore, it is used only for
/// BVSubmission.
public struct BVUAS: BVSubmissionable {
  
  public static var singularKey: String {
    return BVConversationsConstants.BVUAS.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVUAS.pluralKey
  }
  
  public let bvAuthToken: String?
  public let uas: String?
  
  private enum CodingKeys: String, CodingKey {
    case uas = "User"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    uas = try container.decodeIfPresent(String.self, forKey: .uas)
    bvAuthToken = nil
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(uas, forKey: .uas)
  }
}

extension BVUAS {
  public init(_ bvAuthToken: String) {
    self.bvAuthToken = bvAuthToken
    self.uas = nil
  }
}

extension BVUAS: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return BVConversationsConstants.BVUAS.postResource
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}

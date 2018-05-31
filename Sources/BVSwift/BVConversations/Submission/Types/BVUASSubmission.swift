//
//
//  BVUASSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVQuestion Submissions
/// - Note:
/// \
/// For more information please see the [Documentation].(https://developer.bazaarvoice.com/conversations-api/tutorials/submission/authentication)
public class BVUASSubmission: BVConversationsSubmission<BVUAS> {
  
  /// The BVAuth Token to submit against
  public var bvAuthToken: String? {
    get {
      guard let uas = submissionable else {
        return nil
      }
      return uas.bvAuthToken
    }
  }
  
  /// The initializer for BVUASSubmission
  /// - Parameters:
  ///   - bvAuthToken: The BVAuth Token to submit against
  public convenience init?(bvAuthToken: String) {
    self.init(BVUAS(bvAuthToken))
  }
  
  /// The initializer for BVUASSubmission
  /// - Parameters:
  ///   - uas: The BVUAS object containing a bvAuthToken to submit against.
  public override init?(_ uas: BVUAS)  {
    guard let bvAuthToken = uas.bvAuthToken else {
      return nil
    }
    super.init(uas)
    
    conversationsParameters ∪= [
      URLQueryItem(name: "authtoken", value: bvAuthToken),
    ]
  }
}

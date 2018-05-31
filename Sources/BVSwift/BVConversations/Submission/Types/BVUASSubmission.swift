//
//
//  BVUASSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVUASSubmission: BVConversationsSubmission<BVUAS> {
  
  public convenience init?(bvAuthToken: String) {
    self.init(BVUAS(bvAuthToken))
  }
  
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

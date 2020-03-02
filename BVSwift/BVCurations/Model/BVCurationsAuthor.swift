//
//
//  BVCurationsAuthor.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsAuthor type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsAuthor: BVAuxiliaryable {
  
  public let alias: String?
  public let avatar: BVCodableSafe<URL>?
  public let channel: String?
  public let profile: String?
  public let token: String?
  public let username: String?
}

public struct BVCurationsAuthorSubmission: BVAuxiliaryable {
  public let identifier: String?
  public let name: String?
  
  private enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case name
  }
  
  init(identifier: String, name: String) {
    self.identifier = identifier
    self.name = name
  }
}

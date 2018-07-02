//
//  BVManagerConversations.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

// MARK: - BVManager: BVConversationsConfiguration
extension BVManager {
  internal static
  var conversationsConfiguration: BVConversationsConfiguration? {
    return BVManager.sharedManager.getConfiguration()
  }
}

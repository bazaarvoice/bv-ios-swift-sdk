//
//  BVManagerConversations.swift
//  BVSwift
//
//  Created by Michael Van Milligan on 5/23/18.
//  Copyright © 2018 Michael Van Milligan. All rights reserved.
//

import Foundation

// MARK: - BVManager: BVConversationsConfiguration
extension BVManager {
  internal static
  var conversationsConfiguration: BVConversationsConfiguration? {
    get {
      return BVManager.sharedManager.getConfiguration()
    }
  }
}

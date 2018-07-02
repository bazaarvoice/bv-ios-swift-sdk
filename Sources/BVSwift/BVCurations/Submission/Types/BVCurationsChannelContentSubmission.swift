//
//
//  BVCurationsChannelContentSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling Curations Channel Content Submissions
/// - Note:
/// \
/// For more information please see the [Documentation](https://developer.bazaarvoice.com/curations-api/reference).
internal class
  BVCurationsChannelContentSubmission:
BVCurationsSubmission<BVCurationsChannelContent> {
  override init?(_ channelContent: BVCurationsChannelContent) {
    super.init(channelContent)
  }
}

//
//
//  BVCurationsCustomContentSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling Curations Custom Content Submissions
/// - Note:
/// \
/// For more information please see the [Documentation](https://developer.bazaarvoice.com/curations-api/reference).
internal class BVCurationsCustomContentSubmission:
BVCurationsSubmission<BVCurationsCustomContent> {
  override init?(_ customContent: BVCurationsCustomContent) {
    super.init(customContent)
  }
}

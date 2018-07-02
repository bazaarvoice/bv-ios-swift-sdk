//
//
//  BVManagerCurationsSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation


/// Protocol defining the gestalt of submission requests. To be used as a
/// vehicle to generate types which are likely generative of all of the
/// submission types.
internal protocol BVCurationsSubmissionGenerator {
  
  /// Generator for BVCurationsChannelContentSubmission
  /// - Parameters:
  ///   - answer: BVCurationsChannelContent object to generate submission for
  func submission(
    _ channelContent: BVCurationsChannelContent) -> BVCurationsChannelContentSubmission?
  
  /// Generator for BVCurationsCustomContentSubmission
  /// - Parameters:
  ///   - answer: BVCurationsCustomContent object to generate submission for
  func submission(
    _ customContent: BVCurationsCustomContent) -> BVCurationsCustomContentSubmission?
}

/// BVManager's conformance to the BVCurationsSubmissionGenerator protocol
/// - Note:
/// \
/// This is a convenience extension to generate already preconfigured
/// submission types. It's also an abstraction layer to allow for easier
/// integration with any future advamcements made in the configuration layer
/// instead of having to manually configure each type.
extension BVManager: BVCurationsSubmissionGenerator {
  func submission(
    _ channelContent: BVCurationsChannelContent) -> BVCurationsChannelContentSubmission? {
    guard let config: BVCurationsConfiguration =
      BVManager.curationsConfiguration else {
        return nil
    }
    return BVCurationsChannelContentSubmission(channelContent)?
      .configure(config)
  }
  
  func submission(
    _ customContent: BVCurationsCustomContent) -> BVCurationsCustomContentSubmission? {
    guard let config: BVCurationsConfiguration =
      BVManager.curationsConfiguration else {
        return nil
    }
    return BVCurationsCustomContentSubmission(customContent)?
      .configure(config)
  }
}

//
//
//  BVFeedbackSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVFeedback Submissions
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/feedback/feedback-submission)
public class BVFeedbackSubmission: BVConversationsSubmission<BVFeedback> {
  
  /// The Feedback to submit against
  public var feedback: BVFeedback? {
    return submissionable
  }
  
  /// The initializer for BVFeedbackSubmission
  /// - Parameters:
  ///   - feedback: The BVFeedback object to submit against.
  public override init?(_ feedback: BVFeedback)  {
    guard let urlQueryItems = feedback.urlQueryItems else {
      return nil
    }
    super.init(feedback)
    
    submissionParameters ∪= urlQueryItems
  }
  
  /// Internal
  override var
  submissionPostflightResultsClosure: (([BVFeedback]?) -> Void)? {
    return { [weak self] (results: [BVFeedback]?) in
      guard nil != results,
        let fb = self?.feedback,
        let contentId = fb.contentId,
        let contentType = fb.contentType else {
          return
      }
      
      guard let productType: BVAnalyticsProductType =
        { () -> BVAnalyticsProductType? in
          
          switch contentType {
          case .answer:
            return .question
          case .review:
            return .reviews
          default:
            return nil
          }
        }() else {
          return
      }
      
      var featureType: BVAnalyticsFeatureType
      var additional: [String: String] =
        ["contentType": contentType.rawValue,
         "contentId": contentId]
      
      switch fb {
      case let .helpfulness(vote, _, _, _):
        featureType = .feedback
        additional += ["detail1": vote.rawValue]
      case .inappropriate:
        featureType = .inappropriate
        additional += ["detail1": "Inappropriate"]
      }
      
      let analyticEvent: BVAnalyticsEvent =
        .feature(
          bvProduct: productType,
          name: featureType,
          productId: contentId,
          brand: nil,
          additional: additional)
      BVPixel.track(
        analyticEvent,
        analyticConfiguration: self?.configuration?.analyticsConfiguration)
    }
  }
}

extension BVFeedbackSubmission: BVConversationsSubmissionUserInformationable {
  @discardableResult
  public func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self {
    
    switch userInfo {
    case .identifier:
      submissionParameters ∪= userInfo.urlQueryItems
    default:
      break
    }
    
    return self
  }
}

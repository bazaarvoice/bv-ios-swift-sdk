//
//
//  BVFeedbackSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVFeedbackSubmission: BVConversationsSubmission<BVFeedback> {
  
  private var feedback: BVFeedback?
  
  public override init?(_ feedback: BVFeedback)  {
    guard let urlQueryItems = feedback.urlQueryItems else {
      return nil
    }
    
    self.feedback = feedback
    super.init(feedback)
    
    conversationsParameters ∪= urlQueryItems
  }
  
  override var conversationsPostflightResultsClosure: (([BVFeedback]?) -> Void)? {
    get {
      return { (results: [BVFeedback]?) in
        guard let _ = results,
          let fb = self.feedback,
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
        var additional: [String : String] =
          ["contentType" : contentType.rawValue,
           "contentId" : contentId]
        
        switch fb {
        case let .helpfulness(vote, _, _, _):
          featureType = .feedback
          additional += ["detail1" : vote.rawValue]
          break
        case .inappropriate:
          featureType = .inappropriate
          additional += ["detail1" : "Inappropriate"]
          break
        }
        
        let analyticEvent: BVAnalyticsEvent =
          .feature(
            bvProduct: productType,
            name: featureType,
            productId: contentId,
            brand: nil,
            additional: additional)
        BVPixel.track(analyticEvent)
      }
    }
  }
}

extension BVFeedbackSubmission: BVConversationsSubmissionUserInformationable {
  @discardableResult
  public func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self {
    
    switch userInfo {
    case .identifier:
      conversationsParameters ∪= userInfo.urlQueryItems
      break
    default:
      break
    }
    
    return self
  }
}

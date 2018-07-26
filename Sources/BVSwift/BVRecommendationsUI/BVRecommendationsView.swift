//
//
//  BVRecommendationsView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

public class BVRecommendationsView: UIView, BVRecommendationsContainer {
  private var hasSentRenderedEvent: Bool = false
  private var hasSentSeenEvent: Bool = false
  
  public var query: BVRecommendationsProfileQuery?
  
  public func load() {
    query?.async()
    
    guard let productId = query?.productId,
      let category = query?.requiredCategory else {
        return
    }
    
    trackContainerTypeViewedEvent(
      .carousel, productId: productId, categoryId: category)
  }
  
  public override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    
    guard nil != newSuperview && !hasSentRenderedEvent else {
      return
    }
    
    hasSentRenderedEvent = true
    trackContainerTypeLoadedEvent(.custom)
  }
  
  public override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    
    guard nil != newWindow && !hasSentSeenEvent else {
      return
    }
  }
}

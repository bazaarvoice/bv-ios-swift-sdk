//
//
//  BVRecommendationsTableView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

public class BVRecommendationsTableView:
UITableView, BVRecommendationsContainer {
  private var delegateProxy: BVProxyObject
  private var datasourceProxy: BVProxyObject
  
  private var hasSentScrollEvent: Bool = false
  private var hasSentRenderedEvent: Bool = false
  private var hasSentSeenEvent: Bool = false
  
  public var query: BVRecommendationsProfileQuery?
  
  public override init(frame: CGRect, style: UITableViewStyle) {
    let dummyObject = BVProxyObject(NSObject())
    delegateProxy = dummyObject
    datasourceProxy = dummyObject
    super.init(frame: frame, style: style)
    delegateProxy = BVProxyObject(self)
    datasourceProxy = BVProxyObject(self)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    let dummyObject = BVProxyObject(NSObject())
    delegateProxy = dummyObject
    datasourceProxy = dummyObject
    super.init(coder: aDecoder)
    delegateProxy = BVProxyObject(self)
    datasourceProxy = BVProxyObject(self)
  }
  
  public func load() {
    query?.async()
    
    guard let productId = query?.productId,
      let category = query?.requiredCategory else {
        return
    }
    
    trackContainerTypeViewedEvent(
      .carousel, productId: productId, categoryId: category)
  }
}

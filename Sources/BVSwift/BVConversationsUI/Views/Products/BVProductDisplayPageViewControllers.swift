//
//
//  BVProductDisplayPageViewControllers.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

@objc
open class BVProductDisplayPageViewController: UIViewController {
  public var product: BVProduct?
  private var hasSentPageviewEvent: Bool = false
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let productId = product?.productId,
      !hasSentPageviewEvent {
      
      hasSentPageviewEvent = true
      
      let pageViewEvent: BVAnalyticsEvent =
        .pageView(
          bvProduct: .reviews,
          productId: productId,
          brand: product?.brand?.name,
          categoryId: product?.categoryId,
          rootCategoryId: nil,
          additional: nil)
      BVPixel.track(pageViewEvent)
    }
  }
}

@objc
open class BVProductDisplayPageTableViewController: UITableViewController {
  public var product: BVProduct?
  private var hasSentPageviewEvent: Bool = false
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let productId = product?.productId,
      !hasSentPageviewEvent {
      
      hasSentPageviewEvent = true
      
      let pageViewEvent: BVAnalyticsEvent =
        .pageView(
          bvProduct: .reviews,
          productId: productId,
          brand: product?.brand?.name,
          categoryId: product?.categoryId,
          rootCategoryId: nil,
          additional: nil)
      BVPixel.track(pageViewEvent)
    }
  }
}

@objc
open class
BVProductDisplayPageCollectionViewController: UICollectionViewController {
  public var product: BVProduct?
  private var hasSentPageviewEvent: Bool = false
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let productId = product?.productId,
      !hasSentPageviewEvent {
      
      hasSentPageviewEvent = true
      
      let pageViewEvent: BVAnalyticsEvent =
        .pageView(
          bvProduct: .reviews,
          productId: productId,
          brand: product?.brand?.name,
          categoryId: product?.categoryId,
          rootCategoryId: nil,
          additional: nil)
      BVPixel.track(pageViewEvent)
    }
  }
}

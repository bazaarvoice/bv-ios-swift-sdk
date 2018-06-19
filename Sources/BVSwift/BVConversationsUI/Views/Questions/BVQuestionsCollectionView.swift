//
//
//  BVQuestionsCollectionView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

@objc
public class BVQuestionsCollectionView: BVConversationsCollectionView {
  
  private var cellToProductMap: [String: BVQuestion] = [:]
  public var productId: String = "none"
  
  internal override var scrollEvent: BVAnalyticsEvent? {
    return .feature(
      bvProduct: .question,
      name: .scrolled,
      productId: productId,
      brand: nil,
      additional: nil)
  }
  
  internal override var wasSeenEvent: BVAnalyticsEvent? {
    return .inView(
      bvProduct: .question,
      component: "QuestionsCollectionView",
      productId: productId,
      brand: nil,
      additional: nil)
  }
  
  // MARK: - UICollectionViewDataSource
  public override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    guard let receiver = dataSourceReceiver else {
      return 0
    }
    return receiver.collectionView(
      collectionView, numberOfItemsInSection: section)
  }
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let receiver = dataSourceReceiver else {
      return BVCollectionViewCell<BVQuestion>()
    }
    
    let cell =
      receiver.collectionView(collectionView, cellForItemAt: indexPath)
    
    if let bvCollectionViewCell: BVCollectionViewCell<BVQuestion> =
      cell as? BVCollectionViewCell<BVQuestion> {
      
      if let bvType: BVQuestion = bvCollectionViewCell.bvType {
        cellToProductMap[indexPath.bvKey] = bvType
      } else {
        let msg: String =
          "BVCollectionViewCell has nil \"bvType\" property. " +
        "This must be set in \"cellForItemAtIndexPath\"."
        BVLogger.sharedLogger.fault(msg)
        assert(false, msg)
      }
    }
    return cell
  }
}

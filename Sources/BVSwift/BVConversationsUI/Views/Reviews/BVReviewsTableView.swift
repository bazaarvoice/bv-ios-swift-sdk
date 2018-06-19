//
//
//  BVReviewsTableView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

@objc
public class BVReviewsTableView: BVConversationsTableView {
  
  private var cellToProductMap: [String: BVReview] = [:]
  public var productId: String = "none"
  
  internal override var scrollEvent: BVAnalyticsEvent? {
    return .feature(
      bvProduct: .reviews,
      name: .scrolled,
      productId: productId,
      brand: nil,
      additional: nil)
  }
  
  internal override var wasSeenEvent: BVAnalyticsEvent? {
    return .inView(
      bvProduct: .reviews,
      component: "ReviewsTableView",
      productId: productId,
      brand: nil,
      additional: nil)
  }
  
  // MARK: - UITableViewDataSource
  public override func tableView(
    _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let receiver = dataSourceReceiver else {
      BVLogger.sharedLogger.error("BVReviewsTableView receiver is nil")
      return 0
    }
    return receiver.tableView(tableView, numberOfRowsInSection: section)
  }
  
  public override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let receiver = dataSource else {
      BVLogger.sharedLogger.error("BVReviewsTableView receiver is nil")
      return BVTableViewCell<BVReview>()
    }
    
    let cell = receiver.tableView(tableView, cellForRowAt: indexPath)
    
    if let bvTableViewCell: BVTableViewCell<BVReview> =
      cell as? BVTableViewCell<BVReview> {
      
      if let bvType: BVReview = bvTableViewCell.bvType {
        cellToProductMap[indexPath.bvKey] = bvType
      } else {
        let msg: String =
          "BVTableViewCell has nil \"bvType\" property. " +
        "This must be set in \"cellForItemAtIndexPath\"."
        BVLogger.sharedLogger.fault(msg)
        assert(false, msg)
      }
    } else {
      let msg: String =
      "BVTableViewCell isn't a validly typed cell class."
      BVLogger.sharedLogger.error(msg)
    }
    return cell
  }
}

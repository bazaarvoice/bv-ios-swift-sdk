//
//
//  BVAnswersTableView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import UIKit

@objc
public class BVAnswersTableView: BVConversationsTableView {
  
  private var cellToProductMap: [String : BVAnswer] = [:]
  
  internal override var scrollEvent: BVAnalyticsEvent? {
    get {
      return .feature(
        bvProduct: .question,
        name: .scrolled,
        productId: "none",
        brand: nil,
        additional: nil)
    }
  }
  
  internal override var wasSeenEvent: BVAnalyticsEvent? {
    get {
      return .inView(
        bvProduct: .question,
        component: "AnswersTableView",
        productId: "none",
        brand: nil,
        additional: nil)
    }
  }
  
  // MARK: - UITableViewDataSource
  public override func tableView(
    _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let receiver = dataSourceReceiver else {
      return 0
    }
    return receiver.tableView(tableView, numberOfRowsInSection: section)
  }
  
  public override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let receiver = dataSource else {
      return BVTableViewCell<BVAnswer>()
    }
    
    let cell = receiver.tableView(tableView, cellForRowAt: indexPath)
    
    if let bvTableViewCell: BVTableViewCell<BVAnswer> =
      cell as? BVTableViewCell<BVAnswer> {
      
      if let bvType: BVAnswer = bvTableViewCell.bvType {
        cellToProductMap[indexPath.bvKey] = bvType
      } else {
        let msg: String =
          "BVTableViewCell has nil \"bvType\" property. " +
        "This must be set in \"cellForItemAtIndexPath\"."
        BVLogger.sharedLogger.fault(msg)
        assert(false, msg)
      }
    }
    return cell
  }
}

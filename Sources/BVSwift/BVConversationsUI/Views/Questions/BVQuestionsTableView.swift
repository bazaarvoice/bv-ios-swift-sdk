//
//
//  BVQuestionsTableView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

@objc
public class BVQuestionsTableView: BVConversationsTableView {
  
  private var cellToProductMap: [String : BVQuestion] = [:]
  public var productId: String = "none"
  
  internal override var scrollEvent: BVAnalyticsEvent? {
    get {
      return .feature(
        bvProduct: .question,
        name: .scrolled,
        productId: productId,
        brand: nil,
        additional: nil)
    }
  }
  
  internal override var wasSeenEvent: BVAnalyticsEvent? {
    get {
      return .inView(
        bvProduct: .question,
        component: "QuestionsTableView",
        productId: productId,
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
      return BVTableViewCell<BVQuestion>()
    }
    
    let cell = receiver.tableView(tableView, cellForRowAt: indexPath)
    
    if let bvTableViewCell: BVTableViewCell<BVQuestion> =
      cell as? BVTableViewCell<BVQuestion> {
      
      if let bvType: BVQuestion = bvTableViewCell.bvType {
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

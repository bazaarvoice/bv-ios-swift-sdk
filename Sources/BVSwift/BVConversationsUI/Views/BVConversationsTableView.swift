//
//
//  BVConversationsTableView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import UIKit

/// public class BVConversationsTableView<BVType: BVQueryable>:
/// UITableView, UITableViewDataSource, UITableViewDelegate {

@objc
public class BVConversationsTableView:
UITableView, UITableViewDataSource, UITableViewDelegate {

  /// private var cellToProductMap: [String : BVType] = [:]
  private var hasEnteredView: Bool = false
  private var hasSentScrollEvent: Bool = false
  private var delegateProxy: BVProxyObject?
  private var datasourceProxy: BVProxyObject?

  private func initialize() {
    delegateProxy = BVProxyObject(self)
    datasourceProxy = BVProxyObject(self)

    /// This makes sure to set the proxies
    delegate = nil
    dataSource = nil
  }

  internal var dataSourceReceiver: UITableViewDataSource? {
    return dataSource
  }

  internal var scrollEvent: BVAnalyticsEvent? {
    return nil
  }

  internal var wasSeenEvent: BVAnalyticsEvent? {
    return nil
  }

  public final override var dataSource: UITableViewDataSource? {
    get {
      return datasourceProxy?.receiver as? UITableViewDataSource
    }
    set(newValue) {
      datasourceProxy?.receiver = newValue
      super.dataSource = datasourceProxy
    }
  }

  public final override var delegate: UITableViewDelegate? {
    get {
      return delegateProxy?.receiver as? UITableViewDelegate
    }
    set(newValue) {
      delegateProxy?.receiver = newValue
      super.delegate = delegateProxy
    }
  }

  deinit {
    datasourceProxy?.receiver = nil
    delegateProxy?.receiver = nil
  }

  public override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    initialize()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    if let event = wasSeenEvent,
      !hasEnteredView {
      hasEnteredView = true
      BVPixel.track(event)
    }
  }

  // MARK: - UITableViewDataSource
  public func tableView(
    _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    ///    guard let receiver = dataSource else {
    ///      return 0
    ///    }
    ///    return receiver.tableView(tableView, numberOfRowsInSection: section)

    let msg: String =
      "UITableViewDataSource function firing for superclass, " +
    "this is probably something that you don't want happening."
    BVLogger.sharedLogger.error(msg)

    return 0
  }

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    ///    guard let receiver = dataSource else {
    ///      return BVTableViewCell<BVType>()
    ///    }
    ///
    ///    let cell = receiver.tableView(tableView, cellForRowAt: indexPath)
    ///
    ///    if let bvTableViewCell: BVTableViewCell<BVType> =
    ///      cell as? BVTableViewCell<BVType> {
    ///
    ///      if let bvType: BVType = bvTableViewCell.bvType {
    ///        cellToProductMap[indexPath.bvKey] = bvType
    ///      } else {
    ///        let msg: String =
    ///          "BVTableViewCell has nil \"bvType\" property. " +
    ///        "This must be set in \"cellForItemAtIndexPath\"."
    ///        BVLogger.sharedLogger.fault(msg)
    ///        assert(false, msg)
    ///      }
    ///    }
    ///
    ///    return cell

    let msg: String =
      "UITableViewDataSource function firing for superclass, " +
    "this is probably something that you don't want happening."
    BVLogger.sharedLogger.error(msg)

    return UITableViewCell()
  }

  // MARK: - UITableViewDelegate
  public func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let receiver = delegate else {
      return
    }
    receiver.tableView?(tableView, didSelectRowAt: indexPath)
  }

  // MARK: - UITableViewDelegate
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if let receiver = delegate {
      receiver.scrollViewWillBeginDragging?(scrollView)
    }

    if let event = scrollEvent,
      !hasSentScrollEvent {
      hasSentScrollEvent = true
      BVPixel.track(event)
    }
  }

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if let receiver = delegate {
      receiver.scrollViewDidEndDecelerating?(scrollView)
    }

    if let event = scrollEvent {
      BVPixel.track(event)
    }
  }
}

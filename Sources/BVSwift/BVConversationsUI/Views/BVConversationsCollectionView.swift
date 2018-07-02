//
//
//  BVConversationsCollectionView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import UIKit

/// public class BVConversationsCollectionView<BVType: BVQueryable>:
/// UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

@objc
public class BVConversationsCollectionView:
UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

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

  internal var dataSourceReceiver: UICollectionViewDataSource? {
    return dataSource
  }

  internal var scrollEvent: BVAnalyticsEvent? {
    return nil
  }

  internal var wasSeenEvent: BVAnalyticsEvent? {
    return nil
  }

  public final override var dataSource: UICollectionViewDataSource? {
    get {
      return datasourceProxy?.receiver as? UICollectionViewDataSource
    }
    set(newValue) {
      datasourceProxy?.receiver = newValue
      super.dataSource = datasourceProxy
    }
  }

  public final override var delegate: UICollectionViewDelegate? {
    get {
      return delegateProxy?.receiver as? UICollectionViewDelegate
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

  public override init(
    frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
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


  // MARK: - UICollectionViewDataSource
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    ///    guard let receiver = dataSource else {
    ///      return 0
    ///    }
    ///    return receiver.collectionView(
    ///      collectionView, numberOfItemsInSection: section)
    return 0
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    ///    guard let receiver = dataSource else {
    ///      return BVCollectionViewCell<BVType>()
    ///    }
    ///
    ///    let cell =
    ///      receiver.collectionView(collectionView, cellForItemAt: indexPath)
    ///
    ///    if let bvCollectionViewCell: BVCollectionViewCell<BVType> =
    ///      cell as? BVCollectionViewCell<BVType> {
    ///
    ///      if let bvType: BVType = bvCollectionViewCell.bvType {
    ///        cellToProductMap[indexPath.bvKey] = bvType
    ///      } else {
    ///        let msg: String =
    ///          "BVCollectionViewCell has nil \"bvType\" property. " +
    ///        "This must be set in \"cellForItemAtIndexPath\"."
    ///        BVLogger.sharedLogger.fault(msg)
    ///        assert(false, msg)
    ///      }
    ///    }
    ///
    ///    return cell
    return UICollectionViewCell()
  }

  // MARK: - UICollectionViewDelegate
  public final func collectionView(
    _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let receiver = delegate else {
      return
    }
    receiver.collectionView?(collectionView, didSelectItemAt: indexPath)
  }

  // MARK: - UIScrollViewDelegate
  public final func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if let receiver = delegate {
      receiver.scrollViewWillBeginDragging?(scrollView)
    }

    if let event = scrollEvent,
      !hasSentScrollEvent {
      hasSentScrollEvent = true
      BVPixel.track(event)
    }
  }

  public final func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if let receiver = delegate {
      receiver.scrollViewDidEndDecelerating?(scrollView)
    }

    if let event = scrollEvent {
      BVPixel.track(event)
    }
  }
}

//
//
//  BVCurationsCollectionView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

public typealias BVCurationsLoadImageCompletion =
  ((_ image: UIImage?, _ imageURL: URL) -> Swift.Void)

public typealias BVCurationsIsImageCachedCompletion =
  ((_ cached: Bool, _ imageURL: URL) -> Swift.Void)

public protocol BVCurationsUICollectionViewDelegate: class {
  func loadImage(_ imageURL: URL, completion: BVCurationsLoadImageCompletion)
  func cachedImage(
    _ imageURL: URL, completion: BVCurationsIsImageCachedCompletion)
  func didSelectFeedItem(_ feedItem: BVCurationsFeedItem)
  func failedToLoad(_ error: Error)
}

public class BVCurationsCollectionView: UICollectionView,
  UICollectionViewDelegate,
  UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate {
  
  private static let desiredPadding: CGFloat = 3.0
  private static let rowsOffScreenBeforeReload: CGFloat = 2.5
  private static let velocityThreshold: CGFloat = 1000.0
  
  private var feedItemsPriv: [BVCurationsFeedItem] = [BVCurationsFeedItem]()
  private var lastFetchedTimeStamp: Date?
  private var totalHeight: CGFloat = 0.0
  private var pendingUpdate: Bool = false
  private var allItemsFetched: Bool = false
  private var impressedItems: Set<BVCurationsFeedItem> =
    Set<BVCurationsFeedItem>()
  private var oldTimeStamp: Date?
  private var oldBounds: CGFloat = 0.0
  private var shouldRequestImageLoad: Bool = false
  
  public enum UILayout {
    case carousel
    case grid
  }
  
  public weak var feedDelegate: BVCurationsUICollectionViewDelegate?
  public var feedItems: [BVCurationsFeedItem] {
    return feedItemsPriv
  }
  public var fetchSize: UInt = 10
  public var groups: [String]?
  public var infiniteScroll: Bool = true
  public var itemsPerRow: UInt = 2
  public var layout: UILayout = .grid {
    didSet {
      switch (layout, collectionViewLayout) {
      case (.grid, let collectionViewLayout as UICollectionViewFlowLayout):
        collectionViewLayout.scrollDirection = .vertical
      case (.carousel, let collectionViewLayout as UICollectionViewFlowLayout):
        collectionViewLayout.scrollDirection = .horizontal
      default:
        break
      }
      
      updateInfiniteDimensions(
        items: UInt(feedItems.count), rowItems: itemsPerRow)
      reloadData()
    }
  }
  public var productId: String?
  
  private func setup() {
    delegate = self
    dataSource = self
    
    register(
      BVCurationsUICollectionViewCell.self,
      forCellWithReuseIdentifier:
      String(describing: BVCurationsUICollectionViewCell.self))
    
    if let collectionViewLayout =
      self.collectionViewLayout as? UICollectionViewFlowLayout {
      collectionViewLayout.minimumLineSpacing =
        BVCurationsCollectionView.desiredPadding
      collectionViewLayout.minimumInteritemSpacing =
        BVCurationsCollectionView.desiredPadding
    }
  }
  
  private func oneCellDimension(items: UInt) -> CGFloat {
    return layout == .grid ?
      (frame.width / CGFloat(items)) -
        BVCurationsCollectionView.desiredPadding
      : frame.height - BVCurationsCollectionView.desiredPadding
  }
  
  private func updateInfiniteDimensions(items: UInt, rowItems: UInt) {
    totalHeight = totalHeight(items: items, rowItems: rowItems)
  }
  
  private func totalHeight(items: UInt, rowItems: UInt) -> CGFloat {
    let oneCellHeight = oneCellDimension(items: items)
    return
      layout == .grid ?
        oneCellHeight * ceil(CGFloat(feedItems.count) / CGFloat(itemsPerRow))
        :  oneCellHeight * CGFloat(feedItems.count)
  }
  
  public override init(
    frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public func load() {
    if infiniteScroll {
      let oneCellHeight = oneCellDimension(items: itemsPerRow)
      let totalExpected = UInt(feedItems.count) + fetchSize
      let estimatedTotalHeight =
        oneCellHeight * ceil(CGFloat(totalExpected) / CGFloat(itemsPerRow))
      if estimatedTotalHeight < bounds.height {
        let diff = bounds.height - estimatedTotalHeight
        let numRowOffset = UInt(ceil(diff / oneCellHeight))
        fetchSize += (numRowOffset * itemsPerRow)
      }
    }
    
    loadCurationsFeed(limit: fetchSize, lastFetched: lastFetchedTimeStamp)
  }
  
  private func loadCurationsFeed(limit: UInt, lastFetched: Date?) {
    if pendingUpdate || allItemsFetched {
      return
    }
    
    guard let fetchGroups = groups else {
      return
    }
    
    pendingUpdate = true
    let feedItemQuery =
      BVCurationsFeedItemQuery(UInt16(limit))
        .field(.hasPhotoOrVideo(true))
        .field(.groups(fetchGroups))
    
    if let lastFetched = lastFetchedTimeStamp {
      feedItemQuery.field(.before(lastFetched))
    }
    
    if let id = productId {
      feedItemQuery.field(.productId(BVIdentifier.string(id)))
    }
    
    feedItemQuery.handler { [weak self] response in
      
      DispatchQueue.main.async {
        
        self?.pendingUpdate = false
        
        guard case let .success(_, results) = response else {
          
          if case let .failure(errors) = response {
            for err in errors {
              self?.feedDelegate?.failedToLoad(err)
            }
          }
          
          return
        }
        
        if let id = self?.productId {
          let inViewEvent: BVAnalyticsEvent =
            .inView(
              bvProduct: .curations,
              component: String(describing: self),
              productId: id,
              brand: nil,
              additional: nil)
          BVPixel.track(inViewEvent)
        }
        
        self?.allItemsFetched = !results.isEmpty
        self?.lastFetchedTimeStamp = results.last?.timestamp
        results.forEach {
          self?.feedItemsPriv.append($0)
        }
        self?.updateInfiniteDimensions(
          items: UInt(self?.feedItems.count ?? 0),
          rowItems: self?.itemsPerRow ?? 0)
        
        guard results.count > limit else {
          self?.reloadData()
          return
        }
        
        var indexPaths = [IndexPath]()
        let inserted = limit <= results.count ? limit : UInt(results.count)
        for index in 0..<inserted {
          let path =
            IndexPath(
              item: ((self?.feedItems.count ?? 0) - 1 - Int(index)),
              section: 0)
          indexPaths.append(path)
        }
        self?.insertItems(at: indexPaths)
      }
    }
    
    feedItemQuery.async()
  }
  
  // MARK: - UICollectionViewDataSource
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    return feedItems.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell: BVCurationsUICollectionViewCell =
      dequeueReusableCell(
        withReuseIdentifier: String(
          describing: BVCurationsUICollectionViewCell.self),
        for: indexPath) as? BVCurationsUICollectionViewCell
        ?? BVCurationsUICollectionViewCell()
    
    cell.loadImageHandler =
      { (url: URL, completion: BVCurationsLoadImageCompletion) in
        self.feedDelegate?.loadImage(url, completion: completion)
    }
    cell.cachedImageHandler =
      { (url: URL, completion: BVCurationsIsImageCachedCompletion) in
        self.feedDelegate?.cachedImage(url, completion: completion)
    }
    cell.shouldLoadObject = shouldRequestImageLoad
    cell.feedItem = feedItems[indexPath.item]
    
    if let currentFeedItem = cell.feedItem,
      !impressedItems.contains(currentFeedItem) {
      impressedItems.insert(currentFeedItem)
      
      if let productId = currentFeedItem.externalId?.description,
        let contentId = currentFeedItem.contentId?.description,
        let sourceClient = currentFeedItem.sourceClient {
        let impressionEvent: BVAnalyticsEvent =
          .impression(
            bvProduct: .curations,
            contentId: contentId,
            contentType: .feedItem,
            productId: productId,
            brand: nil,
            categoryId: nil,
            additional: ["syndicationSource": sourceClient])
        BVPixel.track(impressionEvent)
      }
    }
    
    return cell
  }
  
  // MARK: - UICollectionViewDelegateFlowLayout
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    let oneCellSize = oneCellDimension(items: itemsPerRow)
    return CGSize(width: oneCellSize, height: oneCellSize)
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int) -> UIEdgeInsets {
    let padding = BVCurationsCollectionView.desiredPadding * 0.5
    return UIEdgeInsets(
      top: padding, left: padding, bottom: padding, right: padding)
  }
  
  // MARK: - UICollectionViewDelegate
  public func collectionView(
    _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    deselectItem(at: indexPath, animated: true)
    
    let currentFeedItem = feedItems[indexPath.item]
    feedDelegate?.didSelectFeedItem(currentFeedItem)
    
    guard let productId = currentFeedItem.externalId else {
      return
    }
    
    let tapEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .curations,
        name: .contentClick,
        productId: productId.description,
        brand: nil,
        additional: nil)
    
    BVPixel.track(tapEvent)
  }
  
  // MARK: - UIScrollViewDelegate
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !infiniteScroll || allItemsFetched {
      return
    }
    
    let timestamp = Date()
    let newBounds =
      layout == .grid ? scrollView.bounds.origin.y :
        scrollView.bounds.origin.x
    let boundsDiff = fabs(oldBounds - newBounds)
    let timeDiff =
      timestamp.timeIntervalSince1970 -
        (oldTimeStamp?.timeIntervalSince1970 ?? 0.0)
    let velocity = boundsDiff / CGFloat(timeDiff)
    oldTimeStamp = timestamp
    oldBounds = newBounds
    
    shouldRequestImageLoad =
      velocity < BVCurationsCollectionView.velocityThreshold
    
    let oneCellHeight = oneCellDimension(items: itemsPerRow)
    let lowerBounds =
      layout == .grid ?
        scrollView.bounds.origin.y + scrollView.bounds.height :
        scrollView.bounds.origin.x + scrollView.bounds.width
    
    let totalHeightWithReloadOffset =
      totalHeight -
        (oneCellHeight * BVCurationsCollectionView.rowsOffScreenBeforeReload)
    if lowerBounds > totalHeightWithReloadOffset {
      loadCurationsFeed(limit: fetchSize, lastFetched: lastFetchedTimeStamp)
    }
  }
  
  public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    if !shouldRequestImageLoad {
      shouldRequestImageLoad = true
    }
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if !shouldRequestImageLoad {
      shouldRequestImageLoad = true
    }
    
    guard let id = productId else {
      return
    }
    
    let scrollEvent: BVAnalyticsEvent =
      .feature(
        bvProduct: .curations,
        name: .scrolled,
        productId: id,
        brand: nil,
        additional: nil)
    
    BVPixel.track(scrollEvent)
  }
}

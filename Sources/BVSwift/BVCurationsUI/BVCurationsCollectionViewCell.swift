//
//
//  BVCurationsCollectionViewCell.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

public class BVCurationsUICollectionViewCell: UICollectionViewCell {
  
  lazy private var socialImageView: UIImageView = {
    let imageView = UIImageView(image: nil)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  lazy private var sourceIconImageView: UIImageView = {
    let imageView = UIImageView(image: nil)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  lazy private var playIconImageView: UIImageView = {
    let imageView = UIImageView(image: nil)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "play")
    imageView.contentMode = .scaleAspectFit
    imageView.isHidden = true
    return imageView
  }()
  
  private var thumbnailURL: URL?
  
  public var feedItem: BVCurationsFeedItem? {
    didSet {
      let scale = UIScreen.main.scale
      let dimension = ceil(scale * frame.height)
      let mediaURL: String? =
        feedItem?.photos?.first?.imageServiceURL?.value?.absoluteString ??
          feedItem?.videos?.first?.imageServiceURL?.value?.absoluteString ??
      nil
      
      if let baseURL = mediaURL {
        thumbnailURL =
          URL(
            string: "\(baseURL)&width=\(dimension)&" +
            "height=\(dimension)&exact=true")
      } else {
        thumbnailURL = nil
      }
      
      if let channel = feedItem?.channel {
        sourceIconImageView.image = UIImage(named: channel)
      } else {
        sourceIconImageView.image = nil
      }
      
      updateUI()
    }
  }
  public var shouldLoadObject: Bool = false
  public var loadImageHandler: (
  (URL, BVCurationsLoadImageCompletion) -> Swift.Void)?
  public var cachedImageHandler: (
  (URL, BVCurationsIsImageCachedCompletion) -> Swift.Void)?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(socialImageView)
    contentView.addSubview(playIconImageView)
    contentView.addSubview(sourceIconImageView)
    
    configureConstraints()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func updateUI() {
    guard let thumbURL = thumbnailURL,
      let cached = cachedImageHandler,
      shouldLoadObject else {
        playIconImageView.isHidden = true
        socialImageView.image = UIImage(named: "placeholder")
        return
    }
    
    cached(thumbURL) { [weak self] (cached: Bool, _: URL) in
      
      guard cached,
        let load = self?.loadImageHandler else {
          self?.socialImageView.image = UIImage(named: "placeholder")
          return
      }
      
      load(thumbURL) { (image: UIImage?, url: URL) in
        guard url == thumbURL else {
          return
        }
        
        DispatchQueue.main.async {
          self?.socialImageView.image =
            (self?.shouldLoadObject ?? false)
            ? image : UIImage(named: "placeholder")
        }
      }
    }
  }
  
  private func configureConstraints() {
    
    /// Social Image View
    let heightSocial =
      NSLayoutConstraint(
        item: socialImageView,
        attribute: .height,
        relatedBy: .equal,
        toItem: contentView,
        attribute: .height,
        multiplier: 1.0,
        constant: 0.0)
    
    let widthSocial =
      NSLayoutConstraint(
        item: socialImageView,
        attribute: .width,
        relatedBy: .equal,
        toItem: contentView,
        attribute: .width,
        multiplier: 1.0,
        constant: 0.0)
    
    let centerXSocial =
      NSLayoutConstraint(
        item: contentView,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: socialImageView,
        attribute: .centerX,
        multiplier: 1.0,
        constant: 0.0)
    
    let centerYSocial =
      NSLayoutConstraint(
        item: contentView,
        attribute: .centerY,
        relatedBy: .equal,
        toItem: socialImageView,
        attribute: .centerY,
        multiplier: 1.0,
        constant: 0.0)
    
    /// Play Icon View
    let heightPlay =
      NSLayoutConstraint(
        item: playIconImageView,
        attribute: .height,
        relatedBy: .lessThanOrEqual,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1.0,
        constant: 45.0)
    
    let widthPlay =
      NSLayoutConstraint(
        item: playIconImageView,
        attribute: .width,
        relatedBy: .equal,
        toItem: playIconImageView,
        attribute: .height,
        multiplier: 1.0,
        constant: 1.0)
    
    let centerXPlay =
      NSLayoutConstraint(
        item: contentView,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: playIconImageView,
        attribute: .centerX,
        multiplier: 1.0,
        constant: 0.0)
    
    let centerYPlay =
      NSLayoutConstraint(
        item: contentView,
        attribute: .centerY,
        relatedBy: .equal,
        toItem: playIconImageView,
        attribute: .centerY,
        multiplier: 1.0,
        constant: 0.0)
    
    let proportionalDimPlay =
      NSLayoutConstraint(
        item: playIconImageView,
        attribute: .height,
        relatedBy: .equal,
        toItem: contentView,
        attribute: .height,
        multiplier: 0.3,
        constant: 1.0)
    proportionalDimPlay.priority = UILayoutPriority(rawValue: 999.0)
    
    /// Source Icon View
    let heightSource =
      NSLayoutConstraint(
        item: sourceIconImageView,
        attribute: .height,
        relatedBy: .lessThanOrEqual,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1.0,
        constant: 30.0)
    
    let widthSource =
      NSLayoutConstraint(
        item: sourceIconImageView,
        attribute: .width,
        relatedBy: .equal,
        toItem: sourceIconImageView,
        attribute: .height,
        multiplier: 1.0,
        constant: 1.0)
    
    let rightSource =
      NSLayoutConstraint(
        item: contentView,
        attribute: .rightMargin,
        relatedBy: .equal,
        toItem: sourceIconImageView,
        attribute: .rightMargin,
        multiplier: 1.0,
        constant: 6.0)
    
    let bottomSource =
      NSLayoutConstraint(
        item: contentView,
        attribute: .bottomMargin,
        relatedBy: .equal,
        toItem: sourceIconImageView,
        attribute: .bottomMargin,
        multiplier: 1.0,
        constant: 6.0)
    
    let proportionalDimSource =
      NSLayoutConstraint(
        item: sourceIconImageView,
        attribute: .height,
        relatedBy: .equal,
        toItem: contentView,
        attribute: .height,
        multiplier: 0.25,
        constant: 1.0)
    proportionalDimSource.priority = UILayoutPriority(rawValue: 999.0)
    
    NSLayoutConstraint.activate(
      [heightSocial,
       widthSocial,
       centerXSocial,
       centerYSocial,
       heightPlay,
       widthPlay,
       centerXPlay,
       centerYPlay,
       proportionalDimPlay,
       heightSource,
       widthSource,
       rightSource,
       bottomSource,
       proportionalDimSource])
  }
}

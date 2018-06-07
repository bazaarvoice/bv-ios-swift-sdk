//
//
//  BVConversationsViews.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

open class BVCollectionViewCell<BVType: BVQueryable>: UICollectionViewCell {
  open var bvType: BVType?
  
  open override func didMoveToSuperview() {
    super.didMoveToSuperview()
    bvGestureRecognizerCheck()
  }
}

open class BVTableViewCell<BVType: BVQueryable>: UITableViewCell {
  open var bvType: BVType?
  
  open override func didMoveToSuperview() {
    super.didMoveToSuperview()
    bvGestureRecognizerCheck()
  }
}

open class BVView<BVType: BVQueryable>: UIView {
  open var bvType: BVAnswer?
  
  open override func didMoveToSuperview() {
    super.didMoveToSuperview()
    bvGestureRecognizerCheck()
  }
}

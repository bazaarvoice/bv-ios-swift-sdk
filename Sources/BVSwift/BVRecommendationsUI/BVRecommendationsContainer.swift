//
//
//  BVRecommendationsContainer.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

public protocol BVRecommendationsContainer: class {
  var query: BVRecommendationsProfileQuery? { get set }
  func load()
}

public protocol BVRecommendationsProductContainer: class {
  var product: BVRecommendationsProduct? { get set }
}

//
//
//  BVRecommendationsAnalytics.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

internal struct BVRecommendationsAnalytics {
  internal static let productName: String = "Personalization"
  
  internal static var mainParameters: [String: BVAnyEncodable] {
    
    return ["type": BVAnyEncodable("Recommendation"),
            "source": BVAnyEncodable("recommendation-mob")]
  }
  
  internal static var featureParameters: [String: BVAnyEncodable] {
    
    return ["source": BVAnyEncodable("recommendation-mob")]
  }
  
  internal static var pageViewParameters: [String: BVAnyEncodable] {
    
    return ["type": BVAnyEncodable("Embedded"),
            "source": BVAnyEncodable("recommendation-mob")]
  }
  
  internal static func analyticInfo(
    _ product: BVRecommendationsProduct,
    visible: Bool = true) -> [String: BVAnyEncodable] {
    
    guard let id = product.productId,
      let sponsored = product.sponsored else {
        return [:]
    }
    
    var dict: [String: BVAnyEncodable] = [:]
    
    if let stats = product.stats {
      dict = BVRecommendationsStats.CodingKeys.all.reduce([:])
      { (result: [String: BVAnyEncodable],
        key: BVRecommendationsStats.CodingKeys) -> [String: BVAnyEncodable] in
        var statDict = result
        statDict[key.rawValue] = BVAnyEncodable(stats[key] ?? 0)
        return result
      }
    }
    
    dict["RS"] = BVAnyEncodable(product.RS ?? BVNil())
    dict["productId"] = BVAnyEncodable(id)
    dict["sponsored"] = BVAnyEncodable(sponsored ? "true" : "false")
    dict["visible"] = BVAnyEncodable(visible ? "true" : "false")
    
    return dict
  }
}

public enum BVRecommendationsContainerType {
  case carousel
  case custom
  case tableView
  
  internal var analyticsField: [String: BVAnyEncodable] {
    switch self {
    case .carousel:
      return ["component": analyticsValue]
    case .tableView:
      return ["component": analyticsValue]
    case .custom:
      return ["component": analyticsValue]
    }
  }
  
  internal var analyticsValue: BVAnyEncodable {
    switch self {
    case .carousel:
      return BVAnyEncodable("carousel")
    case .tableView:
      return BVAnyEncodable("tableview")
    case .custom:
      return BVAnyEncodable("custom")
    }
  }
}

extension CALayerDelegate {
  public func trackViewedEvent(_ product: BVRecommendationsProduct) {
    
    guard let productId = product.productId,
      let configuration: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        return
    }
    
    let common = BVRecommendationsAnalytics.analyticInfo(product)
    let overrides = BVRecommendationsAnalytics.mainParameters + common
    
    let event: BVAnalyticsEvent =
      .impression(
        bvProduct: .recommendations,
        contentId: productId,
        contentType: .productRecommendation,
        productId: productId,
        brand: nil,
        categoryId: nil,
        additional: nil)
    
    BVAnalyticsManager.sharedManager.enqueue(
      analyticsEventable: event,
      configuration: configuration,
      anonymous: false,
      overrides: overrides)
  }
  
  public func trackTappedEvent(_ product: BVRecommendationsProduct) {
    guard let productId = product.productId,
      let configuration: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        return
    }
    
    let common = BVRecommendationsAnalytics.analyticInfo(product)
    let overrides =
      BVRecommendationsAnalytics.featureParameters + common +
        ["name": BVAnyEncodable("ContentClick")]
    
    let event: BVAnalyticsEvent =
      .feature(
        bvProduct: .recommendations,
        name: .contentClick,
        productId: productId,
        brand: nil,
        additional: nil)
    
    BVAnalyticsManager.sharedManager.enqueue(
      analyticsEventable: event,
      configuration: configuration,
      anonymous: false,
      overrides: overrides)
  }
  
  public func trackContainerTypeLoadedEvent(
    _ containerType: BVRecommendationsContainerType) {
    guard let configuration: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        return
    }
    
    let overrides =
      BVRecommendationsAnalytics.featureParameters +
        containerType.analyticsField +
        ["name": BVAnyEncodable("InView"),
         "productId": BVAnyEncodable(BVNil())]
    
    let event: BVAnalyticsEvent =
      .feature(
        bvProduct: .recommendations,
        name: .inView,
        productId: "will be overriden",
        brand: nil,
        additional: nil)
    
    BVAnalyticsManager.sharedManager.enqueue(
      analyticsEventable: event,
      configuration: configuration,
      anonymous: false,
      overrides: overrides)
  }
  
  public func trackContainerTypeViewedEvent(
    _ containerType: BVRecommendationsContainerType,
    product: BVRecommendationsProduct,
    categoryId: String? = nil) {
    guard let productId = product.productId,
      let configuration: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        return
    }
    
    let pageType = type(of: self)
    
    let overrides =
      BVRecommendationsAnalytics.pageViewParameters +
        ["reportingGroup": containerType.analyticsValue,
         "pageType": BVAnyEncodable("\(pageType)")]
    
    let event: BVAnalyticsEvent =
      .pageView(
        bvProduct: .recommendations,
        productId: productId,
        brand: nil,
        categoryId: categoryId,
        rootCategoryId: nil,
        additional: nil)
    
    BVAnalyticsManager.sharedManager.enqueue(
      analyticsEventable: event,
      configuration: configuration,
      anonymous: false,
      overrides: overrides)
  }
}

extension UIScrollViewDelegate {
  public func trackScrollEvent(_ containerType: BVRecommendationsContainerType) {
    guard let configuration: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        return
    }
    
    let overrides =
      BVRecommendationsAnalytics.featureParameters +
        containerType.analyticsField +
        ["name": BVAnyEncodable("Scrolled"),
         "productId": BVAnyEncodable(BVNil())]
    
    let event: BVAnalyticsEvent =
      .feature(
        bvProduct: .recommendations,
        name: .scrolled,
        productId: "will be overriden",
        brand: nil,
        additional: nil)
    
    BVAnalyticsManager.sharedManager.enqueue(
      analyticsEventable: event,
      configuration: configuration,
      anonymous: false,
      overrides: overrides)
  }
}

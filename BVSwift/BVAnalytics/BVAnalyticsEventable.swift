//
//
//  BVAnalyticsEventEventable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent: BVAnalyticsEventable {
  
  internal mutating func augment(_ additional: [String: BVAnyEncodable]?) {
    
    guard let add = additional else {
      return
    }
    
    let new = BVAnalyticsEvent.stringifyAndTypeErase(add)
    
    switch self {
      
    case let .conversion(type, value, label, old):
      self =
        .conversion(
          type: type, value: value, label: label, additional: new + old)
    case let .feature(bvProduct, name, productId, brand, old):
      self =
        .feature(
          bvProduct: bvProduct,
          name: name,
          productId: productId,
          brand: brand,
          additional: new + old)
    case let .impression(
      bvProduct, contentId, contentType, productId, brand, categoryId, old):
      self =
        .impression(
          bvProduct: bvProduct,
          contentId: contentId,
          contentType: contentType,
          productId: productId,
          brand: brand,
          categoryId: categoryId,
          additional: new + old)
    case let .inView(bvProduct, component, productId, brand, old):
      self =
        .inView(
          bvProduct: bvProduct,
          component: component,
          productId: productId,
          brand: brand,
          additional: new + old)
    case let .pageView(
      bvProduct, productId, brand, categoryId, rootCategoryId, old):
      self =
        .pageView(
          bvProduct: bvProduct,
          productId: productId,
          brand: brand,
          categoryId: categoryId,
          rootCategoryId: rootCategoryId,
          additional: new + old)
    case let .transaction(
      items,
      orderId,
      total,
      city,
      country,
      currency,
      shipping,
      state,
      tax,
      old):
      self = .transaction(
        items: items,
        orderId: orderId,
        total: total,
        city: city,
        country: country,
        currency: currency,
        shipping: shipping,
        state: state,
        tax: tax,
        additional: new + old)
    case let .viewed(
      bvProduct, productId, brand, categoryId, rootCategoryId, old):
      self = .viewed(
        bvProduct: bvProduct,
        productId: productId,
        brand: brand,
        categoryId: categoryId,
        rootCategoryId: rootCategoryId,
        additional: new + old)
    default:
      break
    }
  }
  
  internal func serialize(_ anonymous: Bool) -> [String: BVAnyEncodable] {
    switch self {
    case .conversion:
      return serializeConversion(anonymous)
    case .feature:
      return serializeFeature(anonymous)
    case .impression:
      return serializeImpression(anonymous)
    case .inView:
      return serializeInView(anonymous)
    case .pageView:
      return serializePageView(anonymous)
    case .personalization:
      return serializePersonalization(anonymous)
    case .transaction:
      return serializeTransaction(anonymous)
    case .viewed:
      return serializeViewed(anonymous)
    }
  }
}

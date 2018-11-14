//
//
//  BVAnalyticsTransactionItem.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The BVAnalyticsTransactionItem struct to be used within the
/// BVAnalyticsEvent transaction type.
public struct BVAnalyticsTransactionItem: Codable {
  let category: String
  let imageURL: BVCodableSafe<URL>?
  let name: String?
  let price: Double
  let quantity: Int
  let sku: String
  
  private enum CodingKeys: String, CodingKey {
    case category = "category"
    case imageURL = "imageUrl"
    case name = "name"
    case price = "price"
    case quantity = "quantity"
    case sku = "sku"
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(category, forKey: .category)
    try container.encodeIfPresent(imageURL, forKey: .imageURL)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encode(String(format: "%0.2f", price), forKey: .price)
    try container.encode(String(format: "%ld", quantity), forKey: .quantity)
    try container.encode(sku, forKey: .sku)
  }
}

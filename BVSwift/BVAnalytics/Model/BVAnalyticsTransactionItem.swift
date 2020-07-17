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
    public let category: String
    public let imageURL: BVCodableSafe<URL>?
    public let name: String?
    public let price: Double
    public let quantity: Int
    public  let sku: String
    
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
    
    //To make accessable from the Cocopods
    public init(category: String, imageURL: BVCodableSafe<URL>?, name: String, price: Double, quantity: Int, sku: String) {
        self.category = category
        self.imageURL = imageURL
        self.name = name
        self.price = price
        self.quantity = quantity
        self.sku = sku
    }
}

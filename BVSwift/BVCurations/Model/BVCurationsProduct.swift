//
//
//  BVCurationsProduct.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsProduct type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsProduct: BVAuxiliaryable {
  
  public var attributes: [BVCurationsProductAttribute]? {
    return attributesDictionary?.array
  }
  private let attributesDictionary: BVCodableDictionary<BVCurationsProductAttribute>?
  public let brand: BVCurationsBrand?
  public let brandExternalId: String?
  public let categoryId: String?
  public let eans: [String]?
  public let familyIds: [String]?
  public let filteredQAStatistics: BVCurationsQAStatistics?
  public let filteredReviewStatistics: BVCurationsReviewStatistics?
  public let imageUrl: BVCodableSafe<URL>?
  public let isbns: [String]?
  public let manufacturerPartNumbers: [String]?
  public let modelNumbers: [String]?
  public let name: String?
  public let productDescription: String?
  public let productId: String?
  public let productPageUrl: BVCodableSafe<URL>?
  public let qaStatistics: BVCurationsQAStatistics?
  public let reviewStatistics: BVCurationsReviewStatistics?
  public let upcs: [String]?
  
  private enum CodingKeys: String, CodingKey {
    case attributesDictionary = "Attributes"
    case brand = "Brand"
    case brandExternalId = "BrandExternalId"
    case categoryId = "CategoryId"
    case eans = "EANs"
    case familyIds = "FamilyIds"
    case filteredQAStatistics = "FilteredQAStatistics"
    case filteredReviewStatistics = "FilteredReviewStatistics"
    case imageUrl = "ImageUrl"
    case isbns = "ISBNs"
    case manufacturerPartNumbers = "ManufacturerPartNumbers"
    case modelNumbers = "ModelNumbers"
    case name = "Name"
    case productDescription = "Description"
    case productId = "Id"
    case productPageUrl = "ProductPageUrltidal"
    case qaStatistics = "QAStatistics"
    case reviewStatistics = "ReviewStatistics"
    case upcs = "UPCs"
  }
}

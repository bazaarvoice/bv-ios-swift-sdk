//
//  BVProduct.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVProduct type
/// - Note:
/// \
/// It conforms to BVQueryable and, therefore, it is used only for BVQuery.
public struct BVProduct: BVQueryable {
  
  public static var singularKey: String {
    get {
      return BVConversationsConstants.BVProducts.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVConversationsConstants.BVProducts.pluralKey
    }
  }
  
  public private(set) var answers: [BVAnswer]? = nil
  public private(set) var authors: [BVAuthor]? = nil
  public private(set) var comments: [BVComment]? = nil
  public private(set) var questions: [BVQuestion]? = nil
  public private(set) var reviews: [BVReview]? = nil
  
  var attributes: Decoder? {
    get {
      return attributesDecoder?.decoder
    }
  }
  private let attributesDecoder: BVCodableRawDecoder?
  let brand: BVBrand?
  let brandExternalId: String?
  let categoryId: String?
  let eans: [String]?
  let familyIds: [String]?
  let filteredQAStatistics: BVReviewStatistics?
  let filteredReviewStatistics: BVReviewStatistics?
  let imageUrl: URL?
  let isbns: [String]?
  let manufacturerPartNumbers: [String]?
  let modelNumbers: [String]?
  let name: String?
  let productDescription: String?
  let productId: String?
  let productPageUrl: URL?
  let qaStatistics: BVQAStatistics?
  let reviewStatistics: BVReviewStatistics?
  let upcs: [String]?
  
  private enum CodingKeys: String, CodingKey {
    case attributesDecoder = "Attributes"
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

// MARK: - BVProduct: BVAnswerIncludable
extension BVProduct: BVAnswerIncludable { }

// MARK: - BVProduct: BVAuthorIncludable
extension BVProduct: BVAuthorIncludable { }

// MARK: - BVProduct: BVCommentIncludable
extension BVProduct: BVCommentIncludable { }

// MARK: - BVProduct: BVQuestionIncludable
extension BVProduct: BVQuestionIncludable { }

// MARK: - BVProduct: BVReviewIncludable
extension BVProduct: BVReviewIncludable { }

// MARK: - BVProduct: BVConversationsUpdateIncludable
extension BVProduct: BVConversationsUpdateIncludable {
  
  internal mutating
  func updateIncludable(_ includable: BVConversationsIncludable) {
    
    if let answers: [BVAnswer] = includable.answers {
      self.answers = answers
    }
    if let authors: [BVAuthor] = includable.authors {
      self.authors = authors
    }
    if let comments: [BVComment] = includable.comments {
      self.comments = comments
    }
    if let questions: [BVQuestion] = includable.questions {
      self.questions = questions
    }
    if let reviews: [BVReview] = includable.reviews {
      self.reviews = reviews
    }
  }
}

extension BVProduct: BVQueryableInternal {
  internal static var getResource: String? {
    get {
      return BVConversationsConstants.BVProducts.getResource
    }
  }
}

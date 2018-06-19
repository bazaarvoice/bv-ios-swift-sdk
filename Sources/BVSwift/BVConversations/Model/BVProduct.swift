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
    return BVConversationsConstants.BVProducts.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVProducts.pluralKey
  }
  
  private var includedAnswers: [BVAnswer]?
  private var includedAuthors: [BVAuthor]?
  private var includedComments: [BVComment]?
  private var includedQuestions: [BVQuestion]?
  private var includedReviews: [BVReview]?
  
  public var attributes: [BVProductAttribute]? {
    return attributesDictionary?.array
  }
  private let attributesDictionary: BVCodableDictionary<BVProductAttribute>?
  public let brand: BVBrand?
  public let brandExternalId: String?
  public let categoryId: String?
  public let eans: [String]?
  public let familyIds: [String]?
  public let filteredQAStatistics: BVQAStatistics?
  public let filteredReviewStatistics: BVReviewStatistics?
  public let imageUrl: BVCodableSafe<URL>?
  public let isbns: [String]?
  public let manufacturerPartNumbers: [String]?
  public let modelNumbers: [String]?
  public let name: String?
  public let productDescription: String?
  public let productId: String?
  public let productPageUrl: BVCodableSafe<URL>?
  public let qaStatistics: BVQAStatistics?
  public let reviewStatistics: BVReviewStatistics?
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

// MARK: - BVProduct: BVAnswerIncludable
extension BVProduct: BVAnswerIncludable {
  public var answers: [BVAnswer]? {
    return includedAnswers
  }
}

// MARK: - BVProduct: BVAuthorIncludable
extension BVProduct: BVAuthorIncludable {
  public var authors: [BVAuthor]? {
    return includedAuthors
  }
}

// MARK: - BVProduct: BVCommentIncludable
extension BVProduct: BVCommentIncludable {
  public var comments: [BVComment]? {
    return includedComments
  }
}

// MARK: - BVProduct: BVQuestionIncludable
extension BVProduct: BVQuestionIncludable {
  public var questions: [BVQuestion]? {
    return includedQuestions
  }
}

// MARK: - BVProduct: BVReviewIncludable
extension BVProduct: BVReviewIncludable {
  public var reviews: [BVReview]? {
    return includedReviews
  }
}

// MARK: - BVProduct: BVConversationsUpdateIncludable
extension BVProduct: BVConversationsUpdateIncludable {
  
  internal mutating
  func update(_ includable: BVConversationsIncludable) {
    
    if let answers: [BVAnswer] = includable.answers {
      self.includedAnswers = answers
    }
    if let authors: [BVAuthor] = includable.authors {
      self.includedAuthors = authors
    }
    if let comments: [BVComment] = includable.comments {
      self.includedComments = comments
    }
    if let questions: [BVQuestion] = includable.questions {
      self.includedQuestions = questions
    }
    if let reviews: [BVReview] = includable.reviews {
      self.includedReviews = reviews
    }
  }
}

extension BVProduct: BVQueryableInternal {
  internal static var getResource: String? {
    return BVConversationsConstants.BVProducts.getResource
  }
}

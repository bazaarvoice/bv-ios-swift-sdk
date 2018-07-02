//
//  BVConversationsQueryResponseInternal.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Protocol defining the meta-data header for queries
public protocol BVConversationsQueryMetaData {

  /// The limit used in the query
  var limit: UInt16? { get }

  /// The locale type of the query
  var locale: String? { get }

  /// The offset used in the query
  var offset: UInt16? { get }

  /// The total returned results of the query
  var totalResults: UInt16? { get }
}

/// Public return type for all BVConversation Queries
/// - Note:
/// \
/// The result type must always be a BVQueryable type.
public enum
BVConversationsQueryResponse<BVType: BVQueryable>: BVURLRequestableResponse {
  public typealias ResponseType = [BVType]
  public typealias MetaType = BVConversationsQueryMetaData

  /// Success state of the query, a.k.a, no errors.
  public var success: Bool {
    guard case .success = self else {
      return false
    }
    return true
  }

  /// Failure case returned errors.
  public var errors: [Error]? {
    guard case let .failure(errors) = self else {
      return nil
    }
    return errors
  }

  case success(MetaType, ResponseType)
  case failure([Error])
}

internal struct BVIncludes: BVConversationsIncludable {
  var answers: [BVAnswer]?
  var authors: [BVAuthor]?
  var comments: [BVComment]?
  var products: [BVProduct]?
  var questions: [BVQuestion]?
  var reviews: [BVReview]?
}

internal struct BVIncludesDictionaries: Codable {
  let answers: BVCodableDictionary<BVAnswer>?
  let authors: BVCodableDictionary<BVAuthor>?
  let comments: BVCodableDictionary<BVComment>?
  let products: BVCodableDictionary<BVProduct>?
  let questions: BVCodableDictionary<BVQuestion>?
  let reviews: BVCodableDictionary<BVReview>?

  private enum CodingKeys: String, CodingKey {
    case answers = "Answers"
    case authors = "Authors"
    case comments = "Comments"
    case products = "Products"
    case questions = "Questions"
    case reviews = "Reviews"
  }
}

internal struct BVConversationsQueryResponseInternal
<BVType: BVQueryable>: Codable, BVConversationsQueryMetaData {
  let errors: [BVConversationsError]?
  let hasErrors: Bool?
  let limit: UInt16?
  let locale: String?
  let offset: UInt16?
  let totalResults: UInt16?
  let results: [BVType]?
  private let includes: BVIncludesDictionaries?

  private enum CodingKeys: String, CodingKey {
    case errors = "Errors"
    case hasErrors = "HasErrors"
    case includes = "Includes"
    case limit = "Limit"
    case locale = "Locale"
    case offset = "Offset"
    case totalResults = "TotalResults"
    case results = "Results"
  }

  private enum IncludeCodingKeys: String, CodingKey {
    case answerId = "AnswerId"
    case answerIds = "AnswerIds"
    case authorId = "AuthorId"
    case authorIds = "AuthorIds"
    case commentId = "CommentId"
    case commentIds = "CommentIds"
    case productId = "ProductId"
    case productIds = "ProductIds"
    case questionId = "QuestionId"
    case questionIds = "QuestionIds"
    case reviewId = "ReviewId"
    case reviewIds = "ReviewIds"
  }

  /// Function to walk include objects by id and in order to make sure that the
  /// returned array preserves the ordering so that we don't have to also
  /// squirrel away the order somewhere else.
  /// - Parameters:
  ///   - container: The decodable container keyed off whatever respective
  ///     object id representation.
  ///   - lookup: BVIncludesDictionaries containing the mappings of ids to
  ///     objects.
  ///   - plural: The plural key is the key representing the potential list of
  ///     objects to be included; list > 1.
  ///   - singular: The singular key is the key representing the potential list
  ///     objects to be included; list <= 1.
  /// - Note:
  /// \
  /// The use of singular and plural keys may be overkill but we're just
  /// protecting against that possibility of having only one singular object as
  /// part of the includes.
  private static func extractInclude<T: BVQueryable, Key>(
    container: KeyedDecodingContainer<Key>,
    lookup: [String: T],
    plural: Key,
    singular: Key) throws -> [T] {

    var extraction: [T] = []
    if let ids: [String] =
      try container
        .decodeIfPresent([String].self, forKey: plural) {
      extraction = ids.compactMap { return lookup[$0] }
    } else if let id: String =
      try container
        .decodeIfPresent(String.self, forKey: singular),
      let object: T = lookup[id] {
      extraction = [object]
    }
    return extraction
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    /// The main suspects...
    errors =
      try container.decodeIfPresent(
        [BVConversationsError].self, forKey: .errors)
    hasErrors = try container.decodeIfPresent(Bool.self, forKey: .hasErrors)
    includes =
      try container.decodeIfPresent(
        BVIncludesDictionaries.self, forKey: .includes)
    limit = try container.decodeIfPresent(UInt16.self, forKey: .limit)
    locale = try container.decodeIfPresent(String.self, forKey: .locale)
    offset = try container.decodeIfPresent(UInt16.self, forKey: .offset)
    totalResults =
      try container.decodeIfPresent(UInt16.self, forKey: .totalResults)

    /// Let's start the main object hydration dance by grabbing a nested
    /// unkeyed container.
    guard var resultsContainer: UnkeyedDecodingContainer =
      try? container.nestedUnkeyedContainer(forKey: .results) else {
        results = nil
        return
    }

    var resultsArray: [BVType] = []

    /// This next line is critical. Apparently decoders (and their child
    /// objects) are copy on write/mutation (probably structs but I don't want
    /// to jump to conclusions) and therefore this allows for us to walk the
    /// same tree twice:
    ///
    /// 1.)  To have the BVQueryable Codable protocol hydrate the object.
    /// 2.)  To have the below code walk the tree to pick out the pertinent
    ///      include objects.
    ///
    /// Otherwise if it were referencing the same buffers we'd deplete the tree
    /// before we got a chance to re-walk the members.
    var includesContainer: UnkeyedDecodingContainer = resultsContainer

    /// This is how much I trust any language...
    var ceiling: Int = resultsContainer.count ?? 0
    ceiling = 0 > ceiling ? 0 : ceiling

    while !resultsContainer.isAtEnd && 0 < ceiling {

      ceiling -= 1

      /// Grab a decoder to toss over to the initializer
      let result: BVType =
        try BVType(from: try resultsContainer.superDecoder())

      /// If we don't have any includes or an object that doesn't follow the
      /// protocol, then what's the point of continuing?
      guard var resultUpdateIncludable: BVConversationsUpdateIncludable =
        result as? BVConversationsUpdateIncludable,
        let resultIncludes: BVIncludesDictionaries = includes else {
          resultsArray.append(result)
          continue
      }

      var internalIncludes: BVIncludes = BVIncludes()

      /// Let us grab each nested container object, i.e., BVQueryable and jump
      /// over their keys that we expose and tear out the included key values
      /// that we're keeping private.
      let includeContainer: KeyedDecodingContainer =
        try includesContainer.nestedContainer(keyedBy: IncludeCodingKeys.self)

      /// We could really do with some preprocessor macros here...
      /// although, I will not apologize for: `type(of: self)`

      /// BVAnswerIncludable
      if let answers: [String: BVAnswer] =
        resultIncludes.answers?.dictionary {
        internalIncludes.answers = try
          type(of: self).extractInclude(
            container: includeContainer,
            lookup: answers,
            plural: .answerIds,
            singular: .answerId)
      }

      /// BVAuthorIncludableInternal
      if let authors: [String: BVAuthor] =
        resultIncludes.authors?.dictionary {
        internalIncludes.authors = try
          type(of: self).extractInclude(
            container: includeContainer,
            lookup: authors,
            plural: .authorIds,
            singular: .authorId)
      }

      /// BVCommentIncludableInternal
      if let comments: [String: BVComment] =
        resultIncludes.comments?.dictionary {
        internalIncludes.comments = try
          type(of: self).extractInclude(
            container: includeContainer,
            lookup: comments,
            plural: .commentIds,
            singular: .commentId)
      }

      /// BVProductIncludableInternal
      if let products: [String: BVProduct] =
        resultIncludes.products?.dictionary {
        internalIncludes.products = try
          type(of: self).extractInclude(
            container: includeContainer,
            lookup: products,
            plural: .productIds,
            singular: .productId)
      }

      /// BVQuestionIncludableInternal
      if let questions: [String: BVQuestion] =
        resultIncludes.questions?.dictionary {
        internalIncludes.questions = try
          type(of: self).extractInclude(
            container: includeContainer,
            lookup: questions,
            plural: .questionIds,
            singular: .questionId)
      }

      /// BVReviewIncludableInternal
      if let reviews: [String: BVReview] =
        resultIncludes.reviews?.dictionary {
        internalIncludes.reviews = try
          type(of: self).extractInclude(
            container: includeContainer,
            lookup: reviews,
            plural: .reviewIds,
            singular: .reviewId)
      }

      resultUpdateIncludable.update(internalIncludes)

      /// This is kind of gross. We're attempting to obfuscate the fact that we
      /// have an internal protocol that we're following. This causes a copy to
      /// happen. However, let's hope the compiler is smart enough to not do
      /// deep copies as nothing changes with respect to the roots, i.e., it
      /// only does delta copies.
      ///
      /// If this becomes a problem in the future we'll just make the protocol
      /// public and include it within the BVQueryable's definition.
      guard let backToQueryableType: BVType =
        resultUpdateIncludable as? BVType else {
          /// Should never ever get here but we'll just add the original result
          /// object
          resultsArray.append(result)
          continue
      }

      resultsArray.append(backToQueryableType)
    }

    results = resultsArray
  }
}

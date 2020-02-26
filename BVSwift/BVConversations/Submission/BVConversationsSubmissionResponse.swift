//
//
//  BVConversationsSubmissionResponse.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for submissions
public protocol BVConversationsSubmissionMetaData {
  
  /// The submission token for the submission
  var authorSubmissionToken: String? { get }
  
  /// Field errors
  var formFieldErrors: [BVFormFieldError]? { get }
  
  /// Fields attached to submission
  /// - Note:
  /// \
  /// Useful for debugging Preview submissions
  var formFields: [BVFormField]? { get }
  
  /// Flag for the existence of errors
  var hasErrors: Bool { get }
  
  /// Locale for the submission
  var locale: String? { get }
  
  /// Identifier for the submission
  var submissionId: String? { get }
  
  /// Typical hours for post to be live
  var typicalHoursToPost: Int? { get }
}

/// Public return type for all BVConversation Submissions
/// - Note:
/// \
/// The result type must always be a BVSubmissionable type.
public enum BVConversationsSubmissionResponse
<BVType: BVSubmissionable>: BVURLRequestableResponse {
  public typealias ResponseType = BVType
  public typealias MetaType = BVConversationsSubmissionMetaData
  
  public var success: Bool {
    guard case .success = self else {
      return false
    }
    return true
  }
  
  public var errors: [Error]? {
    guard case let .failure(errors) = self else {
      return nil
    }
    return errors
  }
  
  case success(MetaType, ResponseType)
  case failure([Error])
}

internal struct BVConversationsSubmissionResponseInternal
<BVType: BVSubmissionable>: Codable, BVConversationsSubmissionMetaData {
  let authorSubmissionToken: String?
  let errors: [BVConversationsError]?
  let formFieldErrors: [BVFormFieldError]?
  let formFields: [BVFormField]?
  let hasErrors: Bool
  let locale: String?
  let result: BVType?
  let submissionId: String?
  let typicalHoursToPost: Int?
  
  private enum CodingKeys: String, CodingKey {
    case authorSubmissionToken = "AuthorSubmissionToken"
    case errors = "Errors"
    case formFieldErrors = "FormErrors"
    case data = "Data"
    case hasErrors = "HasErrors"
    case locale = "Locale"
    case submissionId = "SubmissionId"
    case typicalHoursToPost = "TypicalHoursToPost"
  }
  
  private enum FormFieldErrorCodingKeys: String, CodingKey {
    case formFieldErrors = "FieldErrors"
  }
  
  private enum FormFieldCodingKeys: String, CodingKey {
    case formFields = "Fields"
  }
  
  func encode(to encoder: Encoder) throws {
    fatalError("What are you doing? This isn't implemented yet.")
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let resultContainer = try decoder.container(keyedBy: BVCodingKey.self)
    
    // The interesting suspects...
    if let resultKey: BVCodingKey =
      BVCodingKey(stringValue: BVType.singularKey) {
      result =
        try resultContainer.decodeIfPresent(BVType.self, forKey: resultKey)
    } else {
      result = nil
    }
    
    // The main suspects
    authorSubmissionToken =
      try container
        .decodeIfPresent(String.self, forKey: .authorSubmissionToken)
    errors =
      try container
        .decodeIfPresent([BVConversationsError].self, forKey: .errors)
    let doesHaveErrors =
      try container.decodeIfPresent(Bool.self, forKey: .hasErrors)
    hasErrors = doesHaveErrors ?? false
    locale = try container.decodeIfPresent(String.self, forKey: .locale)
    submissionId =
      try container.decodeIfPresent(String.self, forKey: .submissionId)
    typicalHoursToPost =
      try container.decodeIfPresent(Int.self, forKey: .typicalHoursToPost)
    
    /// So currently the conversations api behavior is such that if there is an
    /// authentication error then these values will not be present and it will
    /// default to a Display request/response. Therefore, we have to first
    /// check if we have an existence of these nested containers otherwise
    /// we'll end up asserting/faulting on the thrown parsing errors.
    if let formFieldErrorsContainer: KeyedDecodingContainer =
      try? container.nestedContainer(
        keyedBy: FormFieldErrorCodingKeys.self, forKey: .formFieldErrors),
      let formFieldErrorDict: BVCodableDictionary<BVFormFieldError> =
      try formFieldErrorsContainer
        .decodeIfPresent(
          BVCodableDictionary<BVFormFieldError>.self,
          forKey: .formFieldErrors) {
      formFieldErrors = formFieldErrorDict.array
    } else {
      formFieldErrors = nil
    }
    
    /// See above comment, samezies.
    if let formFieldContainer: KeyedDecodingContainer =
      try? container.nestedContainer(
        keyedBy: FormFieldCodingKeys.self, forKey: .data),
      let formFieldDict: BVCodableDictionary<BVFormField> =
      try formFieldContainer
        .decodeIfPresent(
          BVCodableDictionary<BVFormField>.self,
          forKey: .formFields) {
      formFields = formFieldDict.array
    } else {
      formFields = nil
    }
  }
}

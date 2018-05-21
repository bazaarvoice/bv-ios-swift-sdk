//
//
//  BVConversationsSubmissionResponse.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public protocol BVConversationsSubmissionMetaData {
  var authorSubmissionToken: String? { get }
  var formFieldErrors: [BVFormFieldError]? { get }
  var formFields: [BVFormField]? { get }
  var hasErrors: Bool { get }
  var locale: String? { get }
  var submissionId: String? { get }
  var typicalHoursToPost: Int? { get }
}

public enum BVConversationsSubmissionResponse<BVType: BVSubmissionable>:
BVURLRequestableResponse {
  public typealias ResponseType = BVType
  public typealias MetaType = BVConversationsSubmissionMetaData
  
  public var success: Bool {
    get {
      guard case .success = self else {
        return false
      }
      return true
    }
  }
  
  public var errors: [Error]? {
    get {
      guard case let .failure(errors) = self else {
        return nil
      }
      return errors
    }
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
    
    let formFieldErrorsContainer: KeyedDecodingContainer =
      try container.nestedContainer(
        keyedBy: FormFieldErrorCodingKeys.self, forKey: .formFieldErrors)
    
    if let formFieldErrorDict: BVCodableDictionary<BVFormFieldError> =
      try formFieldErrorsContainer
        .decodeIfPresent(
          BVCodableDictionary<BVFormFieldError>.self,
          forKey: .formFieldErrors) {
      formFieldErrors = formFieldErrorDict.array
    } else {
      formFieldErrors = nil
    }
    
    let formFieldContainer: KeyedDecodingContainer =
      try container.nestedContainer(
        keyedBy: FormFieldCodingKeys.self, forKey: .data)
    
    if let formFieldDict: BVCodableDictionary<BVFormField> =
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

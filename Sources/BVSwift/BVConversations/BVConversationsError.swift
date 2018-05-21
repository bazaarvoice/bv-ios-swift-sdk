//
//
//  BVConversationsError.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVConversationsError {
  case accessDenied(String?)
  case badRequest(String?)
  case duplicate(String?)
  case duplicateNickname(String?)
  case duplicateSubmission(String?)
  case invalidApiKey(String?)
  case invalidCallback(String?)
  case invalidEmailAddress(String?)
  case invalidFilterAttribute(String?)
  case invalidIncluded(String?)
  case invalidIPAddress(String?)
  case invalidLimit(String?)
  case invalidLocale(String?)
  case invalidOffset(String?)
  case invalidOption(String?)
  case invalidParameters(String?)
  case invalidSearchAttribute(String?)
  case invalidSortAttribute(String?)
  case invalidSubjectId(String?)
  case missingSubjectId(String?)
  case missingUserId(String?)
  case patternMismatch(String?)
  case profanity(String?)
  case rejected(String?)
  case requestLimitReached(String?)
  case required(String?)
  case requiredEither(String?)
  case requiredNickname(String?)
  case requiresTrue(String?)
  case restricted(String?)
  case storageProviderFailed(String?)
  case submittedNickname(String?)
  case tooFew(String?)
  case tooHigh(String?)
  case tooLong(String?)
  case tooLow(String?)
  case tooShort(String?)
  case uploadIO(String?)
  case unsupported(String?)
  case unknown(String?)
  
  private enum CodingKeys: String, CodingKey {
    case message = "Message"
    case code = "Code"
  }
}

extension BVConversationsError: Codable {
  public func encode(to encoder: Encoder) throws {
    fatalError("This isn't implemented, nor will it be.")
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let code = try container.decodeIfPresent(String.self, forKey: .code)
    let message = try container.decodeIfPresent(String.self, forKey: .message)
    
    switch (code, message) {
      
    case let (.some(code), message) where "ERROR_ACCESS_DENIED" == code:
      self = .accessDenied(message)
      
    case let (.some(code), message) where "ERROR_BAD_REQUEST" == code:
      self = .badRequest(message)
      
    case let (.some(code), message) where "ERROR_FORM_DUPLICATE" == code:
      self = .duplicate(message)
      
    case let (.some(code), message) where
      "ERROR_FORM_DUPLICATE_NICKNAME" == code:
      self = .duplicateNickname(message)
      
    case let (.some(code), message) where
      "ERROR_DUPLICATE_SUBMISSION" == code ||
        "ERROR_PARAM_DUPLICATE_SUBMISSION" == code:
      self = .duplicateSubmission(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_INVALID_API_KEY" == code:
      self = .invalidApiKey(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_INVALID_CALLBACK" == code:
      self = .invalidCallback(message)
      
    case let (.some(code), message) where
      "ERROR_FORM_INVALID_EMAILADDRESS" == code:
      self = .invalidEmailAddress(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_INVALID_FILTER_ATTRIBUTE" == code:
      self = .invalidFilterAttribute(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_INVALID_INCLUDED" == code:
      self = .invalidIncluded(message)
      
    case let (.some(code), message) where
      "ERROR_FORM_INVALID_IPADDRESS" == code:
      self = .invalidIPAddress(message)
      
    case let (.some(code), message) where "ERROR_PARAM_INVALID_LIMIT" == code:
      self = .invalidLimit(message)
      
    case let (.some(code), message) where "ERROR_PARAM_INVALID_LOCALE" == code:
      self = .invalidLocale(message)
      
    case let (.some(code), message) where "ERROR_PARAM_INVALID_OFFSET" == code:
      self = .invalidOffset(message)
      
    case let (.some(code), message) where "ERROR_FORM_INVALID_OPTION" == code:
      self = .invalidOption(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_INVALID_PARAMETERS" == code:
      self = .invalidParameters(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_INVALID_SEARCH_ATTRIBUTE" == code:
      self = .invalidSearchAttribute(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_INVALID_SORT_ATTRIBUTE" == code:
      self = .invalidSortAttribute(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_INVALID_SUBJECT_ID" == code:
      self = .invalidSubjectId(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_MISSING_SUBJECT_ID" == code:
      self = .missingSubjectId(message)
      
    case let (.some(code), message) where
      "ERROR_PARAM_MISSING_USER_ID" == code:
      self = .missingUserId(message)
      
    case let (.some(code), message) where
      "ERROR_FORM_PATTERN_MISMATCH" == code:
      self = .patternMismatch(message)
      
    case let (.some(code), message) where "ERROR_FORM_PROFANITY" == code:
      self = .profanity(message)
      
    case let (.some(code), message) where "ERROR_FORM_REJECTED" == code:
      self = .rejected(message)
      
    case let (.some(code), message) where
      "ERROR_REQUEST_LIMIT_REACHED" == code:
      self = .requestLimitReached(message)
      
    case let (.some(code), message) where "ERROR_FORM_REQUIRED" == code:
      self = .required(message)
      
    case let (.some(code), message) where "ERROR_FORM_REQUIRED_EITHER" == code:
      self = .requiredEither(message)
      
    case let (.some(code), message) where
      "ERROR_FORM_REQUIRED_NICKNAME" == code:
      self = .requiredNickname(message)
      
    case let (.some(code), message) where "ERROR_FORM_REQUIRES_TRUE" == code:
      self = .requiresTrue(message)
      
    case let (.some(code), message) where "ERROR_FORM_RESTRICTED" == code:
      self = .restricted(message)
      
    case let (.some(code), message) where
      "ERROR_FORM_STORAGE_PROVIDER_FAILED" == code:
      self = .storageProviderFailed(message)
      
    case let (.some(code), message) where
      "ERROR_FORM_SUBMITTED_NICKNAME" == code:
      self = .submittedNickname(message)
      
    case let (.some(code), message) where "ERROR_FORM_TOO_FEW" == code:
      self = .tooFew(message)
      
    case let (.some(code), message) where "ERROR_FORM_TOO_HIGH" == code:
      self = .tooHigh(message)
      
    case let (.some(code), message) where "ERROR_FORM_TOO_LONG" == code:
      self = .tooLong(message)
      
    case let (.some(code), message) where "ERROR_FORM_TOO_LOW" == code:
      self = .tooLow(message)
      
    case let (.some(code), message) where "ERROR_FORM_TOO_SHORT" == code:
      self = .tooShort(message)
      
    case let (.some(code), message) where "ERROR_FORM_UPLOAD_IO" == code:
      self = .uploadIO(message)
      
    case let (.some(code), message) where "ERROR_UNSUPPORTED" == code:
      self = .unsupported(message)
      
    /// Non-standard default "catch all" unknown errors
    case let (_, message):
      self = .unknown(message)
    }
  }
}

extension BVConversationsError: BVError {
  
  public var code: String {
    get {
      switch self {
      case .accessDenied: return "ERROR_ACCESS_DENIED"
      case .badRequest: return "ERROR_BAD_REQUEST"
      case .duplicate: return "ERROR_FORM_DUPLICATE"
      case .duplicateNickname: return "ERROR_FORM_DUPLICATE_NICKNAME"
      case .duplicateSubmission: return "ERROR_DUPLICATE_SUBMISSION"
      case .invalidApiKey: return "ERROR_PARAM_INVALID_API_KEY"
      case .invalidCallback: return "ERROR_PARAM_INVALID_CALLBACK"
      case .invalidEmailAddress: return "ERROR_FORM_INVALID_EMAILADDRESS"
      case .invalidFilterAttribute:
        return "ERROR_PARAM_INVALID_FILTER_ATTRIBUTE"
      case .invalidIncluded: return "ERROR_PARAM_INVALID_INCLUDED"
      case .invalidIPAddress: return "ERROR_FORM_INVALID_IPADDRESS"
      case .invalidLimit: return "ERROR_PARAM_INVALID_LIMIT"
      case .invalidLocale: return "ERROR_PARAM_INVALID_LOCALE"
      case .invalidOffset: return "ERROR_PARAM_INVALID_OFFSET"
      case .invalidOption: return "ERROR_FORM_INVALID_OPTION"
      case .invalidParameters: return "ERROR_PARAM_INVALID_PARAMETERS"
      case .invalidSearchAttribute:
        return "ERROR_PARAM_INVALID_SEARCH_ATTRIBUTE"
      case .invalidSortAttribute: return "ERROR_PARAM_INVALID_SORT_ATTRIBUTE"
      case .invalidSubjectId: return "ERROR_PARAM_INVALID_SUBJECT_ID"
      case .missingSubjectId: return "ERROR_PARAM_MISSING_SUBJECT_ID"
      case .missingUserId: return "ERROR_PARAM_MISSING_USER_ID"
      case .patternMismatch: return "ERROR_FORM_PATTERN_MISMATCH"
      case .profanity: return "ERROR_FORM_PROFANITY"
      case .rejected: return "ERROR_FORM_REJECTED"
      case .requestLimitReached: return "ERROR_REQUEST_LIMIT_REACHED"
      case .required: return "ERROR_FORM_REQUIRED"
      case .requiredEither: return "ERROR_FORM_REQUIRED_EITHER"
      case .requiredNickname: return "ERROR_FORM_REQUIRED_NICKNAME"
      case .requiresTrue: return "ERROR_FORM_REQUIRES_TRUE"
      case .restricted: return "ERROR_FORM_RESTRICTED"
      case .storageProviderFailed: return "ERROR_FORM_STORAGE_PROVIDER_FAILED"
      case .submittedNickname: return "ERROR_FORM_SUBMITTED_NICKNAME"
      case .tooFew: return "ERROR_FORM_TOO_FEW"
      case .tooHigh: return "ERROR_FORM_TOO_HIGH"
      case .tooLong: return "ERROR_FORM_TOO_LONG"
      case .tooLow: return "ERROR_FORM_TOO_LOW"
      case .tooShort: return "ERROR_FORM_TOO_SHORT"
      case .uploadIO: return "ERROR_FORM_UPLOAD_IO"
      case .unsupported: return "ERROR_UNSUPPORTED"
      case .unknown: return "ERROR_UNKNOWN"
      }
    }
  }
  
  public var message: String {
    get {
      switch self {
      case .accessDenied(.some(let message)): return message
      case .badRequest(.some(let message)): return message
      case .duplicate(.some(let message)): return message
      case .duplicateNickname(.some(let message)): return message
      case .duplicateSubmission(.some(let message)): return message
      case .invalidApiKey(.some(let message)): return message
      case .invalidCallback(.some(let message)): return message
      case .invalidEmailAddress(.some(let message)): return message
      case .invalidFilterAttribute(.some(let message)): return message
      case .invalidIncluded(.some(let message)): return message
      case .invalidIPAddress(.some(let message)): return message
      case .invalidLimit(.some(let message)): return message
      case .invalidLocale(.some(let message)): return message
      case .invalidOffset(.some(let message)): return message
      case .invalidOption(.some(let message)): return message
      case .invalidParameters(.some(let message)): return message
      case .invalidSearchAttribute(.some(let message)): return message
      case .invalidSortAttribute(.some(let message)): return message
      case .invalidSubjectId(.some(let message)): return message
      case .missingSubjectId(.some(let message)): return message
      case .missingUserId(.some(let message)): return message
      case .patternMismatch(.some(let message)): return message
      case .profanity(.some(let message)): return message
      case .rejected(.some(let message)): return message
      case .requestLimitReached(.some(let message)): return message
      case .required(.some(let message)): return message
      case .requiredEither(.some(let message)): return message
      case .requiredNickname(.some(let message)): return message
      case .requiresTrue(.some(let message)): return message
      case .restricted(.some(let message)): return message
      case .storageProviderFailed(.some(let message)): return message
      case .submittedNickname(.some(let message)): return message
      case .tooFew(.some(let message)): return message
      case .tooHigh(.some(let message)): return message
      case .tooLong(.some(let message)): return message
      case .tooLow(.some(let message)): return message
      case .tooShort(.some(let message)): return message
      case .uploadIO(.some(let message)): return message
      case .unsupported(.some(let message)): return message
      case .unknown(.some(let message)): return message
      default:
        return "No error message."
      }
    }
  }
  
  var localizedDescription: String {
    get {
      return code
    }
  }
  
  public var description: String {
    return localizedDescription
  }
  
  public var debugDescription: String {
    return "Code: \(code), Message: \(message)"
  }
}

extension BVConversationsError {
  internal init?(_ code: String, message: String? = nil) {
    
    switch code {
    case "ERROR_ACCESS_DENIED":
      self = .accessDenied(message)
      break
    case "ERROR_BAD_REQUEST":
      self = .badRequest(message)
      break
    case "ERROR_FORM_DUPLICATE":
      self = .duplicate(message)
      break
    case "ERROR_FORM_DUPLICATE_NICKNAME":
      self = .duplicateNickname(message)
      break
    case "ERROR_DUPLICATE_SUBMISSION":
      fallthrough
    case "ERROR_PARAM_DUPLICATE_SUBMISSION":
      self = .duplicateSubmission(message)
      break
    case "ERROR_PARAM_INVALID_API_KEY":
      self = .invalidApiKey(message)
      break
    case "ERROR_PARAM_INVALID_CALLBACK":
      self = .invalidCallback(message)
      break
    case "ERROR_FORM_INVALID_EMAILADDRESS":
      self = .invalidEmailAddress(message)
      break
    case "ERROR_PARAM_INVALID_FILTER_ATTRIBUTE":
      self = .invalidFilterAttribute(message)
      break
    case "ERROR_PARAM_INVALID_INCLUDED":
      self = .invalidIncluded(message)
      break
    case "ERROR_FORM_INVALID_IPADDRESS":
      self = .invalidIPAddress(message)
      break
    case "ERROR_PARAM_INVALID_LIMIT":
      self = .invalidLimit(message)
      break
    case "ERROR_PARAM_INVALID_LOCALE":
      self = .invalidLocale(message)
      break
    case "ERROR_PARAM_INVALID_OFFSET":
      self = .invalidOffset(message)
      break
    case "ERROR_FORM_INVALID_OPTION":
      self = .invalidOption(message)
      break
    case "ERROR_PARAM_INVALID_PARAMETERS":
      self = .invalidParameters(message)
      break
    case "ERROR_PARAM_INVALID_SEARCH_ATTRIBUTE":
      self = .invalidSearchAttribute(message)
      break
    case "ERROR_PARAM_INVALID_SORT_ATTRIBUTE":
      self = .invalidSortAttribute(message)
      break
    case "ERROR_PARAM_INVALID_SUBJECT_ID":
      self = .invalidSubjectId(message)
      break
    case "ERROR_PARAM_MISSING_SUBJECT_ID":
      self = .missingSubjectId(message)
      break
    case "ERROR_PARAM_MISSING_USER_ID":
      self = .missingUserId(message)
      break
    case "ERROR_FORM_PATTERN_MISMATCH":
      self = .patternMismatch(message)
      break
    case "ERROR_FORM_PROFANITY":
      self = .profanity(message)
      break
    case "ERROR_FORM_REJECTED":
      self = .rejected(message)
      break
    case "ERROR_REQUEST_LIMIT_REACHED":
      self = .requestLimitReached(message)
      break
    case "ERROR_FORM_REQUIRED":
      self = .required(message)
      break
    case "ERROR_FORM_REQUIRED_EITHER":
      self = .requiredEither(message)
      break
    case "ERROR_FORM_REQUIRED_NICKNAME":
      self = .requiredNickname(message)
      break
    case "ERROR_FORM_REQUIRES_TRUE":
      self = .requiresTrue(message)
      break
    case "ERROR_FORM_RESTRICTED":
      self = .restricted(message)
      break
    case "ERROR_FORM_STORAGE_PROVIDER_FAILED":
      self = .storageProviderFailed(message)
      break
    case "ERROR_FORM_SUBMITTED_NICKNAME":
      self = .submittedNickname(message)
      break
    case "ERROR_FORM_TOO_FEW":
      self = .tooFew(message)
      break
    case "ERROR_FORM_TOO_HIGH":
      self = .tooHigh(message)
      break
    case "ERROR_FORM_TOO_LONG":
      self = .tooLong(message)
      break
    case "ERROR_FORM_TOO_LOW":
      self = .tooLow(message)
      break
    case "ERROR_FORM_TOO_SHORT":
      self = .tooShort(message)
      break
    case "ERROR_FORM_UPLOAD_IO":
      self = .uploadIO(message)
      break
    case "ERROR_UNSUPPORTED":
      self = .unsupported(message)
      break
    /// Non-standard default "catch all" unknown errors
    default:
      self = .unknown(message)
      break
    }
  }
}

//
//
//  BVConversationsError.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The BVConversations errors
/// - Note:
/// \
/// Most of these will always have a message attached to them if they're coming
/// back from a query/submission, however, it's not guarenteed in all cases so
/// be sure to check and make sure.
public enum BVConversationsError {
  
  /// Insufficient privileges to perform the operation
  /// - Note:
  /// \
  /// ERROR_ACCESS_DENIED
  case accessDenied(String?)
  
  /// Authentication token is invalid, missing or the user has already been
  /// authenticated
  /// - Note:
  /// \
  /// ERROR_BAD_REQUEST
  case badRequest(String?)
  
  /// The parameter value is already in use.
  /// - Note:
  /// \
  /// ERROR_FORM_DUPLICATE
  case duplicate(String?)
  
  /// The nickname is already in use.
  /// - Note:
  /// \
  /// ERROR_FORM_DUPLICATE_NICKNAME
  case duplicateNickname(String?)
  
  /// Duplicate submissions are not allowed for this client.
  /// - Note:
  /// \
  /// ERROR_PARAM_DUPLICATE_SUBMISSION
  case duplicateSubmission(String?)
  
  /// Invalid API Key value
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_API_KEY
  case invalidApiKey(String?)
  
  /// Invalid callback function
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_CALLBACK
  case invalidCallback(String?)
  
  /// Email address is not in the proper format.
  /// - Note:
  /// \
  /// ERROR_FORM_INVALID_EMAILADDRESS
  case invalidEmailAddress(String?)
  
  /// Invalid filter attribute name
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_FILTER_ATTRIBUTE
  case invalidFilterAttribute(String?)
  
  /// Invalid parameter value
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_INCLUDED
  case invalidIncluded(String?)
  
  /// The IP address is invalid.
  /// - Note:
  /// \
  /// ERROR_FORM_INVALID_IPADDRESS
  case invalidIPAddress(String?)
  
  /// Invalid limit value
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_LIMIT
  case invalidLimit(String?)
  
  /// Invalid locale code
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_LOCALE
  case invalidLocale(String?)
  
  /// Invalid offset value
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_OFFSET
  case invalidOffset(String?)
  
  /// The selected option has been removed.
  /// - Note:
  /// \
  /// ERROR_FORM_INVALID_OPTION
  case invalidOption(String?)
  
  /// Invalid parameter in content submission.
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_PARAMETERS
  case invalidParameters(String?)
  
  /// Invalid search attribute name or search not supported
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_SEARCH_ATTRIBUTE
  case invalidSearchAttribute(String?)
  
  /// Invalid sort attribute name
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_SORT_ATTRIBUTE
  case invalidSortAttribute(String?)
  
  /// An object id must be specified since accepting objects can only be
  /// submitted on the object type representing the id.
  /// - Note:
  /// \
  /// ERROR_PARAM_INVALID_SUBJECT_ID
  case invalidSubjectId(String?)
  
  /// Submission is missing a an object id to submit against. An object id is
  /// REQUIRED for submissions.
  /// - Note:
  /// \
  /// ERROR_PARAM_MISSING_SUBJECT_ID
  case missingSubjectId(String?)
  
  /// This client does not allow unauthenticated submissions. A valid UserId is
  /// required.
  /// - Note:
  /// \
  /// ERROR_PARAM_MISSING_USER_ID
  case missingUserId(String?)
  
  /// This field is not in the correct format.
  /// - Note:
  /// \
  /// ERROR_FORM_PATTERN_MISMATCH
  case patternMismatch(String?)
  
  /// The content contains inappropriate language.
  /// - Note:
  /// \
  /// ERROR_FORM_PROFANITY
  case profanity(String?)
  
  /// The submission was rejected.
  /// - Note:
  /// \
  /// ERROR_FORM_REJECTED
  case rejected(String?)
  
  /// Rate limiting error, i.e. too many requests per time interval
  /// - Note:
  /// \
  /// ERROR_REQUEST_LIMIT_REACHED
  case requestLimitReached(String?)
  
  /// A required field was not supplied.
  /// - Note:
  /// \
  /// ERROR_FORM_REQUIRED
  case required(String?)
  
  /// Both of the required hosted authentication parameters are missing.
  /// - Note:
  /// \
  /// ERROR_FORM_REQUIRED_EITHER
  case requiredEither(String?)
  
  /// You must enter a nickname.
  /// - Note:
  /// \
  /// ERROR_FORM_REQUIRED_NICKNAME
  case requiredNickname(String?)
  
  /// A field requires a value of true. (e.g., "You must agree to the terms and
  /// conditions.")
  /// - Note:
  /// \
  /// ERROR_FORM_REQUIRES_TRUE
  case requiresTrue(String?)
  
  /// Content provider's age is too young. (e.g., "Content cannot be accepted from
  /// minors under age 13.")
  /// - Note:
  /// \
  /// ERROR_FORM_RESTRICTED
  case restricted(String?)
  
  /// The uploaded file could not be stored. Try uploading again later.
  /// - Note:
  /// \
  /// ERROR_FORM_STORAGE_PROVIDER_FAILED
  case storageProviderFailed(String?)
  
  /// This nickname has already been submitted.
  /// - Note:
  /// \
  /// ERROR_FORM_SUBMITTED_NICKNAME
  case submittedNickname(String?)
  
  /// There must be a minimum number of items contributed for this field.
  /// - Note:
  /// \
  /// ERROR_FORM_TOO_FEW
  case tooFew(String?)
  
  /// This field has too many items.
  /// - Note:
  /// \
  /// ERROR_FORM_TOO_HIGH
  case tooHigh(String?)
  
  /// The field has too many characters.
  /// - Note:
  /// \
  /// ERROR_FORM_TOO_LONG
  case tooLong(String?)
  
  /// This field has too few items.
  /// - Note:
  /// \
  /// ERROR_FORM_TOO_LOW
  case tooLow(String?)
  
  /// The field doesn't have enough characters.
  /// - Note:
  /// \
  /// ERROR_FORM_TOO_SHORT
  case tooShort(String?)
  
  /// The item could not be uploaded. Ensure that it is a valid file type.
  /// - Note:
  /// \
  /// ERROR_FORM_UPLOAD_IO
  case uploadIO(String?)
  
  /// For unsupported features, clients etc.
  /// - Note:
  /// \
  /// ERROR_UNSUPPORTED
  case unsupported(String?)
  
  /// Unknown error (internal server error, for instance)
  /// - Note:
  /// \
  /// ERROR_UNKNOWN
  case unknown(String?)
  
  private enum CodingKeys: String, CodingKey {
    case message = "Message"
    case code = "Code"
  }
}

extension BVConversationsError: Codable {
  /// Conformance with Encodable. Currently it isn't implemented and therefore
  /// shouldn't be used. It will fatalError to remind you :)
  /// - Note:
  /// \
  /// Please see the plethora of information regarding this protocol.
  public func encode(to encoder: Encoder) throws {
    fatalError("This isn't implemented, nor will it be.")
  }
  
  /// Conformance with Decodable. Used to hydrate from the json returned from
  /// the various API calls.
  /// - Note:
  /// \
  /// Please see the plethora of information regarding this protocol.
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

/// Conformance with the BVError Protocol
extension BVConversationsError: BVError {
  
  public var code: String {
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
  
  public var message: String {
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
  
  var localizedDescription: String {
    return code
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
    case "ERROR_BAD_REQUEST":
      self = .badRequest(message)
    case "ERROR_FORM_DUPLICATE":
      self = .duplicate(message)
    case "ERROR_FORM_DUPLICATE_NICKNAME":
      self = .duplicateNickname(message)
    case "ERROR_DUPLICATE_SUBMISSION":
      fallthrough
    case "ERROR_PARAM_DUPLICATE_SUBMISSION":
      self = .duplicateSubmission(message)
    case "ERROR_PARAM_INVALID_API_KEY":
      self = .invalidApiKey(message)
    case "ERROR_PARAM_INVALID_CALLBACK":
      self = .invalidCallback(message)
    case "ERROR_FORM_INVALID_EMAILADDRESS":
      self = .invalidEmailAddress(message)
    case "ERROR_PARAM_INVALID_FILTER_ATTRIBUTE":
      self = .invalidFilterAttribute(message)
    case "ERROR_PARAM_INVALID_INCLUDED":
      self = .invalidIncluded(message)
    case "ERROR_FORM_INVALID_IPADDRESS":
      self = .invalidIPAddress(message)
    case "ERROR_PARAM_INVALID_LIMIT":
      self = .invalidLimit(message)
    case "ERROR_PARAM_INVALID_LOCALE":
      self = .invalidLocale(message)
    case "ERROR_PARAM_INVALID_OFFSET":
      self = .invalidOffset(message)
    case "ERROR_FORM_INVALID_OPTION":
      self = .invalidOption(message)
    case "ERROR_PARAM_INVALID_PARAMETERS":
      self = .invalidParameters(message)
    case "ERROR_PARAM_INVALID_SEARCH_ATTRIBUTE":
      self = .invalidSearchAttribute(message)
    case "ERROR_PARAM_INVALID_SORT_ATTRIBUTE":
      self = .invalidSortAttribute(message)
    case "ERROR_PARAM_INVALID_SUBJECT_ID":
      self = .invalidSubjectId(message)
    case "ERROR_PARAM_MISSING_SUBJECT_ID":
      self = .missingSubjectId(message)
    case "ERROR_PARAM_MISSING_USER_ID":
      self = .missingUserId(message)
    case "ERROR_FORM_PATTERN_MISMATCH":
      self = .patternMismatch(message)
    case "ERROR_FORM_PROFANITY":
      self = .profanity(message)
    case "ERROR_FORM_REJECTED":
      self = .rejected(message)
    case "ERROR_REQUEST_LIMIT_REACHED":
      self = .requestLimitReached(message)
    case "ERROR_FORM_REQUIRED":
      self = .required(message)
    case "ERROR_FORM_REQUIRED_EITHER":
      self = .requiredEither(message)
    case "ERROR_FORM_REQUIRED_NICKNAME":
      self = .requiredNickname(message)
    case "ERROR_FORM_REQUIRES_TRUE":
      self = .requiresTrue(message)
    case "ERROR_FORM_RESTRICTED":
      self = .restricted(message)
    case "ERROR_FORM_STORAGE_PROVIDER_FAILED":
      self = .storageProviderFailed(message)
    case "ERROR_FORM_SUBMITTED_NICKNAME":
      self = .submittedNickname(message)
    case "ERROR_FORM_TOO_FEW":
      self = .tooFew(message)
    case "ERROR_FORM_TOO_HIGH":
      self = .tooHigh(message)
    case "ERROR_FORM_TOO_LONG":
      self = .tooLong(message)
    case "ERROR_FORM_TOO_LOW":
      self = .tooLow(message)
    case "ERROR_FORM_TOO_SHORT":
      self = .tooShort(message)
    case "ERROR_FORM_UPLOAD_IO":
      self = .uploadIO(message)
    case "ERROR_UNSUPPORTED":
      self = .unsupported(message)
    /// Non-standard default "catch all" unknown errors
    default:
      self = .unknown(message)
    }
  }
}

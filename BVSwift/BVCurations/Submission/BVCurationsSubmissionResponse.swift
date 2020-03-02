//
//
//  BVCurationsSubmissionResponse.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for submissions
internal protocol BVCurationsSubmissionMetaData {
  
  /// The code for the result of the submission
  var code: Int? { get }
  
  /// The status for the request
  var status: String? { get }
}

// Public return type for all BVCurations Submissions
/// - Note:
/// \
/// The result type is empty unless it's an unknown result.
internal enum
BVCurationsSubmissionResponse: BVURLRequestableResponse {
  public typealias ResponseType = Data
  public typealias MetaType = BVCurationsSubmissionMetaData
  
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

internal struct BVCurationsSubmissionResponseInternal:
Codable, BVCurationsSubmissionMetaData {
  
  let code: Int?
  let status: String?
  
  private enum CodingKeys: String, CodingKey {
    case code
    case message
    case status
    case statusCode
  }
  
  func encode(to encoder: Encoder) throws {
    fatalError()
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    if let statusCode =
      ((try? container.decodeIfPresent(Int.self, forKey: .statusCode)) as Int??) {
      code = statusCode
    } else if let intCode =
      ((try? container.decodeIfPresent(Int.self, forKey: .code)) as Int??) {
      code = intCode
    } else {
      code = nil
    }
    
    var msg: String = ""
    if let statusString =
      ((try? container.decodeIfPresent(String.self, forKey: .code)) as String??) {
      msg += (statusString ?? "")
    }
    
    if let message =
      try container.decodeIfPresent(String.self, forKey: .message) {
      msg += ":" + message
    } else if let statusMessage =
      try container.decodeIfPresent(String.self, forKey: .status) {
      msg += ":" + statusMessage
    }
    
    status = msg
  }
}

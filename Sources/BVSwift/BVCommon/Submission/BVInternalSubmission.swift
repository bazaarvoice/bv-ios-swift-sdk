//
//  BVInternalSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal protocol BVInternalSubmissionDelegate: class,
BVURLRequestBodyable, BVURLQueryItemable { }

// MARK: - BVInternalSubmission
internal class BVInternalSubmission: BVURLRequest {
  
  /// Internal
  final internal let submissionableType: BVSubmissionableInternal?
  internal weak var submissionBodyable: BVInternalSubmissionDelegate?
  
  internal init(_ internalType: BVSubmissionableInternal) {
    submissionableType = internalType
    super.init()
    resource =
      type(of: internalType).postResource ?? String.empty
  }
  
  override var urlQueryItems: [URLQueryItem]? {
    return submissionBodyable?.urlQueryItems
  }
  
  override internal var request: URLRequest? {
    guard var superRequest = super.request,
      let url = superRequest.url else {
        /// This should fail in the super class
        fatalError("Super request returned was nil")
    }
    
    guard let type = submissionableType,
      let contentType = submissionBodyable?.requestContentType(type) else {
        fatalError("Cannot ascertain content type from submissionable type")
    }
    
    superRequest.httpMethod = "POST"
    superRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
    BVLogger
      .sharedLogger.debug(
        "Issuing Submission Request to: \(url.absoluteString)")
    
    return superRequest
  }
}

// MARK: - BVInternalSubmission: BVSubmissionableConsumable
extension BVInternalSubmission: BVSubmissionableConsumable {
  var submissionableInternal: BVSubmissionableInternal? {
    return submissionableType
  }
}

// MARK: - BVInternalSubmission: BVURLRequestableWithBodyData
extension BVInternalSubmission: BVURLRequestableWithBodyData {
  internal var bodyData: Data? {
    guard let bodyable = submissionBodyable,
      let type = submissionableType else {
        return nil
    }
    
    switch bodyable.requestBody(type) {
    case let .some(.multipart(map, boundary)):
      
      let multipartData = map.reduce(Data())
      { (result: Data, keyValue: (key: String, value: Any)) -> Data in
        switch keyValue.value {
        case let value as String:
          return (result + URLRequest
            .multipartData(
              key: keyValue.key, string: value, boundary: boundary))
        case let value as Data:
          return (result + URLRequest
            .multipartData(
              key: keyValue.key, data: value, boundary: boundary))
        default:
          return result
        }
      }
      return (multipartData + URLRequest.encloseMultipartData(boundary))
    case let .some(.raw(data)):
      return data
    default:
      return nil
    }
  }
}

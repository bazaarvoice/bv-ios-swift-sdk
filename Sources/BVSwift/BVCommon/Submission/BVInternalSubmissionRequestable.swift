//
//
//  BVInternalSubmissionRequestable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVInternalSubmission: BVURLRequestableWithBodyData
extension BVInternalSubmission: BVURLRequestableWithBodyData {
  
  internal var request: URLRequest? {
    if commonEndpoint.isEmpty {
      fatalError(
        "Endpoint value is empty, make sure you configure the query first.")
    }
    
    let urlString: String = "\(commonEndpoint)\(bvPath)"
    guard var urlComponents: URLComponents =
      URLComponents(string: urlString) else {
        return nil
    }
    
    if let items = urlQueryItems,
      !items.isEmpty {
      urlComponents.queryItems = items
    }
    
    guard let url: URL = urlComponents.url else {
      return nil
    }
    
    let cachePolicy: URLRequest.CachePolicy =
      usesURLCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
    var request: URLRequest = URLRequest(url: url, cachePolicy: cachePolicy)
    request.httpMethod = "POST"
    
    if let contentType: String = submissionBodyable?.requestContentType {
      request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
    
    BVLogger
      .sharedLogger.debug(
        "Issuing Submission Request to: \(url.absoluteString)")
    
    return request
  }
  
  internal var bodyData: Data? {
    guard let bodyable = submissionBodyable,
      let type = submissionableType else {
        return nil
    }
    
    switch bodyable.requestBody(type) {
    case let .some(.multipart(map)):
      
      let multipartData = map.reduce(Data())
      { (result: Data, keyValue: (key: String, value: Any)) -> Data in
        switch keyValue.value {
        case let value as String:
          return (result + URLRequest
            .multipartData(key: keyValue.key, value: value))
        case let value as Data:
          return (result + URLRequest
            .multipartData(key: keyValue.key, value: value))
        default:
          return result
        }
      }
      
      return (multipartData + URLRequest.encloseMultipartData())
    case let .some(.raw(data)):
      return data
    default:
      return nil
    }
  }
}

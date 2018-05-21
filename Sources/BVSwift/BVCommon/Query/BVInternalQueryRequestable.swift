//
//  BVInternalQueryRequestable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

extension BVInternalQuery: BVURLRequestable {
  
  internal var request: URLRequest? {
    get {
      
      if commonEndpoint.isEmpty {
        fatalError(
          "Endpoint value is empty, make sure you configure the query first.")
      }
      
      let urlString: String = "\(commonEndpoint)\(bvPath)"
      guard var urlComponents:URLComponents =
        URLComponents(string: urlString) else {
          return nil
      }
      
      urlComponents.queryItems = urlQueryItems
      
      guard let url: URL = urlComponents.url else {
        return nil
      }
      
      return URLRequest(url: url)
    }
  }
  
  func preflight(_ completion: BVCompletionWithErrorsHandler?) -> Bool {
    guard let handler = preflightHandler else {
      return false
    }
    handler(completion)
    return true
  }
  
  internal final func process(
    data: Data?, urlResponse: URLResponse?, error: Error?) {
    
    guard let _ = responseHandler else {
      fatalError(
        "No completion response block given for query, make sure you" +
        "explicitly mark ignoringCompletion if this is what you intended.")
    }
    
    guard let httpResponse:HTTPURLResponse = urlResponse as? HTTPURLResponse
      else {
        let err = BVCommonError.unknown("URLResponse wasn't an HTTPURLResponse")
        assert(false, err.description)
        
        
        responseHandler?(.failure([err]))
        return
    }
    
    if let httpError:Error = error, 200 != httpResponse.statusCode {
      let err = BVCommonError.network(
        httpResponse.statusCode, httpError.localizedDescription)
      assert(false, err.description)
      
      responseHandler?(.failure([err]))
      return
    }
    
    guard let jsonData:Data = data else {
      let err = BVCommonError.noData
      assert(false, err.description)
      
      
      responseHandler?(.failure([err]))
      return
    }
    
    responseHandler?(.success(urlResponse, jsonData))
  }
  
  internal final func process(
    url: URL?, urlResponse: URLResponse?, error: Error?) {
    
  }
}

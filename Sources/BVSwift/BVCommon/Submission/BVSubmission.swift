//
//
//  BVSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVSubmission {
  private var box: BVInternalSubmission
  
  internal init(internalType: BVSubmissionableInternal) {
    box = BVInternalSubmission(internalType)
    box.submissionBodyable = self
  }
  
  internal var contentBodyClosure:
    ((BVSubmissionableInternal) -> BVURLRequestBody?)? {
    get {
      return { (submission: BVSubmissionableInternal) -> BVURLRequestBody? in
        
        /// I think this is a swift bug, but this isn't maleviolent.
        let encodable = BVAnyEncodable(submission)
        guard let data: Data = try? JSONEncoder().encode(encodable) else {
          
          #if DEBUG
            do {
              let _ = try JSONEncoder().encode(encodable)
            } catch {
              BVLogger.sharedLogger.error("Error: \(error)")
            }
            
            return nil
          #else
            fatalError()
          #endif
        }
        
        return .raw(data)
      }
    }
  }
  
  internal var contentTypeClosure: (() -> String?)? {
    get {
      return {
        return "application/json"
      }
    }
  }
  
  internal var postflightClosure: BVURLRequestableHandler? {
    get {
      return nil
    }
  }
}

// MARK: - BVSubmission: BVInternalSubmissionDelegate
extension BVSubmission : BVInternalSubmissionDelegate {
  var requestContentType: String? {
    guard let contentType = contentTypeClosure else {
      return nil
    }
    return contentType()
  }
  
  func requestBody(_ type: BVSubmissionableInternal) -> BVURLRequestBody? {
    guard let body = contentBodyClosure else {
      return nil
    }
    return body(type)
  }
}

// MARK: - BVSubmission: BVURLRequestable
extension BVSubmission : BVURLRequestable {
  
  public var request: URLRequest? {
    get {
      return box.request
    }
  }
  
  public func preflight(_ completion: BVCompletionWithErrorsHandler?) -> Bool {
    return box.preflight(completion)
  }
  
  public func process(data: Data?, urlResponse: URLResponse?, error: Error?) {
    box.process(data: data, urlResponse: urlResponse, error: error)
  }
  
  public func process(url: URL?, urlResponse: URLResponse?, error: Error?) {
    box.process(url: url, urlResponse: urlResponse, error: error)
  }
}

// MARK: - BVSubmission: BVURLRequestableWithBodyData
extension BVSubmission: BVURLRequestableWithBodyData {
  public var bodyData: Data? {
    return box.bodyData
  }
}

// MARK: - BVSubmission: BVSubmissionActionableInternal
extension BVSubmission: BVSubmissionActionableInternal {
  
  var preflightHandler: BVURLRequestablePreflightHandler? {
    get {
      return box.preflightHandler
    }
    set(newValue) {
      box.preflightHandler = newValue
    }
  }
  
  internal var responseHandler: BVURLRequestableHandler? {
    get {
      return box.responseHandler
    }
    set(newValue) {
      /// We do a little swizzling so we can plumb postflight actions through.
      /// We need to be careful to avoid cycles so we may need to suss this out
      /// a little bit; however, I think this may be fine. Famous last words.
      guard let cmp = newValue else {
        box.responseHandler = nil
        return
      }
      box.responseHandler = {
        cmp($0)
        self.postflight($0)
      }
    }
  }
}

// MARK: - BVSubmission: BVConfigureExistentially
extension BVSubmission: BVConfigureExistentially {
  @discardableResult
  final public func configureExistentially(_ config: BVConfiguration) -> Self {
    box.configurationType = config
    return self
  }
}

// MARK: - BVSubmission: BVSubmissionPostflightable
extension BVSubmission: BVSubmissionPostflightable {
  internal func postflight(_ response: BVURLRequestableResponseInternal) {
    postflightClosure?(response)
  }
}

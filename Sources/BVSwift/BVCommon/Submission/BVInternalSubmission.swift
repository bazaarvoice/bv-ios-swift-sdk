//
//  BVInternalSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal protocol BVInternalSubmissionDelegate:
class,
BVURLRequestBodyTypeable,
BVURLQueryItemable,
BVURLRequestUserAgentable { }

// MARK: - BVInternalSubmission
internal class BVInternalSubmission: BVURLRequest {
  
  /// Private
  private var cachedBodyType: BVURLRequestBodyType?
  
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
  
  override var userAgent: String? {
    return submissionBodyable?.userAgent
  }
  
  override internal var request: URLRequest? {
    guard var superRequest = super.request,
      let url = superRequest.url else {
        /// This should fail in the super class
        fatalError("Super request returned was nil")
    }
    
    /// We always use the cached body type if we have it since that shouldn't
    /// ever change. The content type of a request should be static. However,
    /// the body may change, therefore, that's why we don't rely on a cache we
    /// cafefully recompute each time; and thus, rely upon caching at the
    /// specific request layer.
    /// - Note:
    /// \
    /// If this becomes a performance bottleneck, then we can add a conditional
    /// parameter to the delegate function to "hold off" on calculating the body
    /// since we're only asking for the content type.
    guard let bodyType =
      cachedBodyType ?? submissionBodyable?.requestBodyType else {
        fatalError("Cannot ascertain content type from submissionable type")
    }
    
    /// Make sure we keep it around
    cachedBodyType = bodyType
    
    superRequest.httpMethod = "POST"
    superRequest.setValue(
      bodyType.description, forHTTPHeaderField: "Content-Type")
    
    BVLogger
      .sharedLogger.debug(
        "Issuing Submission Request to: \(url.absoluteString)")
    
    return superRequest
  }
}

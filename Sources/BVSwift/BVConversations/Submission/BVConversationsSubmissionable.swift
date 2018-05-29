//
//  BVConversationsSubmissionable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Enumeration defining the submission type
public enum BVConversationsSubmissionAction {
  
  /// Preview the submission
  case preview
  
  /// Actually submit the submission
  case submit
}

/// Protocol defining the ability to accept a BVConversationsSubmissionAction
public protocol BVConversationsSubmissionActionable {
  @discardableResult
  func add(_ action: BVConversationsSubmissionAction) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionUserAuthenticatedString {
  
  /// User authenticated string
  case uas(String)
}

/// Protocol defining the ability to accept a
/// BVConversationsSubmissionUserAuthenticatedString
public protocol BVConversationsSubmissionUserAuthenticatedStringable {
  @discardableResult
  func add(_ uas: BVConversationsSubmissionUserAuthenticatedString) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionAuthenticity {
  
  /// Device fingerprint
  case fingerprint(String)
}

/// Protocol defining the ability to accept a
/// BVConversationsSubmissionAuthenticity
public protocol BVConversationsSubmissionAuthenticityable {
  @discardableResult
  func add(_ authenticity: BVConversationsSubmissionAuthenticity) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionAlerts {
  
  /// Flag for sending an email if something is commented on
  case sendEmailWhenCommented(Bool)
  
  /// Flag for sending an email if something is published
  case sendEmailWhenPublished(Bool)
}

/// Protocol defining the ability to accept a BVConversationsSubmissionAlerts
public protocol BVConversationsSubmissionAlertable {
  @discardableResult
  func add(_ alert: BVConversationsSubmissionAlerts) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionFieldTypes {
  
  /// The additional field
  case additional(name: String, value: String)
  
  /// The context data field with value
  case contextData(name: String, value: String)
  
  /// The context data field with boolean false
  case contextDataFalse(name: String)
  
  /// The context data field with boolean true
  case contextDataTrue(name: String)
  
  /// The freeform tag with name, cardinality, and value
  case freeformTag(name: String, number: Int, value: String)
  
  /// The predefinedTag tag with name, id, and value
  case predefinedTag(name: String, id: String, value: String)
  
  /// The rating with name and value
  case rating(name: String, value: CustomStringConvertible)
}

/// Protocol defining the ability to accept a
/// BVConversationsSubmissionFieldTypes
public protocol BVConversationsSubmissionFieldTypeable {
  @discardableResult
  func add(_ fieldType: BVConversationsSubmissionFieldTypes) -> Self
}

/// Protocol defining the ability to accept custom dictionary of strings
public protocol BVConversationsSubmissionCustomizeable {
  @discardableResult
  func add(_ customFields: [String : String]) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionHostedAuthenticated {
  
  /// The hosted authentication callback URL
  case hostedAuthCallback(URL)
  
  /// The hosted authentication email address
  case hostedAuthEmail(String)
}

/// Protocol defining the ability to accept a
/// BVConversationsSubmissionHostedAuthenticated
public protocol BVConversationsSubmissionHostedAuthenticatable {
  @discardableResult
  func add(_ hostedAuth: BVConversationsSubmissionHostedAuthenticated) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionLocale {
  
  /// The locale for the submission type
  case locale(String)
}

/// Protocol defining the ability to accept a
/// BVConversationsSubmissionLocaleable
public protocol BVConversationsSubmissionLocaleable {
  @discardableResult
  func add(_ locale: BVConversationsSubmissionLocale) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionMedia {
  
  /// Any photos attached to the submission
  case photos([BVPhoto])
  
  /// Any videos attached to the submission
  case videos([BVVideo])
}

/// Protocol defining the ability to accept a BVConversationsSubmissionMediable
public protocol BVConversationsSubmissionMediable {
  @discardableResult
  func add(_ media: BVConversationsSubmissionMedia) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionRating {
  
  /// Rating comment attached to submission
  case comment(String)
  
  /// Rating score attached to the submission
  case score(UInt)
  
  /// Rating `is recommended` attached to the submission
  case recommended(Bool)
}

public protocol BVConversationsSubmissionRatable {
  @discardableResult
  func add(_ rate: BVConversationsSubmissionRating) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionTag {
  
  /// Campaign Id submission tag
  case campaignId(String)
}

public protocol BVConversationsSubmissionTaggable {
  @discardableResult
  func add(_ tag: BVConversationsSubmissionTag) -> Self
}

/// Enumeration defining the submission type
public enum BVConversationsSubmissionTermsAndConditions {
  
  /// Agree or not with the terms and conditions
  case agree(Bool)
}

public protocol BVConversationsSubmissionTermsAndConditionsable {
  @discardableResult
  func add(
    _ termsAndConditions: BVConversationsSubmissionTermsAndConditions) -> Self
}


/// Enumeration defining the submission type
public enum BVConversationsSubmissionUserInfo {
  
  /// User email address
  case email(String)
  
  /// User identifier
  case identifier(String)
  
  /// User Location
  case location(String)
  
  /// User nickname
  case nickname(String)
}

public protocol BVConversationsSubmissionUserInformationable {
  @discardableResult
  func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self
}

// MARK: - BVConversationsSubmissionParameterable
internal protocol BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? { get }
}

// MARK: - BVConversationsSubmissionable
internal protocol BVConversationsSubmissionable: class {
  var conversationsParameters: [URLQueryItem] { get set }
  var customConversationsParameters: [URLQueryItem]? { get set }
}

// MARK: - BVConversationsSubmissionPostflightable
internal protocol
BVConversationsSubmissionPostflightable: BVSubmissionActionable {
  associatedtype ConversationsPostflightResult: BVSubmissionable
  func conversationsPostflight(_ results: [ConversationsPostflightResult]?)
}

extension BVConversationsSubmissionAction:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case .preview:
        return [URLQueryItem(name: "action", value: "Preview")]
      case .submit:
        return [URLQueryItem(name: "action", value: "Submit")]
      }
    }
  }
}

extension BVConversationsSubmissionUserAuthenticatedString:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .uas(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(name: "user", value: encoded)]
      }
    }
  }
}

extension BVConversationsSubmissionAuthenticity:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .fingerprint(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(name: "fp", value: encoded)]
      }
    }
  }
}

extension BVConversationsSubmissionAlerts:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .sendEmailWhenCommented(value):
        let encoded = value ? "true" : "false"
        return [URLQueryItem(
          name: "sendemailalertwhencommented", value: encoded)]
      case let .sendEmailWhenPublished(value):
        let encoded = value ? "true" : "false"
        return [URLQueryItem(
          name: "sendemailalertwhenpublished", value: encoded)]
      }
    }
  }
}

extension BVConversationsSubmissionFieldTypes:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
        
      case let .additional(name, value):
        return [URLQueryItem(
          name: "additionalfield_\(name)", value: value)]
      case let .contextData(name, value):
        return [URLQueryItem(
          name: "contextdatavalue_\(name)", value: value)]
      case let .contextDataFalse(name):
        return [URLQueryItem(
          name: "contextdatavalue_\(name)", value: "false")]
      case let .contextDataTrue(name):
        return [URLQueryItem(
          name: "contextdatavalue_\(name)", value: "true")]
      case let .freeformTag(name, number, value):
        return [URLQueryItem(
          name: "tagid_\(name)_\(number)", value: value)]
      case let .predefinedTag(name, id, value):
        return [URLQueryItem(
          name: "tagid_\(name)/\(id)", value: value)]
      case let .rating(name, value):
        return [URLQueryItem(
          name: "rating_\(name)", value: "\(value)")]
      }
    }
  }
}

extension BVConversationsSubmissionHostedAuthenticated:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .hostedAuthCallback(value):
        guard let encoded = value.absoluteString.urlEncode() else {
          return nil
        }
        return [URLQueryItem(
          name: "hostedauthentication_callbackurl", value: encoded)]
      case let .hostedAuthEmail(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(
          name: "hostedauthentication_authenticationemail", value: encoded)]
      }
    }
  }
}

extension BVConversationsSubmissionLocale:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .locale(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(name: "locale", value: encoded)]
      }
    }
  }
}

extension BVConversationsSubmissionMedia:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .photos(value):
        var index: Int = 0
        return value.reduce([])
        { (result: [URLQueryItem], photo: BVPhoto) -> [URLQueryItem] in
          var items = result
          
          if let caption = photo.caption?.urlEncode(),
            let sizes = photo.photoSizes,
            let url = sizes.filter({ (photoSize: BVPhotoSize) -> Bool in
              guard let sizeId = photoSize.sizeId else {
                return false
              }
              return "normal" == sizeId.lowercased()
            }).first?.url?.absoluteString.urlEncode() {
            
            items += [
              URLQueryItem(name: "photourl_\(index)", value: url),
              URLQueryItem(name: "photocaption_\(index)", value: caption)
            ]
            
            index += 1
          }
          
          return items
        }
      case let .videos(value):
        var index: Int = 1
        return
          value.reduce([])
          { (result: [URLQueryItem], video: BVVideo) -> [URLQueryItem] in
            var items = result
            
            if let url = video.videoUrl?.absoluteString.urlEncode(),
              let caption = video.caption {
              
              items += [
                URLQueryItem(name: "VideoUrl_\(index)", value: url),
                URLQueryItem(name: "VideoCaption_\(index)", value: caption)
              ]
              
              index += 1
            }
            
            return items
        }
      }
    }
  }
}

extension BVConversationsSubmissionRating:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .comment(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(
          name: "netpromotercomment", value: encoded)]
      case let .score(value):
        
        let score = (0 < value) ?
          (10 > value) ?
            value : 10 : 1
        
        guard let encoded = "\(score)".urlEncode() else {
          return nil
        }
        return [URLQueryItem(
          name: "netpromoterscore", value: encoded)]
      case let .recommended(value):
        guard let encoded = (value ? "true" : "false").urlEncode() else {
          return nil
        }
        return [URLQueryItem(
          name: "isrecommended", value: encoded)]
      }
    }
  }
}

extension BVConversationsSubmissionTag:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .campaignId(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(name: "campaignid", value: encoded)]
      }
    }
  }
}

extension BVConversationsSubmissionTermsAndConditions:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .agree(value):
        let encoded = value ? "true" : "false"
        return
          [URLQueryItem(name: "agreedtotermsandconditions", value: encoded)]
      }
    }
  }
}

extension BVConversationsSubmissionUserInfo:
BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? {
    get {
      switch self {
      case let .email(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(name: "useremail", value: encoded)]
      case let .identifier(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(name: "userid", value: encoded)]
      case let .location(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(name: "userlocation", value: encoded)]
      case let .nickname(value):
        guard let encoded = value.urlEncode() else {
          return nil
        }
        return [URLQueryItem(name: "usernickname", value: encoded)]
      }
    }
  }
}


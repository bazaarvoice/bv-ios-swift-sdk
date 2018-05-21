//
//  BVConversationsSubmissionable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVConversationsSubmissionAction
public enum BVConversationsSubmissionAction {
  case preview
  case submit
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

public protocol BVConversationsSubmissionActionable {
  @discardableResult
  func add(_ action: BVConversationsSubmissionAction) -> Self
}

// MARK: - BVConversationsSubmissionUserAuthenticatedString
public enum BVConversationsSubmissionUserAuthenticatedString {
  case uas(String)
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

public protocol BVConversationsSubmissionUserAuthenticatedStringable {
  @discardableResult
  func add(_ uas: BVConversationsSubmissionUserAuthenticatedString) -> Self
}

// MARK: - BVConversationsSubmissionAuthenticity
public enum BVConversationsSubmissionAuthenticity {
  case fingerprint(String)
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

public protocol BVConversationsSubmissionAuthenticityable {
  @discardableResult
  func add(_ authenticity: BVConversationsSubmissionAuthenticity) -> Self
}

// MARK: - BVConversationsSubmissionAlerts
public enum BVConversationsSubmissionAlerts {
  case sendEmailWhenCommented(Bool)
  case sendEmailWhenPublished(Bool)
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

public protocol BVConversationsSubmissionAlertable {
  @discardableResult
  func add(_ alert: BVConversationsSubmissionAlerts) -> Self
}

// MARK: - BVConversationsSubmissionFieldTypes
public enum BVConversationsSubmissionFieldTypes {
  case additional(name: String, value: String)
  case contextData(name: String, value: String)
  case contextDataFalse(name: String)
  case contextDataTrue(name: String)
  case freeformTag(name: String, number: Int, value: String)
  case predefinedTag(name: String, id: String, value: String)
  case rating(name: String, value: CustomStringConvertible)
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

public protocol BVConversationsSubmissionFieldTypeable {
  @discardableResult
  func add(_ fieldType: BVConversationsSubmissionFieldTypes) -> Self
}

// MARK: - BVConversationsSubmissionCustomizeable
public protocol BVConversationsSubmissionCustomizeable {
  @discardableResult
  func add(_ customFields: [String : String]) -> Self
}

// MARK: - BVConversationsSubmissionHostedAuthenticated
public enum BVConversationsSubmissionHostedAuthenticated {
  case hostedAuthCallback(URL)
  case hostedAuthEmail(String)
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

public protocol BVConversationsSubmissionHostedAuthenticatable {
  @discardableResult
  func add(_ hostedAuth: BVConversationsSubmissionHostedAuthenticated) -> Self
}

// MARK: - BVConversationsSubmissionLocale
public enum BVConversationsSubmissionLocale {
  case locale(String)
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

public protocol BVConversationsSubmissionLocaleable {
  @discardableResult
  func add(_ locale: BVConversationsSubmissionLocale) -> Self
}

// MARK: - BVConversationsSubmissionMedia
public enum BVConversationsSubmissionMedia {
  case photos([BVPhoto])
  case videos([BVVideo])
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

public protocol BVConversationsSubmissionMediable {
  @discardableResult
  func add(_ media: BVConversationsSubmissionMedia) -> Self
}

// MARK: - BVConversationsSubmissionParameterable
internal protocol BVConversationsSubmissionParameterable {
  var urlQueryItems: [URLQueryItem]? { get }
}

// MARK: - BVConversationsSubmissionRating
public enum BVConversationsSubmissionRating {
  case comment(String)
  case score(UInt)
  case recommended(Bool)
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

public protocol BVConversationsSubmissionRatable {
  @discardableResult
  func add(_ rate: BVConversationsSubmissionRating) -> Self
}

// MARK: - BVConversationsSubmissionTag
public enum BVConversationsSubmissionTag {
  case campaignId(String)
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

public protocol BVConversationsSubmissionTaggable {
  @discardableResult
  func add(_ tag: BVConversationsSubmissionTag) -> Self
}

// MARK: - BVConversationsSubmissionTermsAndConditions
public enum BVConversationsSubmissionTermsAndConditions {
  case agree(Bool)
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

public protocol BVConversationsSubmissionTermsAndConditionsable {
  @discardableResult
  func add(
    _ termsAndConditions: BVConversationsSubmissionTermsAndConditions) -> Self
}


// MARK: - BVConversationsSubmissionUserInfo
public enum BVConversationsSubmissionUserInfo {
  case email(String)
  case identifier(String)
  case location(String)
  case nickname(String)
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

public protocol BVConversationsSubmissionUserInformationable {
  @discardableResult
  func add(_ userInfo: BVConversationsSubmissionUserInfo) -> Self
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

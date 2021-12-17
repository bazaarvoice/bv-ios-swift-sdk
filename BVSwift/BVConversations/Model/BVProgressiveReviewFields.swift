//
//
//  BVProgressiveReviewFields.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVProgressiveReviewFields: BVAuxiliaryable {
    
    public var rating: Int?
    public var title: String?
    public var reviewtext: String?
    public var agreedToTerms: Bool?
    public var isRecommended: Bool?
    public var sendEmailAlert: Bool?
    public var hostedAuthenticationEmail: String?
    public var hostedAuthenticationCallbackurl: String?
  

    private enum CodingKeys: String, CodingKey {
        case rating = "rating"
        case title = "title"
        case reviewtext = "reviewtext"
        case agreedToTerms = "agreedtotermsandconditions"
        case isRecommended = "isrecommended"
        case sendEmailAlert = "sendemailalertwhenpublished"
        case hostedAuthenticationEmail = "hostedauthentication_authenticationemail"
        case hostedAuthenticationCallbackurl = "hostedauthentication_callbackurl"
    }
    
    //To make accessable by CocoaPods
    public init() {}
}

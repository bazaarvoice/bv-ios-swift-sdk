//
//
//  BVMultiProductReviewSummary.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVMultiProductReviewSummary: BVAuxiliaryable {
    
    public let submissionId: String?
    public let title: String?
    public let reviewtext: String?
    public let rating: Int?
    public let buyagain: Bool?
    public let productExternalId: String?
    public let submissionTime: String?

    private enum CodingKeys: String, CodingKey {
        case submissionId = "submissionID"
        case title = "title"
        case reviewtext = "reviewtext"
        case rating = "rating"
        case buyagain = "buyagain"
        case productExternalId = "productExternalID"
        case submissionTime = "submissionTime"
        
    }
}


public struct BVProgressiveReviewSummary: BVAuxiliaryable {
    public let title: String?
    public let reviewtext: String?
    public let rating: Int?
    public let isRecommended: Bool?
    public let sendPublishedEmailAlert: Bool?
    public let sendCommentedEmailAlert: Bool?
    public let submissionTime: String?

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case reviewtext = "ReviewText"
        case rating = "Rating"
        case isRecommended = "IsRecommended"
        case sendPublishedEmailAlert = "SendEmailAlertWhenPublished"
        case sendCommentedEmailAlert = "SendEmailAlertWhenCommented"
        case submissionTime = "SubmissionTime"
    }
}

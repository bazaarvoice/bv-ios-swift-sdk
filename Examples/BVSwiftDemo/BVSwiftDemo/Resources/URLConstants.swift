//
//  Constants.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 06/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class URLConstants {
    
    static let curationsPhotoPostUrlMatch = "bazaarvoice.com/curations/content/get"
    static let curationsUrlMatch = "https://api.bazaarvoice.com/curations/c3/content/"
    static let recommendationsUrlMatch = "bazaarvoice.com/recommendations"
    static let profileUrlMatch = "bazaarvoice.com/users"
    static let analyticsMatch = "bazaarvoice.com/event"
    static let conversationsMatchReview = "bazaarvoice.com/data/reviews"
    static let conversationsQuestionsMatch = "bazaarvoice.com/data/question"
    static let conversationsProductMatch = "bazaarvoice.com/data/products"
    static let conversationsAuthorsMatch = "bazaarvoice.com/data/authors"
    static let conversationsReviewHighlightsMatch = "bazaarvoice.com/highlights"
    static let submitReviewMatch = "bazaarvoice.com/data/submitreview"
    static let submitReviewPhotoMatch = "bazaarvoice.com/data/uploadphoto"
    static let submitQuestionMatch = "bazaarvoice.com/data/submitquestion"
    static let submitAnswerMatch = "bazaarvoice.com/data/submitanswer"
    static let pinRequestMatch = "bazaarvoice.com/pin/toreview"
    
}

class User {
    static let local = "en_US"
    static let id = "123abc\(arc4random())"
}

class AlertMessage {
    static let successMessage = "Your review was submitted. It may take up to 72 hours for us to respond."
}

class AlertTitle {
    static let error = "Error!"
    static let success = "Success!"
    
    static let okay = "Okay"
}
class ErrorMessage {
    static let reviewTitleEmptyError = "Please enter review title."
    static let ratingEmptyError = "Please give ratings"
    
    static let reviewDetailEmptyError = "Please enter review details."
    static let userNicknameEmptyError = "Please enter user nickname."
    
    static let emailAddressEmptyError = "Please enter email address."
    static let emailAddressInvalidError = "Please enter a valid email address."
    
    static let validationError = "Validation Error"
}

class UserFormConstants {
    static let recommendProductSwitchKey = "recommendProductSwitch"
    static let recommendProductSwitchText = "I recommend this product."
    
    static let ratingStarsKey = "ratingStars"
    static let ratingStarsTitle = "Rate this product"
    static let ratingStarText = ""
    
    
    static let reviewTitleFieldKey = "reviewTitle"
    static let reviewTitleFieldTitle = "Review Title"
    static let reviewTitleFieldText = "Add your review title"
    
    static let reviewDetailsFieldKey = "reviewDetails"
    static let reviewDetailsFieldTitle = "Your Review"
    static let reviewDetailsFieldText = "Add your thoughts and experinces with this product."
    
    static let userNicknameFieldKey = "userNickname"
    static let userNicknameFieldTitle = "Nickname"
    static let userNicknameFieldText = "Display name for the question"
    
    static let userEmailFieldKey = "userEmail"
    static let userEmailFieldTitle = "Email address"
    static let userEmailFieldText = "Enter a valid email address."
    
    static let photoKey = "photo"
    static let photoTitle = "Add a photo (optional)"
    
    static let sendEmailAlertWhenPublishedFieldKey = "sendEmailAlertWhenPublished"
    static let sendEmailAlertWhenPublishedFieldTitle = "May we contact you at this email address?"
    static let sendEmailAlertWhenPublishedFieldText = "Send me status by email?"
}

class AppConstants {
    static let appName = "bazaarvoice:"
}

class ViewControllerTittles {
    static let write_a_Review = "Write a Review"
}

class NavigationBarButtonNames {
    static let write_a_Review = "Write a Review"
    static let submit = "Submit"
}

class Headers {
    static let header = ["Content-Type": "application/json"]
    static let header_utf8 = ["Content-Type": "application/json;charset=utf-8"]
}

class AdKey {
    static let adUnitId = "/5705/bv-incubator/IncubatorEnduranceCycles"
}

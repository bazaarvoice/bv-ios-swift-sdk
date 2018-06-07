//
//  RootViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class RootViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.barTintColor = UIColor.white
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  @IBAction func submitReviewTapped(sender: AnyObject) {
    
    guard let reviewSubmission = BVManager.sharedManager.submission(productId: Constants.TEST_PRODUCT_ID,
                                                                    reviewText: "Review text...This needs to be long enough to be accepted.",
                                                                    reviewTitle: "Review Title",
                                                                    reviewRating: 5) else {
                                                                      return
    }
    
    // We need to use the same userId for both the photo post and review content
    let userId = "123abc\(arc4random())"
    
    if let photo = UIImage(named: "puppy") {
      let bvPhoto: BVPhoto = BVPhoto(photo, "5 star pup!")
      reviewSubmission.add(.photos([bvPhoto]))
    }
    
    // add youtube video link, if your configuration supports it
    if let videoURL = URL(string: "https://www.youtube.com/watch?v=oHg5SJYRHA0") {
      let video: BVVideo =
        BVVideo(videoURL,
                caption: "All your wildest dreams will come true.")
      reviewSubmission.add(.videos([video]))
    }
    
    // a working example of posting a review.
    reviewSubmission
      .add(.preview) // Don't actually post, just run in preview mode!
      .add(.nickname(userId))
      .add(.email("foo@bar.com"))
      .add(.identifier(userId))
      .add(.recommended(true))
      .add(.sendEmailWhenPublished(true))
      .handler(completion: { response in
        
        if case let .failure(errors) = response,
          let firstError = errors.first {
          self.showAlertError(message: firstError.localizedDescription)
          return
        }
        
        guard case .success = response else {
          self.showAlertError(message: "No valid response object?")
          return
        }
        
        self.showAlertSuccess(message: "Success Submitting Review!")
        
      }).async()
  }
  
  @IBAction func submitQuestionTapped(sender: AnyObject) {
    
    guard let questionSubmission = BVManager.sharedManager.submission(productId: Constants.TEST_PRODUCT_ID,
                                                                      questionDetails: "Question details...",
                                                                      questionSummary: "Question Summary") else {
                                                                        return
    }
    
    let userId = "123abc\(arc4random())"
    
    questionSubmission
      .add(.preview)
      .add(.email("foo@bar.com"))
      .add(.identifier(userId))
      .add(.nickname(userId))
      .add(.sendEmailWhenPublished(true))
      .add(.agree(true))
      .handler(completion: { response in
        if case let .failure(errors) = response,
          let firstError = errors.first {
          self.showAlertError(message: firstError.localizedDescription)
          return
        }
        
        guard case .success = response else {
          self.showAlertError(message: "No valid response object?")
          return
        }
        
        self.showAlertSuccess(message: "Success Submitting Question!")
      }).async()
  }
  
  @IBAction func submitAnswerTapped(sender: AnyObject) {
    
    guard let answerSubmission = BVManager.sharedManager.submission(answerQuestionId: "14679", answerText: "User answer text goes here....") else {
      return
    }
    
    let userId = "123abc\(arc4random())"
    
    answerSubmission
      .add(.preview)
      .add(.email("foo@bar.com"))
      .add(.identifier(userId))
      .add(.nickname(userId))
      .add(.sendEmailWhenPublished(true))
      .handler(completion: { response in
        if case let .failure(errors) = response,
          let firstError = errors.first {
          self.showAlertError(message: firstError.localizedDescription)
          return
        }
        
        guard case .success = response else {
          self.showAlertError(message: "No valid response object?")
          return
        }
        
        self.showAlertSuccess(message: "Success Submitting Answer!")
      }).async()
  }
  
  @IBAction func submitFeedbackTapped(sender: AnyObject) {
    
    let feedback: BVFeedback = .helpfulness(vote: .positive, authorId: "userId" + String(arc4random()), contentId: "192451", contentType: .review)
    
    guard let feedbackSubmission = BVManager.sharedManager.submission(feedback) else {
      return
    }
    
    feedbackSubmission
      .handler(completion: { response in
        if case let .failure(errors) = response,
          let firstError = errors.first {
          self.showAlertError(message: firstError.localizedDescription)
          return
        }
        
        guard case .success = response else {
          self.showAlertError(message: "No valid response object?")
          return
        }
        
        self.showAlertSuccess(message: "Success Submitting Feedback!")
      }).async()
  }
  
  @IBAction func submitReviewCommentTapped(sender: AnyObject) {
    
    let randomId = String(arc4random()) // create a random id for testing only
    let commentText = "I love comments! They are just the most! Seriously!"
    let commentTitle = "Best Comment Title Ever!"
    guard let commentSubmission = BVManager.sharedManager.submission(reviewId: "192548", commentText: commentText, commentTitle: commentTitle) else {
      return
    }
    
    commentSubmission
      
      // Some PRR clients may support adding photos, check your configuration
      //        if let photo = UIImage(named: "puppy") {
      //            let bvPhoto: BVPhoto = BVPhoto(photo, "Review Comment Pupper!")
      //            commentRequest.add(photos([bvPhoto]))
      //        }
      
      .add(.preview)
      .add(.campaignId("BV_COMMENT_CAMPAIGN_ID"))
      .add(.locale("en_US"))
      .add(.sendEmailWhenPublished(true))
      .add(.nickname("UserNickname" + randomId))
      .add(.identifier("UserId" + randomId))
      .add(.email("developer@bazaarvoice.com"))
      .add(.agree(true))
      //.add(.fingerprint(<<FINGERPRINT>>)) // the iovation fingerprint would go here...
      .handler(completion: { response in
        if case let .failure(errors) = response,
          let firstError = errors.first {
          self.showAlertError(message: firstError.localizedDescription)
          return
        }
        
        guard case .success = response else {
          self.showAlertError(message: "No valid response object?")
          return
        }
        
        self.showAlertSuccess(message: "Success Submitting Review Comment!")
      }).async()
  }
  
  
  func showAlertSuccess(message : String){
    
    let alert = UIAlertController(title: "Success!", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func showAlertError(message : String){
    
    let alert = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
}

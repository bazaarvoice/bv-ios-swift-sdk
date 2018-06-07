//
//  ViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift


class ReviewsViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var reviewsTableView : BVReviewsTableView!
  var reviews : [BVReview] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    reviewsTableView.dataSource = self
    reviewsTableView.estimatedRowHeight = 44
    reviewsTableView.rowHeight = UITableViewAutomaticDimension
    reviewsTableView.register(UINib(nibName: "MyReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MyReviewTableViewCell")
    
    guard let reviewQuery =
      BVManager.sharedManager.query(reviewProductId: Constants.TEST_PRODUCT_ID, limit: 20, offset: 0) else {
        return
    }
    
    reviewQuery
    .sort(.submissionTime, order: .descending)
    .include(.comments)
    .handler(completion: { response in
      if case let .failure(errors) = response {
        print(errors)
        return
      }
      
      guard case let .success(_, results) = response else {
        return
      }
      
      self.reviews = results
      
      DispatchQueue.main.async {
        self.reviewsTableView.reloadData()
      }
      
    }).async()
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Review Responses"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let tableCell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell") as! MyReviewTableViewCell
    
    tableCell.bvType = reviews[indexPath.row]
    
    return tableCell
  }
  
}

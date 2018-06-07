//
//  InlineRatingsViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class InlineRatingsViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var inlineReviewsTableView: UITableView!
  
  var productStatistics = [BVProductStatistics]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    inlineReviewsTableView.dataSource = self
    inlineReviewsTableView.estimatedRowHeight = 68
    inlineReviewsTableView.rowHeight = UITableViewAutomaticDimension
    inlineReviewsTableView.register(UINib(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: "StatisticTableViewCell")
    
    guard let productStatisticsQuery = BVManager.sharedManager.query(productIds: Constants.TEST_PRODUCT_IDS_ARRAY) else {
      return
    }
    
    productStatisticsQuery
      .stats(.nativeReviews)
      .stats(.reviews)
      .handler(completion: { response in
        if case let .failure(errors) = response {
          print(errors)
          return
        }
        
        guard case let .success(_, results) = response else {
          return
        }
        self.productStatistics = results
        
        DispatchQueue.main.async {
          self.inlineReviewsTableView.reloadData()
        }
      }).async()
  }
  
  // MARK: UITableViewDatasource
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Inline Review Responses"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return productStatistics.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticTableViewCell")! as! StatisticTableViewCell
    
    cell.statTypeLabel.text = "Product Id: " + productStatistics[indexPath.row].productId!
    cell.statValueLabel.text = "Total Review Count(\(productStatistics[indexPath.row].reviewStatistics?.totalReviewCount ?? -1)), \nAverage Overall Rating(\(productStatistics[indexPath.row].reviewStatistics?.averageOverallRating ?? -1)), \nOverall Rating Range(\(productStatistics[indexPath.row].reviewStatistics?.overallRatingRange ?? -1)) "
    
    return cell
  }
  
}

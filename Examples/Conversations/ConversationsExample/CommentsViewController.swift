//
//  CommentsViewController.swift
//  
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class CommentsViewController: UIViewController, UITableViewDataSource {
  
  
  @IBOutlet weak var commentsTaleView: UITableView!
  var comments : [BVComment] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    commentsTaleView.dataSource = self
    commentsTaleView.estimatedRowHeight = 44
    commentsTaleView.rowHeight = UITableViewAutomaticDimension
    commentsTaleView.register(UINib(nibName: "MyCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCommentTableViewCell")
    
    let limit : UInt16  = 99
    let offset : UInt16 = 0
    guard let commentsQuery = BVManager.sharedManager.query(commentProductId: Constants.TEST_REVIEW_PRODUCT_ID_FOR_COMMENTS, commentReviewId: Constants.TEST_REVIEW_ID_FOR_COMMENTS, limit: limit, offset: offset) else {
      return
    }
    
    commentsQuery.handler(completion: { response in
      if case let .failure(errors) = response,
        let firstError = errors.first {
        print("ERROR fetching comments: \(firstError.localizedDescription)")
        return
      }
      
      guard case let .success(_, results) = response else {
        return
      }
      
      self.comments = results
      
      DispatchQueue.main.async {
        self.commentsTaleView.reloadData()
      }
    }).async()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableViewDatasource
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Available Comments"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let tableCell = tableView.dequeueReusableCell(withIdentifier: "MyCommentTableViewCell") as! MyCommentTableViewCell
    
    tableCell.comment = comments[indexPath.row]
    
    return tableCell
  }
}

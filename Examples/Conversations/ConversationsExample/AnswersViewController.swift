//
//  AnswersViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class AnswersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  @IBOutlet weak var answersTableView: BVAnswersTableView!
  var answers : [BVAnswer]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    answersTableView.dataSource = self
    answersTableView.delegate = self
    answersTableView.estimatedRowHeight = 68
    answersTableView.rowHeight = UITableViewAutomaticDimension
    answersTableView.register(UINib(nibName: "MyAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAnswerTableViewCell")
    
  }
  
  // MARK: UITableViewDatasource
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Answer Responses"
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let ans = answers else {
      return 0
    }
    return ans.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let ans = answers else {
      return MyAnswerTableViewCell()
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyAnswerTableViewCell")! as! MyAnswerTableViewCell
    
    cell.bvType = ans[indexPath.row];
    
    return cell
  }
}


//
//  QuestionsViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class QuestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  @IBOutlet weak var questionsTableView : BVQuestionsTableView!
  var questions : [BVQuestion] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    questionsTableView.dataSource = self
    questionsTableView.delegate = self
    questionsTableView.estimatedRowHeight = 80
    questionsTableView.rowHeight = UITableViewAutomaticDimension
    questionsTableView.register(UINib(nibName: "MyQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyQuestionTableViewCell")
    
    guard let questionsRequest = BVManager.sharedManager.query(questionProductId: Constants.TEST_PRODUCT_ID, limit: 20, offset: 0) else {
      return
    }
    
    questionsRequest
      // optionally add in a sort option
      .sort(.submissionTime, order: .ascending)
      // optionally add in a filter
      .filter(.hasAnswers, op: .equalTo, value: "true")
      .handler(completion: { response in
        if case let .failure(errors) = response {
          print(errors)
          return
        }
        
        guard case let .success(_, results) = response else {
          return
        }
        
        self.questions = results
        
        DispatchQueue.main.async {
          self.questionsTableView.reloadData()
        }
      }).async()
  }
  
  // MARK: UITableViewDatasource
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Question Responses"
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return questions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuestionTableViewCell")! as! MyQuestionTableViewCell
    
    cell.bvType = questions[indexPath.row];
    
    return cell
  }
  
  // MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Get the answers for this question
    let question = questions[indexPath.row]
    guard let answers = question.answers,
      0 < answers.count else {
        return
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let answersVC = storyboard.instantiateViewController(withIdentifier: "AnswersViewController") as! AnswersViewController
    answersVC.answers = answers
    self.navigationController?.pushViewController(answersVC, animated: true)
  }
}

//
//  PDPViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class PDPViewController: BVProductDisplayPageViewController, UITableViewDataSource {
  
  @IBOutlet weak var demoStatsTableView: UITableView!
  
  var reviewStats: BVReviewStatistics?
  var questionAnswerStats: BVQAStatistics?
  
  enum StatSections : Int {
    case ReviewStats
    case QAStats
    
    static var count: Int { return StatSections.QAStats.rawValue + 1 }
  }
  
  enum ReviewStateRows : Int {
    case TotalReviewCount
    case AverageOverallRating
    case HelpfulVoteCount
    case NotHelpfulVoteCount
    case RecommendedCount
    case NotRecommendedCount
    case OverallRatingRange
    
    static var count: Int { return ReviewStateRows.OverallRatingRange.rawValue + 1 }
  }
  
  enum QAStatRows : Int {
    case TotalQuestions
    case TotalAnswers
    case AnswerHelpfulVoteCount
    case AnswerNotHelpfulVoteCount
    case QuestionHelpfulVoteCount
    case QuestionNotHelpfulVoteCount
    
    static var count: Int { return QAStatRows.QuestionNotHelpfulVoteCount.rawValue + 1 }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    demoStatsTableView.estimatedRowHeight = 80
    demoStatsTableView.rowHeight = UITableViewAutomaticDimension
    demoStatsTableView.register(UINib(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: "StatisticTableViewCell")
    
    guard let productQuery = BVManager.sharedManager.query(productId:  Constants.TEST_PRODUCT_ID) else {
      return
    }
    
    productQuery
      .stats(.answers)
      .stats(.questions)
      .stats(.reviews)
      .include(.questions, limit: 10) // Include 10 Questions
      .sort(.questions(.totalAnswerCount), order: .descending) // For the included answers, add by most answers, descending.
      .handler(completion: { response in
        if case let .failure(errors) = response {
          print(errors)
          return
        }
        
        guard case let .success(_, results) = response,
          let product: BVProduct = results.first else {
            return
        }
        
        self.reviewStats = product.reviewStatistics
        self.questionAnswerStats = product.qaStatistics
        
        DispatchQueue.main.async {
          self.demoStatsTableView.reloadData()
        }
      }).async()
  }
  
  // MARK: UITableViewDatasource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return StatSections.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case StatSections.ReviewStats.rawValue:
      return "Product Review Statistics"
    case StatSections.QAStats.rawValue:
      return "Product Question & Answer Statistics"
    default:
      return ""
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch (section, reviewStats, questionAnswerStats) {
    case (StatSections.ReviewStats.rawValue, .some, _):
      return ReviewStateRows.count
    case (StatSections.QAStats.rawValue, _, .some):
      return QAStatRows.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticTableViewCell")! as! StatisticTableViewCell
    
    switch (indexPath.section, reviewStats, questionAnswerStats) {
      
    case let (StatSections.ReviewStats.rawValue, .some(review), _):
      
      switch indexPath.row {
      case ReviewStateRows.TotalReviewCount.rawValue:
        cell.statTypeLabel.text = "Total Review Count"
        cell.statValueLabel.text = "\(review.totalReviewCount ?? -1)"
      case ReviewStateRows.AverageOverallRating.rawValue:
        cell.statTypeLabel.text = "Average Overall Rating"
        cell.statValueLabel.text = "\(review.averageOverallRating ?? -1)"
      case ReviewStateRows.HelpfulVoteCount.rawValue:
        cell.statTypeLabel.text = "Helpful Vote Count"
        cell.statValueLabel.text = "\(review.helpfulVoteCount ?? -1)"
      case ReviewStateRows.NotHelpfulVoteCount.rawValue:
        cell.statTypeLabel.text = "Not Helpful Vote Count"
        cell.statValueLabel.text = "\(review.notHelpfulVoteCount ?? -1)"
      case ReviewStateRows.RecommendedCount.rawValue:
        cell.statTypeLabel.text = "Recommended Count"
        cell.statValueLabel.text = "\(review.recommendedCount ?? -1)"
      case ReviewStateRows.NotRecommendedCount.rawValue:
        cell.statTypeLabel.text = "Not Recommeded Count"
        cell.statValueLabel.text = "\(review.notRecommendedCount ?? -1)"
      case ReviewStateRows.OverallRatingRange.rawValue:
        cell.statTypeLabel.text = "Overall Rating Range"
        cell.statValueLabel.text = "\(review.overallRatingRange ?? -1)"
      default:
        cell.statTypeLabel.text = "Error"
        cell.statValueLabel.text = "Error"
      }
      
    case let (StatSections.QAStats.rawValue, _, .some(question)):
      
      switch indexPath.row {
      case QAStatRows.TotalQuestions.rawValue:
        cell.statTypeLabel.text = "Total Question Count"
        cell.statValueLabel.text = "\(question.totalQuestionCount ?? -1)"
      case QAStatRows.TotalAnswers.rawValue:
        cell.statTypeLabel.text = "Total Answer Count"
        cell.statValueLabel.text = "\(question.totalAnswerCount ?? -1)"
      case QAStatRows.AnswerHelpfulVoteCount.rawValue:
        cell.statTypeLabel.text = "Answer Helpful Vote Count"
        cell.statValueLabel.text = "\(question.answerHelpfulVoteCount ?? -1)"
      case QAStatRows.AnswerNotHelpfulVoteCount.rawValue:
        cell.statTypeLabel.text = "Answer Not Helpful Vote Count"
        cell.statValueLabel.text = "\(question.answerNotHelpfulVoteCount ?? -1)"
      case QAStatRows.QuestionHelpfulVoteCount.rawValue:
        cell.statTypeLabel.text = "Question Helpful Vote Count"
        cell.statValueLabel.text = "\(question.questionHelpfulVoteCount ?? -1)"
      case QAStatRows.QuestionNotHelpfulVoteCount.rawValue:
        cell.statTypeLabel.text = "Question Not Helpful Vote Count"
        cell.statValueLabel.text = "\(question.questionNotHelpfulVoteCount ?? -1)"
      default:
        cell.statTypeLabel.text = "Error"
        cell.statValueLabel.text = "Error"
      }
      
    default:
      print("Bad section provided for stats table view")
    }
    
    return cell
  }
}

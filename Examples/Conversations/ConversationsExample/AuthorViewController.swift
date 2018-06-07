//
//  AuthorViewController.swift
//  ConversationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class AuthorViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var authorProfileTableView: UITableView!
  
  var authorResponse : BVConversationsQueryResponse<BVAuthor>?
  
  enum AuthorSections : Int {
    case ProfileStats
    case IncludedReviews
    case IncludedQuestions
    case IncludedAnswers
    
    static var count: Int { return AuthorSections.IncludedAnswers.hashValue + 1}
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    authorProfileTableView.estimatedRowHeight = 80
    authorProfileTableView.rowHeight = UITableViewAutomaticDimension
    authorProfileTableView.register(UINib(nibName: "StatisticTableViewCell", bundle: nil), forCellReuseIdentifier: "StatisticTableViewCell")
    authorProfileTableView.register(UINib(nibName: "MyReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "MyReviewTableViewCell")
    authorProfileTableView.register(UINib(nibName: "MyQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "MyQuestionTableViewCell")
    authorProfileTableView.register(UINib(nibName: "MyAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAnswerTableViewCell")
    
    guard let authorQuery = BVManager.sharedManager.query(authorId: Constants.TEST_AUTHOR_ID) else {
      return
    }
    
    authorQuery
      // stats includes
      .stats(.answers)
      .stats(.questions)
      .stats(.reviews)
      // other includes
      .include(.reviews, limit: 10)
      .include(.questions, limit: 10)
      .include(.answers, limit: 10)
      // sorts
      .sort(.answers(.submissionTime), order: .descending)
      .sort(.reviews(.submissionTime), order: .descending)
      .sort(.questions(.submissionTime), order: .descending)
      .handler(completion: { response in
        if case let .failure(errors) = response {
          print(errors)
          return
        }
        
        print(response)
        self.authorResponse = response
        
        DispatchQueue.main.async {
          self.authorProfileTableView.reloadData()
        }
      }).async()
  }
  
  // MARK: UITableViewDatasource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return AuthorSections.count;
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    switch section {
    case AuthorSections.ProfileStats.rawValue:
      return "Author Profile Stats"
    case AuthorSections.IncludedReviews.rawValue:
      return "Included Reviews"
    case AuthorSections.IncludedAnswers.rawValue:
      return "Included Answers"
    case AuthorSections.IncludedQuestions.rawValue:
      return "Included Questions"
    default:
      return ""
    }
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let response = authorResponse,
      case let .success(_, authors) = response,
      let author = authors.first {
      switch section {
      case AuthorSections.ProfileStats.rawValue:
        return 1;
      case AuthorSections.IncludedReviews.rawValue:
        return (author.reviews?.count ?? 0)
      case AuthorSections.IncludedQuestions.rawValue:
        return (author.questions?.count ?? 0)
      case AuthorSections.IncludedAnswers.rawValue:
        return (author.answers?.count ?? 0)
      default:
        return 0
      }
    }
    else {
      print("Error: No results to display")
      return 0
    }
  }
  
  func createAuthorStats(author: BVAuthor) -> String {
    
    var result = ""
    
    result += "Stats for: " + (author.userNickname ?? "N/A") + "\n"
    result += "Location: " + (author.userLocation ?? "N/A") + "\n"
    
    if let reviewStatistics = author.reviewStatistics,
      let totalReviewCount = reviewStatistics.totalReviewCount {
      result += "Reviews (\(totalReviewCount))" + "\n"
    }
    
    if let qaStatistics = author.qaStatistics,
      let totalQuestionCount = qaStatistics.totalQuestionCount,
      let totalAnswerCount = qaStatistics.totalAnswerCount {
      result += "Questions (\(totalQuestionCount))" + "\n"
      result += "Answers (\(totalAnswerCount))" + "\n"
    }
    
    if let contextDataValues = author.contextDataValues {
      result += "Context Data Values: (\(contextDataValues.count))"
      for contextData in contextDataValues {
        guard let identifier = contextData.contextDataValueId,
          let value = contextData.value else {
            continue
        }
        result += "[" + identifier + ":" + value + "]"
      }
    }
    
    result += "\n"
    
    if let badges = author.badges {
      result += "Badges (\(badges.count))"
      
      for badge in badges {
        guard let identifier = badge.badgeId,
          let contentType = badge.contentType else {
            continue
        }
        result += "[" + identifier + ":" + contentType + "]"
      }
      
      result += "\n"
    }
    
    return result
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let response = authorResponse,
      case let .success(_, authors) = response,
      let author = authors.first {
      
      switch indexPath.section {
      case AuthorSections.ProfileStats.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticTableViewCell")! as! StatisticTableViewCell
        cell.statTypeLabel.text = "Author Statistics";
        cell.statValueLabel.text = self.createAuthorStats(author: author)
        return cell
      case AuthorSections.IncludedReviews.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell")! as! MyReviewTableViewCell
        cell.bvType = author.reviews?[indexPath.row]
        return cell
      case AuthorSections.IncludedQuestions.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuestionTableViewCell")! as! MyQuestionTableViewCell
        cell.bvType = author.questions?[indexPath.row]
        cell.accessoryType = .none
        return cell
      case AuthorSections.IncludedAnswers.rawValue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAnswerTableViewCell")! as! MyAnswerTableViewCell
        cell.bvType = author.answers?[indexPath.row]
        return cell
      default:
        return UITableViewCell()
      }
    }
    return UITableViewCell()
  }
}

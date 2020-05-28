//
//  QuestionsViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 27/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift

protocol QuestionsViewModelDelegate: class {
    func fetchQuestions()
}

class QuestionsViewModel: ViewModelType {
    
    weak var viewController: QuestionsTableViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private var questions: [BVQuestion]?
}

// MARK:- QuestionsViewModelDelegate
extension QuestionsViewModel: QuestionsViewModelDelegate {
    
    func fetchQuestions() {
        
        let questionQuery = BVQuestionQuery(productId: "test1",
                                            limit: 10,
                                            offset: 0)
            .configure(ConfigurationManager.sharedInstance.config)
            .handler { (response: BVConversationsQueryResponse<BVQuestion>) in
                
                if case .failure(let error) = response {
                  print(error)
                    // TODO:- show alert
                  return
                }
                
                guard case let .success(_, questions) = response else {
                    // TODO:- show alert
                  return
                }
                
                self.questions = questions
        }
        
        questionQuery.async()
    }
}

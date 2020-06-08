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
    
    var numberOfSections: Int { get }
    
    var numberOfRows: Int { get }
    
    func questionForRowAtIndexPath(_ indexPath: IndexPath) -> BVQuestion?
    
    func askQuestionTapped()
    
}

class QuestionsViewModel: ViewModelType {
    
    weak var viewController: QuestionsTableViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private var questions: [BVQuestion]?
    
    private let productId: String
    
    init(productId: String) {
        self.productId = productId
    }
}

// MARK:- QuestionsViewModelDelegate
extension QuestionsViewModel: QuestionsViewModelDelegate {
    
    func questionForRowAtIndexPath(_ indexPath: IndexPath) -> BVQuestion? {
        
        guard let question = self.questions?[indexPath.row] else {
            return nil
        }
        
        return question
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return self.questions?.count ?? 0
    }
    
    func fetchQuestions() {
        
        guard let delegate = self.viewController else { return }
        
        delegate.showLoadingIndicator()
        
        let questionQuery = BVQuestionQuery(productId: self.productId,
                                            limit: 10,
                                            offset: 0)
            .include(.answers)
            .include(.products)
            .filter(((.hasAnswers(true), .equalTo)))
            .configure(ConfigurationManager.sharedInstance.config)
            .handler { [weak self] (response: BVConversationsQueryResponse<BVQuestion>) in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    delegate.hideLoadingIndicator()
                    
                    if case .failure(let errors) = response {
                        let errorMessage = (errors.first as? BVError)?.message ?? "Something went wrong."
                        strongSelf.coordinator?.showAlert(title: "", message: errorMessage, handler: {
                            strongSelf.coordinator?.popBack()
                        })
                        return
                    }
                    
                    guard case let .success(_, questions) = response else {
                        strongSelf.coordinator?.showAlert(title: "", message: "Something went wrong.", handler: {
                            strongSelf.coordinator?.popBack()
                        })
                        return
                    }
                    
                    strongSelf.questions = questions
                    delegate.reloadTableView()

                }
        }
        
        questionQuery.async()
    }
    
    func askQuestionTapped() {
        // TODO:- Navigate to Submit a Question screen
    }
}

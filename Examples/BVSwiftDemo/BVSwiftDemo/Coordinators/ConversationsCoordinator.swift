//
//  ConversationsCoordinator.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit

class ConversationsCoordinator: Coordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        
        super.start()
        
        // 1. Create View Controller
        let conversationsAPIListViewController = ConversationsAPIListViewController.instantiate()
        conversationsAPIListViewController.navigationItem.title = "Conversations APIs"
        
        // 2. Create View Model
        let viewModel = ConversationsAPIListViewModel()
        viewModel.viewController = conversationsAPIListViewController
        viewModel.coordinator = self
        
        // 3. Assign View Model and Push View Controller
        conversationsAPIListViewController.viewModel = viewModel
        self.navigationController.pushViewController(conversationsAPIListViewController, animated: true)
    }
    
    override func navigateTo(_ scene: AppNavigator) {
        
        if let displayScene = scene as? ConversationsDisplayAPI {
            print("### Display API Navigation")
            print(displayScene.titleText)
            self.performConversationsDisplayNavigationForScene(displayScene)
        }
        else if let submissionScene = scene as? ConversationsSubmissionAPI {
            print("### Submission API Navigation")
            print(submissionScene.titleText)
            self.performConversationsSubmissionNavigationForScene(submissionScene)
        }
    }
    
    private func performConversationsDisplayNavigationForScene(_ scene: ConversationsDisplayAPI) {
        
        switch scene {
            
        case .authorQuery: return
            
        case .commentQuery: return
            
        case .commentsQuery: return
            
        case .productQuery: return
            
        case .productSearchQuery: return
            
        case .productsQuery: return
            
        case .productStatisticsQuery: return
            
        case .questionQuery: self.showQuestionsScreen()
            
        case .questionSearchQuery: return
            
        case .reviewQuery: return
            
        case .reviewSearchQuery: return
            
        case .multiProductQuery: return
            
        case .reviewHighlights: return
            
        }
    }
    
    private func showQuestionsScreen() {

        // 1. Create View Controller
        let questionsViewController = QuestionsTableViewController.instantiate()
        questionsViewController.navigationItem.title = "Product Questions"
        
        // 2. Create View Model
        let questionsViewModel = QuestionsViewModel()
        questionsViewModel.coordinator = self
        questionsViewModel.viewController = questionsViewController as? QuestionsViewModelDelegate
        
        // 3. Assign and navigate
        questionsViewController.viewModel = questionsViewModel
        self.navigationController.pushViewController(questionsViewController, animated: true)
    }
    
    private func performConversationsSubmissionNavigationForScene(_ scene: ConversationsSubmissionAPI) {
        
        switch scene {
            
        case .answerSubmission: return
            
        case .commentSubmission: return
            
        case .feedbackSubmission: return
            
        case .photoSubmission: return
            
        case .questionSubmission: return
            
        case .reviewSubmission: return
            
        case .uasSubmission: return
            
        case .progressiveSubmission: return
        
        }
    }
    
    
}

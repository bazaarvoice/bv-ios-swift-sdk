//
//  AppCoordinator.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 19/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit
import BVSwift

class AppCoordinator: Coordinator {
    
    enum AppNavigation: AppNavigator {
        
        case productDisplayPage(productId: String)
        
        case questions(productId: String, product: BVProduct)
        
        case review(productId: String, product: BVProduct)
        
        case answers(question: BVQuestion, product: BVProduct)
        
        case author(authorId: String)
        
        case askAQuestion
    }
    
    // MARK:- Initializers
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        
        super.start()
        
        // 1. Create View Controller
        let homeViewController = HomeViewController.instantiate()
        homeViewController.navigationItem.titleView = HomeViewController.createTitleLabel()
        
        // 2. Create View Model
        let viewModel = HomeViewModel()
        viewModel.coordinator = self
        viewModel.viewController = homeViewController
        
        // 3. Assign View Model and Push View Controller
        homeViewController.viewModel = viewModel
        self.navigationController.pushViewController(homeViewController, animated: true)        
    }
    
    override func navigateTo(_ scene: AppNavigator) {
        
        guard let navigationScene = scene as? AppNavigation else { return }
        
        switch navigationScene {
            
        case .productDisplayPage(let productId):
            self.showProductDisplayPage(productId: productId)
            
        case .questions(let productId, let product):
            self.showQuestionsScreen(productId: productId, product: product)
            
        case .answers(let question, let product):
            self.showAnswersScreen(question: question, product: product)
            
        case .review(let productId, let product):
            self.showReviewScreen(productId: productId, product: product)
            
        case .author(let authorId):
            self.showAuthorScreen(authorId: authorId)
            
        case .askAQuestion:
            self.showAskAQuestionScreen()
            
        }
    }
    
    // MARK:- Private methods
    private func showProductDisplayPage(productId: String) {
        
        // 1. Create View Controller
        let productDisplayPageViewController = ProductDisplayPageViewController.instantiate()
        productDisplayPageViewController.navigationItem.titleView = ProductDisplayPageViewController.createTitleLabel()
        
        // 2. Create View Model
        // TODO:- Hard coded to "test1" as the product ids returned by recommendations API are not having data in BVProductQuery.
        let productDisplayPageViewModel = ProductDisplayPageViewModel(productId: "test1")
        productDisplayPageViewModel.coordinator = self
        productDisplayPageViewModel.viewController = productDisplayPageViewController
        
        // 3. Assign View Model and Push View Controller
        productDisplayPageViewController.viewModel = productDisplayPageViewModel
        self.navigationController.pushViewController(productDisplayPageViewController, animated: true)
    }
    
    private func showQuestionsScreen(productId: String, product: BVProduct) {
        
        // 1. Create View Controller
        let questionsViewController = QuestionsTableViewController.instantiate()
        questionsViewController.navigationItem.title = "Questions"
        
        // 2. Create View Model
        let questionsViewModel = QuestionsViewModel(productId: productId,
                                                    product: product)
        questionsViewModel.coordinator = self
        questionsViewModel.viewController = questionsViewController
        
        // 3. Assign and navigate
        questionsViewController.viewModel = questionsViewModel
        self.navigationController.pushViewController(questionsViewController, animated: true)
    }
    
    private func showReviewScreen(productId: String, product: BVProduct) {
        
        //1. Create View Controller
        let reviewsViewController = ReviewsViewController.instantiate()
        reviewsViewController.navigationItem.title = "Reviews"
        
        //2. Create View Model
        let reviewsViewModel = ReviewsViewModel(productId: productId, product: product)
        reviewsViewModel.coordinator = self
        
        
        //3 Assign and Navigate
        reviewsViewModel.viewController = reviewsViewController
        
        reviewsViewController.viewModel = reviewsViewModel
        self.navigationController.pushViewController(reviewsViewController, animated: true)
    }
    
    private func showAnswersScreen(question: BVQuestion, product: BVProduct) {
        
        // 1. Create View Controller
        let answersViewController = AnswersTableViewController.instantiate()
        answersViewController.navigationItem.title = "Answers"
        
        // 2. Create View Model
        let answersViewModel = AnswersViewModel(question: question,
                                                product: product)
        answersViewModel.coordinator = self
        answersViewModel.viewController = answersViewController
        
        // 3. Assign and navigate
        answersViewController.viewModel = answersViewModel
        self.navigationController.pushViewController(answersViewController, animated: true)
    }
    
    private func showAuthorScreen(authorId: String) {
        //1. Create View Controller
        let authorViewController = AuthorViewController.instantiate()
        authorViewController.navigationItem.title = "Profile"
        
        //2. Create ViewModel
        let authorViewModel = AuthorViewModel(authorId: authorId)
        
        authorViewModel.coordinator = self
        authorViewModel.viewController = authorViewController
        
        //3. Assign and Navigate
        authorViewController.viewModel = authorViewModel
        self.navigationController.pushViewController(authorViewController, animated: true)
    }
    
    private func showAskAQuestionScreen() {
        // 1. Create View Controller
        let askAQuestionViewController = AskAQuestionViewController.instantiate()
        askAQuestionViewController.navigationItem.title = "Ask A Question"
        
        // 2. Create ViewModel
        let askAQuestionViewModel = AskAQuestionViewModel()
        askAQuestionViewModel.coordinator = self
        askAQuestionViewModel.viewController = askAQuestionViewController
        
        // 3. Assign and Navigate
        askAQuestionViewController.viewModel = askAQuestionViewModel
        self.navigationController.pushViewController(askAQuestionViewController, animated: true)
    }
}

//
//  ProductSentimentsViewModel.swift
//  BVSwiftDemo
//
//  Created by Rahul on 25/06/25.
//  Copyright © 2025 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift

protocol ProductSentimentsViewModelDelegate: AnyObject {
//        var productId: String { get set }
        func getRowCount(_ type: ReviewTableSections) -> Int
        func getText(_ type: ReviewTableSections, _ row: Int) -> String
        func didSelectFeatureAtIndex(_ type: ReviewTableSections, _ row: Int)
        var productSentimentsUIDelegate: ProductSentimentsUIDelegate? { get set }
}

protocol ProductSentimentsUIDelegate: AnyObject {
    func reloadData()
}


class ProductSentimentsViewModel: ProductSentimentsViewModelDelegate {
    
    private var summarisedFeatures: BVSummarisedFeatures?
    private var reviewSummary: BVReviewSummary?
    private var productFeatures: BVProductFeatures?
    private var productQuotes: BVQuotes?
    private var featureQuotes: BVQuotes?
    private let dispatchGroup = DispatchGroup()
    
    var productSentimentsUIDelegate: ProductSentimentsUIDelegate?

    init(productId: String) {
        self.productId = productId
        self.dispatchGroupNotify()
        self.fetchReviewSummary()
        self.getSummarisedFeatures()
        self.getFeatures()
        self.getQuotes()
    }
    
    var productId: String = ""
    
    private func dispatchGroupNotify() {
        self.dispatchGroup.notify(queue: .main) {
            self.productSentimentsUIDelegate?.reloadData()
        }
    }

    private func fetchReviewSummary() {
        
        self.dispatchGroup.enter()
        
        let reviewSummaryQueryRequest = BVProductReviewSummaryQuery(productId: self.productId)
            .formatType(.paragraph) //.bullet
            .configure(ConfigurationManager.sharedInstance.conversationsConfig)
            .handler { [weak self] (response: BVReviewSummaryQueryResponse<BVReviewSummary>) in
                
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case let .failure(errors):
                    print(errors)
                    
                case let .success(reviewSummary):
                    strongSelf.reviewSummary = reviewSummary
                }
                
                strongSelf.dispatchGroup.leave()
            }
        
        reviewSummaryQueryRequest.async()
        
    }
    
    private func getSummarisedFeatures() {
        self.dispatchGroup.enter()

        let query = BVSummarisedFeaturesQuery(productId: "P000010")//self.productId)
                .embed(.quotes)
                .language("en")
                .configure(ConfigurationManager.sharedInstance.productSentimentsConfig)
                .handler { [weak self] (response: BVProductSentimentsQueryResponse<BVSummarisedFeatures>) in
                    guard let strongSelf = self else { return }

                    switch response {
                        
                    case .success(let result):
                        guard let status = result.status,
                              let sentimentsError = BVProductSentimentsError("\(status)", message: result.detail)
                        else {
                            strongSelf.summarisedFeatures = result
                            return
                        }
                        print(sentimentsError.message)
                    case .failure(let errors):
                        errors.forEach { (error: Error) in
                            guard let bverror: BVError = error as? BVError else { return }
                            print(bverror.message)
                        }
                    }
                    strongSelf.dispatchGroup.leave()
                }
            query.async()
    }
    
    func getFeatures() {
        self.dispatchGroup.enter()

        let query = BVProductFeaturesQuery(productId: "P000010", limit: 10)
            .language("en")
            .configure(ConfigurationManager.sharedInstance.productSentimentsConfig)
            .handler {[weak self] (response: BVProductSentimentsQueryResponse<BVProductFeatures>) in
                
                guard let strongSelf = self else { return }

                if case let .failure(errors) = response {
                    print(errors)
                    errors.forEach { (error: Error) in
                        guard let bverror: BVError = error as? BVError else {return}
                        print(bverror.message)
                    }
                    return
                }
                
                guard case let .success(result) = response else {return}
                guard let status = result.status,
                      let sentimentsError = BVProductSentimentsError("\(status)", message: result.detail)
                else {
                    guard let features = result.features else {
                        print("No features for product")
                        return
                    }
                    strongSelf.productFeatures = result
                    return
                }
                print(sentimentsError.localizedDescription)
                strongSelf.dispatchGroup.leave()
            }
        query.async()
    }
    
    func getQuotes() {
        self.dispatchGroup.enter()

        let query = BVProductQuotesQuery(productId: "P000010", limit: 10)
            .language("en")
            .configure(ConfigurationManager.sharedInstance.productSentimentsConfig)
            .handler {[weak self] (response: BVProductSentimentsQueryResponse<BVQuotes>) in
                
                guard let strongSelf = self else { return }

                if case let .failure(errors) = response {
                    print(errors)
                    errors.forEach { (error: Error) in
                        guard let bverror: BVError = error as? BVError else {return}
                        print(bverror.message)
                    }
                    return
                }
                
                guard case let .success(result) = response else {return}
                guard let status = result.status,
                      let sentimentsError = BVProductSentimentsError("\(status)", message: result.detail)
                else {
                    guard let quotes = result.quotes else {
                        print("No features for product")
                        return
                    }
                    strongSelf.productQuotes = result
                    return
                }
                print(sentimentsError.localizedDescription)
                strongSelf.dispatchGroup.leave()
            }
        query.async()
    }
    
    func didSelectFeatureAtIndex(_ type: ReviewTableSections, _ index: Int) {
        self.featureQuotes = nil
        if type == .pros {
            guard let features = self.summarisedFeatures?.bestFeatures, !features.isEmpty, let quotes = features[index].embedded else { return }
            self.featureQuotes = quotes
        } else if type == .cons {
            guard let features = self.summarisedFeatures?.worstFeatures, !features.isEmpty, let quotes = features[index].embedded else { return }
            self.featureQuotes = quotes
        }
        self.productSentimentsUIDelegate?.reloadData()
    }
    
    func getRowCount(_ type: ReviewTableSections) -> Int {
        switch type {
        case .features:
            let count = self.productFeatures?.features?.count ?? 1
            return count == 0 ? 1 : count
        case .summary:
            return 1
        case .pros:
            let count = self.summarisedFeatures?.bestFeatures?.count ?? 1
            return count == 0 ? 1 : count
        case .cons:
            let count = self.summarisedFeatures?.worstFeatures?.count ?? 1
            return count == 0 ? 1 : count
        case .positiveQuotes:
            return self.summarisedFeatures?.bestFeatures?.first?.embedded?.quotes?.count ?? 0
        case .negativeQuotes:
            return self.summarisedFeatures?.worstFeatures?.first?.embedded?.quotes?.count ?? 0
        case .featureQuotes:
            let count = self.featureQuotes?.quotes?.count ?? 1
            return count == 0 ? 1 : count
        case .quotes:
            let count = self.productQuotes?.quotes?.count ?? 1
            return count == 0 ? 1 : count
        default:
            return 0
        }
    }
    
    func getText(_ type: ReviewTableSections, _ row: Int) -> String {
        switch type {
        case .features:
            guard let feature = self.productFeatures?.features, !feature.isEmpty else {
                return "No features available yet"
            }
            return feature[row].feature ?? ""
        case .summary:
            return self.reviewSummary?.summary ?? "No summary available yet"
        case .pros:
            guard let pros = self.summarisedFeatures?.bestFeatures, !pros.isEmpty else {
                return "No pros available yet"
            }
            return pros[row].feature ?? ""
        case .cons:
            guard let cons = self.summarisedFeatures?.worstFeatures, !cons.isEmpty else {
                return "No cons available yet"
            }
            return cons[row].feature ?? ""
        case .positiveQuotes:
            return self.summarisedFeatures?.bestFeatures?.first?.embedded?.quotes?[row].text ?? ""
        case .negativeQuotes:
            return self.summarisedFeatures?.worstFeatures?.first?.embedded?.quotes?[row].text ?? ""
        case .featureQuotes:
            guard let quotes = self.featureQuotes?.quotes, !quotes.isEmpty else {
                return "Select a Pro or Con to see quotes"
            }
            return quotes[row].text ?? ""
        case .quotes:
            guard let quotes = self.productQuotes?.quotes, !quotes.isEmpty else {
                return "No quotes available yet"
            }
            return quotes[row].text ?? ""
        default:
            return ""
        }
    }
}

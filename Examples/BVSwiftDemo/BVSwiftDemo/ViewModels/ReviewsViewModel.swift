//
//  ReviewsViewModel.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

struct ReviewHighlightsHeaderModel {
    var title: String = ""
    var isExpand: Bool = false
}

protocol ReviewsViewModelDelegate: class {
    
    var numberOfSections: Int { get }
    
    var numberOfRows: Int { get }
    
    func titleForIndexPath(_ indexPath: IndexPath) -> BVReview?
    
    func initReviewHighlightsHeaderArray() -> [ReviewHighlightsHeaderModel]
}

class ReviewsViewModel: ViewModelType {
    
    weak var viewController: ReviewsViewControllerDelegate?
    
    weak var coordinator: Coordinator?
}

extension ReviewsViewModel: ReviewsViewModelDelegate {
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return 22
    }
    
    func titleForIndexPath(_ indexPath: IndexPath) -> BVReview? {
        return nil
    }
    
    func initReviewHighlightsHeaderArray() -> [ReviewHighlightsHeaderModel] {
        
        return [ReviewHighlightsHeaderModel(title: "Pros Mentioned", isExpand: false), ReviewHighlightsHeaderModel(title: "Cons mentioned", isExpand: false)]
    }
    
    
}

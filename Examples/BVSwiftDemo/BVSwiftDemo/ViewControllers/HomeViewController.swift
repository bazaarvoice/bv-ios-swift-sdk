//
//  ViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 19/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

protocol HomeCollectionViewControllerDelegate: class {
    func reloadCollectionView()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class HomeViewController: UIViewController, ViewControllerType {
    
    // MARK:- IBOutlets
    @IBOutlet weak var bvRecommendationProductCollectionView: UICollectionView!
    @IBOutlet weak var bvHeaderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK:- Constants
    private static let PRODUCT_CELL_IDENTIFIER = "ProductCollectionViewCellIdentifier"
    private static let HEADER_CELL_IDENTIFIER = "HeaderCollectionViewCellIdentifier"
    
    // MARK:- Variables
    var viewModel: HomeViewModelDelegate!
    var timer = Timer()
    var counter = 0
    
    var images = [
        UIImage(named: "slide_1.jpg"),
        UIImage(named: "slide_2.jpg"),
        UIImage(named: "slide_3.jpg")
    ]
    
    var currentPageIndex : Int = 0 {
        didSet {
            pageControl.currentPage = currentPageIndex
        }
    }
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setPageView()
        
        self.viewModel.loadProductRecommendations()
    }
    
    class func createTitleLabel() -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 44))
        
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34)
        return titleLabel
    }
    
    private func setPageView() {
        self.pageControl.numberOfPages = self.images.count
        self.pageControl.currentPage = 0
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        
        if self.counter < self.images.count {
            let index = IndexPath.init(item: self.counter, section: 0)
            self.bvHeaderCollectionView.scrollToItem(at: index, at: .centeredVertically, animated: true)
            self.pageControl.currentPage = self.counter
            self.counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: self.counter, section: 0)
            self.bvHeaderCollectionView.scrollToItem(at: index, at: .centeredVertically, animated: true)
            self.pageControl.currentPage = self.counter
            self.counter = 1
        }
        
    }
}

extension HomeViewController: HomeCollectionViewControllerDelegate {
    
    func reloadCollectionView() {
        self.bvRecommendationProductCollectionView.reloadData()
    }
    
    func showLoadingIndicator() {
        self.showSpinner()
    }
    
    func hideLoadingIndicator() {
        self.removeSpinner()
    }
    
}

// Mark:- UICollectionViewDataSource methods
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.bvHeaderCollectionView {
            return self.images.count
        }
        else {
            return self.viewModel.numberOfItems
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.bvHeaderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCellIdentifier", for: indexPath)
            if let vc = cell.viewWithTag(1) as? UIImageView {
                vc.image = self.images[indexPath.row]
            }
            return cell
        }
        else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.PRODUCT_CELL_IDENTIFIER, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
            
            
            if let product = self.viewModel.productForItemAtIndexPath(indexPath) {
                cell.setRecommendationProductDetails(recommendationProduct: product)
            }
            
            return cell
        }
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout methods
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.bvHeaderCollectionView {
            return CGSize(width: (UIScreen.main.bounds.width), height: 210)
        }
        else {
            return CGSize(width: ((UIScreen.main.bounds.width/2) - 10), height: 200)
        }
    }

}

// MARK:- UICollectionViewDelegate methods
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelectItemAt(indexPath: indexPath)
    }
}


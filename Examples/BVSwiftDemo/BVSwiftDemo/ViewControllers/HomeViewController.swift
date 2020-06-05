//
//  ViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 19/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ViewControllerType {
    
    // MARK:- IBOutlets
    @IBOutlet weak var bvModulesTableView: UITableView!
    
    // MARK:- Constants
    private static let CELL_IDENTIFIER = "ProductCollectionViewCell"
    
    // MARK:- Variables
    var viewModel: HomeViewModelDelegate!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    class func createTitleLabel() -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 44))
        
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34)
        return titleLabel
    }
    
    @IBAction func showNextTapped(_ sender: Any) {
        // self.viewModel.didTapShowNextButton()
    }
    
    
}

// Mark:- HomeViewControllerDatasource methods
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.CELL_IDENTIFIER, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}

// MARK:- HomeViewControllerDelegateFlowLayout methods
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((UIScreen.main.bounds.width/2) - 15), height: 200)
     }
}

// MARK:- HomeViewControllerDelegate methods
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}


//
//  ViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 19/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ViewControllerType {
    
    var viewModel: HomeViewModelDelegate!
    
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
        self.viewModel.didTapShowNextButton()
    }
    

}


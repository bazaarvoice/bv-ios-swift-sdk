//
//  ViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 19/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {

    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    class func createTitleLabel() -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 44))
        
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "ForalPro-Regular", size: 36)
        return titleLabel
    }

}


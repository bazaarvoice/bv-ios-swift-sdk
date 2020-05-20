//
//  BVSwiftDemoNavigationController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class BVSwiftDemoNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.bazaarvoiceNavy()
        self.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        self.navigationBar.barStyle = .black;
    }
}

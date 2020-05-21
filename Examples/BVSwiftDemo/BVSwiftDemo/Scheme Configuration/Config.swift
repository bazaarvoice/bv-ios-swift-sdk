//
//  Config.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 21/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

enum ConfigTypes: String {

    case Staging
    case Production
}

class Config: NSObject {

    static let sharedInstance = Config()

    private var configs: NSDictionary = [:]
    private var currentConfig: String = ""
    private let errorStr: String = "ERROR"

    private override init() {

        if let currentConfigStr = Bundle.main.object(forInfoDictionaryKey: "Config") as? String {

            self.currentConfig = currentConfigStr

            switch currentConfigStr.lowercased() {

            case ConfigTypes.Production.rawValue.lowercased() :

                if let path = Bundle.main.path(forResource: "Prod", ofType: "plist") {
                    self.configs = NSDictionary(contentsOfFile: path)!
                }

            case ConfigTypes.Staging.rawValue.lowercased() :
                if let path = Bundle.main.path(forResource: "QA", ofType: "plist") {
                    self.configs = NSDictionary(contentsOfFile: path)!
                }

            default  :
                if let path = Bundle.main.path(forResource: "Dev", ofType: "plist") {
                    self.configs = NSDictionary(contentsOfFile: path)!
                }

            } //end of case
        }

    } //end of init

} //end of class

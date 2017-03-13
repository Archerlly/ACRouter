//
//  testViewController.swift
//  ACRouter
//
//  Created by SnowCheng on 11/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import UIKit
import ACRouter

class testViewController: UIViewController, ACRouterable {
    
    static func registerAction(info: [String : AnyObject]) -> AnyObject {
        
        let newInstance = testViewController()
        let infoString = info.map { "\($0) : \($1)" }.joined(separator: "\n")
        newInstance.infoLabel.text = infoString
        newInstance.infoLabel.sizeToFit()
        newInstance.infoLabel.center = newInstance.view.center
        
        if let bgColor = info["bgColor"] as? UIColor {
            newInstance.view.backgroundColor = bgColor
        }
        
        return newInstance
    }
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        self.view.addSubview(infoLabel)
        return infoLabel
    }()
    
}

//
//  ErrorPageViewController.swift
//  ACRouter
//
//  Created by SnowCheng on 26/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ACRouter

class ErrorPageViewController: UIViewController, ACRouterable {

    static func registerAction(info: [String : AnyObject]) -> AnyObject {
        
        let newInstance = ErrorPageViewController()
        let infoString = info.map { "\($0) : \($1)" }.joined(separator: "\n")
        newInstance.infoLabel.text = infoString
        newInstance.infoLabel.bounds.size = newInstance.infoLabel.sizeThatFits(newInstance.view.bounds.size)
        newInstance.infoLabel.center = newInstance.view.center
        
        if let bgColor = info["bgColor"] as? UIColor {
            newInstance.view.backgroundColor = bgColor
        }
        
        if let faildURL = info[ACRouter.matchFailedKey] as? String {
            newInstance.errorPage.isHidden = faildURL.characters.count == 0
        }
        
        return newInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        self.view.addSubview(infoLabel)
        return infoLabel
    }()
    
    lazy var errorPage: UIImageView = {
        let errorPage = UIImageView.init(image: #imageLiteral(resourceName: "error"))
        errorPage.isHidden = true
        errorPage.center.x = self.view.center.x
        errorPage.center.y = 150
        self.view.addSubview(errorPage)
        return errorPage
    }()
    
}

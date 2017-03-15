//
//  LoginViewController.swift
//  ACRouter
//
//  Created by SnowCheng on 13/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ACRouter

class LoginViewController: UIViewController, ACRouterable {
    
    class func registerAction(info: [String : AnyObject]) -> AnyObject {
        
        let newInstance = LoginViewController()
        
        if let title = info["username"] as? String {
            newInstance.title = title
        }
        
        return newInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 40)
        lab.text = "touch me"
        lab.sizeToFit()
        lab.center = view.center
        view.addSubview(lab)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ACRouter.openURL(localRouterable.profile(content: "\(title ?? "")'shome").requiredURL, userInfo: ["avatar": #imageLiteral(resourceName: "avatar")])
    }
}

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

        newInstance.usernameTextFieled.text = info["username"] as? String
        newInstance.passwordTextFieled.text = info["password"] as? String
        
        return newInstance
    }
    
    let usernameTextFieled = UITextField()
    let passwordTextFieled = UITextField()
    let loginButton = UIButton.init(type: UIButtonType.system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(usernameTextFieled)
        view.addSubview(passwordTextFieled)
        view.addSubview(loginButton)
        
        usernameTextFieled.placeholder = "username"
        usernameTextFieled.borderStyle = .roundedRect
        usernameTextFieled.bounds.size = CGSize.init(width: 150, height: 40)
        usernameTextFieled.center.x = view.center.x
        usernameTextFieled.center.y = 140
        
        passwordTextFieled.placeholder = "password"
        passwordTextFieled.borderStyle = .roundedRect
        passwordTextFieled.bounds.size = CGSize.init(width: 150, height: 40)
        passwordTextFieled.center.x = view.center.x
        passwordTextFieled.center.y = 200
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        loginButton.bounds.size = CGSize.init(width: 100, height: 40)
        loginButton.center.x = view.center.x
        loginButton.center.y = 260
    }
    
    @objc private func loginAction() {
        AuthorizationCenter.default.isLogin = true;
        ACRouter.openURL(ProfileAPI("\(usernameTextFieled.text ?? "")'s home").requiredURL, userInfo: ["avatar": #imageLiteral(resourceName: "avatar")])
    }

}

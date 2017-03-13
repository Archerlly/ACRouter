//
//  ProfileViewController.swift
//  ACRouter
//
//  Created by SnowCheng on 13/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ACRouter

class ProfileViewController: UIViewController, ACRouterable {
    
    static func registerAction(info: [String : AnyObject]) -> AnyObject {
        
        let newInstance = self.init()
        
        if let image = info["avatar"] as? UIImage {
            newInstance.avatarView.image = image
            newInstance.avatarView.sizeToFit()
            newInstance.avatarView.center = newInstance.view.center
        }
        
        if let content = info["content"] as? String {
            newInstance.infoLabel.text = content
            newInstance.infoLabel.sizeToFit()
            newInstance.infoLabel.center = newInstance.view.center
        }
        
        
        return newInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let back = UIButton()
        back.setTitle("back", for: .normal)
        back.setTitleColor(UIColor.black, for: .normal)
        back.addTarget(self, action: #selector(ProfileViewController.backAction), for: .touchUpInside)
        back.frame = CGRect.init(x: 20, y: 20, width: 50, height: 50)
        view.addSubview(back)
    }
    
    @objc private func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        self.view.addSubview(avatarView)
        self.view.sendSubview(toBack: avatarView)
        return avatarView
    }()
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        self.view.addSubview(infoLabel)
        return infoLabel
    }()

}

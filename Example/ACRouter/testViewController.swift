//
//  testViewController.swift
//  ACRouter
//
//  Created by SnowCheng on 11/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import UIKit
import ACRouter

class testViewController: UIViewController {
    
    class func register() {
        //AA://bb/cc/:p1
        ACRouter.addRouter("AA://bb/cc/:p1", priority: 0) { (info) -> AnyObject in
            print(info)
            return testViewController() as AnyObject
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.red

    }
    
}

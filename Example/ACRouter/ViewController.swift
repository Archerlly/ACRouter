//
//  ViewController.swift
//  ACRouter
//
//  Created by SnowCheng on 10/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import UIKit
import ACRouter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testViewController.register()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //AA://bb/cc/:p1
        let info = ["demo": "testInfo",
                    "p1"  : "hahah"]
        
        let url = ACRouter.generate("AA://bb/cc/:p1", userInfo: info, jumpType: .modal)
        ACRouter.openUrl(url)
        
    }

}


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
    }

    @IBAction func userProfileAction(_ sender: Any) {
        ACRouter.openURL(localRouterable.login(username: "Archerlly", password: "hehehe").requiredURL)
    }

    @IBAction func passObjectAction(_ sender: Any) {
        let params = ["demo": "testInfo", "p1"  : "value1"]
        let url = ACRouter.generate("AA://bb/cc/:p1", params: params, jumpType: ACRouter.ACJumpType.modal)
        ACRouter.openURL(url, userInfo: ["bgColor": UIColor.gray])
    }

}


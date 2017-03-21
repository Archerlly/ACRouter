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
        
        let tab = DemoTableView()
        tab.frame = view.bounds
        view.addSubview(tab)
        
    }


}


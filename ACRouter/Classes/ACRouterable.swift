//
//  ACRouterable.swift
//  Pods
//
//  Created by SnowCheng on 13/03/2017.
//
//

import UIKit

public protocol ACRouterable {
    
    static func registerAction(info: [String: AnyObject]) -> AnyObject

}

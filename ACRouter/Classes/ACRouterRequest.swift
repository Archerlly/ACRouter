//
//  ACRouterRequest.swift
//  ACRouter
//
//  Created by SnowCheng on 11/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import UIKit

class ACRouterRequest: ACRouterParser {
    
    var urlString: String
    var sheme: String
    var paths: [String]
    var querys: [String: AnyObject]
    
    init(_ urlString: String) {
        self.urlString = urlString
        self.sheme = ACRouterRequest.parserSheme(urlString)
        
        let result = ACRouterRequest.parser(urlString)
        self.paths = result.paths
        self.querys = result.querys
    }
    
}

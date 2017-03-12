//
//  ACRouterPattern.swift
//  ACRouter
//
//  Created by SnowCheng on 11/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import UIKit

class ACRouterPattern: ACRouterParser {

    typealias HandleBlock = ([String: AnyObject]) -> AnyObject
    static let PatternPlaceHolder = "~AC~"
    
    var patternString: String
    var sheme: String
    var patternPaths: [String]
    var priority: uint
    var handle: HandleBlock
    var matchString: String
    var paramsMatchDict: [String: Int]
    
    
    init(_ string: String, priority: uint = 0, handle: @escaping HandleBlock) {
        self.patternString = string
        self.priority = priority
        self.handle = handle
        self.sheme = ACRouterPattern.parserSheme(string)
        self.patternPaths = ACRouterPattern.parserPaths(string)
        self.paramsMatchDict = [String: Int]()
        
        var matchPaths = [String]()
        for i in 0..<patternPaths.count {
            var pathComponent = self.patternPaths[i]
            if pathComponent.hasPrefix(":") {
                let name = pathComponent.ac_dropFirst(1)
                self.paramsMatchDict[name] = i
                pathComponent = ACRouterPattern.PatternPlaceHolder
            }
            matchPaths.append(pathComponent)
        }
        self.matchString = matchPaths.joined(separator: "/")
    }
    
}





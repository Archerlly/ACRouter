//
//  ACRouter.swift
//  ACRouter
//
//  Created by SnowCheng on 11/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import UIKit

class ACRouter: ACRouterParser {
// MARK: - Constants
    typealias RouteResponse = (pattern: ACRouterPattern?, querys: [String: AnyObject])
    
// MARK: - Private property
    private var patterns = [ACRouterPattern]()

// MARK: - Public  property
    static let shareInstance = ACRouter()
    
// MARK: - Convenience method
    class func addRouter(_ patternString: String, priority: uint = 0, handle: @escaping ACRouterPattern.HandleBlock) {
        shareInstance.addRouter(patternString, priority: priority, handle: handle)
    }
    
    class func removeRouter(_ patternString: String) {
        shareInstance.removeRouter(patternString)
    }
    
    class func canOpenUrl(_ urlString: String) -> Bool {
        return shareInstance.canOpenUrl(urlString)
    }
    
    class func requestUrl(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) -> RouteResponse {
        return shareInstance.requestUrl(urlString, userInfo: userInfo)
    }
    
// MARK: - Public method
    func addRouter(_ patternString: String, priority: uint = 0, handle: @escaping ACRouterPattern.HandleBlock) {
        let pattern = ACRouterPattern.init(patternString, priority: priority, handle: handle)
        patterns.append(pattern)
    }
 
    func removeRouter(_ patternString: String) {
        patterns = patterns.filter{ $0.patternString != patternString }
    }
    
    func canOpenUrl(_ urlString: String) -> Bool {
        return ac_matchUrl(urlString).pattern != nil
    }
    
    func requestUrl(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) -> RouteResponse {
        return ac_matchUrl(urlString, userInfo: userInfo)
    }
    
// MARK: - Private method
    private func ac_matchUrl(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) -> RouteResponse {
        let request = ACRouterRequest.init(urlString)
        var querys = request.querys
        var matched: ACRouterPattern?
        
        //先过滤掉scheme, 与path个数不匹配的
        let matchedPatterns = patterns.filter{ $0.sheme == request.sheme && $0.patternPaths.count == request.paths.count }
        
        for pattern in matchedPatterns {
            var requestPaths = request.paths
            var currentPathQuery = [String: AnyObject]()
            //替换params
            pattern.paramsMatchDict.forEach({ (name, index) in
                let requestPathQueryValue = requestPaths[index] as AnyObject
                currentPathQuery[name] = requestPathQueryValue
                requestPaths[index] = ACRouterPattern.PatternPlaceHolder
            })
            let matchString = requestPaths.joined(separator: "/")
            if matchString == pattern.matchString {
                matched = pattern
                querys.ac_combine(userInfo)
                querys.ac_combine(currentPathQuery)
                break
            }
        }
        
        guard let currentPattern = matched else {
            //没有匹配到
            print("not matched: \(urlString)")
            return (nil, [String: AnyObject]())
        }
        
        return (currentPattern, querys)
    }
}

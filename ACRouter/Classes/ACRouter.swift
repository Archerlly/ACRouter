//
//  ACRouter.swift
//  ACRouter
//
//  Created by SnowCheng on 11/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import Foundation

public class ACRouter: ACRouterParser {
// MARK: - Constants
    public typealias FailedHandleBlock = ([String: AnyObject]) -> Void
    public typealias RouteResponse = (pattern: ACRouterPattern?, queries: [String: AnyObject])
    
// MARK: - Private property
    private var patterns = [ACRouterPattern]()
    
    private var interceptors = [ACRouterInterceptor]()
    
    private var relocationHandle: FailedHandleBlock?
    
    private var matchFailedHandle: FailedHandleBlock?

// MARK: - Public  property
    static let shareInstance = ACRouter()
    
// MARK: - Public method
    func addRouter(_ patternString: String,
                   priority: uint = 0,
                   handle: @escaping ACRouterPattern.HandleBlock) {
        let pattern = ACRouterPattern.init(patternString, priority: priority, handle: handle)
        patterns.append(pattern)
        patterns.sort { $0.priority > $1.priority }
    }
    
    func addInterceptor(_ whiteList: [String] = [String](),
                        priority: uint = 0,
                        handle: @escaping ACRouterInterceptor.InterceptorHandleBlock) {
        let interceptor = ACRouterInterceptor.init(whiteList, priority: priority, handle: handle)
        interceptors.append(interceptor)
        interceptors.sort { $0.priority > $1.priority }
    }
    
    func addGlobalMatchFailedHandel(_ handel: @escaping FailedHandleBlock) {
        matchFailedHandle = handel
    }
    
    func addRelocationHandle(_ handel: @escaping FailedHandleBlock) {
        relocationHandle = handel
    }
 
    func removeRouter(_ patternString: String) {
        patterns = patterns.filter{ $0.patternString != patternString }
    }
    
    func canOpenURL(_ urlString: String) -> Bool {
        return ac_matchURL(urlString).pattern != nil
    }
    
    func requestURL(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) -> RouteResponse {
        return ac_matchURL(urlString, userInfo: userInfo)
    }
    
// MARK: - Private method
    private func ac_matchURL(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) -> RouteResponse {
        let request = ACRouterRequest.init(urlString)
        var queries = request.queries
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
                queries.ac_combine([ACRouter.requestURLKey  : urlString as AnyObject])
                queries.ac_combine(userInfo)
                queries.ac_combine(currentPathQuery)
                break
            }
        }
        
        guard let currentPattern = matched else {
            //没有匹配到
            var info = [ACRouter.matchFailedKey  : urlString as AnyObject]
            info.ac_combine(userInfo)
            matchFailedHandle?(info)
            
            print("not matched: \(urlString)")
            return (nil, [String: AnyObject]())
        }
        
        guard ac_intercept(currentPattern.patternString, queries: queries) else {
            print("interceped: \(urlString)")
            return (nil, [String: AnyObject]())
        }
        
        return (currentPattern, queries)
    }
    
    //Intercep the request and return whether should continue
    private func ac_intercept(_ matchedPatternString: String, queries: [String: AnyObject]) -> Bool {
        
        for interceptor in self.interceptors where !interceptor.whiteList.contains(matchedPatternString) {
            if !interceptor.handle(queries) {
                return false
            }
        }
        
        return true
    }
}

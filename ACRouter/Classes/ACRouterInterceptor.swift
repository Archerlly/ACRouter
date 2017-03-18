//
//  ACRouterInterceptor.swift
//  Pods
//
//  Created by SnowCheng on 18/03/2017.
//
//

import UIKit

public class ACRouterInterceptor: NSObject {

    public typealias InterceptorHandleBlock = ([String: AnyObject]) -> Bool
    
    var priority: uint
    var whiteList: [String]
    var handle: InterceptorHandleBlock
    
    init(_ whiteList: [String],
         priority: uint,
         handle: @escaping InterceptorHandleBlock) {
        
        self.whiteList = whiteList
        self.priority = priority
        self.handle = handle
    }
    
}

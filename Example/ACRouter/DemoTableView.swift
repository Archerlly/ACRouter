//
//  DemoTableView.swift
//  ACRouter
//
//  Created by SnowCheng on 21/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ACRouter

class DemoTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    //页面跳转不需要再通过delegate与Block抛出到控制器去完成, view自身管理简化代码
    
    let dataArr = ["test login",
                   "test profile with login",
                   "test profile without login",
                   "test normalRouter",
                   "test error jump"]
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        dataSource = self
        delegate = self
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = dataArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            ACRouter.openURL(LoginAPI("Archerlly", passWord: "hehehe").requiredURL)
            
        case 1:
            AuthorizationCenter.default.isLogin = true
            ACRouter.openURL(ProfileAPI("My's home").requiredURL, userInfo: ["avatar": #imageLiteral(resourceName: "avatar")])
            
        case 2:
            AuthorizationCenter.default.isLogin = false
            ACRouter.openURL(ProfileAPI("My's home").requiredURL, userInfo: ["avatar": #imageLiteral(resourceName: "avatar")])
            
        case 3:
            let params = ["demo": "testInfo", "p1"  : "value1"]
            let url = ACRouter.generate("AA://bb/cc/:p1", params: params, jumpType: ACRouter.ACJumpType.modal)
            ACRouter.openURL(url, userInfo: ["bgColor": UIColor.gray])
            
        case 4:
            let url = ACRouter.generate("FF://bb/cc", jumpType: ACRouter.ACJumpType.modal)
            ACRouter.openURL(url)
            
        default: break
        }
        
    }
    
}

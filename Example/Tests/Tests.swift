import UIKit
import XCTest
@testable import ACRouter

class Tests: XCTestCase {
    
    let p1 = "AA://bb"
    let p2 = "AA://bb/cc"
    let p3 = "AA://bb/cc/ee"
    let p4 = "AA://bb/:cc/dd"
    
    let relocationUrl = "xx://xx/xx/xx"

    override func setUp() {
        super.setUp()
        
        ACRouter.addRouter(p1) {_ in return nil}
        ACRouter.addRouter(p2) {_ in return nil}
        ACRouter.addRouter(p3) {_ in return nil}
        ACRouter.addRouter(p4) {_ in return nil}
        
        ACRouter.addInterceptor([p1], priority: 0) { info -> Bool in
            if let string = info["shoudContinue1"] as? String,
                let shoudContinue = Bool(string) {
                return shoudContinue
            }
            return true
        }
        
        ACRouter.addInterceptor([p4], priority: 1) { info -> Bool in
            if let string = info["shoudContinue2"] as? String,
                let shoudContinue = Bool(string) {
                return shoudContinue
            }
            return true
        }
        
        ACRouter.addRelocationHandle { (urlString) -> String? in
            
            let dict = [self.relocationUrl: self.p1]
            return dict[urlString]
            
        }
        
    }
    
    func testResponse() {
        let response = ACRouter.requestURL("AA://bb/hello/dd?query=value1#?newquery=newvalue", userInfo: ["query": "value2" as AnyObject])
    
        XCTAssertEqual(response.pattern?.patternString, p4)
        XCTAssertEqual(response.queries["cc"] as? String, "hello")
        XCTAssertEqual(response.queries["query"] as! [String], ["value1", "value2"])
        XCTAssertEqual(response.queries["newquery"]as? String, "newvalue")
    }
    
    func testRelocation() {
        
        var response = ACRouter.requestURL("yy://yy/yy/yy")
        XCTAssertNil(response.pattern)
        
        response = ACRouter.requestURL(relocationUrl)
        XCTAssertNotNil(response.pattern)
    }
    
    func testIntercept() {
        var response: ACRouter.RouteResponse
        
        //p1
        response = ACRouter.requestURL("AA://bb?shoudContinue1=true&shoudContinue2=true")
        XCTAssertNotNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb?shoudContinue1=false&shoudContinue2=false")
        XCTAssertNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb?shoudContinue1=true&shoudContinue2=false")
        XCTAssertNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb?shoudContinue1=false&shoudContinue2=true")
        XCTAssertNotNil(response.pattern)
        
        //p2
        response = ACRouter.requestURL("AA://bb/cc?shoudContinue1=true&shoudContinue2=true")
        XCTAssertNotNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb/cc?shoudContinue1=false&shoudContinue2=false")
        XCTAssertNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb/cc?shoudContinue1=true&shoudContinue2=false")
        XCTAssertNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb/cc?shoudContinue1=false&shoudContinue2=true")
        XCTAssertNil(response.pattern)
        
        //p4
        response = ACRouter.requestURL("AA://bb/helllo/dd?shoudContinue1=true&shoudContinue2=true")
        XCTAssertNotNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb/helllo/dd?shoudContinue1=false&shoudContinue2=false")
        XCTAssertNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb/helllo/dd?shoudContinue1=true&shoudContinue2=false")
        XCTAssertNotNil(response.pattern)
        
        response = ACRouter.requestURL("AA://bb/helllo/dd?shoudContinue1=false&shoudContinue2=true")
        XCTAssertNil(response.pattern)
        
    }
    
    func testRequest() {
        var s = "AA://bb/cc/dd?query=value"
        var r = ACRouterRequest.init(s)
        XCTAssertEqual(r.sheme, "AA")
        XCTAssertEqual(r.paths, ["bb", "cc", "dd"])
        XCTAssertEqual(r.queries as! [String: String], ["query": "value"])
        
        s = "AA://bb/cc/dd?query=value#newPath"
        r = ACRouterRequest.init(s)
        XCTAssertEqual(r.sheme, "AA")
        XCTAssertEqual(r.paths, ["bb", "cc", "dd", "newPath"])
        XCTAssertEqual(r.queries as! [String: String], ["query": "value"])
        
        s = "AA://bb/cc/dd?query=value#?newquery=newvalue"
        r = ACRouterRequest.init(s)
        XCTAssertEqual(r.sheme, "AA")
        XCTAssertEqual(r.paths, ["bb", "cc", "dd"])
        XCTAssertEqual(r.queries as! [String: String], ["query": "value", "newquery": "newvalue"])
        
        s = "AA://bb/cc/dd?query=value#newPath?newquery=newvalue"
        r = ACRouterRequest.init(s)
        XCTAssertEqual(r.sheme, "AA")
        XCTAssertEqual(r.paths, ["bb", "cc", "dd", "newPath"])
        XCTAssertEqual(r.queries as! [String: String], ["query": "value", "newquery": "newvalue"])
    }
    
    func testPattern() {
        var s = "AA://bb/:cc/dd"
        var p = ACRouterPattern.init(s) {_ in return nil}
        XCTAssertEqual(p.sheme, "AA")
        XCTAssertEqual(p.patternPaths, ["bb", ":cc", "dd"])
        XCTAssertEqual(p.paramsMatchDict, ["cc": 1])
        XCTAssertEqual(p.matchString, "bb/~AC~/dd")
        
        s = "AA://bb/:cc/dd?query=value#newPath?newqury=newvalue"
        p = ACRouterPattern.init(s) {_ in return nil}
        XCTAssertEqual(p.sheme, "AA")
        XCTAssertEqual(p.patternPaths, ["bb", ":cc", "dd", "newPath"])
        XCTAssertEqual(p.paramsMatchDict, ["cc": 1])
        XCTAssertEqual(p.matchString, "bb/~AC~/dd/newPath")
    }
    
    func testGenerateURL() {
        let s1 = "AA://bb/:cc/dd"
        let p1 = ["cc": "value1", "ee": "value2"]
        let u1 = ACRouter.generate(s1, params: p1, jumpType: .modal)
        
        let r1 = ["AA://bb/value1/dd?ACJumpTypeKey=ACJumpTypeModal&ee=value2",
                  "AA://bb/value1/dd?ee=value2&ACJumpTypeKey=ACJumpTypeModal"]
        XCTAssert(r1.contains(u1))
        
    }
    
}

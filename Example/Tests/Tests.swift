import UIKit
import XCTest
@testable import ACRouter

class Tests: XCTestCase {
    
    let p1 = "AA://bb"
    let p2 = "AA://bb/cc"
    let p3 = "AA://bb/cc/ee"
    let p4 = "AA://bb/:cc/dd"
    

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
    
}

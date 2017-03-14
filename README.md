# ACRouter

[![CI Status](http://img.shields.io/travis/260732891@qq.com/ACRouter.svg?style=flat)](https://travis-ci.org/260732891@qq.com/ACRouter)
[![Version](https://img.shields.io/cocoapods/v/ACRouter.svg?style=flat)](http://cocoapods.org/pods/ACRouter)
[![License](https://img.shields.io/cocoapods/l/ACRouter.svg?style=flat)](http://cocoapods.org/pods/ACRouter)
[![Platform](https://img.shields.io/cocoapods/p/ACRouter.svg?style=flat)](http://cocoapods.org/pods/ACRouter)

## Introduce

A simple router for swift

## Installation

ACRouter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ACRouter"
```

## fast use

1. CustomViewController inherit ACRouterable, and implement the  func of registerAction.
``` swift
class CustomViewController: UIViewController, ACRouterable {
static func registerAction(info: [String : AnyObject]) -> AnyObject {
let newInstance = LoginViewController()
if let title = info["username"] as? String {
newInstance.title = title
}
return newInstance
}
}
```
2. RegisterRouter for your CustomViewController
`ACRouter.addRouter("AA://bb/cc/:p1", classString: "CustomViewController")`

3. OpenURL in you application
`ACRouter.openURL("AA://bb/cc/content?value1=testInfo")`

##Convenience
- Quickly add multiple router
``` swift
let registerDict = ["AA://bb/cc/:p1" : "CustomViewControllerOne", "AA://ee/ff" : "CustomViewControllerTwo"]
ACRouter.addRouter(registerDict)
```
- Quickly genarate jump
``` swift
ACRouter.generate(_ patternString: params:  jumpType: )
```
It will parse patternString and embed the params and the jumpType in it
- Check the request URL
``` swift
canOpenURL(_ urlString: )
```
- remove router
``` swift
removeRouter(_ patternString: )
```

##Custom Use
1. AddRouter
`ACRouter.addRouter(patternString:  priority: handle: )`
It will store pattern information, and sort by priority reverse order
2. RequestRouter
`ACRouter.requestURL(urlString: userInfo: )`
Request the real urlString, and response the pattern information and the queries which contain the userInfo. if exist the same key, it will embed in array.

##Todo list
- `openURL` not only support Viewcontroller jumping
- Add Interceptor for router
- Add `openURL` failed action

## Author

2302693080@qq.com

## License

ACRouter is available under the MIT license. See the LICENSE file for more info.

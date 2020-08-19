# OsTools

[![CI Status](https://img.shields.io/travis/osfunapps/OsTools.svg?style=flat)](https://travis-ci.org/osfunapps/OsTools)
[![Version](https://img.shields.io/cocoapods/v/OsTools.svg?style=flat)](https://cocoapods.org/pods/OsTools)
[![License](https://img.shields.io/cocoapods/l/OsTools.svg?style=flat)](https://cocoapods.org/pods/OsTools)
[![Platform](https://img.shields.io/cocoapods/p/OsTools.svg?style=flat)](https://cocoapods.org/pods/OsTools)


This module serves as a foundemental toolkit to osApps iOS developing.

## Example functions and signatures
```
/// Will run a function after a delay. The delayed function will run on the main thread
public static func asyncMainTimedFunc(_ funcc: @escaping (() -> ()), _ seconds: Int = 0, millis: Int = 0) -> DispatchWorkItem {
    let task = DispatchWorkItem {
        funcc()
    }
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(seconds) + .milliseconds(millis), execute: task)
    return task
}

/// Will run a function after a delay. The delayed function will run on a background dq
public static func asyncTimedFunc(_ funcc: @escaping (() -> ()),
                           seconds: Int = 0,
                           millis: Int = 0,
                           qos: DispatchQoS.QoSClass = .utility) -> DispatchWorkItem {
    let task = DispatchWorkItem {
        funcc()
    }
    DispatchQueue.global(qos: qos).asyncAfter(deadline: DispatchTime.now() + .seconds(seconds) + .milliseconds(millis), execute: task)
    
    return task
}

/// Wll run a function after a delay on the main thread
public static func asyncMainTimedTask(task: DispatchWorkItem,
                               seconds: Int = 0,
                               millis: Int = 0) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds) + .milliseconds(millis), execute: task)
}

/// Wll run a function after a delay on a background thread
public static func asyncTimedTask(task: DispatchWorkItem,
                           seconds: Int = 0,
                            millis: Int = 0,
                            qos: DispatchQoS.QoSClass = .utility) {
    DispatchQueue.global(qos: qos).asyncAfter(deadline: DispatchTime.now() + .seconds(seconds) + .milliseconds(millis), execute: task)
}

/// Will return true if the char is of a language
public static func isLanguageChar(possibleChar: String) -> Bool {
    if(possibleChar.count > 1){
        return false
    }
    return (possibleChar.range(of: "[\\p{Alnum},\\s#\\-.]+", options: .regularExpression, range: nil, locale: nil) != nil)
}

/// Will return the top most view controller in the back stack
public static func getLastViewController(_ viewController: UIViewController) -> UIViewController? {
    let controllersCount = viewController.navigationController?.viewControllers.count
    if(controllersCount != nil) {
        return viewController.navigationController?.viewControllers[controllersCount! - 1]
    } else {
        return nil
    }
}
```


## Installation

OsTools is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OsTools'
```

## Author

osApps, support@os-apps.com

## License

OsTools is available under the MIT license. See the LICENSE file for more info.

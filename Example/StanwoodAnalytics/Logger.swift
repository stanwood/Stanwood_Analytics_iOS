//
//  Logger.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 23/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n"){
    
    let output = items.compactMap({ "\($0)" }).joined(separator: separator)
    AnalyticsService.log(output, tag: nil, filename: #file, line: #line, method: #function)
    
    if let errors = items.filter({ $0 is Error }) as? [Error] {
        errors.forEach({ error in
            AnalyticsService.track(error: error)
        })
    }
}

public func print(_ items: Any?..., separator: String = " ", terminator: String = "\n") {
    let items = items.compactMap({ $0 })
    guard items.count > 0 else { return }
    print(items)
}

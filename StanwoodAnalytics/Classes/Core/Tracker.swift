//
//  Tracker.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Stanwood GmbH (www.stanwood.io)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit

struct BuildConfiguration {
    static let debug = true
}

open class Tracker {
    let key: String?
    var loggingEnabled: Bool = false
    let context: UIApplication
    let logLevel: Int
    let isDebug: Bool
    private let placeholderString = "your-key-here"
    
    public init(builder: Builder) {
        DataStore.registerDefaults()
        context = builder.context
        loggingEnabled = builder.loggingEnabled
        key = builder.key
        logLevel = builder.logLevel
        isDebug = builder.isDebug
    }
    
    final func checkKey() {
        if key == placeholderString || key?.count == 0 {
            print("StanwoodAnalytics Error: No key defined for class: \(String(describing:self))")
        }
    }
    
    open func start() {
        assert(false)
    }
    
    open func track(trackingParameters: TrackingParameters) {
        assert(false)
    }
    
    open func track(trackerKeys: TrackerKeys) {
        assert(false)
    }

    open func track(error: NSError) {
        assert(false)
    }
    
    open func setTracking(enable: Bool) {
        assert(false)
    }
    
    open class Builder {
        var isDebug:Bool = BuildConfiguration.debug
        var logLevel = 0
        var loggingEnabled: Bool = false
        var exceptionTrackingEnabled = true
        let context: UIApplication
        public let key: String?
        
        public init(context: UIApplication, key: String? = nil) {
            self.context = context
            self.key = key
        }
        
        open func build() -> Tracker {
            return Tracker(builder: self)
        }
        
        open func setDebug(enable: Bool) -> Builder {
            self.isDebug = enable
            return self
        }
        
        open func setLogging(enable: Bool) -> Builder {
            self.loggingEnabled = enable
            return self
        }
        
        open func setExceptionTracking(enable: Bool) -> Builder {
            self.exceptionTrackingEnabled = enable
            return self
        }
    }
}


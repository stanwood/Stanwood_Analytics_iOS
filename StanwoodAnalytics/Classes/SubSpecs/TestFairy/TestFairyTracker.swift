//
//  TestFairyTracker.swift
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

open class TestFairyTracker: Tracker {
    
    init(builder: TestFairyBuilder) {
        super.init(builder: builder)
        
        super.checkKey()
        
        if StanwoodAnalytics.trackingEnabled() == true {
            start()
        }
    }
    
    open override func start() {
        TestFairy.begin(key)
    }
    
    override open func track(trackingParameters: TrackingParameters) {
        let message = "Event: \(String(describing: trackingParameters.eventName)) Name: \(String(describing: trackingParameters.name)) ItemId: \(String(describing: trackingParameters.itemId))"
        TestFairy.log(message)
    }
    
    override open func setTracking(enabled: Bool) {
        // NO-OP
    }
    
    override open func track(error: NSError) {
        // #if DEBUG || BETA
        // TFLogv(message, getVaList(args))
        // #endif
    }
    
    override open func track(trackerKeys: TrackerKeys) {
        
        for (key,value) in trackerKeys.customKeys {
            if key == StanwoodAnalytics.Keys.identifier {
                if let userId = value as? String {
                    TestFairy.setUserId(userId)
                }
            }
        }
    }
    
    open class TestFairyBuilder: Tracker.Builder {
        var uiEventLogging = false
        
        public override init(context: UIApplication, key: String?) {
            super.init(context: context, key: key)
        }
        
        open override func build() -> TestFairyTracker {
            return TestFairyTracker(builder: self)
        }
        
        open func setUIEventLogging(enable: Bool) -> TestFairyTracker.Builder {
            uiEventLogging = enable
            return self
        }
    }
}

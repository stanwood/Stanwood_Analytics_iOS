//
//  BugfenderTracker.swift
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
import BugfenderSDK

/// An enum to define the type of log to record. Logs are filtered according to type.
///
/// - info: Info
/// - warning: Warning
/// - error: Error
public enum BugfenderType: Int {
    case info
    case warning
    case error
    
    static func map(type: String) -> BugfenderType {
        if type.lowercased() == "warning" {
            return .warning
        } else if type.lowercased() == "error" {
            return .error
        }
        return .info
    }
}


/// Bugfender Tracker
open class BugfenderTracker: Tracker {
    
    init(builder: BugfenderBuilder) {
        super.init(builder: builder)
        
        loggingEnabled = builder.uiEventLogging
        
        super.checkKey()
        
        if StanwoodAnalytics.trackingEnabled() == true {
            start()
        }
    }
    
    /// Start logging. Calls activateLogger and enables UI event logging.
    open override func start() {
        Bugfender.activateLogger(key!)
        
        if loggingEnabled == true {
            Bugfender.enableUIEventLogging()
        }
    }
    
    /// Track data using TrackingParameters description.
    ///
    /// - Parameter trackingParameters: TrackingParameters struct
    override open func track(trackingParameters: TrackingParameters) {
        
        guard let contentType = trackingParameters.contentType else { return }
        
        let level = BugfenderType.map(type: contentType)
        
        var bugfenderLevel = BFLogLevel.default
        switch level {
        case .warning:
            bugfenderLevel = BFLogLevel.warning
        case .error:
            bugfenderLevel = BFLogLevel.error
        default:
            bugfenderLevel = BFLogLevel.default
        }
        
        Bugfender.log(lineNumber: 0,
                      method: "",
                      file: "",
                      level: bugfenderLevel,
                      tag: "",
                      message: trackingParameters.description ?? "")
    }
    
    
    /// Set Tracking. Not implemented.
    ///
    /// - Parameter enabled: Enabled
    override open func setTracking(enabled: Bool) {
        // NO-OP
    }
    
    override open func track(error: NSError) {
        
        if let description = error.userInfo[StanwoodAnalytics.Keys.localizedDescription] as? String {
            Bugfender.log(lineNumber: 0,
                          method: error.domain,
                          file: "",
                          level: BFLogLevel.error,
                          tag: "",
                          message: description)
        }
    }

    
    /// Track - no implemented.
    ///
    /// - Parameter trackerKeys: TrackerKeys struct
    override open func track(trackerKeys: TrackerKeys) {
        // Not used
    }
    
    open class BugfenderBuilder: Tracker.Builder {
        var uiEventLogging = false

        public override init(context: UIApplication, key: String?) {
            super.init(context: context, key: key)
        }

        /// Build the tracker
        ///
        /// - Returns: Fully configured tracker
        open override func build() -> BugfenderTracker {
            return BugfenderTracker(builder: self)
        }
        
        /// Enable UI event logging.
        ///
        /// - Parameter enable: Enable logging
        /// - Returns: The builder
        open func setUIEventLogging(enable: Bool) -> BugfenderTracker.Builder {
            uiEventLogging = enable
            return self
        }
    }
}


//
//public protocol BugfenderBase {
//    static func activateLogger(_ key: String)
//    static func enableUIEventLogging()
//    static func log(lineNumber: Int?, method: String?, file: String?, level: BugfenderType, tag: String?, message: String)
//}
//
//class BugfenderMock: BugfenderBase {
//
//    static func activateLogger(_ key: String) {
//
//    }
//
//    static func enableUIEventLogging() {
//
//    }
//
//    static func log(lineNumber: Int?, method: String?, file: String?, level: BugfenderType, tag: String?, message: String) {
//        print("Line: \(String(describing:lineNumber))")
//        print("Method: \(String(describing:method))")
//        print("File: \(String(describing:file))")
//        print("Tag: \(String(describing:tag))")
//        print("Message: \(String(describing:message))")
//    }
//}


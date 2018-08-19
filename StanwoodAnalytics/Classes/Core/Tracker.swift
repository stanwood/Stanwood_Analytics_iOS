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

/// The base class that must be subclassed for each analytics or logging frameworks
open class Tracker {
    let key: String?
    var loggingEnabled: Bool = false
    let context: UIApplication
    let logLevel: Int
    let isDebug: Bool
    private let placeholderString = "your-key-here"

    /// Init method
    ///
    /// - Parameter builder: The build class for this tracker
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
            print("StanwoodAnalytics Error: No key defined for class: \(String(describing: self))")
        }
    }

    /// Start method for the analytics framework. It is called if tracking is enabled (which is the default). This method must be overridden in a Tracker subclass.
    open func start() {
        assert(false)
    }

    /// Track data using tracking parameters. Called by StanwoodAnalytics class. This method must be overridden in a Tracker subclass.
    ///
    /// - Parameter trackingParameters: A struct for all the parameters
    open func track(trackingParameters _: TrackingParameters) {
        assert(false)
    }

    /// Track using custom keys. Called by StanwoodAnalytics class. This method must be overridden in a Tracker subclass.
    ///
    /// - Parameter trackerKeys: A struct of custom keys.
    open func track(trackerKeys _: TrackerKeys) {
        assert(false)
    }

    /// Track an NSError. Called by StanwoodAnalytics class. This method must be overridden in a Tracker subclass.
    ///
    /// - Parameter error: An NSError object
    open func track(error _: NSError) {
        assert(false)
    }

    /// Enable or disable tracking. Called by StanwoodAnalytics class. This method must be overridden in a Tracker subclass.
    ///
    /// - Parameter enable: enable tracking
    open func setTracking(enabled _: Bool) {
        assert(false)
    }

    /// The builder for the tracker.
    open class Builder {
        var isDebug: Bool = BuildConfiguration.debug
        var logLevel = 0
        var loggingEnabled: Bool = false
        var exceptionTrackingEnabled = true
        let context: UIApplication
        public let key: String?

        /// Init function. Pass in the application context as it is a required parameter. The key is optional.
        ///
        /// - Parameters:
        ///   - context: The UIApplication context.
        ///   - key: The key to enable the analytics framework.
        public init(context: UIApplication, key: String? = nil) {
            self.context = context
            self.key = key
        }

        /// Build the tracker.
        ///
        /// - Returns: The configured Tracker object.
        open func build() -> Tracker {
            return Tracker(builder: self)
        }

        /// Enable the debug mode for the framework if aplicable. Returns the builder so that it can be chained.
        ///
        /// - Parameter enable: Enable the debug mode.
        /// - Returns: The builder object
        open func setDebug(enabled: Bool) -> Builder {
            isDebug = enabled
            return self
        }

        /// Enable the logging feature if the framework supports it. Returns the builder so that it can be chained.
        ///
        /// - Parameter enable: Enable the logging mode.
        /// - Returns: The builder object
        open func setLogging(enabled: Bool) -> Builder {
            loggingEnabled = enabled
            return self
        }

        /// Enable the exception tracking feature if the framework supports it. Returns the builder so that it can be chained.
        ///
        /// - Parameter enable: Enable exception tracking.
        /// - Returns: The builder object
        open func setExceptionTracking(enabled: Bool) -> Builder {
            exceptionTrackingEnabled = enabled
            return self
        }
    }
}

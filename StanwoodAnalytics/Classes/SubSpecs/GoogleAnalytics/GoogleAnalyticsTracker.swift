//
//  GoogleAnalyticsTracker.swift
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

/// MapFunction
/// Use a map function to customise the mapping of the tracking parameter keys to the fields required for your application.
public protocol MapFunction {
    func mapCategory(parameters: TrackingParameters) -> String?
    func mapAction(parameters: TrackingParameters) -> String?
    func mapLabel(parameters: TrackingParameters) -> String?
    func mapScreenName(parameters: TrackingParameters) -> String?
    func mapKeys(keys: TrackerKeys) -> [Int: String]?
}

public struct GoogleMapFunction: MapFunction {
    public func mapCategory(parameters: TrackingParameters) -> String? {
        return parameters.eventName
    }

    public func mapAction(parameters: TrackingParameters) -> String? {
        return parameters.name
    }

    public func mapLabel(parameters: TrackingParameters) -> String? {
        return parameters.itemId
    }

    public func mapScreenName(parameters: TrackingParameters) -> String? {

        if parameters.eventName.lowercased() == StanwoodAnalytics.TrackingEvent.viewItem.rawValue.lowercased() {
            return parameters.name
        }
        return nil
    }

    /// Subclass the map function and implement this method.
    public func mapKeys(keys _: TrackerKeys) -> [Int: String]? {
        return nil
    }
}

/// GoogleAnalytics Tracker
open class GoogleAnalyticsTracker: Tracker {
    private var activityTracking: Bool = false
    private var exceptionTracking: Bool = false
    private var adIdCollection: Bool = false

    /// Map function
    var mapFunction: MapFunction?

    init(builder: GoogleAnalyticsBuilder) {
        super.init(builder: builder)

        activityTracking = builder.activityTracking
        exceptionTracking = builder.exceptionTrackingEnabled
        adIdCollection = builder.adIdCollection
        mapFunction = builder.mapFunction

        super.checkKey()

        if StanwoodAnalytics.trackingEnabled() == true {
            start()
        }
    }

    /// Start the tracking
    open override func start() {
        guard let gai = GAI.sharedInstance() else { return }
        gai.trackUncaughtExceptions = exceptionTracking
        if loggingEnabled == true {
            gai.logger.logLevel = GAILogLevel.verbose
        }

        let tracker = gai.defaultTracker
        tracker?.set(kGAIAnonymizeIp, value: "1")

        gai.optOut = false
    }

    /// Enable tracking. This method employs the opt-out flag in the framework.
    ///
    /// - Parameter enabled: enable flag
    open override func setTracking(enabled: Bool) {
        guard let gai = GAI.sharedInstance() else { return }
        gai.optOut = !enabled
    }

    /// Track the parameters. If a map function is defined and screen name if not nil, it calls
    ///
    /// - Parameter trackingParameters: Tracking parameters struct
    open override func track(trackingParameters: TrackingParameters) {
        if let screenName = mapFunction?.mapScreenName(parameters: trackingParameters) {
            trackScreenView(screenName)
        } else {
            trackEvent(with: trackingParameters)
        }
    }

    /// :nodoc:
    fileprivate func trackEvent(with parameters: TrackingParameters) {
        guard let action = mapFunction?.mapAction(parameters: parameters) else { return }
        guard let label = mapFunction?.mapLabel(parameters: parameters) else { return }
        guard let category = mapFunction?.mapCategory(parameters: parameters) else { return }
        guard let tracker = GAI.sharedInstance().tracker(withTrackingId: key) else { return }

        if let builder = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: 0),
            let build = (builder.build() as NSDictionary) as? [AnyHashable: Any] {
            tracker.send(build)
        }
    }

    /// :nodoc:
    fileprivate func trackScreenView(_ screenName: String) {
        let tracker = GAI.sharedInstance().tracker(withTrackingId: key)
        tracker?.set(kGAIScreenName, value: screenName)

        // Adding custom dimensions
        tracker?.set(GAIFields.customDimension(for: 1), value: screenName)

        if let builder = GAIDictionaryBuilder.createScreenView(), let build = (builder.build() as NSDictionary) as? [AnyHashable: Any] {
            tracker?.send(build)
        }

        // Sending custom dimentions
        if let builder = GAIDictionaryBuilder.createScreenView() {
            builder.set(screenName, forKey: GAIFields.customDimension(for: 1))
            let parameters = builder.build() as! [AnyHashable: Any]
            tracker?.send(parameters)
        }
    }

    /// Track NSError as a non-fatal exception.
    ///
    /// - Parameter error: NSError
    open override func track(error: NSError) {
        let description = error.localizedDescription
        let gaiData = GAIDictionaryBuilder.createException(withDescription: description,
                                                           withFatal: false)
        let tracker = GAI.sharedInstance().tracker(withTrackingId: key)
        tracker?.send(gaiData?.build() as! [AnyHashable: Any])
    }

    /// Track custom keys
    ///
    /// It is necessary to add a custom mapper for this to work, and implement the mapKeys function, because the default is nil.
    ///
    /// The implementation here requires [Int:String] as the Int is a custom dimention parameter in GA.
    ///
    /// - Parameter trackerKeys: tracker keys struct
    open override func track(trackerKeys: TrackerKeys) {
        guard let mapped = self.mapFunction?.mapKeys(keys: trackerKeys) else { return }
        let tracker = GAI.sharedInstance().tracker(withTrackingId: key)

        for (key, value) in mapped {
            let custom = GAIFields.customDimension(for: UInt(key))
            tracker?.set(custom, value: value)
        }

        if let builder = GAIDictionaryBuilder.createScreenView(), let build = (builder.build() as NSDictionary) as? [AnyHashable: Any] {
            tracker?.send(build)
        }
    }

    /// Set a value for kGAIUserId
    ///
    /// - Parameter clientID: Clinet Id.
    func set(clientID: String) {
        let tracker = GAI.sharedInstance().tracker(withTrackingId: key)
        tracker?.set(kGAIUserId, value: clientID)
    }

    /// Builder
    open class GoogleAnalyticsBuilder: Tracker.Builder {
        var uiEventLogging = false
        var sampleRate: Int = 0
        var activityTracking: Bool = false
        var adIdCollection: Bool = false
        var mapFunction: MapFunction = GoogleMapFunction()

        /// Init the builder
        ///
        /// - Parameters:
        ///   - context: UIApplication context
        ///   - key: GA Key
        public override init(context: UIApplication, key: String?) {
            super.init(context: context, key: key)
        }

        open override func build() -> GoogleAnalyticsTracker {
            return GoogleAnalyticsTracker(builder: self)
        }

        /// Set the Mapfunction
        ///
        /// - Parameter mapFunction: custom map function
        /// - Returns: Builder so that it can be chained.
        open func set(mapFunction: MapFunction) -> GoogleAnalyticsBuilder {
            self.mapFunction = mapFunction
            return self
        }

        /// Enable UI event logging.
        ///
        /// - Parameter enabled: Set UI event logging.
        /// - Returns: Builder so that it can be chained.
        open func setUIEventLogging(enabled: Bool) -> GoogleAnalyticsTracker.Builder {
            uiEventLogging = enabled
            return self
        }
    }
}

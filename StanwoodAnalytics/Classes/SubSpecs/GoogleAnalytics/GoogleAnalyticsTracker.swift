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

public protocol MapFunction {
    func mapCategory(parameters: TrackingParameters) -> String?
    func mapAction(parameters: TrackingParameters) -> String?
    func mapLabel(parameters: TrackingParameters) -> String?
    func mapScreenName(parameters: TrackingParameters) -> String?
    func mapKeys(keys: TrackerKeys) -> [Int:String]?
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
        
        if parameters.eventName.lowercased() == TrackingEvent.viewItem.rawValue.lowercased() {
            return parameters.name
        }
        return nil
    }
    
    /// Subclass the map function and implement this method.
    public func mapKeys(keys: TrackerKeys) -> [Int:String]? {
        return nil
    }
}

open class GoogleAnalyticsTracker: Tracker {
    private var activityTracking: Bool = false
    private var exceptionTracking: Bool = false
    private var adIdCollection: Bool = false
    
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
    
    override open func setTracking(enabled: Bool) {
        guard let gai = GAI.sharedInstance() else { return }
        gai.optOut = !enabled
    }
    
    override open func track(trackingParameters: TrackingParameters) {
        if let screenName = mapFunction?.mapScreenName(parameters: trackingParameters) {
            trackScreenView(screenName)
        } else {
            trackEvent(with: trackingParameters)
        }
    }
    
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
    
    override open func track(error: NSError) {
        let description = error.localizedDescription
        let gaiData = GAIDictionaryBuilder.createException(withDescription: description,
                                                           withFatal: false)
        let tracker = GAI.sharedInstance().tracker(withTrackingId: key)
        tracker?.send(gaiData?.build() as! [AnyHashable : Any])
    }
    
    /**
     Track custom keys
     
     It is necessary to add a custom mapper for this to work, and implement the
     mapKeys function, because the default is nil.
     
     The implementation here requires [Int:String] as the Int is a custom dimention parameter in GA.
    */
    override open func track(trackerKeys: TrackerKeys) {
        guard let mapped = self.mapFunction?.mapKeys(keys: trackerKeys) else { return }
        let tracker = GAI.sharedInstance().tracker(withTrackingId: key)
        
        for (key,value) in mapped {
            let custom = GAIFields.customDimension(for:UInt(key))
            tracker?.set(custom, value: value)
        }
        
        if let builder = GAIDictionaryBuilder.createScreenView(), let build = (builder.build() as NSDictionary) as? [AnyHashable: Any] {
            tracker?.send(build)
        }
    }
    
    func set(clientID: String) {
        let tracker = GAI.sharedInstance().tracker(withTrackingId: key)
        tracker?.set(kGAIUserId, value: clientID)
    }
    
    open class GoogleAnalyticsBuilder: Tracker.Builder {
        var uiEventLogging = false
        var sampleRate: Int = 0
        var activityTracking: Bool = false
        var adIdCollection: Bool = false
        var mapFunction: MapFunction = GoogleMapFunction()

        public override init(context: UIApplication, key: String?) {
            super.init(context: context, key: key)
        }

        open override func build() -> GoogleAnalyticsTracker {
            return GoogleAnalyticsTracker(builder: self)
        }
        
        open func set(mapFunction: MapFunction) -> GoogleAnalyticsBuilder {
            self.mapFunction = mapFunction
            return self
        }
        
        open func setUIEventLogging(enable: Bool) -> GoogleAnalyticsTracker.Builder {
            uiEventLogging = enable
            return self
        }
    }
}

//
//  AppTracker.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 26/01/2018.
//  Copyright © 2018 Stanwood. All rights reserved.
//

import UIKit
import StanwoodAnalytics
import UserNotifications
import Crashlytics

struct CustomMapFunction: MapFunction {
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
        if keys.customKeys.count == 0 {
            return nil
        }
        
        var filteredKeys: [Int:String] = [:]
        
        for (key, value) in keys.customKeys {
            if let numberKey = Int(key) {
                filteredKeys[numberKey] = value as? String
            }
        }
        
        if filteredKeys.count > 0 {
            return filteredKeys
        }
        
        return nil
    }
}

struct DefaultParameterMapper: ParameterMapper {
    func map(parameters: TrackingParameters) -> [String : NSString] {
        var keyValues: [String:NSString] = [:]
        
        keyValues["category"] = NSString(string: parameters.eventName)
        
        if let itemId = parameters.itemId {
            keyValues["label"] = NSString(string: itemId)
        }
        
        if let name = parameters.name {
            keyValues["action"] = NSString(string: name)
        }
        
        return keyValues
    }
}

struct AnalyticsService {
    static var analytics: StanwoodAnalytics?
    
    // static let shared
    
    static func configure() {
        let application = UIApplication.shared
        let fabricTracker = FabricTracker.FabricBuilder(context: application, key: nil).build()
        let parameterMapper = DefaultParameterMapper()
        let firebaseTracker = FirebaseTracker.FirebaseBuilder(context: application, configFileName: Configuration.Static.Analytics.firebaseConfigFileName)
            .add(mapper: parameterMapper)
            .build()
        let mixpanelTracker = MixpanelTracker.MixpanelBuilder(context: application, key: Configuration.Static.Analytics.mixpanelToken).build()
        
        let googleTrackerBuilder = GoogleAnalyticsTracker.GoogleAnalyticsBuilder(context: application, key: Configuration.Static.Analytics.googleTrackingKey)
            .set(mapFunction: CustomMapFunction())
        let googleTracker = googleTrackerBuilder.build()
        
        var analyticsBuilder = StanwoodAnalytics.builder()
            .add(tracker: fabricTracker)
            .add(tracker: firebaseTracker)
            .add(tracker: mixpanelTracker)
            .add(tracker: googleTracker)

    #if DEBUG || BETA
        
        let testFairyTracker = TestFairyTracker.TestFairyBuilder(context: application, key: Configuration.Static.Analytics.testFairyKey).build()
        analyticsBuilder = analyticsBuilder.add(tracker: testFairyTracker)
        
        #if BF_ENABLED
        let bugfenderTracker = BugfenderTracker.BugfenderBuilder(context: application, key: bugFenderKey)
            .setUIEventLogging(enable: true)
            .build()
        analyticsBuilder = analyticsBuilder.add(tracker: bugfenderTracker)
        #endif
        
        #if DEBUG
        analytics = analyticsBuilder.setNotificationDelegate(delegate: notificationDelegate).build()
        
        #else
        analytics = analyticsBuilder.build()
        #endif
         
    #else
        analytics = analyticsBuilder.build()
    #endif
        
    }
    
    static func trackingEnabled() -> Bool {
        return StanwoodAnalytics.trackingEnabled()
    }
    
    static func setTracking(enable: Bool) {
        guard let analytics = AnalyticsService.analytics else { return }
        analytics.setTracking(enable: enable)
    }
    
    static func track(error: Error) {
        guard let analytics = AnalyticsService.analytics else { return }
        analytics.track(error: error as NSError)
    }
    
    static func track(trackingParameters: TrackingParameters) {
        guard let analytics = AnalyticsService.analytics else { return }
        analytics.track(trackingParameters: trackingParameters)
    }
    
    static func track(trackerKeys: TrackerKeys) {
        guard let analytics = AnalyticsService.analytics else { return }
        analytics.track(trackerKeys: trackerKeys)
    }

    static func trackScreen(name: String, className: String) {
        guard let analytics = AnalyticsService.analytics else { return }
        analytics.trackScreen(name: name, className: className)
        
        let trackingParameters = TrackingParameters.init(eventName: TrackingEvent.viewItem.rawValue, name: name)
        analytics.track(trackingParameters: trackingParameters)
    }
    
    // An example taken from Schneehohen on how to map resort ids to analytics.
    // This is set in GoogleAnalytics as custom dimensions.
    static func trackResortView(screen: String, resortId: Int, resortName: String) {
        guard let analytics = AnalyticsService.analytics else { return }
        var trackerKeys = TrackerKeys()
        trackerKeys.customKeys = ["resortId": String(describing: resortId)]
        trackerKeys.customKeys["resortName"] = resortName
        analytics.track(trackerKeys: trackerKeys)
    }
    
    static func track(userName: String?, email: String?, identifier: String?) {
        guard let analytics = AnalyticsService.analytics else { return }
        var trackerKeys = TrackerKeys()
        if let identifier = identifier {
            trackerKeys.customKeys[StanwoodAnalytics.Keys.identifier] = identifier
        }
        if let email = email {
            trackerKeys.customKeys[StanwoodAnalytics.Keys.email] = email
        }
        
        if let userName = userName {
            trackerKeys.customKeys[StanwoodAnalytics.Keys.userName] = userName
        }
        
        analytics.track(trackerKeys: trackerKeys)
    }
    
    static func log(_ message: String, tag: String? = nil, filename: String = #file, line: Int = #line, method: String = #function) {
        if trackingEnabled() {
            #if DEBUG || BETA
            TFLogv("\(filename).\(method), line: \(line) $ \(message)", getVaList([]))
            
            CLSNSLogv(message, getVaList([]))
            
            #if BF_ENABLED
            BFLog(message, [])
            Bugfender.log(lineNumber: line,
                          method: method,
                          file: filename,
                          level: .default,
                          tag: tag,
                          message: message)
            #endif
            Swift.print(message)
            #else
            CLSLogv("\(filename).\(method), line: \(line) $ \(message)", getVaList([]))
            #endif
        }
    }
}

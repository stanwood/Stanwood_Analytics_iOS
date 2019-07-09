//
//  FirebaseTracker.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 02/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
// import StanwoodAnalytics

/*

 These event names are reserved and cannot be used:

 ad_activeview
 ad_click
 ad_exposure
 ad_impression
 ad_query
 adunit_exposure
 app_clear_data
 app_remove
 app_update
 error
 first_open
 in_app_purchase
 notification_dismiss
 notification_foreground
 notification_open
 notification_receive
 os_update
 screen_view
 session_start
 user_engagement

 */

/// Custom parameter mapper for Firebase.
///
/// ItemId -> AnalyticsParameterItemID
/// ContentType -> AnalyticsParameterContentType
/// Category -> AnalyticsParameterItemCategory
/// Name -> AnalyticsParameterItemName
///
struct FirebaseParameterMapper: ParameterMapper {
    func map(parameters: TrackingParameters) -> [String: NSString] {
        var keyValues: [String: NSString] = [:]

        if let itemId = parameters.itemId {
            keyValues[AnalyticsParameterItemID] = NSString(string: itemId)
        }

        if let contentType = parameters.contentType {
            keyValues[AnalyticsParameterContentType] = NSString(string: contentType)
        }

        if let category = parameters.category {
            keyValues[AnalyticsParameterItemCategory] = NSString(string: category)
        }

        if let name = parameters.name {
            keyValues[AnalyticsParameterItemName] = NSString(string: name)
        }

        return keyValues
    }
}

public protocol FirebaseCoreEnabler {
    static func configure(options: [String: String])
}

public protocol FirebaseAnalyticsEnabler {
    static func logEvent()
    static func setScreenName()
}

/// FirebaseAnalytics Tracker
open class FirebaseTracker: Tracker {

    var parameterMapper: ParameterMapper?

    /// Init method for the tracker. It checks that tracking enabled is set in the StanwoodAnalytics framework.
    /// It will then check for the existence for FirebaseApp to see if an init call already been called
    /// and will print a warning to the console if it has been.
    ///
    /// It checks for the existence of GoogleService-Info.plist file is no file name has been passed in the configuration.
    ///
    /// - Parameter builder: <#builder description#>
    init(builder: FirebaseBuilder) {
        super.init(builder: builder)

        if builder.parameterMapper == nil {
            parameterMapper = FirebaseParameterMapper()
        } else {
            parameterMapper = builder.parameterMapper
        }

        Analytics.setAnalyticsCollectionEnabled(StanwoodAnalytics.trackingEnabled())

        if FirebaseApp.app() == nil {

            if builder.configFileName != nil {
                guard let firebaseConfigFile = Bundle.main.path(forResource: builder.configFileName, ofType: "plist") else {
                    let fileName = builder.configFileName!
                    print("StanwoodAnalytics Error: The file \(String(describing: fileName)) cannot be found.")
                    return
                }
                let firebaseOptions = FirebaseOptions(contentsOfFile: firebaseConfigFile)
                FirebaseApp.configure(options: firebaseOptions!)
            } else {
                if hasConfigurationFile() == true {
                    FirebaseApp.configure()
                }
            }

        } else {
            print("StanwoodAnalytics Warning: Firebase has been configured elsewhere.")
        }
    }

    private func hasConfigurationFile() -> Bool {
        guard let _ = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            print("StanwoodAnalytics Error: The GoogleService-Info property list used to configure Firebase Analytics cannot be found.")
            return false }
        return true
    }

    /// Calls the enable function of the analytics collection function of the FirebaseAnalytics framework.
    open override func start() {
        Analytics.setAnalyticsCollectionEnabled(true)
    }

    /// Sets the analytics collection enabled or disabled.
    open override func setTracking(enabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(enabled)
    }

    /// Track data in the TrackingParameters struct into FirebaseAnalytics.
    ///
    /// Uses the paramater mapper to map the Tracking parameters to those used by Firebase Analytics.
    ///
    /// This mapping uses the following parameters:
    ///
    /// event name
    /// name
    /// category
    /// contentType
    /// itemId
    /// description
    ///
    /// - Parameter trackingParameters: TrackingParameters struct
    open override func track(trackingParameters: TrackingParameters) {

        if parameterMapper != nil {
            Analytics.logEvent(trackingParameters.eventName, parameters: parameterMapper?.map(parameters: trackingParameters))
        } else {
            var keyValueDict: [String: NSString] = ["event_name": trackingParameters.eventName as NSString]

            if let category = trackingParameters.category {
                keyValueDict["category"] = category as NSString
            }

            if let contentType = trackingParameters.contentType {
                keyValueDict["contentType"] = contentType as NSString
            }

            if let itemId = trackingParameters.itemId {
                keyValueDict["itemId"] = itemId as NSString
            }

            if let name = trackingParameters.name {
                keyValueDict["name"] = name as NSString
            }

            if let description = trackingParameters.description {
                keyValueDict["description"] = description as NSString
            }

            Analytics.logEvent(trackingParameters.eventName, parameters: keyValueDict)
        }
    }

    /**

     Track the error using logEvent and the UserInfo dictionary.

     */

    open override func track(error: NSError) {
        let parameters = error.userInfo as [String: Any]
        Analytics.logEvent("error", parameters: parameters)
    }

    /**

     Track screen name and class.

     Using the custom keys and values, use the StanwoodAnalytics.Key.screenName key

     */
    open override func track(trackerKeys: TrackerKeys) {
        let customKeys = trackerKeys.customKeys

        var screenName: String = ""
        var screenClass: String = ""

        for (key, value) in customKeys {
            if key == StanwoodAnalytics.Keys.screenName {
                screenName = value as! String
            }

            if key == StanwoodAnalytics.Keys.screenClass {
                screenClass = value as! String
            }
        }

        if !screenName.isEmpty {
            if screenClass.isEmpty {
                Analytics.setScreenName(screenName, screenClass: nil)
            } else {
                Analytics.setScreenName(screenName, screenClass: screenClass)
            }
        }
    }

    open class FirebaseBuilder: Tracker.Builder {

        var parameterMapper: ParameterMapper?
        var configFileName: String?

        public init(context: UIApplication, configFileName: String? = nil) {
            super.init(context: context, key: nil)
            self.configFileName = configFileName
        }

        open func add(mapper: ParameterMapper) -> FirebaseBuilder {
            parameterMapper = mapper
            return self
        }

        open override func build() -> FirebaseTracker {
            return FirebaseTracker(builder: self)
        }
    }
}

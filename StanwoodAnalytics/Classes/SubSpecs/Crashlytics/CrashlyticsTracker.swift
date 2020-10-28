//
//  FabricTracker.swift
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
import FirebaseCore
import FirebaseCrashlytics

/// Fabric Tracker
///
/// For this tracker to work, it is necessary to insert the Fabric and Crashlytics configuration into the Info.plist,
/// and add a run script phase that calls Fabric.framework/run with the token.
open class CrashlyticsTracker: Tracker {

    /// Init function
    ///
    /// - Parameter builder: Tracker builder
    init(builder: CrashlyticsBuilder) {
        super.init(builder: builder)

        if StanwoodAnalytics.trackingEnabled() == true {
            start()
        }
    }

    /// Start the tracking. This function verifies that the Fabric key has been defined in the Application Info.plist
    open override func start() {
        if hasFabricKey() == true {
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
        } else {
            print("StanwoodAnalytics Error: The Fabric API key is not found in the Info.plist.")
        }
    }

    /// :nodoc:
    private func hasFabricKey() -> Bool {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else { return false }
        guard let resourceFileDictionary = NSDictionary(contentsOfFile: path) else { return false }
        guard let fabricConfiguration = resourceFileDictionary["Fabric"] as? NSDictionary else { return false }
        guard let APIKey = fabricConfiguration["APIKey"] as? String else { return false }
        return APIKey.count > 0 ? true : false
    }

    /// Track data to the framework. This is called by StanwoodAnalytics.
    /// Only the parameters eventName, name and itemId are tracked using the CLSLogv function.
    ///
    /// - Parameter trackingParameters: `TrackingParameters` struct
    open override func track(trackingParameters: TrackingParameters) {

        let logMessage = "Event: \(String(describing: trackingParameters.eventName)) "
            + "Name: \(String(describing: trackingParameters.name)) "
            + "ItemId: \(String(describing: trackingParameters.itemId))"

        #if DEBUG || STAGE
            Crashlytics.crashlytics().log("\(logMessage)")
        #else
            //CLSLogv("%s", getVaList([logMessage]))
        #endif
    }

    /// Set Tracking. No implemented here is there is no switch for it in the framework.
    /// The change will only take place on the next app start.
    ///
    /// - Parameter enabled: enable tracking
    open override func setTracking(enabled _: Bool) {
    }

    /// Track NSError to Crashlytics recordError method.
    ///
    /// - Parameter error: NSError
    open override func track(error: NSError) {
        Crashlytics.crashlytics().record(error: error)
    }

    /**

     Use this for tracking custom keys and values.

     The user name, email and identifier are set using the keys definied in the analytics class.

     Sends data types to Crashlytics: Bool, Int32, Float, String or and object.

     */

    /// TrackerKeys Use this for tracking custom keys and values.
    ///
    /// The user name, email and identifier are set using the keys definied in the analytics class.
    ///
    /// It will send these data types to Crashlytics: Bool, Int32, Float, String or and object.
    ///
    /// - Parameter trackerKeys: trackerKeys
    open override func track(trackerKeys: TrackerKeys) {
        let customKeys = trackerKeys.customKeys

        for (key, value) in customKeys {
            if key == StanwoodAnalytics.Keys.identifier {
                if let identifier = value as? String {
                    Crashlytics.crashlytics().setUserID(identifier)
                }
            } else {
                Crashlytics.crashlytics().setCustomValue(value, forKey: key)
            }
        }
    }

    /// The builder class for this tracker. Although the application is a required parameter, it is not used.
    open class CrashlyticsBuilder: Tracker.Builder {

        public override init(context: UIApplication, key: String?) {
            super.init(context: context, key: key)
        }

        open override func build() -> CrashlyticsTracker {
            return CrashlyticsTracker(builder: self)
        }
    }
}

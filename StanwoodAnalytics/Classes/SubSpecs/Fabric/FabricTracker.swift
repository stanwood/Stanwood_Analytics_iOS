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
import Crashlytics
import Fabric

open class FabricTracker: Tracker {
    
    init(builder: FabricBuilder) {
        super.init(builder: builder)
        
        if StanwoodAnalytics.trackingEnabled() == true {
            start()
        }
    }
    
    open override func start() {
        if hasFabricKey() == true {
            Fabric.with([Crashlytics.self])
        } else {
            print("StanwoodAnalytics Error: The Fabric API key is not found in the Info.plist.")
        }
        
    }

    private func hasFabricKey() -> Bool {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else { return false }
        guard let resourceFileDictionary = NSDictionary(contentsOfFile: path) else { return false }
        guard let fabricConfiguration = resourceFileDictionary["Fabric"] as? NSDictionary else { return false }
        guard let APIKey = fabricConfiguration["APIKey"] as? String else { return false }
        return APIKey.count > 0 ? true : false
    }

    /**

     Note: For Fabric and Crashlytics to work, you have to update the Info.plist file with the data from the Fabric website, and add a run script phase that calls Fabric.framework/run with the token.
     
     
     Only the parameters event name, name and item Id are tracked using the CLSLogv function.
     
    */
    
    override open func track(trackingParameters: TrackingParameters) {
        
        let logMessage = "Event: \(String(describing: trackingParameters.eventName)) "
                       + "Name: \(String(describing: trackingParameters.name)) "
                       + "ItemId: \(String(describing: trackingParameters.itemId))"
        
        #if DEBUG || STAGE
            CLSNSLogv("%s", getVaList([logMessage]))
        #else
            CLSLogv("%s", getVaList([logMessage]))
        #endif
    }
    
    override open func setTracking(enabled: Bool) {
        
    }
    
    /**
     
     Passes the error directly to Crashlytics recordError method.
 
    */
    
    override open func track(error: NSError) {
        Crashlytics.sharedInstance().recordError(error)
    }
    
    /**
     
     Use this for tracking custom keys and values.
     
     The user name, email and identifier are set using the keys definied in the analytics class.
     
     Sends data types to Crashlytics: Bool, Int32, Float, String or and object.
 
    */
    
    override open func track(trackerKeys: TrackerKeys) {
        let customKeys = trackerKeys.customKeys
        
        for (key,value) in customKeys {
            if key == StanwoodAnalytics.Keys.identifier {
                let identifier = value as? String
                Crashlytics.sharedInstance().setUserIdentifier(identifier)
            } else if (key == StanwoodAnalytics.Keys.email) {
                let email = value as? String
                Crashlytics.sharedInstance().setUserEmail(email)
            } else if (key == StanwoodAnalytics.Keys.userName) {
                let userName = value as? String
                Crashlytics.sharedInstance().setUserName(userName)
            } else {
                if let intValue = value as? Int32 {
                    Crashlytics.sharedInstance().setIntValue(intValue, forKey: key)
                }
                
                else if let floatValue = value as? Float {
                    Crashlytics.sharedInstance().setFloatValue(floatValue, forKey: key)
                }
                
                else if let boolValue = value as? Bool {
                    Crashlytics.sharedInstance().setBoolValue(boolValue, forKey: key)
                }
                
                else if let stringValue = value as? NSString {
                    Crashlytics.sharedInstance().setObjectValue(stringValue, forKey: key)
                }
            }
        }
    }
    
    /**
     
     The builder class for this tracker. Although the application is a required parameter, it is not used.
 
    */
    
    open class FabricBuilder: Tracker.Builder {

        public override init(context: UIApplication, key: String?) {
            super.init(context: context, key: key)
        }
        
        open override func build() -> FabricTracker {
            return FabricTracker(builder: self)
        }
    }
}

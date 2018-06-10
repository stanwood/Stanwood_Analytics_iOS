//
//  MixpanelTracker.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 16/03/2018.
//  Copyright © 2018 Stanwood. All rights reserved.
//

//
//  FirebaseTracker.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 02/01/2018.
//  Copyright © 2018 Stanwood. All rights reserved.
//

import Foundation
import StanwoodAnalytics
import Mixpanel

open class MixpanelTracker: Tracker {

    var parameterMapper: ParameterMapper?

    init(builder: MixpanelBuilder) {
        super.init(builder: builder)

        Mixpanel.initialize(token: builder.key!)
    }

    override open func track(trackingParameters: TrackingParameters) {

        var properties: [String:String] = [:]
        properties["EventName"] = trackingParameters.eventName

        if let name = trackingParameters.name {
            properties["Name"] = name
        }

        if let itemId = trackingParameters.itemId {
            properties["ItemId"] = itemId
        }

        if let contentType = trackingParameters.contentType {
            properties["ContentType"] = contentType
        }

        if let category = trackingParameters.category {
            properties["Category"] = category
        }

        if let description = trackingParameters.description {
            properties["Description"] = description
        }
        
        trackingParameters.customParameters.forEach { (arg) in
            let (key, value) = arg
            properties[key] = value as? String
        }

        Mixpanel.mainInstance().track(event: trackingParameters.eventName, properties: properties)
    }

    /**

     Track the error using logEvent and the UserInfo dictionary.

     */

    override open func track(error: NSError) {
        // Not tracking errors
    }

    override open func track(trackerKeys: TrackerKeys) {

        for (key,value) in trackerKeys.customKeys {
            if key == StanwoodAnalytics.Keys.screenName {
                if let screenName = value as? String {
                    Mixpanel.mainInstance().track(event: key, properties: [key: screenName])
                }
            } else if key == StanwoodAnalytics.Keys.identifier {
                if let userId = value as? String {
                    Mixpanel.mainInstance().identify(distinctId: userId)
                }
            } else if key == StanwoodAnalytics.Keys.email {
                if let userEmail = value as? String {
                    Mixpanel.mainInstance().people.set(property: "$email", to: userEmail)
                }
            } else {
                
                if let anyValue = value as? MixpanelType {
                    Mixpanel.mainInstance().people.set(property: key, to: anyValue)
                } else {
                    print("StanwoodAnalytics Error: Unsupported value for key (" + String(describing: key) + ") in TrackerKeys")
                }
            }
        }
    }

    open class MixpanelBuilder: Tracker.Builder {

        var parameterMapper: ParameterMapper?

        public override init(context: UIApplication, key: String?) {
            super.init(context: context, key: key)
        }

        open func add(mapper: ParameterMapper) -> MixpanelBuilder {
            parameterMapper = mapper
            return self
        }

        open override func build() -> MixpanelTracker {
            return MixpanelTracker(builder: self)
        }
    }
}



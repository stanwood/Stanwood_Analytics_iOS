//
//  StanwoodAnalytics.swift
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

import UIKit
import UserNotifications

public protocol ParameterMapper {
    func map(parameters: TrackingParameters) -> [String:NSString]
}

public enum TrackingEvent: String {
    case viewItem = "view_item"
    case addToCart = "add_to_cart"
    case login = "login"
    case selectContent = "select_content"
    case viewItemList = "view_item_list"
    case viewSearchResults = "view_search_results"
    case share = "share"
    case message = "message"
    case debug = "debug"
}

public struct TrackingParameters {
    public let eventName: String
    
    public var itemId: String?
    public var name: String?
    public var description: String?
    public var category: String?
    public var contentType: String?
    public var customParameters: [String:Any] = [:]
    
    public init(eventName: String) {
        self.eventName = eventName
        self.itemId = nil
        self.name = nil
        self.description = nil
        self.category = nil
        self.contentType = nil
    }
    
    public init(eventName: String,
                itemId: String?,
                name: String?,
                description: String?,
                category: String?,
                contentType: String?) {
        
        self.eventName = eventName
        self.itemId = itemId
        self.name = name
        self.description = description
        self.category = category
        self.contentType = contentType
    }
    
    public init(eventName: String,
                contentType: String?) {
        
        self.eventName = eventName
        self.itemId = nil
        self.name = nil
        self.description = nil
        self.category = nil
        self.contentType = contentType
    }
    
    public init(eventName: String,
                name: String?) {
        
        self.eventName = eventName
        self.itemId = nil
        self.name = name
        self.description = nil
        self.category = nil
        self.contentType = nil
    }
    
    public func debugInfo() -> String {
        var line1 = "Event: " + eventName + "\n"
        
        if let debugName = name {
            line1.append("Name: " + debugName + " ")
        }
        
        if let debugId = itemId {
            line1.append("ItemId: " + debugId + " ")
        }
        
        if let debugDescription = description {
            line1.append("Description: " + debugDescription + " ")
        }
        
        if let debugCategory = category {
            line1.append("Category: " + debugCategory + " ")
        }
        
        if let debugContentType = contentType {
            line1.append("Content Type: " + debugContentType + " ")
        }
        
        return line1
    }
}

open class StanwoodAnalytics {
    
    private var trackingEnable: Bool = false
    /**
     
     All the trackers that have been registered for analytics and logging.
 
    */
    private var trackers: [Tracker] = []
    private var notificationsEnabled = false
    private let options: UNAuthorizationOptions = [.alert]
    
    /**
     
     The tracking keys used when the switch value is changed.
 
    */
    private let trackingOptOut = "tracking_opt_out"
    private let trackingOptIn = "tracking_opt_in"
    
    /**
     
     Keys for user parameters.
 
    */
    public struct Keys {
        public static let localizedDescription = "localizedDescription"
        public static let identifier = "id"
        public static let email = "email"
        public static let userName = "userName"
        public static let screenName = "screenName"
        public static let screenClass = "screenClass"
    }
    
    public enum TrackingEvent: String {
        case viewItem = "view_item"
        case purchase = "ecommerce_purchase"
        case login = "login"
        case selectContent = "select_content"
        case viewItemList = "view_item_list"
        case viewSearchResults = "view_search_results"
        case share = "share"
        case message = "message"
        case debug = "debug"
        case identifyUser = "identify_user"
    }

    /**
     
     Init method using the Builder pattern.
 
    */
    public init(builder: Builder) {
        trackers = builder.trackers
        
        notificationsEnabled = builder.notificationsEnabled
        
        if notificationsEnabled == true {
            addNotifications(with: builder.notificationDelegate!)
        }
        
        trackingEnable = DataStore.trackingEnabled
        
        if trackingEnable == true {
            trackSwitch(enabled: trackingEnable)
        }
    }
    
    fileprivate func addNotifications(with delegate: UIViewController) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        center.delegate = delegate as? UNUserNotificationCenterDelegate
    }
    
    // NODOC
    private func start() {
        trackers.forEach {
            $0.start()
        }
    }
    
    /**
     
     The Builder for this class.
     
    */
    open static func builder() -> Builder {
        return Builder()
    }
    
    /**
     
     Track the parameters. Which parameters that are actually tracked depends on
     the implementation of each tracker.
     
     */
    
    open func track(trackingParameters: TrackingParameters) {
        if trackingEnable == true {
            trackers.forEach { $0.track(trackingParameters: trackingParameters) }
            
            showNotification(with: trackingParameters.debugInfo())
        }
    }
    
    fileprivate func showNotification(with message: String) {
        if notificationsEnabled == true {
            let content = UNMutableNotificationContent()
            content.title = "Track event"
            content.body = message
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            let center = UNUserNotificationCenter.current()
            let identifier = "Tracking Notification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("Error: something is not right with this. ")
                } else {
                    print("Should be working.")
                }
            })
        }
    }
    
    /**
     Returns the stored value for the tracking setting.
     
     This is the value used for the next application start.
 */
    
    open static func trackingEnabled() -> Bool {
        return DataStore.trackingEnabled
    }
    
    private func trackSwitch(enabled: Bool) {
        
        let eventName = enabled ? trackingOptOut : trackingOptIn
        
        let params = TrackingParameters(eventName: eventName,
                                        itemId: "",
                                        name: "",
                                        description: nil,
                                        category: "",
                                        contentType: "")
        
        track(trackingParameters: params)
    }
    
    /**
     Set this value to false to stop the tracking, and on the next start it will be fully disabled.
     It is on by default.
     
     If tracking is off, then turning the switch on will call start in all the trackers.
     
     This functionality is intended to be compatibly with the EU law on GDPR, and allows users to disable tracking.
 
     
    */
    
    open func setTracking(enable: Bool, on viewController: UIViewController? = nil) {
        
        if enable == false {
            showAlert(on: viewController)
        }
        
        
        if trackingEnable == true {
            if enable == false {
                // turn off tracking
                trackers.forEach {
                    $0.setTracking(enable: enable)
                }

                trackSwitch(enabled: enable)
            }
        } else {
            // Tracked at startup was off.
            start()
            trackingEnable = true
        }

        
        DataStore.setTracking(enabled: enable)
        
        if enable == true {
            trackSwitch(enabled: enable)
        }
    }
    
    private func showAlert(on viewController: UIViewController? = nil) {
        var rootViewController: UIViewController
        
        if viewController == nil {
            rootViewController = (UIApplication.shared.keyWindow?.rootViewController)!
            
            if rootViewController is UINavigationController {
                let controller = rootViewController as! UINavigationController
                rootViewController = controller.visibleViewController!
            }
        } else {
            rootViewController = viewController!
        }
        
        let message = localised(key: "ALERT_MESSAGE")
        let buttonTitle = localised(key: "ALERT_BUTTON_TITLE")
        let alert = AlertFactory.makeAlert(message: message, buttonTitle: buttonTitle)
            
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    private func localised(key: String) -> String {
        let frameworkBundle = Bundle(for: StanwoodAnalytics.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("StanwoodAnalytics.bundle")
        let bundle = Bundle(url: bundleURL!)
        return NSLocalizedString(key, bundle: bundle!, comment: "")
    }
    
    /**
     
     Track specific keys.
     
    */
    open func track(trackerKeys: TrackerKeys) {
        if trackingEnable == true {
            trackers.forEach {$0.track(trackerKeys: trackerKeys) }
            
            showNotification(with: serializeKeys(trackerKeys: trackerKeys))
        }
    }
    
    fileprivate func serializeKeys(trackerKeys: TrackerKeys) -> String {
        var message = ""
        for (key,value) in trackerKeys.customKeys {
            message.append(key + " " + String(describing: value))
        }
        return message
    }
    
    /**
     
     Track NSError objects.
 
    */
    open func track(error: NSError) {
        if trackingEnable == true {
            trackers.forEach { $0.track(error: error) }
        }
    }
    
    /**
     
     Helper function to track the screen name along with the class name.
     
    */
    
    open func trackScreen(name: String, className: String? = nil) {
        var trackerKeys = TrackerKeys()
        trackerKeys.customKeys = [StanwoodAnalytics.Keys.screenName: name]
        if let className = className {
            trackerKeys.customKeys[StanwoodAnalytics.Keys.screenClass] = className
        }
        track(trackerKeys: trackerKeys)
    }
    
    /**
 
     The builder for this class.
     
    */
    open class Builder {
        var trackers: [Tracker] = []
        var notificationsEnabled = false
        var notificationDelegate: UIViewController?
        
        public func add(tracker: Tracker) -> Builder {
            trackers.append(tracker)
            return self
        }
        
        public func setNotificationDelegate(delegate: UIViewController) -> Builder {
            notificationsEnabled = true
            notificationDelegate = delegate
            return self
        }
        
        public func build() -> StanwoodAnalytics {
            return StanwoodAnalytics(builder: self)
        }
        
        public func setExceptionTracking(enable: Bool) {
            
        }
    }
}

//  Source: https://gist.github.com/snikch/3661188#gistcomment-1392643

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

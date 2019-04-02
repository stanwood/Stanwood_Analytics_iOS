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

/**
 Protocol to map tracking parameters to a dictionary of [String:NSString] and removes all optionals.

 Implement this protocol when it is necessary to map keys to other values for different trackers.
 */
public protocol ParameterMapper {
    func map(parameters: TrackingParameters) -> [String: NSString]
}

/**
 The base class for Analytics
 */
open class StanwoodAnalytics {

    // MARK: Properties
    /// :nodoc:
    private var trackingEnable: Bool = false
    /// :nodoc:
    private var trackers: [Tracker] = []
    /// :nodoc:
    private var notificationsEnabled = false
    private var postNotificationsEnabled: Bool = false
    private let options: UNAuthorizationOptions = [.alert]
    /// :nodoc:
    private let trackingOptOut = "tracking_opt_out"
    /// :nodoc:
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

        // Used in the dictionary payload of the notification posted to the debugger.
        public static let eventName = "eventName"
        public static let itemId = "itemId"
        public static let contentType = "contentType"
        public static let category = "category"
        public static let createdAt = "createdAt"

        public static let notificationName = "io.stanwood.debugger.didReceiveAnalyticsItem"
    }

    /**
     The event types used for tracking.
     */
    public enum TrackingEvent: String {

        case viewItem = "view_item"
        case purchase = "ecommerce_purchase"
        case login
        case selectContent = "select_content"
        case viewItemList = "view_item_list"
        case viewSearchResults = "view_search_results"
        case share
        case message
        case debug
        case identifyUser = "identify_user"
    }

    /**

     Init method using the Builder pattern.

     - Parameter builder:
     The builder pattern is used here to configure the analytics instance.
     */
    public init(builder: Builder) {
        trackers = builder.trackers

        notificationsEnabled = builder.notificationsEnabled
        postNotificationsEnabled = builder.postNotificationsEnabled

        if notificationsEnabled == true {
            addNotifications(with: builder.notificationDelegate!)
        }

        trackingEnable = DataStore.trackingEnabled

        if trackingEnable == true {
            trackSwitch(enabled: trackingEnable)
        }
    }

    /// :nodoc:
    fileprivate func addNotifications(with delegate: UIViewController) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: options) {
            granted, _ in
            if !granted {
                print("Stanwood Analytics Warning: Notifications permission is not granted by the user.")
            }
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }

        center.delegate = delegate as? UNUserNotificationCenterDelegate
    }

    fileprivate func postNotification(payload: [String:String]) {
        let notificationCentre = NotificationCenter.default
        let notification = Notification.init(name: Notification.Name(rawValue: Keys.notificationName), object: nil, userInfo: payload)
        notificationCentre.post(notification)
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

    /// Track data using TrackingParameters struct. It iterates over all the trackers and calls track on each.
    ///
    /// The parameters that are tracked depends on how each tracker is configured.
    ///
    /// - Parameter trackingParameters: TrackingParameters struct
    open func track(trackingParameters: TrackingParameters) {
        if trackingEnable == true {
            trackers.forEach { $0.track(trackingParameters: trackingParameters) }

            showNotification(with: trackingParameters.debugInfo())

            if postNotificationsEnabled == true {
                postNotification(payload: trackingParameters.payload())
            }
        }
    }

    /// :nodoc:
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
            center.add(request, withCompletionHandler: { error in
                if error != nil {
                    print("StanwoodAnalytics Error: Completion block for notification.")
                }
            })
        }
    }

    /// Tracking Enabled. This is the value used for the next application start.
    ///
    /// - Returns: Bool value that is stored in UserDefaults.
    open static func trackingEnabled() -> Bool {
        return DataStore.trackingEnabled
    }

    /// :nodoc:
    private func trackSwitch(enabled: Bool) {
        let eventName = enabled ? trackingOptIn : trackingOptOut
        let params = TrackingParameters(eventName: eventName,
                                        itemId: "",
                                        name: "",
                                        description: nil,
                                        category: "",
                                        contentType: "")

        track(trackingParameters: params)
    }

    /// Set this value to false to stop the tracking, and on the next start it will be fully disabled.
    /// It is on by default.
    ///
    /// If tracking is off, enabling it will call start in all the trackers.
    ///
    /// This functionality is intended to be compatible with the EU directive on GDPR, and
    /// allows users to disable tracking in all frameworks.
    ///
    /// As tracking is not disabled immediately an alert (localised in English and German) is displayed
    /// informing the user of this. To display the alert the framework assumes that the root view controller
    /// is either a UIViewController or a UINavigationController. If this is not the case the alert will
    /// fail to show. An optional parameter is provided to support injecting a view controller so that the
    /// present method can be called on it and display the alert that way.
    ///
    /// - Parameters:
    ///   - enabled: Bool. Will display an alert when disabled.
    ///   - viewController: UIViewController. An optional parameter for a viewController to display the alert controller when disabling tracking.
    open func setTracking(enabled: Bool, on viewController: UIViewController? = nil) {

        if enabled == false {
            showAlert(on: viewController)
        }

        if trackingEnable == true {
            if enabled == false {
                // turn off tracking
                trackers.forEach {
                    $0.setTracking(enabled: enabled)
                }

                trackSwitch(enabled: enabled)
            }
        } else {
            // Tracked at startup was off.
            start()
            trackingEnable = true
        }

        DataStore.setTracking(enabled: enabled)

        if enabled == true {
            trackSwitch(enabled: enabled)
        }
    }

    /// :nodoc:
    private func showAlert(on viewController: UIViewController? = nil) {
        
        guard var rootViewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController else { return }
        
        if let rootNav = rootViewController as? UINavigationController {
            rootViewController = rootNav.visibleViewController ?? rootViewController
        }

        let message = localised(key: "ALERT_MESSAGE")
        let buttonTitle = localised(key: "ALERT_BUTTON_TITLE")
        let alert = AlertFactory.makeAlert(message: message, buttonTitle: buttonTitle)

        rootViewController.present(alert, animated: true, completion: nil)
    }

    /// :nodoc:
    private func localised(key: String) -> String {
        let frameworkBundle = Bundle(for: StanwoodAnalytics.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("StanwoodAnalytics.bundle")
        let bundle = Bundle(url: bundleURL!)
        return NSLocalizedString(key, bundle: bundle!, comment: "")
    }

    /// Track custom keys. The implementation depends on the mapping in the custom trackers.
    ///
    /// - Parameter trackerKeys: TrackerKeys struct
    open func track(trackerKeys: TrackerKeys) {
        if trackingEnable == true {
            trackers.forEach { $0.track(trackerKeys: trackerKeys) }

            showNotification(with: serializeKeys(trackerKeys: trackerKeys))
            
            if postNotificationsEnabled == true {
                postNotification(payload: trackerKeys.payload())
            }
        }
    }

    /// :nodoc:
    fileprivate func serializeKeys(trackerKeys: TrackerKeys) -> String {
        var message = ""
        for (key, value) in trackerKeys.customKeys {
            message.append(key + " " + String(describing: value))
        }
        return message
    }

    /// Track NSError. Each tracker has a custom implementation for this method.
    ///
    /// - Parameter error: NSError
    open func track(error: NSError) {
        if trackingEnable == true {
            trackers.forEach { $0.track(error: error) }
        }
    }

    /// Track Screen: Helper function to track the screen name along with the class name.
    ///
    /// - Parameters:
    ///   - name: String
    ///   - className: String
    open func trackScreen(name: String, className: String? = nil) {
        var trackerKeys = TrackerKeys()
        trackerKeys.customKeys = [StanwoodAnalytics.Keys.screenName: name]
        if let className = className {
            trackerKeys.customKeys[StanwoodAnalytics.Keys.screenClass] = className
        }
        track(trackerKeys: trackerKeys)
    }

    /// The builder for this class.
    open class Builder {
        var trackers: [Tracker] = []
        var notificationsEnabled = false
        var notificationDelegate: UIViewController?
        var postNotificationsEnabled: Bool = false

        public func add(tracker: Tracker) -> Builder {
            trackers.append(tracker)
            return self
        }

        /**
         Set a delegate to display local notifications. This is used for debugging the tracking. It will display a local notification for each time track is called.
         */
        public func setNotificationDelegate(delegate: UIViewController) -> Builder {
            notificationsEnabled = true
            notificationDelegate = delegate
            return self
        }

        public func setDebuggerNotifications(enabled: Bool) -> Builder {
            postNotificationsEnabled = enabled
            return self
        }

        public func build() -> StanwoodAnalytics {
            return StanwoodAnalytics(builder: self)
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

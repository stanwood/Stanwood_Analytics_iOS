# Stanwood Analytics iOS

[![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg)]()
[![iOS 8+](https://img.shields.io/badge/iOS-10+-EB7943.svg)]() [![Pod Version](https://cocoapod-badges.herokuapp.com/v/StanwoodAnalytics/badge.png)]()
 [![Build Status](https://app.bitrise.io/app/5179611a33857ebf/status.svg?token=H42t71dnrDDzKsmJGycNQQ&branch=master)](https://app.bitrise.io/app/5179611a33857ebf) [![CodeClimate Badge](https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability)](https://codeclimate.com/github/codeclimate/codeclimate/maintainability) [![License](https://cocoapod-badges.herokuapp.com/l/StanwoodAnalytics/badge.svg)](http://cocoapods.org/pods/StanwoodAnalytics) [![Docs](https://img.shields.io/badge/docs-%E2%9C%93-blue.svg)](https://stanwood.github.io/Stanwood_Analytics_iOS/)

The Stanwood Analytics framework is a wrapper to reduce the effort involved in adding analytics and logging frameworks to iOS projects and to make the implementation consistent. The pod consists of a base install, and optional extras defined as sub-specs. There is still work in progress to add support for more frameworks. 

1. Fabric [Base]
1. Crashlytics [Base]
1. TestFairy [Base]
1. Firebase Analytics [Base] 
1. GoogleAnalytics
1. MixPanel
2. BugFender
1. Adjust [In progress]
2. IVW Tracking [Planned]

## Table of contents

- [Example](#example)
- [Requirements](#requirements)
- [Installation](#installation)
- [Basic Configuration](#basic-configuration)
- [GDPR Compliance](#gdpr-compliance)
- [Firebase](#firebase)
- [Google Analytics](#google-analytics)
- [Mixpanel](#mixpanel)
- [Notifications](#notifications)
- [BugFender](#bugfender-tracker)
- [Analytics Tracking API Functions](#analytics-tracking-api-functions)
- [Updating Analytics in Existing Projects](#updating-analytics-in-existing-projects)
- [Release Notes](#release-notes)
- [Author](#author)
- [License](#license)
- [Troubleshooting](#troubleshooting)

## Example

Before running the project, it is recommended to register with both Fabric and Firebase Analytics. Optionally register with Google Analytics, Mixpanel, BugFender and TestFairy. Set the keys in the Configuration.swift file. 

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The example app consists of 2 screens, the first with buttons and text fields to log user data and events, and the second to track custom events (Google Analytics) and a switch to toggle the tracking. It is on by default. It is a global disable switch which is intented to comply to the legal requirements for GDPR. Since some frameworks will continue to send information even after tracking is disabled, an alert is displayed on turning off the switch to inform users that data will continue to be sent until the app has been restarted. Some frameworks will also send data on restarting the application when tracking and logging is disabled, but this is usually only a single call. If the switch is off at startup, turning it on will call the start() function of all the trackers. 

The changes in the switch setting are tracked in the frameworks using 2 keys: "tracking_opt_out" and "tracking_opt_in". The change is tracked immediately before it is turned off, or immediately after it is turned on.

## Requirements

- 1. Crashlytics & Fabric

Follow the [install instructions for Crashlytics](https://firebase.google.com/docs/crashlytics/get-started?authuser=0) to add the run script. Do not add the pods to the Podfile, nor call the initialize function - this framework handles that part.

Note that the run script path will be different to that stated on the Fabric website.

```ruby
"${PODS_ROOT}/StanwoodAnalytics/Frameworks/Fabric.framework/run" 
```

- 2. Firebase Analytics 

See the [documentation](https://firebase.google.com/docs/ios/setup?authuser=0) on how to configure your project. The only necessary requirement is to add the GoogleServices.plist file. Do not call FirebaseApp.configure(). 

## Installation

StanwoodAnalytics is available through [CocoaPods](http://cocoapods.org). To install
it, add the following line to your Podfile:

```
pod 'StanwoodAnalytics'
```

This framework has has a base install that by default includes Fabric, Crashlytics, FirebaseAnalytics and TestFairy. Sub specs are defined for BugFender, Google Analytics and Mixpanel.

```ruby
pod 'StanwoodAnalytics/Mixpanel'
pod 'StanwoodAnalytics/BugFender'
pod 'StanwoodAnalytics/Google'
```

If the project already has existing analytics frameworks, see the [Updating a Project](#updating-analytics-in-existing-projects) section.

## Basic Configuration

Add the following code into the AppDelegate, or a helper class. Create a tracker with the builder helper class and add it to the analytics builder. Call the build() function to create the instance. 


```
let testFairyKey = "abc123def456"

let fabricTracker = FabricTracker.FabricBuilder(context: application, key: nil).build()

let analyticsBuilder = StanwoodAnalytics.builder()
.add(tracker: fabricTracker)

#if DEBUG || STAGE

let testFairyTracker = TestFairyTracker.TestFairyBuilder(context: application, key: testFairyKey).build()
analyticsBuilder = analyticsBuilder.add(tracker: testFairyTracker)

#endif

analytics = analyticsBuilder.build()       
```

## GDPR Compliance 

As of the 25th of May 2018, all companies have to comply with the EU rgulation on tracking personal data. Tracking is enabled by default and an application must provide a switch to disable it. If the application has a signup process, tracking must be disabled by default and allow a user to enable it.

```
analytics.setTracking(enable: Bool)
```
The framework stores the value of the switch internally in UserDefaults. Use the static function ``StanwoodAnalytics.trackingEnabled()``to read the current state, and update the switch accordingly. Do not call setTracking at startup, as this is done internally. 

## Firebase

The base install includes Firebase/Analytics and its dependencies so it is not necessary to define it in the Podfile. 

The Firebase tracker has an optional init parameter to pass in the name of a configuration property list so as to support different configurations depending on the configuration being run (for debug, beta, release and so on). 

For example, add a function in the application configuration struct:

```
static func firebaseConfigurationFileName() -> String {
        #if DEBUG
            return "FirebaseService-DEBUG-Info"
        #else
            return "FirebaseService-RELEASE-Info"
        #endif
}
```

Then init the tracker with that function:

```ruby
   let firebaseTracker = FirebaseTracker.FirebaseBuilder(context: application, configFileName: Configuration.firebaseConfigurationFileName())
   ...
   .add(tracker: firebaseTracker)
```

**WARNING:** If the application has a previous configuration for Firebase, remember to remove the call to FirebaseApp.configure() as it can only be called once, or the app will crash.

## Google Analytics

```
   pod 'StanwoodAnalytics/Google'
```

``` 
   let googleTracker = GoogleAnalyticsTracker.GoogleAnalyticsBuilder(context: application, key: googleTrackingKey).build()
   ... 
   .add(tracker: googleTracker)
```

### Map Function

The tracker uses a default map function that can be replaced if required. 

```
public protocol MapFunction {
    func mapCategory(parameters: TrackingParameters) -> String?
    func mapAction(parameters: TrackingParameters) -> String?
    func mapLabel(parameters: TrackingParameters) -> String?
    func mapScreenName(parameters: TrackingParameters) -> String?
    func mapKeys(keys: TrackerKeys) -> [String:String]?
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
    
    public func mapKeys(keys: TrackerKeys) -> [String:String]? {
        return nil
    }
}
```

A custom map function can be assigned in the GoogleAnalyticsBuilder. 

If you need to track custom dimensions, first add the value into the GA web dashboard (Select Admin, then under Property (second column) select Custom Definitions, and then Custom Dimensions) and then use the index number as the key. Add this tracking code: 

```
let index = YOUR-VALUE
var trackerKeys = TrackerKeys.init()
trackerKeys.customKeys = [String(describing:index):screenName]
analytics?.track(trackerKeys: trackerKeys)
```



## Mixpanel

```ruby
  pod 'StanwoodAnalytics/Mixpanel'
```

```ruby 
let mixpanelTracker = MixpanelTracker.MixpanelBuilder(context: application, key: mixpanelToken).build()
...
.add(tracker: mixpanelTracker)

```

## Notifications

This framework uses local notifications (iOS 10.0 +) to display events to help with debugging and verifying analytics logging. The analytics init function has an optional parameter that must conform to the UNUserNotificationCenterDelegate protocol.

First add an extension to a view controller:

```
extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let alert = UIAlertController(title: "Tracker Alert", message: "We have tracking for this event", preferredStyle: .alert)
        let action = UIAlertAction(title: "Thanks!", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

        completionHandler()
    }
}
```

Then pass this object as a parameter to the init.

```
let window = application.windows.first
        let viewController = window?.rootViewController
        analytics = analyticsBuilder.setNotificationDelegate(delegate: viewController!).build()

```

It is useful to only enable the notifications for debug / testing. Ensure they are not visible in release builds. 



## BugFender

In the Podfile add:
```
pod 'StanwoodAnalytics/BugFender'
```

Then in the tracking class:

```
    let bugFenderKey = "abcdef"
    let bugfenderTracker = BugfenderTracker.BugfenderBuilder(context: application, key: bugFenderKey)
            .setUIEventLogging(enable: true)
            .build()
   ...  
   .add(tracker: bugfenderTracker)
```

## Analytics Tracking API Functions

The 4 functions for tracking are: 

```ruby
   func track(trackingParameters: TrackingParameters)
   func track(trackerKeys: TrackerKeys)
   func trackScreen(name: String, className: String? = nil)
   func track(error: NSError)
```

where TrackingParameters and TrackerKeys are structs.

### TrackingParameters
```
    let eventName: String
    var itemId: String?
    var name: String?
    var description: String?
    var category: String?
    var contentType: String?
```

### TrackerKeys

This struct contains a single mutable dictionary [String:Any]. It should be used to set custom keys and values.


## Updating Analytics in Existing Projects

If Fabric and Crashltyics are already in use in a project, it is necessary to remove the pods from the Podfile, and remove any import statements in the project source code. Also check for references of Crashlytics in the code - they should all be removed first before adding Stanwood Analytics. Made sure the app compiles and runs for a few minutes. If the app previously has integrations with Firebase, remove the call to FirebaseApp.configure() or it will crash. There can only be one call to this function.

```ruby
# Remove all of these pods.
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'BugfenderSDK'
  pod 'TestFairy'
  pod 'GoogleAnalytics'
  pod 'Mixpanel'

```

See the example project on how to replace the calls to Fabric/Crashlytics with the new analytics framework.

IMPORTANT: If you get linker errors when compiling the app, check the build settings OTHER LINKER FLAGS in the project and ensure that any references to Crashlytics and Fabric are removed. 

If you still experience problems with Fabric, first try to remove all references to it in the project and get it to run, and then add the framework again. 

## iOS9 Support

As local notifications are used for help in debugging analytics tracking, and this is using an iOS 10 API, since a few projects are not updated just yet there is a compatibility branch. 

```
pod 'StanwoodAnalytics', git: 'git@github.com:stanwood/Stanwood_Analytics_iOS.git', branch: 'hotfix/iOS9-Compatibility'
```

## Release Notes

1.1.2: Updated the Code Climate and Danger files. Added badges. 

1.1.0: Added support for Code Climate Quality, Danger. Extended the framework to support posting notifications of events that are used in the Debugger pod. This will be a huge help in debugging analytics.

1.0.1: Updating the example project and readme to reflect changes in the API for 0.9 onwards.

1.0.0: Release candidate. Removing keys for all the frameworks. Added code to prevent crashes when the configuration for Firebase and Fabric are not prevent. 

0.11.0: Added internal support for FirebaseTracker. Added internal changes to setTracking to start the tracking frameworks when the state changes from off to on when the application started with tracking off. 

0.10.1 - 0.10.9: Bug fixes. 

0.10.0: Added support for an alert to give a warning when disabling tracking.

0.9.2: Update build version push out changes.

0.9.1: Fixed compiler warnings for FirebaseTracker.

0.9.0: Added support for enable and disable tracking for GDPR compliance. 

0.8.0: Mixpanel is fully integrated into the release. Google Analytics support extended to include custom dimensions. Fixed issues with GA after updating to CocoaPods 1.5.0. TestFairy is part of the base install. 

0.7.1: Added support for Google Analytics custom dimensions. In BugFender tracker, made the parameter optional. Updated: 

```
customParameters: [String:Any]
```

0.7.0: Added basic support for both Google Analytics and Mixpanel.

0.6.0: Removed FirebaseAnalytics and embedded frameworks. 

0.5.0: Fixed issues with dependencies for Firebase

0.4.5: Added UserNotifications as a framework dependency

0.4.4: Updated the example project.

0.4.3: Made screen class parameter optional in trackScreen.

0.4.2: Added trackScreen function to StanwoodAnalytics class.

```
open func trackScreen(name: String, className: String)
```

0.4.1: Updated FirebaseTracker to call Analytics.setScreenName().

0.4.0: Added notification to help with debugging analytics tracking. This requires a min of iOS 10.

## Author

Ronan O Ciosoig ronan.o.ciosoig@stanwood.de

## License

StanwoodAnalytics is under MIT licence. See the [LICENSE](https://github.com/stanwood/Stanwood_Core/blob/master/LICENSE) file for more info.

## Troubleshooting

### Compile error

```
Undefined symbols for architecture x86_64:
  "_kFIRServiceRemoteConfig", referenced from:
      -[FIRRemoteConfig(FIRApp) configureConfig:] in FirebaseRemoteConfig(FIRRemoteConfig+FIRApp_090f076533867dc11958284cd1b529ac.o)
  "_kServiceInfoFileName", referenced from:
      -[FIRRemoteConfig(FIRApp) configureConfig:] in FirebaseRemoteConfig(FIRRemoteConfig+FIRApp_090f076533867dc11958284cd1b529ac.o)
  "_kServiceInfoFileType", referenced from:
      -[FIRRemoteConfig(FIRApp) configureConfig:] in FirebaseRemoteConfig(FIRRemoteConfig+FIRApp_090f076533867dc11958284cd1b529ac.o)
```

Ensure that the Podfile includes `pod Firebase/Analytics`

### Linker Error

```
ld: framework not found Fabric for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

This can be a few things, but first try to remove all references to the analytics framework from the project, and get it to compile. Then add the pod, then code back again. 


### Firebase Crash signal SIGABRT

The application crashes on calling FirebaseApp.configure()

Ensure that there is only one call to this function. If Firebase was previously used in the app before adding the analytics framework, remove the reference first. 

Also check that the bundle Id matches the one specified in the GoogleServices info.plist. 

### Framework Compile errors 

With the update in CocoaPods 1.5.0 came some other compile erorrs. The solution was to delete the Xcode preferences. 

```
cd ~/Library/Preferences
ls -l | grep xcode -i
rm com.apple.dt.xcodebuild.plist
```

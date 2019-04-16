//
//  IOLLogging.h
//  INFOnlineLibrary
//
//  Created by Michael Ochs on 7/24/17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Values for controlling the level of debug outputs during runtime.

 This enumerated type is used to declare the level of debug outputs to the IOLSession object you use to log events
 */
typedef NS_ENUM(NSUInteger, IOLDebugLevel) {
    /** Log nothing. */
    IOLDebugLevelOff = 0,
    /** Log only errors. */
    IOLDebugLevelError = 1,
    /** Log errors and warnings. */
    IOLDebugLevelWarning = 2,
    /** Log errors, warnings and infos. */
    IOLDebugLevelInfo = 3,
    /** Log errors, warnings, infos, events, requests and responses. Requests and responses will be logged as file in the Documents folder of your app. You can enable iTunes File Sharing in the info.plist file of your app to easily retrieve these files from iTunes. */
    IOLDebugLevelTrace = 4,
    IOLDebugLevelVerbose = IOLDebugLevelTrace
};

/**
 When a new log message is logged, an IOLLogDidUpdateNotification is posted.
 
 @see `IOLLogging`
 */
FOUNDATION_EXTERN NSString * const IOLLogDidUpdateNotification;


/**
 IOLLogging handles the logging of the INFOnlineLibrary framework.
 You can set an IOLDebugLogLevel and access the latest log messages.
 
 When a new log message is available, an IOLLogDidUpdateNotification will be posted.
 
 @see `IOLLogDidUpdateNotification`
 */
@interface IOLLogging : NSObject

/**
 The debug level for the INFOnline library.

 @return The debugLogLevel that is currently used
 */
+ (IOLDebugLevel)debugLogLevel;

/**
 Sets the debug log level for the INFOnline library.
 In the release build of your app you might want to set this value to IOLDebugLevelOff to stop the app from logging into the device console.

 @param debugLogLevel The log level to use from now on.
 */
+ (void)setDebugLogLevel:(IOLDebugLevel)debugLogLevel;

/**
 Clears the array of log messages
 */
+ (void)clearLogs;

/**
 An array of the most recent logs with a maximum count of `limit`.
 
 @param limit The maximum ammount of log messages to return. Pass in 0 to get all
 @returns An array of the most recent log messages with the specified limit
 */
+ (NSArray<NSString*>*)mostRecentLogsWithLimit:(NSUInteger)limit;

@end

NS_ASSUME_NONNULL_END

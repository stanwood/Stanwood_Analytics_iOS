//
//  IOLSession.h
//  INFOnlineReports
//
//  Copyright 2010 RockAByte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOLEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

/**
 When the configuration of an active session is updated, an IOLConfigDidUpdateNotification is posted.
 
 The userInfo dictionary contains following keys and objects:
 
 <ul>
 <li> IOLSessionTypeKey: A NSNumber object containing the IOLSessionType of the updated session.</li>
 
 <li> IOLUpdatedConfigVersionKey: The new configVersion of the updated session.</li>
 </ul>
 
 @see `IOLUpdatedConfigVersionKey`
 @see `IOLSessionTypeKey`
 */
FOUNDATION_EXTERN NSString * const IOLConfigDidUpdateNotification;

/**
 IOLUpdatedConfigVersionKey
 
 The key for the updated configVersion in the IOLConfigDidUpdateNotification userInfo dictionary.
 
 @see `IOLConfigDidUpdateNotification`
 */
FOUNDATION_EXTERN NSString * const IOLUpdatedConfigVersionKey;

/**
 IOLSessionTypeKey
 
 The key for the sessionType (as NSNumber) in the IOLConfigDidUpdateNotification userInfo dictionary.
 
 @see `IOLConfigDidUpdateNotification`
 */
FOUNDATION_EXTERN NSString * const IOLSessionTypeKey;


@class IOLEvent;


/**
 IOLPrivacyType is a mandatory parameter when starting an IOLSession.
 
 This enum type is used to define the purpose of measuring.
 */
typedef NS_ENUM(NSUInteger,  IOLPrivacyType) {
    /** Use this option if an opt in is given. */
    IOLPrivacyTypeACK,
    /** Use this option if you got a legitimate interest for the measurement. */
    IOLPrivacyTypeLIN,
    /** Use this option for an anonymous measurement. */
    IOLPrivacyTypePIO
};

/**
 Values for initializing a default IOLSession.

 This enum type is used to initialize an IOLSession for the specific measurement system.
 */
typedef NS_ENUM(NSUInteger, IOLSessionType) {
    /** This can be used in an IOLSession and specifies the SZM measurement system. */
    IOLSessionTypeSZM = 0,
    /** This can be used in an IOLSession and specifies the OEWA measurement system. */
    IOLSessionTypeOEWA
};

/**
 IOLSession is the main entry point of the library. It handles event logging, connections with the server, starting and stopping of event gathering and debug logs.
 */
@interface IOLSession : NSObject


/// @name Basic information

/**
 Gives you the default session you should use for logging.

 On the first call the default session instance is allocated and initialized. You have to call startSessionWithOfferIdentifier:privacyType: before you can start logging.
 
 @warning If you don't want the lib to be instantiated at all, you **must not** call this method.
 @param sessionType The sessionType used for the IOLSession.
 @return The default session to use for logging
 @see `-startSessionWithOfferIdentifier:privacyType:`
 */
+ (IOLSession*)defaultSessionFor:(IOLSessionType)sessionType;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

/**
 @return The current version of the library
 */
+ (NSString*)libraryVersion;

/**
 @return The session types of all currently active sessions
 */
+ (NSArray<NSNumber*>*)activeSessionTypes;

#pragma clang diagnostic pop

/**
 @return The version of the configuration. This uniquely identifies the version of the configuration.
 */
@property (nonatomic, copy, readonly, nullable) NSString *configVersion;

/**
 The offer identifier that is used in this session
 
 @note You have to set the offer identifier via startSessionWithOfferIdentifier:privacyType:
 @return The current session's offer identifier
 
 @see `-startSessionWithOfferIdentifier:privacyType:`
 */
@property (nonatomic, copy, readonly, nullable) NSString *offerIdentifier;

/**
 The privacy type that is used in this session
 
 @note You have to set the privacy type via startSessionWithOfferIdentifier:privacyType:
 @return The current session's privacy type
 
 @see `-startSessionWithOfferIdentifier:privacyType:`
 */
@property (nonatomic, readonly) IOLPrivacyType privacyType;

/**
 The hybrid identifier is optional and is used for hybrid apps that have web content that should be tracked.
 
 @note You have to set the hybrid identifier via startSessionWithOfferIdentifier:privacyType:hybridIdentifier:customerData:
 @return The current session's hybrid identifier
 
 @see `-startSessionWithOfferIdentifier:privacyType:hybridIdentifier:customerData:`
 */
@property (nonatomic, copy, readonly, nullable) NSString *hybridIdentifier;

/**
 Customer data is optional and is used for hybrid apps that have web content that should be tracked.
 This identifier is defined by the developer and is sent as is, without any calculations or validations on it.
 
 @return The current session's customerData value
 
 @see `-startSessionWithOfferIdentifier:privacyType:hybridIdentifier:customerData:
 */
@property (nonatomic, copy, readonly, nullable) NSString *customerData;

/**
 * The active state of the session.
 *
 * For newly created sessions, the isActive state is false.
 *
 * @return YES, if the session is active. NO, if the session is terminated.
 *
 * @see `-startSessionWithOfferIdentifier:privacyType:`
 * @see `-terminateSession`
 */
@property (nonatomic, readonly) BOOL isActive;

/// @name Session lifetime

/**
 This call starts the session with the given offer identifier. After this call, you can start logging events with `logEvent:` .
 
 On calling this method, events that could not be sent in the last session will be sent immediately.
 If you don't want the lib to track events, for example if the user opt out from tracking in you app, you must not call this method.
 
 @param offerIdentifier The offer identifier you want to start the session with
 @param privacyType The type of the privacy setting that has to be set for a session
 
 @see `-terminateSession`
 @see `offerIdentifier`
 @see `privacyType`
 */
- (void)startSessionWithOfferIdentifier:(NSString*)offerIdentifier privacyType:(IOLPrivacyType)privacyType;

/**
 * This call starts the session with the given offer identifier and a hybrid identifier that is needed for web based tracking.
 * After this call, you can start logging events with `logEvent:` .
 *
 * On calling this method, events that could not be sent in the last session will be sent immediately.
 * If you don't want the lib to track events, for example if the user opt out from tracking in you app, you must not call this method.
 *
 * @param offerIdentifier The offer identifier you want to start the session with
 * @param privacyType The type of the privacy setting that has to be set for a session
 * @param hybridIdentifier The hybrid identifier for web content tracking
 * @param customerData The customer data to use for web content tracking
 *
 * @see `-terminateSession`
 * @see `offerIdentifier`
 * @see `privacyType`
 * @see `hybridIdentifier`
 * @see `customerData`
 */
- (void)startSessionWithOfferIdentifier:(NSString*)offerIdentifier privacyType:(IOLPrivacyType)privacyType hybridIdentifier:(nullable NSString*)hybridIdentifier customerData:(nullable NSString*)customerData;

/**
 This terminates the current logging session. You should call this method, if you want to cancel logging after a call
 to startSessionWithOfferIdentifier:privacyType: for example when the user opts-out in your app.
 
 @note This drops all events that are currently in the event queue. These events will never be sent.
 
 @see `-startSessionWithOfferIdentifier:privacyType:`
 @see `-sendLoggedEvents`
 */
- (void)terminateSession;


/// @name Event logging

/**
 This queues an event you want to log in the current event queue. Logged events will be sent automatically from the session at given times during the session life time or if you call sendLoggedEvents
 
 There are several convenience methods to log events, that do not require you to instantiate an IOLEvent yourself. For further information look at IOLSession(IOLEvent)
 
 @param event The event you want to log.
 
 @see `-startSessionWithOfferIdentifier:privacyType:`
 @see `-sendLoggedEvents`
 */
- (void)logEvent:(IOLEvent*)event;

/**
 This forces the queued events to be sent immediately. You might want to call this method before calling terminateSession as this would drop all events that haven't been sent.
 
 @note The session sends queued events automatically on different events. Under normal conditions you should not need to call this message.
 */
- (void)sendLoggedEvents;


@end

NS_ASSUME_NONNULL_END

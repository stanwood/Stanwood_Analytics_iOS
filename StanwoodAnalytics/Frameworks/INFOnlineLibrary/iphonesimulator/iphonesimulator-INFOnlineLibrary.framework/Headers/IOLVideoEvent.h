//
//  IOLVideoEvent.h
//  INFOnlineLibrary
//
//  Created by Sebastian Homscheidt on 13.06.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLVideoEventType is the list of publicly available eventtypes that can be set for a triggered IOLVideoEvent within your app.
 */
typedef NS_ENUM(NSUInteger, IOLVideoEventType) {
    /** This can be used in an IOLVideoEvent and specifies the 'play' type. */
    IOLVideoEventTypePlay,
    /** This can be used in an IOLVideoEvent and specifies the 'pause' type. */
    IOLVideoEventTypePause,
    /** This can be used in an IOLVideoEvent and specifies the 'stop' type. */
    IOLVideoEventTypeStop,
    /** This can be used in an IOLVideoEvent and specifies the 'next' type. */
    IOLVideoEventTypeNext,
    /** This can be used in an IOLVideoEvent and specifies the 'previous' type. */
    IOLVideoEventTypePrevious,
    /** This can be used in an IOLVideoEvent and specifies the 'replay' type. */
    IOLVideoEventTypeReplay,
    /** This can be used in an IOLVideoEvent and specifies the 'seek back' type. */
    IOLVideoEventTypeSeekBack,
    /** This can be used in an IOLVideoEvent and specifies the 'seek forward' type. */
    IOLVideoEventTypeSeekForward
};

/**
 IOLVideoEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLVideoEvent : IOLEvent

/**
 This is the type specified when the event was initialized.
 */
@property (nonatomic, readonly) IOLVideoEventType type;

/**
 Initializes an IOLVideoEvent object with its type.
 
 @param type The event type you want to specify.
 @return The created IOLVideoEvent.
 */
- (instancetype)initWithType:(IOLVideoEventType)type;

/**
 Initializes an IOLVideoEvent object with its type, category and comment.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLVideoEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLVideoEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLVideoEvent.
 */
- (instancetype)initWithType:(IOLVideoEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLVideoEvent object with its type, category, comment and parameter.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLVideoEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLVideoEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLVideoEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLVideoEvent.
 */
- (instancetype)initWithType:(IOLVideoEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter;


@end

NS_ASSUME_NONNULL_END

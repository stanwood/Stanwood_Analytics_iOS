//
//  IOLAudioEvent.h
//  INFOnlineLibrary
//
//  Created by Konstantin Karras on 20.06.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLAudioEventType is the list of publicly available eventtypes that can be set for a triggered IOLAudioEvent within your app.
 */
typedef NS_ENUM(NSUInteger, IOLAudioEventType) {
    /** This can be used in an IOLAudioEvent and specifies the 'play' type. */
    IOLAudioEventTypePlay,
    /** This can be used in an IOLAudioEvent and specifies the 'pause' type. */
    IOLAudioEventTypePause,
    /** This can be used in an IOLAudioEvent and specifies the 'stop' type. */
    IOLAudioEventTypeStop,
    /** This can be used in an IOLAudioEvent and specifies the 'next' type. */
    IOLAudioEventTypeNext,
    /** This can be used in an IOLAudioEvent and specifies the 'previous' type. */
    IOLAudioEventTypePrevious,
    /** This can be used in an IOLAudioEvent and specifies the 'replay' type. */
    IOLAudioEventTypeReplay,
    /** This can be used in an IOLAudioEvent and specifies the 'seek back' type. */
    IOLAudioEventTypeSeekBack,
    /** This can be used in an IOLAudioEvent and specifies the 'seek forward' type. */
    IOLAudioEventTypeSeekForward
};

/**
 IOLAudioEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLAudioEvent : IOLEvent

/**
 This is the type specified when the event was initialized.
 */
@property (nonatomic, readonly) IOLAudioEventType type;

/**
 Initializes an IOLAudioEvent object with its type.
 
 @param type The event type you want to specify.
 @return The created IOLAudioEvent.
 */
- (instancetype)initWithType:(IOLAudioEventType)type;

/**
 Initializes an IOLAudioEvent object with its type, category and comment.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLAudioEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLAudioEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLAudioEvent.
 */
- (instancetype)initWithType:(IOLAudioEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLAudioEvent object with its type, category, comment and parameter.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLAudioEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLAudioEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLAudioEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLAudioEvent.
 */
- (instancetype)initWithType:(IOLAudioEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter;
@end

NS_ASSUME_NONNULL_END

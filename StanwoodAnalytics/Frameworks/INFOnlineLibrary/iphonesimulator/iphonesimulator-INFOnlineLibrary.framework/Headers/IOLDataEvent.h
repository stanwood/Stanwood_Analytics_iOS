//
//  IOLDataEvent.h
//  INFOnlineLibrary
//
//  Created by Konstantin Karras on 20.06.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLDataEventType is the list of publicly available eventtypes that can be set for a triggered IOLDataEvent within your app.
 */
typedef NS_ENUM(NSUInteger, IOLDataEventType) {
    /** This can be used in an IOLDataEvent and specifies the 'cancelled' type. */
    IOLDataEventTypeCancelled,
    /** This can be used in an IOLDataEvent and specifies the 'refresh' type. */
    IOLDataEventTypeRefresh,
    /** This can be used in an IOLDataEvent and specifies the 'succeeded' type. */
    IOLDataEventTypeSucceeded,
    /** This can be used in an IOLDataEvent and specifies the 'failed' type. */
    IOLDataEventTypeFailed
};

/**
 IOLDataEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLDataEvent : IOLEvent

/**
 This is the type specified when the event was initialized.
 */
@property (nonatomic, readonly) IOLDataEventType type;

/**
 Initializes an IOLDataEvent object with its type.
 
 @param type The event type you want to specify.
 @return The created IOLDataEvent.
 */
- (instancetype)initWithType:(IOLDataEventType)type;

/**
 Initializes an IOLDataEvent object with its type, category and comment.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLDataEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLDataEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLDataEvent.
 */
- (instancetype)initWithType:(IOLDataEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLDataEvent object with its type, category, comment and parameter.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLDataEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLDataEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLDataEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLDataEvent.
 */
- (instancetype)initWithType:(IOLDataEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter;
@end

NS_ASSUME_NONNULL_END

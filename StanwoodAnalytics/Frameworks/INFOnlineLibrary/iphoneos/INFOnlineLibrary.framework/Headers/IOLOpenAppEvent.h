//
//  IOLOpenAppEvent.h
//  INFOnlineLibrary
//
//  Created by Konstantin Karras on 26.06.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLOpenAppEventType is the list of publicly available eventtypes that can be set for a triggered IOLOpenAppEvent within your app.
 */
typedef NS_ENUM(NSUInteger, IOLOpenAppEventType) {
    /** This can be used in an IOLOpenAppEvent and specifies the 'maps' type. */
    IOLOpenAppEventTypeMaps,
    /** This can be used in an IOLOpenAppEvent and specifies the 'other' type. */
    IOLOpenAppEventTypeOther
};

/**
 IOLOpenAppEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLOpenAppEvent : IOLEvent

/**
 This is the type specified when the event was initialized.
 */
@property (nonatomic, readonly) IOLOpenAppEventType type;

/**
 Initializes an IOLOpenAppEvent object with its type.
 
 @param type The event type you want to specify.
 @return The created IOLOpenAppEvent.
 */
- (instancetype)initWithType:(IOLOpenAppEventType)type;

/**
 Initializes an IOLOpenAppEvent object with its type, category and comment.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLOpenAppEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLOpenAppEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLOpenAppEvent.
 */
- (instancetype)initWithType:(IOLOpenAppEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLOpenAppEvent object with its type, category, comment and parameter.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLOpenAppEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLOpenAppEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLOpenAppEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLOpenAppEvent.
 */
- (instancetype)initWithType:(IOLOpenAppEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter;

@end

NS_ASSUME_NONNULL_END

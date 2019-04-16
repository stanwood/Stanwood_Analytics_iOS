//
//  IOLAdvertisementEvent.h
//  INFOnlineLibrary
//
//  Created by Konstantin Karras on 20.06.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLAdvertisementEventType is the list of publicly available eventtypes that can be set for a triggered IOLAdvertisementEvent within your app.
 */
typedef NS_ENUM(NSUInteger, IOLAdvertisementEventType) {
    /** This can be used in an IOLAdvertisementEvent and specifies the 'open' type. */
    IOLAdvertisementEventTypeOpen,
    /** This can be used in an IOLAdvertisementEvent and specifies the 'close' type. */
    IOLAdvertisementEventTypeClose
};

/**
 IOLAdvertisementEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLAdvertisementEvent : IOLEvent

/**
 This is the type specified when the event was initialized.
 */
@property (nonatomic, readonly) IOLAdvertisementEventType type;

/**
 Initializes an IOLAdvertisementEvent object with its type.
 
 @param type The event type you want to specify.
 @return The created IOLAdvertisementEvent.
 */
- (instancetype)initWithType:(IOLAdvertisementEventType)type;

/**
 Initializes an IOLAdvertisementEvent object with its type, category and comment.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLAdvertisementEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLAdvertisementEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLAdvertisementEvent.
 */
- (instancetype)initWithType:(IOLAdvertisementEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLAdvertisementEvent object with its type, category, comment and parameter.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLAdvertisementEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLAdvertisementEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLAdvertisementEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLAdvertisementEvent.
 */
- (instancetype)initWithType:(IOLAdvertisementEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter;

@end

NS_ASSUME_NONNULL_END

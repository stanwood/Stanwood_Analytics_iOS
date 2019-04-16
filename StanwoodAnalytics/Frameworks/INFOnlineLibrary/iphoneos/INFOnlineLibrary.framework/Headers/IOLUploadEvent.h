//
//  IOLUploadEvent.h
//  INFOnlineLibrary
//
//  Created by Konstantin Karras on 20.06.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLUploadEventType is the list of publicly available eventtypes that can be set for a triggered IOLUploadEvent within your app.
 */
typedef NS_ENUM(NSUInteger,IOLUploadEventType) {
    /** This can be used in an IOLUploadEvent and specifies the 'cancelled' type. */
    IOLUploadEventTypeCancelled,
    /** This can be used in an IOLUploadEvent and specifies the 'start' type. */
    IOLUploadEventTypeStart,
    /** This can be used in an IOLUploadEvent and specifies the 'succeeded' type. */
    IOLUploadEventTypeSucceeded,
    /** This can be used in an IOLUploadEvent and specifies the 'failed' type. */
    IOLUploadEventTypeFailed
};

/**
 IOLUploadEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLUploadEvent : IOLEvent

/**
 This is the type specified when the event was initialized.
 */
@property (nonatomic, readonly) IOLUploadEventType type;

/**
 Initializes an IOLUploadEvent object with its type.
 
 @param type The event type you want to specify.
 @return The created IOLUploadEvent.
 */
- (instancetype)initWithType:(IOLUploadEventType)type;

/**
 Initializes an IOLUploadEvent object with its type, category and comment.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLUploadEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLUploadEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLUploadEvent.
 */
- (instancetype)initWithType:(IOLUploadEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLUploadEvent object with its type, category, comment and parameter.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLUploadEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLUploadEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLUploadEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLUploadEvent.
 */
- (instancetype)initWithType:(IOLUploadEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter;

@end

NS_ASSUME_NONNULL_END

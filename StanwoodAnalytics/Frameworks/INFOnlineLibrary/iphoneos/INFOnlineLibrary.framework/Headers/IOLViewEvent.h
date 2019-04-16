//
//  IOLViewEvent.h
//  INFOnlineLibrary
//
//  Created by Konstantin Karras on 20.06.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLViewEventType is the list of publicly available eventtypes that can be set for a triggered IOLViewEvent within your app.
 */
typedef NS_ENUM(NSUInteger,IOLViewEventType) {
    /** This can be used in an IOLViewEvent and specifies the 'appeared' type. */
    IOLViewEventTypeAppeared,
    /** This can be used in an IOLViewEvent and specifies the 'refreshed' type. */
    IOLViewEventTypeRefreshed,
    /** This can be used in an IOLViewEvent and specifies the 'disappeared' type. */
    IOLViewEventTypeDisappeared
};

/**
 IOLViewEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
  @see `IOLSession`
 */
@interface IOLViewEvent : IOLEvent

/**
 This is the type specified when the event was initialized.
 @return The type of the IOLViewEvent.
 */
@property (nonatomic, readonly) IOLViewEventType type;

/**
Initializes an IOLViewEvent object with its type.

@param type The event type you want to specify.
*/
- (instancetype)initWithType:(IOLViewEventType)type;

/**
  Initializes an IOLViewEvent object with its type, category and comment.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLViewEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLViewEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLViewEvent.
*/
- (instancetype)initWithType:(IOLViewEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLViewEvent object with its type, category, comment and parameter.
 
 @param type The event type you want to specify.
 @param category The category you want to set for this IOLViewEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLViewEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLViewEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLViewEvent.
 */
- (instancetype)initWithType:(IOLViewEventType)type category:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter;


@end

NS_ASSUME_NONNULL_END

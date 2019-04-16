//
//  IOLCustomEvent.h
//  INFOnlineLibrary
//
//  Created by Sebastian Homscheidt on 12.07.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLCustomEvent represents a custom event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */

@interface IOLCustomEvent : IOLEvent

/**
 This is the name specified when the event was initialized.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 Initializes an IOLCustomEvent object with its name.
 
 @param name The event name you want to specify.
 @return The created IOLCustomEvent.
 */
- (instancetype)initWithName:(NSString*)name;

/**
 Initializes an IOLCustomEvent object with its name, category and comment.
 
 @param name The event name you want to specify.
 @param category The category you want to set for this IOLCustomEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLCustomEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLCustomEvent.
 */
- (instancetype)initWithName:(NSString*)name category:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLCustomEvent object with its name, category, comment and parameter.
 
 @param name The event name you want to specify.
 @param category The category you want to set for this IOLCustomEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLCustomEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLCustomEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLCustomEvent.
 */
- (instancetype)initWithName:(NSString*)name category:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter;

@end

NS_ASSUME_NONNULL_END

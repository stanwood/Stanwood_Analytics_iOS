//
//  IOLGestureEvent.h
//  INFOnlineLibrary
//
//  Created by Konstantin Karras on 20.06.17.
//  Copyright © 2017 RockAByte GmbH. All rights reserved.
//

#import "IOLEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 IOLGestureEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLGestureEvent : IOLEvent

/**
 Initializes an IOLGestureEvent object with its IOLGestureEventTypeShake.
 
 @return The created IOLGestureEvent.
 */
- (instancetype)init;

/**
 Initializes an IOLGestureEvent object with its IOLGestureEventTypeShake, category and comment.
 
 @param category The category you want to set for this IOLGestureEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLGestureEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @return The created IOLGestureEvent.
 */
- (instancetype)initWithCategory:(nullable NSString*)category comment:(nullable NSString*)comment;

/**
 Initializes an IOLGestureEvent object with its IOLGestureEventTypeShake, category, comment and parameter.
 
 @param category The category you want to set for this IOLGestureEvent or nil if you don't want to set a category. Category values are provided by INFOnline specifically for your app.
 @param comment The comment you want to specify for this IOLGestureEvent or nil if you don't want to add a comment. The comment is a value that is specified by yourself to identify different event contexts.
 @param parameter A dictionary of parameters you want to specify for this IOLGestureEvent or nil if you don't want to add a parameter. Parameters are values that are specified by yourself to identify different event contexts. Keys and Values must be of type NSString.
 @return The created IOLGestureEvent.
 */
- (instancetype)initWithCategory:(nullable NSString*)category comment:(nullable NSString*)comment parameter:(nullable NSDictionary<NSString*, NSString*>*)parameter ;

@end

NS_ASSUME_NONNULL_END

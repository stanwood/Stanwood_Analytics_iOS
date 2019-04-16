//
//  IOLEvent.h
//  INFOnlineLibrary
//
//  Created by Michael Ochs on 7/20/12.
//  Copyright (c) 2012 RockAByte GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 IOLEvent represents one event you can log and send to the IOL servers via an IOLSession object.
 
 @see `IOLSession`
 */
@interface IOLEvent : NSObject <NSSecureCoding, NSCopying>

/**
 This is the category you specified in the init of the event.
 */
@property (nonatomic, copy, readonly) NSString *category;

/**
 This is the comment you specified in the init of the event.
 */
@property (nonatomic, copy, readonly) NSString *comment;

- (instancetype) init __attribute__((unavailable("Use a designated initializer instead.")));

@end

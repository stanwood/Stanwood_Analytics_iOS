//
//  IOLUIWebView.h
//  INFOnlineLibrary
//
//  Created by Philip Laskowski on 02.07.15.
//  Copyright (c) 2015 RockAByte GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOLEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

@class IOLSession;

/**
 IOLUIWebView is a wrapper class for a UIWebView to use for logging.
 */

@interface IOLUIWebView : UIWebView

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

#pragma clang diagnostic pop

/**
 The multi identifier string is sent to your webserver as argument of the iom.setMultiIdentifier(string) JavaScript method
 of the INFOnline tracking framework.
 
 Normally you don't need to access this value, however if you are using frameworks like phonegap and you are not able to
 use the IOLUIWebView, you can use this string and call the iom.setMultiIdentifier() method on -webViewDidFinishLoad: manually.
 
 @return The escaped multi identifier string or nil if the session has not been initialized yet.
 @note You should not cache or store this value. Pass it as is to the JavaScript function! No manipulation like escaping is required.
 */
+ (nullable NSString*)multiIdentifierString;

/**
 Initializes an IOLUIWebView object.
 
 @param frame The frame of the IOLUIWebView.
 @return The created IOLUIWebView.
 */
-(instancetype)initWithFrame:(CGRect)frame;


/**
 Initializes an IOLUIWebView object.
 
 @param aDecoder The aDecoder of the IOLUIWebView.
 @return The created IOLUIWebView.
 */
-(instancetype)initWithCoder:(NSCoder*)aDecoder;

@end

NS_ASSUME_NONNULL_END

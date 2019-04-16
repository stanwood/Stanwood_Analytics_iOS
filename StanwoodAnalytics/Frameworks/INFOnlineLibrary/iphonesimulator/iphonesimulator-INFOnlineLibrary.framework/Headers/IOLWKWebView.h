//
//  IOLWKWebView.h
//  INFOnlineLibrary
//
//  Created by Philip Laskowski on 02.07.15.
//  Copyright (c) 2015 RockAByte GmbH. All rights reserved.
//

#import "IOLEnvironment.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IOLSession;

/**
 IOLWKWebView is a wrapper class for a WKWebView to use for logging.
 */
@interface IOLWKWebView : WKWebView

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

/**
 The multi identifier string is sent to your webserver as argument of the iom.setMultiIdentifier(string) JavaScript method
 of the INFOnline tracking framework.
 
 Normally you don't need to access this value, however if you are using frameworks like phonegap and you are not able to
 use the IOLWKWebView, you can use this string and call the iom.setMultiIdentifier() method on -webViewDidFinishLoad: manually.
 
 @return The escaped multi identifier string or nil if the session has not been initialized yet.
 
 @note You should not cache or store this value. Pass it as is to the JavaScript function! No manipulation like escaping is required.
 */
+ (nullable NSString*)multiIdentifierString;

/**
 Initializes an IOLWKWebView object.
 
 @param frame The frame of the IOLWKWebView.
 @return The created IOLWKWebView.
 */
-(instancetype)initWithFrame:(CGRect)frame;


/**
 Initializes an IOLWKWebView object.
 
 @param aDecoder The aDecoder of the IOLWKWebView.
 @return The created IOLWKWebView.
 */
-(instancetype)initWithCoder:(NSCoder*)aDecoder;

/**
 Initializes an IOLWKWebView object with its session.
 
 @param frame The frame of the IOLWKWebView.
 @param configuration The WKWebViewConfiguration.
 @return The created IOLWKWebView.
 */
-(instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration*)configuration;

@end

NS_ASSUME_NONNULL_END

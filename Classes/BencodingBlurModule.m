/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "BencodingBlurModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation BencodingBlurModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"d85a60ff-a204-4a70-b16a-315bd61c7d0d";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"bencoding.blur";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];
}

-(void)shutdown:(id)sender
{
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 


#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

-(NSNumber*) isSupported:(id)unused
{
 
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

    return NUMBOOL(YES);
    
#else
    
    return NUMBOOL(NO);
    
#endif
    
}

@end

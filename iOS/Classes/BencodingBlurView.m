/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurView.h"
#import "ImageLoader.h"
#import "TiUIViewProxy.h"
#import "BXBImageHelpers.h"

@implementation BencodingBlurView

BOOL _rendered = NO;


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(_debug){
        NSLog(@"[DEBUG] onPresent - willMoveToSuperview");
    }
    
    if ([self.proxy _hasListeners:@"onPresent"]) {
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"presented",@"action",
							   nil
							   ];
        
		[self.proxy fireEvent:@"onPresent" withObject:event];
	}
}

-(void)removeImage
{
	if (_blurView!=nil)
	{
		_blurView.image = nil;
	}
}

-(void)initializeState
{
    //This is alittle hacky but, on init create and add our view
    [self blurView];
    //Set our blur defaults
    _blurLevel = [NSNumber numberWithFloat:5.0f];
    _blurFilter = @"CIGaussianBlur";
    _cropToFit = YES;
    _rendered = NO;
    _debug = NO;
    _viewToBlur = nil;
    _blurTint = [UIColor clearColor];
    _helpers = [[BXBImageHelpers alloc] init];
	[super initializeState];
}

-(void)dealloc
{
    [self clearTimer];
	_blurView = nil;
    _blurTint = nil;
    _viewToBlur = nil;
}

-(UIImageView*)blurView
{

	if (_blurView == nil) {
		_blurView = [[UIImageView alloc] initWithFrame:[self frame]];
		[self addSubview:_blurView];
	}
    
	return _blurView;
}

-(void)tryRefresh:(id)unused
{
    ENSURE_UI_THREAD(tryRefresh,unused);
    
    if(_debug){
        NSLog(@"[DEBUG] tryRefresh called");
    }
    
    if(_viewToBlur!=nil){
        [self setBackgroundView_:_viewToBlur];
        if(_debug){
            NSLog(@"[DEBUG] tryRefresh - backgroundView updated");
        }
        return;
    }
    
    id currentImage = [self.proxy valueForUndefinedKey:@"image"];
    
    if(currentImage!=nil){
        [self setImage_:currentImage];
        if(_debug){
            NSLog(@"[DEBUG] tryRefresh - image updated");
        }
    }
    
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    if(_debug){
        NSLog(@"[DEBUG] frameSizeChanged");
    }
    
	if ([self blurView] != nil) {
		
        [TiUtils setView:[self blurView] positionRect:bounds];
        
        if ([self.proxy _hasListeners:@"onSizeChanged"]) {
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"resized",@"action",
                                   nil
                                   ];
            
            [self.proxy fireEvent:@"onSizeChanged" withObject:event];
        }
	}
}

-(void) setDebug_:(id)value
{
    _debug =[TiUtils boolValue:value def:NO];
}

-(void) setBlurTintColor_:(id)value
{
    TiColor *newColor = [TiUtils colorValue:value];
    _blurTint = [newColor _color];
}

-(void) setBlurCroppedToRect_:(id)value
{
    _cropToFit =[TiUtils boolValue:value def:YES];
}

-(void) setBlurFilter_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    _blurFilter =[TiUtils stringValue:value];
}

-(void) setBlurLevel_:(id)value
{
    _blurLevel =[NSNumber numberWithDouble:[TiUtils doubleValue:value def:5.0]];
}

-(void) setBackgroundView_:(id)viewProxy
{
    ENSURE_SINGLE_ARG(viewProxy, TiViewProxy);

    _viewToBlur = viewProxy;
    
    [self removeImage];
    
    //CREATE A BLOG IMAGE FROM OUR PROXY
    TiBlob* blobImage = [_viewToBlur toImage:nil];

    [self addImageToView:[blobImage image]];
}

-(void) setViewToBlur_:(id)viewProxy
{    
    DebugLog(@"[WARN] viewToBlur has been depreciated, please use backgroundView");
    [self setBackgroundView_:viewProxy];
}

-(void)clearTimer
{
    if(_blurTimer!=nil){
        [_blurTimer invalidate];
        _blurTimer = nil;
    }
}

- (void)timerElapsed
{

    if(_debug){
        NSLog(@"[DEBUG] timerElapsed");
    }
    
    [self tryRefresh:nil];
    
    if ([self.proxy _hasListeners:@"onLiveBlur"]) {
        NSDictionary *timerEvent = [NSDictionary dictionaryWithObjectsAndKeys:@"liveBlur",@"action",
                                    NUMBOOL(YES),@"success",nil];
        
        [self.proxy fireEvent:@"onLiveBlur" withObject:timerEvent];
    }
    
}

-(void)clearContents:(id)unused
{
    ENSURE_UI_THREAD(clearContents,unused);
    [self removeImage];
}

-(void)startLiveBlur:(id)args
{
   
    ENSURE_SINGLE_ARG(args,NSDictionary)
    ENSURE_UI_THREAD(startLiveBlur,args);
    
    if(_debug){
        NSLog(@"[DEBUG] startLiveBlur");
    }
    
    float timerInterval = [TiUtils floatValue:@"interval" properties:args def:-1];
    
   [self clearTimer];
    
    if(timerInterval > 1){
    
        if(_debug){
            NSLog(@"[DEBUG] Live Blur Interval Scheduled");
        }
    
        _blurTimer = [NSTimer scheduledTimerWithTimeInterval:
                                [[NSNumber numberWithFloat:timerInterval] doubleValue]
                                                                target:self
                                                              selector:@selector(timerElapsed)
                                                              userInfo:nil
                                                               repeats:YES];
    }
    
}

-(void)stopLiveBlur:(id)unused
{
    ENSURE_UI_THREAD(stopLiveBlur,unused);
    if(_debug){
        NSLog(@"[DEBUG] stopLiveBlur");
    }
    [self clearTimer];
}

-(void) addImageToView:(UIImage*)theImage
{
    
    //CHECK IF WE NEED TO CROP TO THE VIEW'S FRAME
    if(_cropToFit ==YES){
        theImage = [_helpers imageCroppedToRect:[self frame] theImage:theImage];
    }

    //PASS THE IMAGE FROM OUR BLOB INTO OUR EFFECT METHOD
    [self blurView].image = [_helpers applyBlur:theImage withFilter:_blurFilter withLevel:_blurLevel withTint:_blurTint];
}

-(void) setImage_:(id)args
{
    
	if (args==nil || args==_blurView.image || [args isEqual:@""] || [args isKindOfClass:[NSNull class]])
	{
		return;
	}
    
    [self removeImage];

	UIImage *image = [_helpers convertToUIImage:args withProxy:[self proxy]];
    
    if (image != nil){
        [self addImageToView:image];
        // Have to resize the proxy view to fit new subview size, if necessary
        [(TiViewProxy*)[self proxy] contentsWillChange];
    }
    
	if (image == nil)
	{
        NSURL* imageURL = [[self proxy] sanitizeURL:args];
        if (![imageURL isKindOfClass:[NSURL class]]) {
            [self throwException:@"invalid image type"
                       subreason:[NSString stringWithFormat:@"expected TiBlob, String, TiFile, was: %@",[args class]]
                        location:CODELOCATION];
        }

        if ([imageURL isFileURL]) {
            image = [UIImage imageWithContentsOfFile:[imageURL path]];
            if (image == nil) {
                image = [[ImageLoader sharedLoader] loadImmediateImage:imageURL];
            }

            image = [_helpers rotatedImage:image withProxy:[self proxy]];
        }
        
        if(image!=nil){
            [self addImageToView:image];
            [(TiViewProxy*)[self proxy] contentsWillChange];
        }
	}
    
}

-(void) setImageToBlur_:(id)args
{
    DebugLog(@"[WARN] imageToBlur has been depreciated, please use image");
    [self setImage_:args];
}

@end

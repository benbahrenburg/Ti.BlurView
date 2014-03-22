/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurView.h"
#import "ImageLoader.h"
#import "TiUIViewProxy.h"
#import "BXBImageHelpers.h"

@implementation BencodingBlurView

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    
    _rendered = YES;
    
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
    
    if((_rebindOnPresent)||(([self isViewBlur]) && (_stopViewRebind==NO))){
        
        if(_debug){
            NSLog(@"[DEBUG] Rebinding onPresent");
        }
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, _onPresentDelay);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if(_debug){
                NSLog(@"[DEBUG] Rebinding onPresent Queue Executed");
            }
            [self tryRefresh:nil];
        });
    }
}

-(BOOL) isViewBlur
{
    
    if(_viewToBlur!=nil){
        return YES;
    }
    id bgView = [self.proxy valueForUndefinedKey:@"backgroundView"];
    if(bgView!=nil){
        return YES;
    }
    
    return NO;
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
    _debug = NO;
    _onPresentDelay = 100;
    _cropToFit =YES;
    _rebindOnPresent = NO;
    _rebindOnResize = NO;
    _stopViewRebind = NO;
    _rendered = NO;

    //This is alittle hacky but, on init create and add our view
    [self blurView];
    //Set our blur defaults

    _blurLevel = [NSNumber numberWithFloat:5.0f];
    _blurFilter = @"CIGaussianBlur";
    _blurTint = [UIColor clearColor];
    _helpers = [[BXBImageHelpers alloc] init];
	[super initializeState];
}

-(void)dealloc
{
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
    
    id bgView = [self.proxy valueForUndefinedKey:@"backgroundView"];
    
    if(bgView!=nil)
    {
        if(_debug){
            NSLog(@"[DEBUG] tryRefresh - setting setBackgroundView_");
        }
        [self setBackgroundView_:bgView];
        return;
    }
    
    id currentImage = [self.proxy valueForUndefinedKey:@"image"];
    
    if(currentImage!=nil){
        [self setImage_:currentImage];
        if(_debug){
            NSLog(@"[DEBUG] tryRefresh - image updated");
        }
        return;
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
    
    if(_rebindOnResize){
        if(_debug){
            NSLog(@"[DEBUG] trying to rebind on resize");
        }
        [self tryRefresh:nil];
    }
}


-(void) setStopViewRebind_:(id)value
{
    _stopViewRebind =[TiUtils boolValue:value def:NO];
}
-(void) setRebindOnPresentDelay_:(id)value
{
    _onPresentDelay =[TiUtils floatValue:value def:100];
}

-(void) setRebindOnResize_:(id)value
{
    _rebindOnResize =[TiUtils boolValue:value def:NO];
}

-(void) setRebindOnPresent_:(id)value
{
    _rebindOnPresent =[TiUtils boolValue:value def:NO];
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

-(void)setBackgroundView_:(id)viewProxy
{
    ENSURE_SINGLE_ARG(viewProxy, TiViewProxy);
    
    _viewToBlur = viewProxy;
    
    if(_rendered==NO){
        if(_debug){
            NSLog(@"[DEBUG] BlurView not rendered yet, waiting until willMoveToSuperview");
        }
        return;
    }
    
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


-(void)clearContents:(id)unused
{
    ENSURE_UI_THREAD(clearContents,unused);
    [self removeImage];
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

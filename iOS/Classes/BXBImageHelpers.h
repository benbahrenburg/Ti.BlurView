/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TiUtils.h"
@interface BXBImageHelpers : NSObject

-(UIImage*)rotatedImage:(UIImage*)originalImage withProxy:(TiProxy*)proxy;
-(UIImage*)convertToUIImage:(id)arg withProxy:(TiProxy*)proxy;
- (UIImage *)imageCroppedToRect:(CGRect)rect theImage:(UIImage*)theImage;
-(UIImage*) applyBlur :(UIImage*)theImage
             withFilter:(NSString*)blurFilterName
              withLevel:(NSNumber*) blurLevel
               withTint:(UIColor*)tintColor;
@end

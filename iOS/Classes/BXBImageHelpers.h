/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BXBImageHelpers : NSObject

- (UIImage *)imageCroppedToRect:(CGRect)rect theImage:(UIImage*)theImage;
-(UIImage*) applyBlur :(UIImage*)theImage
             withFilter:(NSString*)blurFilterName
              withLevel:(NSNumber*) blurLevel
               withTint:(UIColor*)tintColor;
@end

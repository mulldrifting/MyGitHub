//
//  LLConstants.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/22/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLConstants.h"

@implementation LLConstants

+ (UIImage *)gutterButtonNormalImage
{
    static UIImage *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIImage *myIconImage = [UIImage imageNamed:@"GutterButton"];
        
        UIGraphicsBeginImageContextWithOptions (myIconImage.size, NO, [[UIScreen mainScreen] scale]); // for correct resolution on retina, thanks @MobileVet
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, 0, myIconImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGRect rect = CGRectMake(0, 0, myIconImage.size.width, myIconImage.size.height);
        
        /// draw tint color
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        [[UIColor colorWithWhite:0.200 alpha:1.000] setFill];
        CGContextFillRect(context, rect);
        
        // mask by alpha values of original image
        CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
        CGContextDrawImage(context, rect, myIconImage.CGImage);
        inst = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return inst;
}

+ (UIImage *)gutterButtonHighlightedImage
{
    static UIImage *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIImage *myIconImage = [UIImage imageNamed:@"GutterButton"];
        
        UIGraphicsBeginImageContextWithOptions (myIconImage.size, NO, [[UIScreen mainScreen] scale]); // for correct resolution on retina, thanks @MobileVet
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, 0, myIconImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGRect rect = CGRectMake(0, 0, myIconImage.size.width, myIconImage.size.height);
        
        /// draw tint color
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        [[UIColor colorWithWhite:0.702 alpha:1.000] setFill];
        CGContextFillRect(context, rect);
        
        // mask by alpha values of original image
        CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
        CGContextDrawImage(context, rect, myIconImage.CGImage);
        inst = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return inst;
}

@end

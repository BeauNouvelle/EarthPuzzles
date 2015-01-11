//
//  UIImage+Extras.m
//  Earth Puzzles
//
//  Created by Beau Young on 11/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import "UIImage+Extras.h"

@implementation UIImage (Extras)

- (UIImage *)resizedImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGImageRef sourceImage = CGImageCreateCopy(self.CGImage);
    UIImage *newImage = [UIImage imageWithCGImage:sourceImage scale:0.0 orientation:self.imageOrientation];
    [newImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    CGImageRelease(sourceImage);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)cropImageFromFrame:(CGRect)frame {
    CGRect destFrame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
    
    CGFloat scale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        scale = [[UIScreen mainScreen] scale];
    }
    
    CGRect sourceFrame = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width*scale, frame.size.height*scale);
    
    UIGraphicsBeginImageContextWithOptions(destFrame.size, NO, 0.0);
    CGImageRef sourceImage = CGImageCreateWithImageInRect(self.CGImage, sourceFrame);
    UIImage *newImage = [UIImage imageWithCGImage:sourceImage scale:0.0 orientation:self.imageOrientation];
    [newImage drawInRect:destFrame];
    CGImageRelease(sourceImage);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

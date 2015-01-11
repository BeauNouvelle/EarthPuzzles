//
//  UIImage+Extras.m
//  Earth Puzzles
//
//  Created by Beau Young on 11/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import "UIImage+Extras.h"

@implementation UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

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

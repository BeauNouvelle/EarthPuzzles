//
//  UIImage+Extras.h
//  Earth Puzzles
//
//  Created by Beau Young on 11/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)resizedImageWithSize:(CGSize)size;
- (UIImage *)cropImageFromFrame:(CGRect)frame;

@end

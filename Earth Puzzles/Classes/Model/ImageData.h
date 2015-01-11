//
//  ImageData.h
//  Earth Puzzles
//
//  Created by Beau Young on 10/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageData : NSObject

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSString *imageTitle;

+ (instancetype)imageDataWithAttributes:(NSDictionary *)attributes;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end

//
//  ImageData.m
//  Earth Puzzles
//
//  Created by Beau Young on 10/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData

+ (instancetype)imageDataWithAttributes:(NSDictionary *)attributes {
    return [[self alloc] initWithAttributes:attributes];
}
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _imageTitle = attributes[@"title"];
        _imageURL = [NSURL URLWithString:attributes[@"url"]];
        
        if ([_imageURL.absoluteString containsString:@"imgur"]) {
            // we'll get a better quality thumbnail if the image is coming from imgur.
            NSString *modifiedString = [_imageURL.absoluteString stringByReplacingOccurrencesOfString:@".jpg" withString:@"m.jpg"];
            _thumbnailURL = [NSURL URLWithString:modifiedString];
        }
        else {
            _thumbnailURL = [NSURL URLWithString:attributes[@"thumbnail"]];
        }
    }
    return self;
}

@end

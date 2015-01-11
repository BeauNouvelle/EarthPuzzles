//
//  ImageFetcher.m
//  Earth Puzzles
//
//  Created by Beau Young on 10/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import "ImageDataFetcher.h"
#import "ImageData.h"

@interface ImageDataFetcher()

@property (strong, nonatomic) NSString *lastImageIdentifier;

@end

@implementation ImageDataFetcher

- (void)fetchImageData {
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[self imageDataURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSError *error;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (DEBUG) {
                NSLog(@"%s -- %@", __PRETTY_FUNCTION__, responseDictionary);
            }
            
            self.lastImageIdentifier = responseDictionary[@"data"][@"after"];
            
            // Now we create our imageData objects by looping through the response and initializing them one at a time.
            NSMutableArray *imageDataArray = [NSMutableArray array];
            
            for (NSDictionary *imageDataDict in responseDictionary[@"data"][@"children"]) {
                
                // We also don't want any URLs that dont end in "jpg". Otherwise they may have to be built, and some require extra api calls in order to get different sizes. (Looking at you flickr). This also excludes URLs that dont point to images at all.
                if (![imageDataDict[@"data"][@"url"] hasSuffix:@"jpg"]) {
                    continue;
                }

                ImageData *image = [ImageData imageDataWithAttributes:imageDataDict[@"data"]];
                [imageDataArray addObject:image];
            }
            
            // Inform the delegate that we have fresh data.
            [self imageDataFetcher:self didFinishFetchingImageData:imageDataArray];
        }
        
        // If there's no data we should handle errors here, if caused by a timeout, we should inform the user and ask them to try again.
        else {
            NSLog(@"No data has returned. Possible network issue.");
        }
    }] resume];
}

- (NSURL *)imageDataURL {
    NSURL *url;
    if (self.lastImageIdentifier) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/r/EarthPorn/.json?limit=30&after=%@", self.lastImageIdentifier]];
    }
    else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/r/EarthPorn/.json?limit=30"]];
    }
    return url;
}

#pragma mark - Delegates

- (void)imageDataFetcher:(ImageDataFetcher *)imageDataFetcher didFinishFetchingImageData:(NSArray *)imageData {
    id <ImageDataFetcherDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(imageDataFetcher:didFinishFetchingImageData:)]) {
        [strongDelegate imageDataFetcher:imageDataFetcher didFinishFetchingImageData:imageData];
    }
}

@end

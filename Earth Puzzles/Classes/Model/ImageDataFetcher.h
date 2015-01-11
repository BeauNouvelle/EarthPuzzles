//
//  ImageFetcher.h
//  Earth Puzzles
//
//  Created by Beau Young on 10/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDataFetcherDelegate;

@interface ImageDataFetcher : NSObject

@property (nonatomic, weak) id <ImageDataFetcherDelegate> delegate;

/*!
 Performs the network call that will download the image data, and notifies the delegate when completed.
 */
- (void)fetchImageData;

@end

@protocol ImageDataFetcherDelegate <NSObject>

@optional
/*!
 @param imageDataFetcher The ImageDataFetcher object doing the fetching.
 @param imageData        An array of ImageData objects.
 */
- (void)imageDataFetcher:(ImageDataFetcher *)imageDataFetcher didFinishFetchingImageData:(NSArray *)imageData;

@end

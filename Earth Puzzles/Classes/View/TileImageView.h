//
//  TileImageView.h
//  Earth Puzzles
//
//  Created by Beau Young on 11/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileImageView : UIImageView

@property (nonatomic,readwrite) CGPoint originalPosition;
@property (nonatomic,readwrite) CGPoint currentPosition;

@end

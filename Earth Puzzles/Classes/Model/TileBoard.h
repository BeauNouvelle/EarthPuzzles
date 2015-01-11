//
//  TileBoard.h
//  Earth Puzzles
//
//  Created by Beau Young on 11/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TileBoard : NSObject

@property (nonatomic) NSInteger size;

- (instancetype)initWithSize:(NSInteger)size;
- (void)setTileAtCoordinate:(CGPoint)coor with:(NSNumber *)number;
- (NSNumber *)tileAtCoordinate:(CGPoint)coor;

- (BOOL)canMoveTile:(CGPoint)coor;
- (CGPoint)shouldMove:(BOOL)move tileAtCoordinate:(CGPoint)coor;
- (BOOL)isAllTilesCorrect;

- (void)shuffle:(NSInteger)times;

@end

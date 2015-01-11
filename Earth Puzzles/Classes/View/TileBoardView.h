//
//  TileBoardView.h
//  Earth Puzzles
//
//  Created by Beau Young on 11/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TileBoardView;

@protocol TileBoardViewDelegate;

@interface TileBoardView : UIView

@property (weak, nonatomic) id<TileBoardViewDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image size:(NSInteger)size frame:(CGRect)frame;
- (void)playWithImage:(UIImage *)image size:(NSInteger)size;
- (void)shuffleTimes:(NSInteger)times;

@end

@protocol TileBoardViewDelegate <NSObject>
@optional
- (void)tileBoardViewDidFinished:(TileBoardView *)tileBoardView;
- (void)tileBoardView:(TileBoardView *)tileBoardView tileDidMove:(CGPoint)position;
@end
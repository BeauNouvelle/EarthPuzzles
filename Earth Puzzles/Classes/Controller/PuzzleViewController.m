//
//  PuzzleViewController.m
//  Earth Puzzles
//
//  Created by Beau Young on 10/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import "PuzzleViewController.h"
#import "SDWebImageManager.h"
#import "TileImageView.h"
#import "UIImage+Extras.h"

#define TILE_SPACING 1
#define SHUFFLE_NUMBER 20
#define TILE_MOVE_SPEED 0.5

int NUM_HORIZONTAL_TILES = 4;
int NUM_VERTICAL_TILES = 4;

typedef enum {
    NONE    = 0,
    UP      = 1,
    DOWN    = 2,
    LEFT    = 3,
    RIGHT   = 4
} ShuffleMove;

@interface PuzzleViewController ()

@property (nonatomic, strong) NSMutableArray *tiles;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIImageView *blurredBackgroundView;
@property (nonatomic, strong) UIView *gameView;
@property (nonatomic, strong) TileImageView *tileImageView;

@end

@implementation PuzzleViewController {
    CGFloat _tileWidth;
    CGFloat _tileHeight;
    CGPoint _blankPosition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup progressview for loading images.
    CGRect frame = self.view.frame;
    CGFloat width = self.view.frame.size.width;
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame)-frame.size.width/2, 0, width, 20)];
    [self.view addSubview:_progressView];
    
    self.tiles = [NSMutableArray array];
    self.gameView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, width-20, width-20)];
    [self.view addSubview:self.gameView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.gameView.gestureRecognizers = @[panGesture];
    
    // Download the selected photo, and start the game.
    [self getPhotoWithURL:_imageData.imageURL completion:^(UIImage *photo) {
        self.blurredBackgroundView.image = photo;
        [self setupGameWithPhoto:photo];
    }];
}

- (void)setupGameWithPhoto:(UIImage *)photo {
    [self.tiles removeAllObjects];
    
    _tileWidth = photo.size.width/NUM_HORIZONTAL_TILES;
    _tileHeight = photo.size.height/NUM_VERTICAL_TILES;
    
    _blankPosition = CGPointMake(NUM_HORIZONTAL_TILES-1, NUM_VERTICAL_TILES-1);
    
    for (int x = 0; x < NUM_HORIZONTAL_TILES; x++) {
        for (int y = 0; y < NUM_VERTICAL_TILES; y++) {
            CGPoint originalPosition = CGPointMake(x, y);
            
            if (_blankPosition.x == originalPosition.x && _blankPosition.y == originalPosition.y) {
                continue;
            }
            
            CGRect frame = CGRectMake(_tileWidth*x, _tileHeight*y, _tileWidth, _tileHeight);
            
            CGImageRef tileImageRef = CGImageCreateWithImageInRect(photo.CGImage, frame);
            UIImage *tileImage = [UIImage imageWithCGImage:tileImageRef];
            
            CGRect tileFrame = CGRectMake((_tileWidth+TILE_SPACING)*x, (_tileHeight+TILE_SPACING)*y, _tileWidth, _tileHeight);
            
            _tileImageView = [[TileImageView alloc] initWithImage:tileImage];
            _tileImageView.frame = tileFrame;
            _tileImageView.originalPosition = originalPosition;
            _tileImageView.currentPosition = originalPosition;
            
            CGImageRelease(tileImageRef);
            
            [_tiles addObject:_tileImageView];
            
            [self.gameView addSubview:_tileImageView];
        }
    }
    [self shuffle];
}

#pragma mark - Tile Move Methods
- (ShuffleMove)validMove:(TileImageView *)tile {
    // blank spot above current piece
    if( tile.currentPosition.x == _blankPosition.x && tile.currentPosition.y == _blankPosition.y+1 ){
        return UP;
    }
    
    // bank splot below current piece
    if( tile.currentPosition.x == _blankPosition.x && tile.currentPosition.y == _blankPosition.y-1 ){
        return DOWN;
    }
    
    // bank spot left of the current piece
    if( tile.currentPosition.x == _blankPosition.x+1 && tile.currentPosition.y == _blankPosition.y ){
        return LEFT;
    }
    
    // bank spot right of the current piece
    if( tile.currentPosition.x == _blankPosition.x-1 && tile.currentPosition.y == _blankPosition.y ){
        return RIGHT;
    }
    
    return NONE;
}

- (void)moveTile:(TileImageView *)tile withAnimation:(BOOL)animate {
    switch ([self validMove:tile]) {
        case UP:
            [self moveTile:tile
              inDirectionX:0 inDirectionY:-1 withAnimation:animate];
            break;
        case DOWN:
            [self moveTile:tile
              inDirectionX:0 inDirectionY:1 withAnimation:animate];
            break;
        case LEFT:
            [self moveTile:tile
              inDirectionX:-1 inDirectionY:0 withAnimation:animate];
            break;
        case RIGHT:
            [self moveTile:tile
              inDirectionX:1 inDirectionY:0 withAnimation:animate];
            break;
        default:
            break;
    }
}

- (void)moveTile:(TileImageView *)tile inDirectionX:(NSInteger)dx inDirectionY:(NSInteger)dy withAnimation:(BOOL)animate {
    tile.currentPosition = CGPointMake(tile.currentPosition.x+dx,
                                       tile.currentPosition.y+dy);
    _blankPosition = CGPointMake(_blankPosition.x-dx,
                                 _blankPosition.y-dy);
    
    int x = tile.currentPosition.x;
    int y = tile.currentPosition.y;
    
    if (animate) {
        [UIView beginAnimations:@"frame" context:nil];
    }
    tile.frame = CGRectMake((_tileWidth+TILE_SPACING)*x,
                            (_tileHeight+TILE_SPACING)*y,
                            _tileWidth,
                            _tileHeight);
    
    if (animate) {
        [UIView commitAnimations];
    }
}

- (void)slideTile:(TileImageView *)tile byX:(CGFloat)xDirection byY:(CGFloat)yDirection {
    tile.currentPosition = CGPointMake(tile.currentPosition.x+xDirection, tile.currentPosition.y+yDirection);
    _blankPosition = CGPointMake(_blankPosition.x-xDirection, _blankPosition.y-yDirection);
    
    tile.frame = CGRectMake(tile.frame.origin.x+xDirection, tile.frame.origin.y+yDirection, _tileWidth, _tileHeight);
}

- (void)shuffle {
    // Tiles must be shuffled and not added to the view in random places.
    // This ensures that the puzzle is actually solvable.
    NSMutableArray *validMoves = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<SHUFFLE_NUMBER; i++) {
        [validMoves removeAllObjects];
        
        // get all of the pieces that can move
        for (TileImageView *tile in _tiles) {
            if ([self validMove:tile] != NONE) {
                [validMoves addObject:tile];
            }
        }
        
        // randomly select a piece to move
        NSInteger pick = random()%validMoves.count;
        [self moveTile:(TileImageView *)[validMoves objectAtIndex:pick] withAnimation:NO];
    }
}

#pragma mark - Helper Methods
- (TileImageView *)getTileAtPoint:(CGPoint)point {
    CGRect touchRect = CGRectMake(point.x, point.y, 1.0, 1.0);
    
    for (TileImageView *tile in _tiles) {
        if (CGRectIntersectsRect(tile.frame, touchRect)) {
            NSLog(@"X:%@ Y:%@", @(touchRect.origin.x), @(touchRect.origin.y));
            return tile;
        }
    }
    return nil;
}

- (BOOL)puzzleCompleted {
    // If every tile is back in its original position, then the player has won.
    for (TileImageView *tile in _tiles) {
        if (tile.originalPosition.x != tile.currentPosition.x || tile.originalPosition.y != tile.currentPosition.y) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Touches & Gestures

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *tileTouch = [touches anyObject];
    CGPoint locationInPuzzle = [tileTouch locationInView:self.gameView];
    
    TileImageView *tile = [self getTileAtPoint:locationInPuzzle];
    if (tile != nil) {
        // move the pieces
        [self moveTile:tile withAnimation:YES];
        
        if ([self puzzleCompleted]) {
            NSLog(@"WINNER");
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint currentlocation = [sender locationInView:self.view];
    TileImageView *tile = [self getTileAtPoint:currentlocation];
    
   if (sender.state == UIGestureRecognizerStateChanged) {
       CGPoint translation = [sender translationInView:self.view];

       [self slideTile:tile byX:0 byY:translation.y];

//       switch ([self validMove:tile]) {
//           case UP:
//               [self slideTile:tile byX:0 byY:translation.y];
//               break;
//           case DOWN:
//               [self slideTile:tile byX:0 byY:translation.y];
//               break;
//           default:
//               break;
//       }
       
       
   }

//    switch ([self validMove:tile]) {
//        case UP:
//            break;
//            
//        default:
//            break;
//    }

//    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)getPhotoWithURL:(NSURL *)URL completion:(void (^)(UIImage *photo))completion {
    NSLog(@"%@", URL.absoluteString);
    // We'll use the SDWebImageManager here because it has caching, which means instant loading of previously played games!
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:URL
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             [_progressView setProgress:(float)receivedSize / (float)expectedSize];
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if (image) {
                                completion([image imageByScalingAndCroppingForSize:self.gameView.frame.size]);
                                [_progressView removeFromSuperview];
                            }
                        }];
}

@end

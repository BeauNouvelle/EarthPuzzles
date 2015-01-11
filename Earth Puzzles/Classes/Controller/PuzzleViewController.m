//
//  PuzzleViewController.m
//  Earth Puzzles
//
//  Created by Beau Young on 10/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import "PuzzleViewController.h"
#import "SDWebImageManager.h"
#import "TileBoard.h"
#import "TileBoardView.h"
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

@interface PuzzleViewController () <TileBoardViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIImageView *blurredBackgroundView;
@property (nonatomic, strong) TileBoardView *board;
@property (weak, nonatomic) UIImageView *imageView;
@property (nonatomic, assign, readonly) UIImage *boardImage;
@property (nonatomic, readonly) NSInteger boardSize;
@property (nonatomic) NSInteger moves;

@end

@implementation PuzzleViewController {
    CGFloat _tileWidth;
    CGFloat _tileHeight;
    CGPoint _blankPosition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    // Setup progressview for loading images.
    CGRect frame = self.view.frame;
    CGFloat width = self.view.frame.size.width;
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame)-frame.size.width/2, 0, width, 20)];
    [self.view addSubview:_progressView];
    
    self.board = [[TileBoardView alloc] initWithFrame:CGRectMake(7.5, 7.5, width-15, width-15)];

    self.board.delegate = self;
    [self.view addSubview:self.board];
    
    // Download the selected photo, and start the game.
    [self getPhotoWithURL:_imageData.imageURL completion:^(UIImage *photo) {
        self.blurredBackgroundView.image = photo;
        [self setupGameWithPhoto:photo];
    }];
}

- (void)setupGameWithPhoto:(UIImage *)photo {
    [self.board playWithImage:photo size:50];
    [self.board shuffleTimes:1];
    self.moves = 0;
}

- (void)setMoves:(NSInteger)moves {
    _moves = moves;
    self.title = [NSString stringWithFormat:@"Moves:%ld", (long)self.moves];
}

#pragma mark - Board Delegates
- (void)tileBoardView:(TileBoardView *)tileBoardView tileDidMove:(CGPoint)position {
    self.moves++;
}

- (void)tileBoardViewDidFinished:(TileBoardView *)tileBoardView {
    NSLog(@"tile is completed");
    
    NSString *message = [NSString stringWithFormat:@"You completed the puzzles in %ld moves", (long)self.moves];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:message delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Download Image

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
                                CGSize size = CGSizeMake(2000, 2000);
                                completion([image imageByScalingAndCroppingForSize:size]);
                                [_progressView removeFromSuperview];
                            }
                        }];
}

@end

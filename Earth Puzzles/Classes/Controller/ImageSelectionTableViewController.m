//
//  ImageSelectionTableViewController.m
//  Earth Puzzles
//
//  Created by Beau Young on 10/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import "ImageSelectionTableViewController.h"
#import "ImageDataFetcher.h"
#import "ImageData.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ImageTableViewCell.h"
#import "PuzzleViewController.h"

@interface ImageSelectionTableViewController () <ImageDataFetcherDelegate>

@property (nonatomic, strong) ImageDataFetcher *imageDataFetcher;
@property (nonatomic, strong) NSMutableArray *fetchedImages;

@end

@implementation ImageSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Choose a puzzle";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchImageData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.fetchedImages = [[NSMutableArray alloc] init];
    
    self.imageDataFetcher = [[ImageDataFetcher alloc] init];
    self.imageDataFetcher.delegate = self;
    [self.imageDataFetcher fetchImageData];
}

- (void)fetchImageData:(id)sender {
    if (self.imageDataFetcher) {
        [self.imageDataFetcher fetchImageData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fetchedImages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImageTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    ImageData *image = _fetchedImages[indexPath.row];
    cell.title.text = image.imageTitle;
    [cell.image setImageWithURL:image.thumbnailURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageData *image = _fetchedImages[indexPath.row];
    [self performSegueWithIdentifier:@"puzzleSegue" sender:image];
}

#pragma mark - Image Data Fetcher Delegate

- (void)imageDataFetcher:(ImageDataFetcher *)imageDataFetcher didFinishFetchingImageData:(NSArray *)imageData {
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    
    [_fetchedImages addObjectsFromArray:imageData];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PuzzleViewController *destinationVC = [segue destinationViewController];
    
    if ([sender isKindOfClass:[ImageData class]]) {
        destinationVC.imageData = sender;
    }
    
    self.title = @"";
}


@end

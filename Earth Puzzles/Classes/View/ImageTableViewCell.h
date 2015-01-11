//
//  ImageTableViewCell.h
//  Earth Puzzles
//
//  Created by Beau Young on 10/01/2015.
//  Copyright (c) 2015 Beau Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;


@end

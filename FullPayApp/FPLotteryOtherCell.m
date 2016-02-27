//
//  FPLotteryOtherCell.m
//  FullPayApp
//
//  Created by mark zheng on 13-12-25.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPLotteryOtherCell.h"

@implementation FPLotteryOtherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.imageView.frame;
    rect.origin.x = 22.0f;
    self.imageView.frame = rect;
    
    rect = self.textLabel.frame;
    rect.origin.x = 70.0f;
    self.textLabel.frame = rect;
}

@end

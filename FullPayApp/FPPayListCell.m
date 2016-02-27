//
//  FPPayListCell.m
//  FullPayApp
//
//  Created by lc on 14-7-10.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPayListCell.h"

@implementation FPPayListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

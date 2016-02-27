//
//  FPMainCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-14.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMainCell.h"

@implementation FPMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleSubtitle;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.textColor = [UIColor redColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        _iconImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(50.0f, 20.0f, 100.0f, 20.0f);
    self.iconImage.frame = CGRectMake(12.0f, (self.height-35.0f)/2, 35.0f, 35.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 200.0f, 0.0f);
    detailTextLabelFrame.size.height = 20.0f;
    detailTextLabelFrame.size.width = 40.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end

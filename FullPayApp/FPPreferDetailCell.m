//
//  FPPreferDetailCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPreferDetailCell.h"

@implementation FPPreferDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleValue1;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        self.textLabel.textAlignment = NSTextAlignmentRight;
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.numberOfLines = 0;
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        self.accessoryType = UITableViewCellAccessoryNone;
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
    
    self.textLabel.frame = CGRectMake(5.0f, 5.0f, 50.0f, 40.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 60.0f, 0.0f);
    detailTextLabelFrame.size.height = 40.0f;
    detailTextLabelFrame.size.width = ScreenWidth - detailTextLabelFrame.origin.x-10;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end

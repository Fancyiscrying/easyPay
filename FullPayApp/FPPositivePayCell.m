//
//  FPPositivePayCell.m
//  FullPayApp
//
//  Created by 刘通超 on 14/11/24.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPositivePayCell.h"

@implementation FPPositivePayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleValue1;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.numberOfLines = 0;
        
//        self.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
//        self.detailTextLabel.textColor = [UIColor blackColor];
//        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
//        self.detailTextLabel.numberOfLines = 0;
//        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        self.accessoryType = UITableViewCellAccessoryNone;

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0.0f, 0.0f, self.width, 40.0f);
    
//    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 90.0f, 0.0f);
//    detailTextLabelFrame.size.height = 40.0f;
//    detailTextLabelFrame.size.width = ScreenWidth-detailTextLabelFrame.origin.x-10;
//    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end

//
//  FPMsgDetailCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMsgDetailCell.h"

@implementation FPMsgDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleValue1;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = [UIColor darkGrayColor];
        //self.textLabel.numberOfLines = 0;
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.numberOfLines = 1;
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
    
    self.textLabel.frame = CGRectMake(5.0f, 0.0f, 320.0f, 40.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 180.0f, 0.0f);
    detailTextLabelFrame.size.height = 40.0f;
    detailTextLabelFrame.size.width = ScreenWidth-205;

    self.detailTextLabel.frame = detailTextLabelFrame;
    //[self.detailTextLabel sizeToFit];
}


@end

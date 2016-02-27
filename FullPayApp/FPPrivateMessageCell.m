//
//  FPPrivateMessageCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPrivateMessageCell.h"

@implementation FPPrivateMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleValue1;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lbl_Status = [[UILabel alloc] initWithFrame:CGRectMake(250, 20, 50, 20)];
        self.lbl_Status.textColor = [UIColor redColor];
        self.lbl_Status.font = [UIFont systemFontOfSize:15.0f];
        self.lbl_Status.textAlignment = NSTextAlignmentRight;
        self.lbl_Status.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lbl_Status];
        
       // self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.numberOfLines = 1;
        self.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        self.detailTextLabel.textColor = [UIColor grayColor];
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
    
    self.textLabel.frame = CGRectMake(10.0f, 2.0f, 250.0f, 40.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 37.0f);
    detailTextLabelFrame.size.height = 20.0f;
    detailTextLabelFrame.size.width = 250.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end

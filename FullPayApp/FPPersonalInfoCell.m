//
//  FPPersonalInfoCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPersonalInfoCell.h"

@implementation FPPersonalInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleSubtitle;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lbl_Mark = [[UILabel alloc] init];
        self.lbl_Mark.textColor = MCOLOR(@"color_perinfor_label");
        self.lbl_Mark.font = [UIFont systemFontOfSize:12.0f];
        self.lbl_Mark.backgroundColor = [UIColor clearColor];
        self.lbl_Mark.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.lbl_Mark];
        
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
        self.accessoryView = accessoryView;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  重写setHighted的方法,改变高亮时的背景色
 */
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.section == 1 && (self.row == 0 ||self.row == 1)) {
        self.backgroundColor = [UIColor whiteColor];
    }else if (highlighted){
        self.backgroundColor = MCOLOR(@"color_common_cellbg");
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect imgRect = self.imageView.frame;
    
    CGFloat cellheight = self.frame.size.height;
    self.textLabel.frame = CGRectMake(imgRect.origin.x + imgRect.size.width + 10, (cellheight - 45.0)/2, 80.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    detailTextLabelFrame.size.height = 20.0f;
    detailTextLabelFrame.size.width = 100.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
    
    CGRect markTextLabelFrame = CGRectMake(220.0f, (cellheight - 20.0)/2, 60.0f, 20.0f);
    self.lbl_Mark.frame = markTextLabelFrame;
}

@end

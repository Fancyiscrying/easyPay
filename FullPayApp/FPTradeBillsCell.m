//
//  FPTradeBillsCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPTradeBillsCell.h"

@implementation FPTradeBillsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleValue1;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Initialization code
        self.lbl_TradeAmt = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 20)];
        //        self.lbl_TradeAmt.textColor = MCOLOR(@"text_color");
        self.lbl_TradeAmt.font = [UIFont systemFontOfSize:14.0f];
        self.lbl_TradeAmt.textAlignment = NSTextAlignmentRight;
        self.lbl_TradeAmt.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lbl_TradeAmt];
        
        self.lbl_TradeStatus = [[UILabel alloc] initWithFrame:CGRectMake(200, 30, 100, 20)];
//        self.lbl_TradeStatus.textColor = MCOLOR(@"color_myfutong_status");
        self.lbl_TradeStatus.textAlignment = NSTextAlignmentRight;
        self.lbl_TradeStatus.font = [UIFont systemFontOfSize:14.0f];
        self.lbl_TradeStatus.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lbl_TradeStatus];
        
       // self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = [UIColor blackColor];
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
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

///**
// *  重写setHighted的方法,改变高亮时的背景色
// */
//-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    if(highlighted){
//        self.backgroundColor = [UIColor whiteColor];
//    }else{
//        self.backgroundColor = [UIColor whiteColor];
//    }
    
//}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15.0f, 5.0f, 190.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    detailTextLabelFrame.size.height = 20.0f;
    detailTextLabelFrame.size.width = 130.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end

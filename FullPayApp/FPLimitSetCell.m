//
//  FPLimitSetCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPLimitSetCell.h"

@implementation FPLimitSetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleValue1;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.numberOfLines = 0;
        
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11.0f];
        
        self.btn_Switch = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_Switch.frame = CGRectMake(0, 20, 54.0, 26.0f);
        [self.btn_Switch setImage:[UIImage imageNamed:@"myfutong_bt_off"] forState:UIControlStateNormal];
        [self.btn_Switch setImage:[UIImage imageNamed:@"myfutong_bt_on"] forState:UIControlStateSelected];
        [self.btn_Switch addTarget:self action:@selector(click_switch:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = self.btn_Switch;
    }
    return self;
}

- (void)setLimitItem:(FPLimitSet *)limitItem
{
    _limitItem = limitItem;
    
    self.textLabel.text = _limitItem.title;
    
    self.detailTextLabel.text = _limitItem.notice;
    
    self.btn_Switch.selected = _limitItem.isOn;
    
    self.tag = _limitItem.filedTag;
    
    [self setNeedsLayout];
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
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, 2.0f, 310.0f, 30.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 30.0f);
    detailTextLabelFrame.size.height = 20.0f;
    detailTextLabelFrame.size.width = 260.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
    
    CGRect accessoryViewFrame = self.accessoryView.frame;
    accessoryViewFrame.origin.y -= 5.0f;
    self.accessoryView.frame = accessoryViewFrame;
}

-(void)click_switch:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate updateLimitSet:self];
    }
}

@end

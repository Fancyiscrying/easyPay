//
//  FPMyFutongCardsCell.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMyFutongCardsCell.h"
#import "UIButton+UIButtonImageWithLabel.h"

@implementation FPMyFutongCardsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lbl_CardNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, 20)];
        self.lbl_CardNumber.font = [UIFont systemFontOfSize:14.0f];
        self.lbl_CardNumber.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lbl_CardNumber];
    
        /*
        self.lbl_CardStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 200, 20)];
        self.lbl_CardStatus.textColor = MCOLOR(@"color_myfutong_status");
        self.lbl_CardStatus.font = [UIFont systemFontOfSize:14.0f];
        self.lbl_CardStatus.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lbl_CardStatus];
         */
        
        self.lbl_CardRemark = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 200, 20)];
        self.lbl_CardRemark.textColor = MCOLOR(@"text_color");
        self.lbl_CardRemark.font = [UIFont systemFontOfSize:14.0f];
        self.lbl_CardRemark.backgroundColor = [UIColor clearColor];
        [self.lbl_CardRemark sizeThatFits:self.lbl_CardRemark.frame.size];
        [self.contentView addSubview:self.lbl_CardRemark];
        
        self.btn_ModifyRemark = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_ModifyRemark.frame = CGRectMake(200, 35, 50, 21);
        [self.btn_ModifyRemark setBackgroundColor:[UIColor clearColor]];
        [self.btn_ModifyRemark setTitle:@"修改" forState:UIControlStateNormal];
        [self.btn_ModifyRemark setTitleColor:MCOLOR(@"color_myfutong_button") forState:UIControlStateNormal];
        [self.btn_ModifyRemark setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.btn_ModifyRemark setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        self.btn_ModifyRemark.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.btn_ModifyRemark addLine:self.btn_ModifyRemark];
        [self.btn_ModifyRemark addTarget:self action:@selector(click_ChangeRemark:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn_ModifyRemark];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.lbl_CardStatus = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 50, 40)];
        self.lbl_CardStatus.backgroundColor = [UIColor clearColor];
        self.lbl_CardStatus.textColor = [UIColor grayColor];
        self.lbl_CardStatus.font = [UIFont systemFontOfSize:14.0f];
        self.lbl_CardStatus.text = @"已注销";
        self.lbl_CardStatus.hidden = YES;
        [self.contentView addSubview:self.lbl_CardStatus];
        
        self.btn_Switch = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_Switch.frame = CGRectMake(0, 0, 54.0, 26.0f);
        [self.btn_Switch setImage:[UIImage imageNamed:@"myfutong_bt_on"] forState:UIControlStateNormal];
        [self.btn_Switch setImage:[UIImage imageNamed:@"myfutong_bt_off"] forState:UIControlStateSelected];
        [self.btn_Switch addTarget:self action:@selector(click_switch:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = self.btn_Switch;
        
        
    }
    return self;
}

- (void)setCardItem:(FPFutongCardItem *)cardItem
{
    _cardItem = cardItem;
    
    self.lbl_CardRemark.text = [NSString stringWithFormat:@"备注名：%@",_cardItem.useDesc];
    self.lbl_CardNumber.text = [NSString stringWithFormat:@"卡  号：%@",[_cardItem.cardNo formateCardNo]];
    
    if ([_cardItem.cardStatus isEqualToString:@"NORMAL"]){
        [self setTextColorWithCardStatus:YES];
        self.btn_ModifyRemark.enabled = YES;
        self.btn_Switch.selected = NO;

    }else{
        [self setTextColorWithCardStatus:NO];
        self.btn_ModifyRemark.enabled = NO;
        self.btn_Switch.selected = YES;


    }
    
    if ([_cardItem.cardStatus isEqualToString:@"NORMAL"]||[_cardItem.cardStatus isEqualToString:@"FREEZE"]){
        self.btn_Switch.hidden = NO;
    }else{
        self.btn_Switch.hidden = YES;
        
        if ([_cardItem.cardStatus isEqualToString:@"CANCEL"]) {
            self.lbl_CardStatus.hidden = NO;
        }else{
            self.lbl_CardStatus.hidden = YES;
        }
    }

    
   /* if ([_cardItem.cardStatus isEqualToString:@"NORMAL"]) {
        self.lbl_CardStatus.text = @"状  态：正常使用中";
        self.btn_Switch.selected = NO;
        self.btn_Switch.enabled = YES;
        self.btn_ModifyRemark.enabled = YES;
        self.btn_Switch.hidden = NO;
        self.btn_ModifyRemark.hidden = NO;
        
    } else if([_cardItem.cardStatus isEqualToString:@"FREEZE"]) {
        self.lbl_CardStatus.text = @"状  态：该卡已被冻结";
        self.btn_Switch.selected = YES;
        self.btn_Switch.enabled = YES;
        self.btn_ModifyRemark.enabled = NO;
        self.btn_Switch.hidden = NO;
        self.btn_ModifyRemark.hidden = NO;
        
    } else if([_cardItem.cardStatus isEqualToString:@"LOSS"]) {
        self.lbl_CardStatus.text = @"状  态：该卡已被挂失";
        self.btn_Switch.selected = YES;
        self.btn_Switch.enabled = NO;
        self.btn_ModifyRemark.enabled = NO;
        self.btn_Switch.hidden = YES;
        self.btn_ModifyRemark.hidden = YES;
        
    } else if([_cardItem.cardStatus isEqualToString:@"CANCEL"]) {
        self.lbl_CardStatus.text = @"状  态：该卡已被注销";
        self.btn_Switch.selected = YES;
        self.btn_Switch.enabled = NO;
        self.btn_ModifyRemark.enabled = NO;
        self.btn_Switch.hidden = YES;
        self.btn_ModifyRemark.hidden = YES;
        
    }
    */
    [self setNeedsDisplay];
}

- (void)setTextColorWithCardStatus:(BOOL)status{
    if (status == YES) {
        self.lbl_CardRemark.textColor = MCOLOR(@"text_color");
        self.lbl_CardNumber.textColor = MCOLOR(@"text_color");
        [self.btn_ModifyRemark setTitleColor:MCOLOR(@"color_myfutong_button") forState:UIControlStateNormal];
    }else{
        self.lbl_CardRemark.textColor = [UIColor lightGrayColor];
        self.lbl_CardNumber.textColor = [UIColor lightGrayColor];
        [self.btn_ModifyRemark setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)click_switch:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate updateFutongCardStatus:self];
    }
}

- (void)click_ChangeRemark:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate updateFutongCardRemark:self];
    }
}
@end

//
//  FPRedPacketWithDarwListCell.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketWithDarwListCell.h"
#import "FPRedWithDrawList.h"

@implementation FPRedPacketWithDarwListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self installView];
    }
    
    return self;
}

- (void)installView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, ScreenWidth, 60)];
    view.backgroundColor = [UIColor whiteColor];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = 5;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 44, 44)];
    image.backgroundColor = [UIColor clearColor];
    image.image = MIMAGE(@"redPacket_withdraw_list_fzf");
    image.tag = 101;
    [view addSubview:image];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(image.right+8, image.top-2, 80, 20)];
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont boldSystemFontOfSize:15];
    name.tag = 102;
    name.textColor = COLOR_STRING(@"#4D4D4D");
    name.text = @"富之富";
    [view addSubview:name];
    
    UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 15)];
    status.center = CGPointMake(view.width/2+30, 16);
    status.font = [UIFont systemFontOfSize:14];
    status.textAlignment = NSTextAlignmentLeft;
    status.tag = 103;
    [view addSubview:status];
    
    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(name.left, name.bottom+8, 150, 20)];
    date.backgroundColor = [UIColor clearColor];
    date.font = [UIFont systemFontOfSize:14];
    date.textColor = COLOR_STRING(@"#B2B2B2");
    date.tag = 104;
    [view addSubview:date];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 20)];
    money.right = ScreenWidth-20;
    money.backgroundColor = [UIColor clearColor];
    money.font = [UIFont boldSystemFontOfSize:18];
    money.textColor = COLOR_STRING(@"#FF5B5C");
    money.textAlignment = NSTextAlignmentRight;
    money.tag = 106;
    [view addSubview:money];
    
    [self addSubview:view];

}

- (void)setItem:(WithDrawCashItem *)item{
    _item = item;
    [self refreshView];

}

- (void)refreshView{
    
    UILabel *status = (UILabel *)[self viewWithTag:103];
    NSString *sta = _item.tradeStatus;
    if ([sta isEqualToString:@"SUCCESS"]) {
        status.textColor = COLOR_STRING(@"#2CF898");
        status.text = [NSString stringWithFormat:@"( 提现成功 )"];
    }else if ([sta isEqualToString:@"TRADING"]) {
        status.textColor = COLOR_STRING(@"#EA905F");
        status.text = [NSString stringWithFormat:@"( 提现中 )"];
    }else if ([sta isEqualToString:@"FAILURE"]) {
        status.textColor = COLOR_STRING(@"#FF5B5C");
        status.text = [NSString stringWithFormat:@"( 提现失败 )"];
    }
    
    UILabel *date = (UILabel *)[self viewWithTag:104];
    date.text = _item.beginTime;
    
    //UILabel *hasGet = (UILabel *)[self viewWithTag:105];
    
    double  amt = [_item.amt doubleValue];
    UILabel *money = (UILabel *)[self viewWithTag:106];
    money.text = [NSString stringWithFormat:@"%0.2f 元",amt/100];
    
    [self drawRect:self.frame];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

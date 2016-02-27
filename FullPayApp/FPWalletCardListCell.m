//
//  FPWalletCardListCell.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/7.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardListCell.h"

@implementation FPWalletCardListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self installView];
    }
    
    return self;
}

- (void)installView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, ScreenWidth, 59)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    image.backgroundColor = ClearColor;
    image.tag = 101;
//    image.layer.masksToBounds = YES;
//    image.layer.cornerRadius = 20;
    [view addSubview:image];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(image.right+8, 5, view.width-image.right, 20)];
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont boldSystemFontOfSize:14];
    name.textColor = COLOR_STRING(@"4D4D4D");
    name.tag = 102;
    [view addSubview:name];
    
    UILabel *cardNum = [[UILabel alloc]initWithFrame:CGRectMake(name.left, name.bottom+5, name.width, 20)];
    cardNum.backgroundColor = [UIColor clearColor];
    cardNum.font = [UIFont systemFontOfSize:14];
    cardNum.textColor = COLOR_STRING(@"808080");
    cardNum.tag = 103;
    [view addSubview:cardNum];
    
    
//    UIImageView * lossCardIV = [[UIImageView alloc] initWithFrame:CGRectMake(view.width-80, 20, 30, 20)];
//    lossCardIV.image = MIMAGE(@"lossCard");
//    lossCardIV.hidden = YES;
//    lossCardIV.tag = 104;
//    [view addSubview:lossCardIV];
    [self addSubview:view];
    
    self.accessoryView = [[UIImageView alloc]initWithImage:MIMAGE(@"WalletCard_list_access")];
    
}

- (void)setItem:(WalletCardListItem *)item{
    WalletCardListItem *temp = item;
    
    UIImageView *image = (UIImageView *)[self viewWithTag:101];
    UILabel *name = (UILabel *)[self viewWithTag:102];
    if (temp.realFlag) {
        image.image = MIMAGE(@"WalletCard_list_realCard");
        name.text = @"实名卡";
        
    }else{
        image.image = MIMAGE(@"WalletCard_list_unrealCard");
        name.text = @"不记名卡";

    }
    
    UILabel *cardNum = (UILabel *)[self viewWithTag:103];
    cardNum.text = [item.cardNo formateCardNo];
}

@end

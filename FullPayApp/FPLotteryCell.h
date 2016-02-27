//
//  FPLotteryCell.h
//  FullPayApp
//
//  Created by mark zheng on 13-11-19.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FPLotteryObject;
@interface FPLotteryCell : UITableViewCell

@property (nonatomic,strong) UIImageView *img_Title;
@property (nonatomic,strong) UILabel *lbl_Title;
@property (nonatomic,strong) UILabel *lbl_Desc1;
@property (nonatomic,strong) UILabel *lbl_Desc2;

@property (nonatomic,strong) FPLotteryObject *item;
@property(nonatomic,strong) NSDictionary *ImageList;

+ (CGFloat)heightForCellWithLottery:(FPLotteryObject *)item;

@end

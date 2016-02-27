//
//  FPMyFutongCardsCell.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPFutongCard.h"

@class FPMyFutongCardsCell;
@protocol FPMyFutongCardsCellDelegate <NSObject>

-(void)updateFutongCardStatus:(FPMyFutongCardsCell *)sender;
-(void)updateFutongCardRemark:(FPMyFutongCardsCell *)sender;

@end

@interface FPMyFutongCardsCell : UITableViewCell

@property (nonatomic,weak) id<FPMyFutongCardsCellDelegate> delegate;

@property (nonatomic,strong) UILabel    *lbl_CardNumber;
@property (nonatomic,strong) UILabel    *lbl_CardStatus;
@property (nonatomic,strong) UILabel    *lbl_CardRemark;
@property (nonatomic,strong) UIButton   *btn_ModifyRemark;
@property (nonatomic,strong) UIButton   *btn_Switch;

@property (nonatomic,strong)FPFutongCardItem *cardItem;

@end

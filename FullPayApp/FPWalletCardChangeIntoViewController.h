//
//  FPWalletCardChangeIntoViewController.h
//  FullPayApp
//
//  Created by 雷窑平 on 15/7/2.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPWalletCardListModel.h"

/*****************************************
 *
 * 选择转入卡页面
 *
 *****************************************/

@interface FPWalletCardChangeIntoViewController : FPViewController

/* 补卡信息 */
@property (nonatomic,strong) WalletCardDetilItem * cardDetilItem;

/* 可转入实名卡数组 */
@property (nonatomic,strong) NSArray * changeCardAry;

/* 转入金额 */
@property (nonatomic,assign) double money;

/* 关联卡id */
@property (nonatomic,strong) NSString * cardId;

@end

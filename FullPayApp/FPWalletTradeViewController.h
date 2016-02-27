//
//  FPWalletTradeViewController.h
//  FullPayApp
//
//  Created by lc on 14-8-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPWalletCardListModel.h"

@interface FPWalletTradeViewController : FPViewController
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong)  WalletCardDetilItem *cardItem;

@end

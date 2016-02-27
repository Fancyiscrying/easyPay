//
//  FPWalletCardListTable.h
//  FullPayApp
//
//  Created by 刘通超 on 15/4/7.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "RTTableView.h"

@interface FPWalletCardListTable : RTTableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *cardList;

@end

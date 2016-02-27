//
//  FPRedPacketWithDarwTable.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "RTTableView.h"

@interface FPRedPacketWithDarwTable : RTTableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *withDrawCashList;

@end

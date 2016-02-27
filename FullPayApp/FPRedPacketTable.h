//
//  FPRedPacketTable.h
//  FullPayApp
//
//  Created by 刘通超 on 14/12/2.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FPRedPacketTable : RTTableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) BOOL isDispatch;
@property (nonatomic, strong) NSMutableArray *redPacketList;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andDispatch:(BOOL)dispatch;
@end

//
//  FPMyAssetViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-14.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPAccountInfo.h"

@interface FPMyAssetViewController : FPViewController

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong) FPAccountInfoItem *accountItem;

@end

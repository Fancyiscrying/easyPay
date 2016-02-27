//
//  FPCommSettingViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-25.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

@interface FPCommSettingViewController : FPViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray * settings;
    NSMutableDictionary * settingsInSection;
}

@property (strong, nonatomic) UITableView *tableView;

@end

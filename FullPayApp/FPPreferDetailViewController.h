//
//  FPPreferDetailViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

@interface FPPreferDetailViewController : FPViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSString   *prefer_Title;
@property (nonatomic,strong) NSString   *prefer_Business;
@property (nonatomic,strong) NSString   *prefer_ValidTime;
@property (nonatomic,strong) NSString   *prefer_Remark;

@end

//
//  FPBillDetailsViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

@interface FPBillDetailsViewController : FPViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSString   *trade_status;
@property (nonatomic,strong) NSString   *trade_name;
@property (nonatomic,strong) NSString   *trade_type;
@property (nonatomic,strong) NSString   *trade_amt;
@property (nonatomic,strong) NSString   *trade_time;
@property (nonatomic,strong) NSString   *trade_remark;
@property (nonatomic,assign) double   trade_fee;

@end

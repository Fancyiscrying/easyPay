//
//  FPMsgDetailViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "FPMessageList.h"

@interface FPMsgDetailViewController : FPViewController
@property (strong,nonatomic) userMessage *mes;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

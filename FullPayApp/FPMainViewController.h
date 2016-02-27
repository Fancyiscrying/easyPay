//
//  FPMainViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-11.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

@interface FPMainViewController : FPViewController
@property (strong, nonatomic) UIImageView *img_HeadBackground;

@property (strong, nonatomic) IBOutlet UIImageView *img_UserImage;
@property (strong, nonatomic) IBOutlet UILabel *lbl_UserName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_UserPhone;

@property (strong, nonatomic) UIButton *btn_IdVerificate;

@property (strong, nonatomic) IBOutlet UIButton *btn_DimScan;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *btn_MoreTradeBills;

@end

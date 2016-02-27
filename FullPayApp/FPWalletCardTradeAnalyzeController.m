//
//  FPWalletCardTradeAnalyzeController.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/12.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardTradeAnalyzeController.h"
#import "FPWalletCardAnalyzeTable.h"
#import "FPWalletCardAnalyzeModel.h"

@interface FPWalletCardTradeAnalyzeController()

@property (nonatomic, strong) FPWalletCardAnalyzeTable *table;
@end


@implementation FPWalletCardTradeAnalyzeController
- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = COLOR_STRING(@"EDF1F2");
    self.view = view;
    
    _table = [[FPWalletCardAnalyzeTable alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    
    [self addTableHeaderView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad{
    self.title = @"统计";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
    [self getAnalyzeCountData];
    
}


- (void)addTableHeaderView{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    header.backgroundColor = COLOR_STRING(@"#FED030");
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:16];
    title.textColor = COLOR_STRING(@"4D4D4D");
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"累记明细";
    [header addSubview:title];
    
    UILabel *leftOutpay = [[UILabel alloc] initWithFrame:CGRectMake(0, title.bottom+1, ScreenWidth/2-0.5, 40)];
    leftOutpay.backgroundColor = [UIColor clearColor];
    leftOutpay.font = [UIFont systemFontOfSize:16];
    leftOutpay.textColor = COLOR_STRING(@"4D4D4D");
    leftOutpay.textAlignment = NSTextAlignmentCenter;
    leftOutpay.text = @"支出: 0.00 元";
    leftOutpay.tag = 101;
    [header addSubview:leftOutpay];
    
    UILabel *rightIncome = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+0.5, title.bottom+1, ScreenWidth/2-0.5, 40)];
    rightIncome.backgroundColor = [UIColor clearColor];
    rightIncome.font = [UIFont systemFontOfSize:16];
    rightIncome.textColor = COLOR_STRING(@"4D4D4D");
    rightIncome.textAlignment = NSTextAlignmentCenter;
    rightIncome.text = @"收入: 0.00 元";
    rightIncome.tag = 102;
    [header addSubview:rightIncome];
    
    UIView *levelLine = [[UIView alloc]initWithFrame:CGRectMake(0, title.bottom, ScreenWidth, 1)];
    levelLine.backgroundColor = COLOR_STRING(@"#929292");
    levelLine.alpha = 0.3;
    [header addSubview:levelLine];
    
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-0.5, levelLine.bottom, 1, 40)];
    verticalLine.backgroundColor = COLOR_STRING(@"#929292");
    verticalLine.alpha = 0.3;
    [header addSubview:verticalLine];
    
    _table.tableHeaderView = header;

}

- (void)getAnalyzeCountData{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];

    [FPWalletCardAnalyzeModel findMonthStsWithAccountNo:self.cardItem.accountNo andStart:@"0" andBlock:^(FPWalletCardAnalyzeModel *analyzeModel, NSError *error) {
        [hud hide:YES];
        if (analyzeModel.result) {
            UILabel *label1 = (UILabel *)[_table.tableHeaderView viewWithTag:101];
            label1.text = [NSString stringWithFormat:@"支出: %@ 元",[NSString simpMoney:analyzeModel.totalItem.payerAmt]];
            
            UILabel *label2 = (UILabel *)[_table.tableHeaderView viewWithTag:102];
            label2.text = [NSString stringWithFormat:@"收入: %@ 元",[NSString simpMoney:analyzeModel.totalItem.payeeAmt]];
            
            _table.analyzeList = analyzeModel.analyzeList;
            [_table reloadData];
        }
    }];

}

@end
    

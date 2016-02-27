//
//  FPRedPacketWithDrawListViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketWithDrawListViewController.h"
#import "FPRedPacketWithDarwTable.h"
#import "FPRedWithDrawList.h"


@interface FPRedPacketWithDrawListViewController ()<UITableViewRefreshDelegate>{
    BOOL isLoading;
    BOOL isLoadOver;
    int msgTotal;
    BOOL _reloading;
    
    NSInteger msgIndex;
}
@property (nonatomic, strong) FPRedPacketWithDarwTable *table;
@end

@implementation FPRedPacketWithDrawListViewController
- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    _table = [[FPRedPacketWithDarwTable alloc]initWithFrame:view.bounds style:UITableViewStylePlain];
    _table.height = ScreenHigh-64;
    _table.isNeedPullRefresh = YES;
    _table.refreshDelegate = self;
    [view addSubview:_table];
    
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.view bringSubviewToFront:defaultBackView];
    [self getRedPacketWithdrawFromAppWith:@"0"];

    // Do any additional setup after loading the view.
}

- (void)click_LeftButton{
    if (_hasWithDrawSucceed) {
        NSArray *controllers = self.navigationController.viewControllers;
        for (UIViewController *temp in controllers) {
            if ([temp isMemberOfClass:NSClassFromString(@"FPRedPacketHomeViewController")]) {
                [self.navigationController popToViewController:temp animated:NO];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark UITableViewRefreshDelegate
- (void)tablePullDown:(MJRefreshBaseView *)refreshView{
    [self getRedPacketWithdrawFromAppWith:@"0"];
}
- (void)tablePullUp:(MJRefreshBaseView *)refreshView{
    [self getRedPacketWithdrawFromAppWith:NSStringFromInt((int)msgIndex)];
}

#pragma mark NetWorking
- (void)getRedPacketWithdrawFromAppWith:(NSString *)start{
    if (isLoading == YES || isLoadOver == YES) {
        return;
    }
    
    isLoading = YES;
    MBProgressHUD *hud;
    if ([start isEqualToString:@"0"]) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
        [self dataLoadOver:NO];
        
    }

    [FPRedWithDrawList getRedPacketWithdrawFromAppWithMemberNo:[Config Instance].personMember.memberNo andAccountNo:@"" andLimit:Limt andStart:start andBlock:^(FPRedWithDrawList *RedWithDrawList, NSError *error) {
        if ([start isEqualToString:@"0"]) {
            [hud hide:YES];
        }
        
        isLoading = NO;
        
        if (error) {
            [self showMojiNotice:YES];
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (RedWithDrawList.result) {
                
                if (RedWithDrawList.total > 0) {
                    
                    if ([start isEqualToString:@"0"]) {
                        if (self.table.withDrawCashList) {
                            [self.table.withDrawCashList removeAllObjects];
                        }else{
                            self.table.withDrawCashList = [NSMutableArray array];
                        }
                    }
                    [self.table.withDrawCashList addObjectsFromArray:RedWithDrawList.withDrawItemList];
                }
                
                if ([RedWithDrawList.withDrawItemList count] < [Limt intValue]) {
                    isLoadOver = YES;
                    [self dataLoadOver:YES];
                    if ([start isEqualToString:@"0"]) {
                        self.table.tableFooterView.hidden = YES;
                    }
                    
                    
                }else{
                    msgIndex += [Limt integerValue];
                }
                
                [self showMojiNotice:NO];
            } else {
                isLoadOver = YES;
                [self dataLoadOver:YES];
                [self showMojiNotice:YES];
                
                if ([start isEqualToString:@"0"]) {
                    self.table.tableFooterView.hidden = YES;
                }
            }
        }
        
        [self.table reloadData];

    }];
}

#pragma mark 显示加载完成

- (void)dataLoadOver:(BOOL)over{
    self.table.tableFooterView.hidden = !over;
    [self.table setFooterHidden:over];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

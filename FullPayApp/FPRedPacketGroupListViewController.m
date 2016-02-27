//
//  FPRedPacketGroupListViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketGroupListViewController.h"
#import "FPRedPacketDetailViewController.h"

#import "FPRedPacketTable.h"
#import "FPRedPacketList.h"

#define dispatchCount(num,money) [NSString stringWithFormat:@"累计发出 %d 个红包,共 %0.2f 元",num,money]
#define receiveCount(num,money) [NSString stringWithFormat:@"累计领到 %d 个红包,共 %0.2f 元",num,money]

@interface FPRedPacketGroupListViewController ()<UITableViewRefreshDelegate>{
    BOOL isLoading;
    BOOL isLoadOver;
    int  msgTotal;
    BOOL _reloading;
    
    NSInteger msgIndex;
}

@property (nonatomic, strong) FPRedPacketTable *table;
@property (nonatomic, strong) UILabel          *titleLabel;
@end

@implementation FPRedPacketGroupListViewController

- (void)loadView{
    UIView *view            = [[UIView alloc]initWithFrame:ScreenBounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image        = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    BOOL dispatch = (_viewComeFrom == RedPacketGroupListViewFromDispatch)?YES:NO;
    
    
    _table = [[FPRedPacketTable alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh-64) style:UITableViewStylePlain andDispatch:dispatch];
    _table.isNeedPullRefresh = YES;
    _table.refreshDelegate   = self;
    [view addSubview:_table];
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    headView.backgroundColor = [UIColor clearColor];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, ScreenWidth, 10)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:11];
    _titleLabel.textColor = COLOR_STRING(@"#000000");
    NSString *title = dispatch ? dispatchCount(0, 0.00):receiveCount(0, 0.00);
    NSMutableAttributedString *attributText = [title transformNumberColorOfString:COLOR_STRING(@"#FF5B5C")];
    _titleLabel.attributedText = attributText;
    [headView addSubview:_titleLabel];
    [_table setTableHeaderView:headView];
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
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    if (_viewComeFrom == RedPacketGroupListViewFromDispatch) {
        self.title = @"发出的红包";
        [self findDistributedRedPacketWithStart:@"0"];
    }else if (_viewComeFrom == RedPacketGroupListViewFromRecevie){
        self.title = @"领到的红包";

        [self findReceivedRedPacketWithStart:@"0"];
    }
    [self.view bringSubviewToFront:defaultBackView];
}

#pragma mark UITableViewRefreshDelegate
- (void)tablePullDown:(MJRefreshBaseView *)refreshView{
    if (_viewComeFrom == RedPacketGroupListViewFromDispatch) {
        [self findDistributedRedPacketWithStart:@"0"];
    }else if(_viewComeFrom == RedPacketGroupListViewFromRecevie){
        [self findReceivedRedPacketWithStart:@"0"];
    }
    
}
- (void)tablePullUp:(MJRefreshBaseView *)refreshView{
    if (_viewComeFrom == RedPacketGroupListViewFromDispatch) {
        [self findDistributedRedPacketWithStart:NSStringFromInt((int)msgIndex)];
    }else if(_viewComeFrom == RedPacketGroupListViewFromRecevie){
        [self findReceivedRedPacketWithStart:NSStringFromInt((int)msgIndex)];
    }
}
- (void)tableView:(RTTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FPRedPacketDetailViewController *controller =[[FPRedPacketDetailViewController alloc]init];
    controller.item =self.table.redPacketList[indexPath.row];
    controller.hidesBottomBarWhenPushed = YES;
    if (_viewComeFrom == RedPacketGroupListViewFromDispatch) {
        controller.viewComeFrom = RedPacketDetailViewComeFromDispatch;
    }else if(_viewComeFrom == RedPacketGroupListViewFromRecevie){
        controller.viewComeFrom = RedPacketDetailViewComeFromReceive;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark NetWorking
- (void)findDistributedRedPacketWithStart:(NSString *)start{
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
    [FPRedPacketList getDistributedRedPacketWithMemberNo:[Config Instance].personMember.memberNo andLimit:Limt andStart:start andBlock:^(FPRedPacketList *redPacketList, NSError *error){
        
        if ([start isEqualToString:@"0"]) {
            [hud hide:YES];
        }
        
        isLoading = NO;
        
        if (error) {
            [self showMojiNotice:YES];
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (redPacketList.result) {
                
                if (redPacketList.total > 0) {
                    
                    if ([start isEqualToString:@"0"]) {
                        if (self.table.redPacketList) {
                            [self.table.redPacketList removeAllObjects];
                        }else{
                            self.table.redPacketList = [NSMutableArray array];
                        }
                    }
                    [self.table.redPacketList addObjectsFromArray:redPacketList.redPacketList];
                }
                
                if ([redPacketList.redPacketList count] < [Limt intValue]) {
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
        
        NSString *text = dispatchCount(redPacketList.totalCount, redPacketList.totalAmt/100);
        _titleLabel.attributedText = [text transformNumberColorOfString:COLOR_STRING(@"#FF5B5C")];
        
    }];


}

- (void)findReceivedRedPacketWithStart:(NSString *)start{
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
    [FPRedPacketList getReceivedRedPacketWithMemberNo:[Config Instance].personMember.memberNo andLimit:Limt andStart:start andBlock:^(FPRedPacketList *redPacketList, NSError *error){
        
        if ([start isEqualToString:@"0"]) {
            [hud hide:YES];
        }
        
        isLoading = NO;
        
        if (error) {
            [self showMojiNotice:YES];
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (redPacketList.result) {
                
                if (redPacketList.total > 0) {
                    
                    if ([start isEqualToString:@"0"]) {
                        if (self.table.redPacketList) {
                            [self.table.redPacketList removeAllObjects];
                        }else{
                            self.table.redPacketList = [NSMutableArray array];
                        }
                    }
                    [self.table.redPacketList addObjectsFromArray:redPacketList.redPacketList];
                }
                
                if ([redPacketList.redPacketList count] < [Limt intValue]) {
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
        
        NSString *text = receiveCount(redPacketList.totalCount, redPacketList.totalAmt/100);
        _titleLabel.attributedText = [text transformNumberColorOfString:COLOR_STRING(@"#FF5B5C")];
        
    }];
    
    
}

#pragma mark 显示加载完成

- (void)dataLoadOver:(BOOL)over{
    self.table.tableFooterView.hidden = !over;
    [self.table setFooterHidden:over];
}

- (void)clear
{
    msgIndex = 0;
    [self.table.redPacketList removeAllObjects];
    isLoadOver = NO;
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

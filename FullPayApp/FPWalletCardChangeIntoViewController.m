//
//  FPWalletCardChangeIntoViewController.m
//  FullPayApp
//
//  Created by 雷窑平 on 15/7/2.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardChangeIntoViewController.h"
#import "FPWalletCardListTable.h"
#import "FPWalletCardNumViewController.h"
#import "FPWalletApplyRealCardController.h"
#import "FPWalletPayPwdView.h"

@interface FPWalletCardChangeIntoViewController ()<UITableViewRefreshDelegate>
@property (nonatomic, strong) FPWalletCardListTable *table;
/*补卡AlertView*/
@property (nonatomic, strong) UIAlertView * changeCardAlertView;
/*申请实名卡AlertView*/
@property (nonatomic, strong) UIAlertView * realCardAlertView;
@end

/*****************************************
 *
 * 选择转入卡页面
 *
 *****************************************/

@implementation FPWalletCardChangeIntoViewController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = COLOR_STRING(@"EDF1F2");
    
    _table = [[FPWalletCardListTable alloc]initWithFrame:view.bounds style:UITableViewStylePlain];
    _table.refreshDelegate = self;
    [view addSubview:_table];
    
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    [self loadCardListData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad{
    self.title = @"选择转入卡";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
}

- (void)loadCardListData{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [FPWalletCardListModel findCardRelate:[Config Instance].memberNo andBlock:^(FPWalletCardListModel *cardListModel, NSError *error) {
        [hud hide:YES];
        
        NSMutableArray * listAry = [NSMutableArray array];
        for (NSInteger i = 0; i < cardListModel.carList.count; i ++) {
            // 判断符合转入的卡片
            WalletCardListItem * item = cardListModel.carList[i];
            for (NSInteger j = 0; j < self.changeCardAry.count; j ++) {
                if ([item.cardNo isEqualToString:self.changeCardAry[j]]) {
                    [listAry addObject:item];
                }
            }
        }
        
        _table.cardList = listAry;
        
        if(_table.cardList == nil || _table.cardList.count == 0){
           // 去申请实名卡页面
            _realCardAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有绑定其他的实名卡，无法完成余额转移。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去申请实名卡", nil];
            [_realCardAlertView show];
        }else{
        
            [_table reloadData];
        }
    }];
}

#pragma mark UITableViewRefreshDelegate
- (void)tableView:(RTTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletCardListItem *item = _table.cardList[indexPath.row];
    
    FPWalletPayPwdView * payView = [[FPWalletPayPwdView alloc]initWithchangeCardTypeandandmoney:self.money CardNo:item.cardNo Completion:^(BOOL cancelled, NSString * password) {
        if (!cancelled) {
            // 表示点击了确认
            // 开始挂失
            // 检查密码是否符合规定
            
            if (password == nil || password.length == 0) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入支付密码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
            if ([password checkPayPwd] == YES) {
                NSString * changeCardNo = [_table.cardList[indexPath.row] cardNo];
                [self changeCardCardId:self.cardId andPayPwd:password andChangeCardNo:changeCardNo];
            }
        }
    } ];
    
    [self.tabBarController.view addSubview:payView];
    
}

/**
 *  开始转入金额
 *
 *  @param cardId       关联卡id
 *  @param payPwd       支付密码
 *  @param changeCardNo 转入卡号
 */
- (void)changeCardCardId:(NSString*)cardId andPayPwd:(NSString *)payPwd andChangeCardNo:(NSString *)changeCardNo{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client changeCardWithCardNo:cardId andPayPwd:payPwd andChangeCardNo:changeCardNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        if (result) {
            _changeCardAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请已提交，待审核" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [_changeCardAlertView show];
        }else{
            NSString *errorInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"补卡失败" message:errorInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];
}

#pragma mark -  AlertView的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == _realCardAlertView) {
        if (buttonIndex == 0) {
            // 表示点击了取消
            [self.navigationController popViewControllerAnimated:YES];
        }else if (buttonIndex == 1){
            // 进入实名卡申请页面
            FPWalletApplyRealCardController * controller = [[FPWalletApplyRealCardController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
    }else if (alertView == _changeCardAlertView){
        
        if (buttonIndex == 0) {
            // 补卡成功，待审核，返回上一级页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}



@end

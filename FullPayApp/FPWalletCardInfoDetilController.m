//
//  FPWalletCardInfoDetilController.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/7.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardInfoDetilController.h"
#import "FPFullWalletRechargeViewController.h"
#import "FPWalletTradeViewController.h"
#import "FPWalletCardMangerController.h"
#import "FPWalletPayPwdView.h"
#import "FPWalletCardChangeIntoViewController.h"
#import "FPWalletApplyRealCardController.h"

@interface FPWalletCardInfoDetilController()
@property (nonatomic, strong)UILabel *balance;
@property (nonatomic, strong)UILabel *balanceLabel;
@property (nonatomic, strong)UILabel *cardStatusLabel;
@property (nonatomic, strong)UIView *mangerMenu;
@property (nonatomic, strong)UIButton *rechargeButton;
@property (nonatomic, strong)UIButton *detilButton;
@property (nonatomic, strong)UIImageView *lossCardIv;

@property (nonatomic, strong)FPWalletPayPwdView *payView;
@property (nonatomic, strong)WalletCardDetilItem *cardDetil;
@end

@implementation FPWalletCardInfoDetilController
- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = COLOR_STRING(@"EDF1F2");
    self.view = view;
    
    [self createCoustomView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self loadCardDetailWithCardId:self.cardId];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad{
    self.title = @"富钱包卡";
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:SystemFontSize(12),NSFontAttributeName, nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(tapRightButton)];
    [right setTitleTextAttributes:attribute forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
}

- (void)createCoustomView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3*ScreenWidth/4/2, 30, ScreenWidth/4, ScreenWidth/4)];
    imageView.backgroundColor = ClearColor;
    imageView.image = MIMAGE(@"WalletCard_Detil_Blance");
    [self.view addSubview:imageView];
    
    _lossCardIv = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.left+5,imageView.top,imageView.width-10,imageView.height/2)];
    _lossCardIv.image = MIMAGE(@"lossCard");
    _lossCardIv.hidden = YES;
    [self.view addSubview:_lossCardIv];
    
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom+10, ScreenWidth, 10)];
    _balanceLabel.backgroundColor = ClearColor;
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    _balanceLabel.font = SystemFontSize(10);
    _balanceLabel.text = @"卡内余额";
    _balanceLabel.textColor = COLOR_STRING(@"#808080");
    [self.view addSubview:_balanceLabel];
    
    _balance = [[UILabel alloc]initWithFrame:CGRectMake(0, _balanceLabel.bottom+10, ScreenWidth, 20)];
    _balance.backgroundColor = ClearColor;
    _balance.textAlignment = NSTextAlignmentCenter;
    _balance.font = SystemFontSize(18);
    _balance.text = @"￥ 0.00";
    //balance.text = [NSString stringWithFormat:@"￥ %@",[NSString simpMoney:_cardItem.balance]];
    [self.view addSubview:_balance];
    
    _cardStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _balance.bottom, ScreenWidth, 20)];
    _cardStatusLabel.backgroundColor = ClearColor;
    _cardStatusLabel.textAlignment = NSTextAlignmentCenter;
    _cardStatusLabel.font = SystemFontSize(12);
    _cardStatusLabel.hidden = YES;
    [self.view addSubview:_cardStatusLabel];
    
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeButton.frame = CGRectMake(50, _balance.bottom+25, ScreenWidth-100, 35);
    _rechargeButton.backgroundColor = COLOR_STRING(@"#50C343");
    [_rechargeButton setTitle:@"我要充值" forState:UIControlStateNormal];
    [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rechargeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [_rechargeButton addTarget:self action:@selector(clickRechargeButton) forControlEvents:UIControlEventTouchUpInside];
    _rechargeButton.titleLabel.font = SystemFontSize(14);
    [self.view addSubview:_rechargeButton];
    
    _rechargeButton.layer.masksToBounds = YES;
    _rechargeButton.layer.cornerRadius = 17.5;
    
    _detilButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _detilButton.frame = CGRectMake(50, _rechargeButton.bottom+15, ScreenWidth-100, 35);
    _detilButton.backgroundColor = ClearColor;
    [_detilButton setTitle:@"收支明细" forState:UIControlStateNormal];
    [_detilButton setTitleColor:COLOR_STRING(@"#808080") forState:UIControlStateNormal];
    [_detilButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [_detilButton addTarget:self action:@selector(clickdetilButton) forControlEvents:UIControlEventTouchUpInside];
    _detilButton.titleLabel.font = SystemFontSize(14);
    
    _detilButton.layer.masksToBounds = YES;
    _detilButton.layer.cornerRadius = 17.5;
    _detilButton.layer.borderColor = COLOR_STRING(@"#000000").CGColor;
    _detilButton.layer.borderWidth = 0.5;
    
    [self.view addSubview:_detilButton];
    
    [self createMangerView];


}

#pragma mark Networking
- (void)loadCardDetailWithCardId:(NSString *)cardId{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findCardRelateDetailWithCardNo:cardId];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        WalletCardDetilItem *temp = [[WalletCardDetilItem alloc]init];
        if (result) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            temp = [WalletCardDetilItem objectWithKeyValues:returnObj];
            temp.cardId = [returnObj objectForKey:@"id"];

            self.cardDetil = temp;
            self.balance.text = [NSString stringWithFormat:@"￥ %@",[NSString simpMoney:temp.balance]];
            self.balanceLabel.text = [NSString stringWithFormat:@"卡内余额(%@)",temp.time];
            if (temp.lossStatus == 0) {
                // 正常状态
                _cardStatusLabel.hidden = YES;
                
                _rechargeButton.hidden = NO;
                _detilButton.top = _rechargeButton.bottom+15;
                _lossCardIv.hidden = YES;
                
            }else if (temp.lossStatus == 1) {
                // 挂失处理中
                _cardStatusLabel.hidden = NO;
                _cardStatusLabel.text = temp.statusName;
                
                _rechargeButton.hidden = YES;
                _detilButton.top = _rechargeButton.top;
                _lossCardIv.hidden = YES;
                
            }else if (temp.lossStatus == 2){
                // 挂失成功
                _cardStatusLabel.hidden = NO;
                _cardStatusLabel.text = temp.statusName;
                
                _rechargeButton.hidden = YES;
                _detilButton.top = _rechargeButton.top;
                _lossCardIv.hidden = NO;
                
            }else if (temp.lossStatus == 3){
                // 解挂处理中
                _cardStatusLabel.hidden = NO;
                _cardStatusLabel.text = temp.statusName;
                
                _rechargeButton.hidden = YES;
                _detilButton.top = _rechargeButton.top;
                _lossCardIv.hidden = YES;
            }
            
            // 根据卡状态判断可以点击那些按钮
            [self canClickButtonWithLossStatus:temp.lossStatus ChangeStatus:temp.changeStatus];
            
        }else{
            NSString *errorInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:errorInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请求失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];

    }];
}

-(void)lossCardWithCardId:(NSString*)cardId andPayPwd:(NSString *)payPwd{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client lossCardWithCardNo:cardId andPayPwd:payPwd];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        if (result) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"挂失成功！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            
            [self loadCardDetailWithCardId:self.cardId];
            
            [alert show];
        }else{
            NSString *errorInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"挂失失败" message:errorInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];

}

-(void)removeLossCardWithCardId:(NSString*)cardId andPayPwd:(NSString *)payPwd{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client removeLossCardWithCardNo:cardId andPayPwd:payPwd];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        if (result) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"解挂成功！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            
            [self loadCardDetailWithCardId:self.cardId];
            
            [alert show];
        }else{
            NSString *errorInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"解挂失败" message:errorInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];

}

-(void)unBindWithCardId:(NSString*)cardId andPayPwd:(NSString *)payPwd{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client unBindCardWithCardNo:cardId andPayPwd:payPwd];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        if (result) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"解绑成功！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            
            [self loadCardDetailWithCardId:self.cardId];
            
            [alert show];
        }else{
            NSString *errorInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"解绑失败" message:errorInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];
    
}

/**
 *  查询会员可转入余额的实名卡卡号列表
 *
 *  @param changeMemberNo 补卡卡号
 */
- (void)findCanChangeCard:(NSString *)changeMemberNo
{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findCanChangeCardWithMemberNo:changeMemberNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        if (result) {
            NSArray * results = [responseObject objectForKey:@"returnObj"];
            
            [self pushNextViewController:results];
            
        }else{
            NSString *errorInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"补卡失败" message:errorInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];
}

/**
 *  根据传进来的数组判断进入哪一个下级页面
 *
 *  @param results 装实名卡号的数组
 */
- (void)pushNextViewController:(NSArray *)results
{
    // 开始进入转账页面
    FPWalletCardChangeIntoViewController * controller = [[FPWalletCardChangeIntoViewController alloc] init];
    controller.cardDetilItem = self.cardDetil;
    controller.changeCardAry = results;
    controller.money = self.cardDetil.balance;
    controller.cardId = self.cardId;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark event respons
- (void)tapRightButton{
    if (self.cardDetil.realFlag) {
        // 表示是实名卡
        [UIView animateWithDuration:0.3 animations:^{
            _mangerMenu.transform = CGAffineTransformMakeTranslation(0, _mangerMenu.height+1);
        }];
        
        //[self lossCardWithCardId:self.cardId andPayPwd:@"888888"];
        //[self removeLossCardWithCardId:self.cardId andPayPwd:@"888888"];
    }else{
    
        FPWalletCardMangerController *controller = [[FPWalletCardMangerController alloc]init];
         controller.cardItem = self.cardDetil;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)clickRechargeButton{
    FPFullWalletRechargeViewController *controller = [[FPFullWalletRechargeViewController alloc]init];
    controller.cardNo = self.cardDetil.cardNo;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickdetilButton{
    FPWalletTradeViewController *walletView = [[FPWalletTradeViewController alloc]init];
    walletView.cardItem = self.cardDetil;
    [self.navigationController pushViewController:walletView animated:YES];
}

- (void)tapTheMenuButton:(UIButton *)button{
    switch (button.tag) {
        case 100:
        {
            _payView = [[FPWalletPayPwdView alloc] initWithUnbingCardTypeandCompletion:^(BOOL cancelled, NSString *password) {
                if (!cancelled) {
                    // 表示点击了确认
                    // 开始解绑
                    // 检查密码是否符合规定
                    
                    if (password == nil || password.length == 0) {
                        [self showAlert:nil andMessage:@"请输入支付密码"];
                    }else if ([password checkPayPwd] == YES) {
                        [self unBindWithCardId:self.cardId andPayPwd:password];
                    }
                }
            }];
            
            [self.tabBarController.view addSubview:_payView];
        
        }
            break;
        case 101:
        {
            
            // 首先跳出提示框
            FPWalletPayPwdView * payPWdView = [[FPWalletPayPwdView alloc] initWithLossCardTypeMessageandCompletion:^(BOOL cancelled, NSString *password) {
                if (!cancelled) {
                    _payView = [[FPWalletPayPwdView alloc]initWithLossCardTypeandCompletion:^(BOOL cancelled, NSString * password) {
                        if (!cancelled) {
                            // 表示点击了确认
                            // 开始挂失
                            // 检查密码是否符合规定
                            if (password == nil || password.length == 0) {
                                [self showAlert:nil andMessage:@"请输入支付密码"];
                            }else if ([password checkPayPwd] == YES) {
                                [self lossCardWithCardId:self.cardId andPayPwd:password];
                            }
                        }
                    } ];
                    
                    [self.tabBarController.view addSubview:_payView];
                    
                }
            }];
            
            [self.tabBarController.view addSubview:payPWdView];
            
        }
            break;
        case 102:
        {
            _payView = [[FPWalletPayPwdView alloc] initWithRemoveLossCardTypeandCompletion:^(BOOL cancelled, NSString *password) {
                if (!cancelled) {
                    // 表示点击了确认
                    // 开始解挂
                    // 检查密码是否符合规定
                    if (password == nil || password.length == 0) {
                        [self showAlert:nil andMessage:@"请输入支付密码"];
                    }else if ([password checkPayPwd]) {
                        [self removeLossCardWithCardId:self.cardId andPayPwd:password];
                    }
                }
            }];
            
            [self.tabBarController.view addSubview:_payView];
        }
            break;
        case 103:
        {
            _payView = [[FPWalletPayPwdView alloc] initWithchangeCardTypeandandmoney:self.cardDetil.balance Completion:^(BOOL cancelled,NSString *password){
                if (!cancelled) {
                    // 表示点击了确认
                    // 开始补卡，先查询有没有可转移的实名卡，如果有，跳到转入实名卡页面，否则，跳到申请实名卡页面
                    [self findCanChangeCard:[Config Instance].memberNo];
                    
                }
            }];
            
            [self.tabBarController.view addSubview:_payView];
        }
            break;
            
        default:
            break;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        _mangerMenu.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark create view

- (void)createMangerView{
    NSArray *array = @[@"解绑",@"挂失",@"解挂",@"补卡"];
    NSArray *imageDisabledArray = @[@"unbing_btn_disabled",@"losscard_btn_disabled",@"removeloss_btn_disabled",@"changecard_btn_disabled"];
    NSArray *imageNormalArray = @[@"unbing_btn_normal",@"losscard_btn_normal",@"removeloss_btn_normal",@"changecard_btn_normal"];
    _mangerMenu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 0)];
    _mangerMenu.backgroundColor = ClearColor;
    
    
    for (int i=0; i<array.count; i++) {
        UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
        temp.frame = CGRectMake(10, 26*i,90, 25);
        [temp setTitle:array[i] forState:UIControlStateNormal];
        [temp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [temp setTitleColor:COLOR_STRING(@"#C2C2C2") forState:UIControlStateDisabled];
        [temp setTitleColor:COLOR_STRING(@"#C2C2C2") forState:UIControlStateHighlighted];
        [temp setImage:MIMAGE(imageDisabledArray[i]) forState:UIControlStateDisabled];
        [temp setImage:MIMAGE(imageNormalArray[i]) forState:UIControlStateNormal];
        [temp setImageEdgeInsets:UIEdgeInsetsMake(2, 10, 3, 65)];
        [temp setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        
        temp.titleLabel.font = SystemFontSize(12);
        [temp setBackgroundColor:COLOR_STRING(@"#2C2C2C")];
        
        temp.tag = 100+i;
        
        [temp addTarget:self action:@selector(tapTheMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mangerMenu addSubview:temp];
        _mangerMenu.height = temp.bottom;
    }
    
    _mangerMenu.right = ScreenWidth;
    _mangerMenu.top = -_mangerMenu.height;
    [self.view addSubview:_mangerMenu];
}



- (void)canClickButtonWithLossStatus:(NSInteger)lossStatus ChangeStatus:(NSString *)changeStatus
{
    UIButton * unBindBtn = (id)[_mangerMenu viewWithTag:100];
    UIButton * lossCardBtn = (id)[_mangerMenu viewWithTag:101];
    UIButton * RemoveLossCardBtn = (id)[_mangerMenu viewWithTag:102];
    UIButton * changeCardBtn = (id)[_mangerMenu viewWithTag:103];
    
    if (lossStatus == 0) {
        unBindBtn.enabled = YES;
        lossCardBtn.enabled = YES;
        RemoveLossCardBtn.enabled = NO;
        changeCardBtn.enabled = NO;
    }else if (lossStatus == 1){
        unBindBtn.enabled = NO;
        lossCardBtn.enabled = NO;
        RemoveLossCardBtn.enabled = YES;
        changeCardBtn.enabled = NO;
    }else if (lossStatus == 2){
        unBindBtn.enabled = NO;
        lossCardBtn.enabled = NO;
        
        RemoveLossCardBtn.enabled = YES;
        changeCardBtn.enabled = NO;
    }else if (lossStatus == 3){
        unBindBtn.enabled = NO;
        lossCardBtn.enabled = YES;
        RemoveLossCardBtn.enabled = NO;
        changeCardBtn.enabled = NO;
    }
    
    if(lossStatus == 2 && (changeStatus.length == 0 || changeStatus == nil)){
        unBindBtn.enabled = NO;
        lossCardBtn.enabled = NO;
        RemoveLossCardBtn.enabled = YES;
        changeCardBtn.enabled = YES;
    }else if (lossStatus == 2 && changeStatus.length != 0){
        unBindBtn.enabled = NO;
        lossCardBtn.enabled = NO;
        RemoveLossCardBtn.enabled = NO;
        changeCardBtn.enabled = NO;
        
        _lossCardIv.hidden = YES;
    }
}

-(void)showAlert:(NSString*)title andMessage:(NSString *)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    [alert show];
}

@end

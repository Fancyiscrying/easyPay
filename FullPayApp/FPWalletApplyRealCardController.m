//
//  FPWalletApplyRealCardController.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/9.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletApplyRealCardController.h"
#import "TimeLineCellView.h"
#import "FPWalletApplyCardList.h"
#import "FPWalletCardListViewController.h"

@interface FPWalletApplyRealCardController()<UIAlertViewDelegate>
@property (nonatomic, strong)UILabel *applyNum;
@property (nonatomic, strong)UILabel *getNum;
@property (nonatomic, strong)UIScrollView *scroll;
@end

@implementation FPWalletApplyRealCardController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = COLOR_STRING(@"EDF1F2");
    self.view = view;
    
    [self createCoustomView];
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
    self.title = @"实名卡申请";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
    [self loadApplyList];
    
}


- (void)createCoustomView{
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh)];
    _scroll.backgroundColor = ClearColor;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((ScreenWidth - 80)/2, 10, 80, 80);
    [button setBackgroundImage:MIMAGE(@"WalletCard_apply_realCard") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapTheApplyBtn) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:button];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, (ScreenWidth - 80)/2, 20)];
    label1.backgroundColor = ClearColor;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = COLOR_STRING(@"#333132");
    label1.font = SystemFontSize(16);
    label1.text = @"申请成功";
    [_scroll addSubview:label1];
    
    _applyNum = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.bottom+5, (ScreenWidth - 80)/2, 20)];
    _applyNum.backgroundColor = ClearColor;
    _applyNum.textAlignment = NSTextAlignmentCenter;

    _applyNum.textColor = COLOR_STRING(@"#333132");
    _applyNum.font = SystemFontSize(16);
    _applyNum.text = @"0张";
    [_scroll addSubview:_applyNum];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(button.right, 35, (ScreenWidth - 80)/2, 20)];
    label2.backgroundColor = ClearColor;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = COLOR_STRING(@"#333132");
    label2.font = SystemFontSize(16);
    label2.text = @"已领取";
    [_scroll addSubview:label2];
    
    _getNum = [[UILabel alloc]initWithFrame:CGRectMake(button.right, label1.bottom+5, (ScreenWidth - 80)/2, 20)];
    _getNum.backgroundColor = ClearColor;
    _getNum.textAlignment = NSTextAlignmentCenter;
    
    _getNum.textColor = COLOR_STRING(@"#333132");
    _getNum.font = SystemFontSize(16);
    _getNum.text = @"3张";
    [_scroll addSubview:_getNum];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-2)/2, button.bottom, 2, 20)];
    line.backgroundColor = COLOR_STRING(@"#FFFFFF");
    [_scroll addSubview:line];
    
    [self.view addSubview:_scroll];
}

- (void)loadApplyList{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [FPWalletApplyCardList getCardApplyWithMemberNo:[Config Instance].memberNo andBlock:^(FPWalletApplyCardList *applyCardList, NSError *error) {
        [hud hide:YES];
        if (applyCardList.result) {
            [self createTimeLine:110 andData:applyCardList.applyList];
            _applyNum.text = [NSString stringWithFormat:@"%@张",applyCardList.totalItem.applyCount];
            _getNum.text = [NSString stringWithFormat:@"%@张",applyCardList.totalItem.drawCount];

        }
    }];
}

- (void)tapTheApplyBtn{
    
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要申请一张实名卡吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alter.tag = 101;
    [alter show];
}

- (void)createTimeLine:(float)top andData:(NSArray *)data{
    if (data.count > 0) {
        float bottom = top;
        for (int i=0; i<data.count; i++) {
            BOOL left = (i%2 == 0)? YES  : NO;
            ApplyItem *item = data[i];
            
            TimeLineCellView *temp = [[TimeLineCellView alloc]initWithFrame:CGRectMake(0, top+70*i, ScreenWidth, 70) andApplyCardInfo:item atTheLeft:left];
            [_scroll addSubview:temp];
            
            bottom = temp.bottom;
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-2)/2, bottom, 2, 20)];
        line.backgroundColor = COLOR_STRING(@"#FFFFFF");
        [_scroll addSubview:line];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, line.bottom, 10, 10)];
        image.image = MIMAGE(@"WalletCard_apply_point");
        [_scroll addSubview:image];
        
        [_scroll setContentSize:CGSizeMake(ScreenWidth,image.bottom+20)];
    }
}

- (void)applyCard{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client applyCardWithMemberNo:[Config Instance].memberNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        
        if (result) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"申请成功" message:@"有效期为七天,请尽快领取！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 102;
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"申请失败" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alter show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];

}

#pragma  mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 1) {
        [self applyCard];
    }
    if (alertView.tag == 102) {
        [self.navigationController popViewControllerAnimated:YES];
        
        
        for (FPWalletCardListViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[FPWalletCardListViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        
    }
}



@end

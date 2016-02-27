//
//  FPWalletCardMangerController.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/11.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardMangerController.h"

@interface FPWalletCardMangerController()
@property (nonatomic, strong)UIButton *loseBtn;
@end

@implementation FPWalletCardMangerController
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
    self.title = @"卡管理";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
}


- (void)createCoustomView{
    UIView *cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *cardImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    cardImage.backgroundColor = ClearColor;

    [cell addSubview:cardImage];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardImage.right+8, 5, cell.width-cardImage.right, 20)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.font = [UIFont boldSystemFontOfSize:14];
    topLabel.textColor = COLOR_STRING(@"#4D4D4D");
    [cell addSubview:topLabel];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(topLabel.left, topLabel.bottom, topLabel.width, 20)];
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.font = [UIFont systemFontOfSize:10];
    bottomLabel.textColor = COLOR_STRING(@"#808080");
    bottomLabel.tag = 103;
    [cell addSubview:bottomLabel];
    
    if (_cardItem.realFlag) {
        /**
         *  实名卡管理流程已经更改 2015-06-22
         *
         */
        cardImage.image = MIMAGE(@"WalletCard_list_realCard");
        
        topLabel.text = @"卡片挂失";
        bottomLabel.text = [NSString stringWithFormat:@"挂失后,需%@个工作日才能生效",[Config Instance].appParams.offlineLossEffectiveTime];
    
        _loseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loseBtn.frame = CGRectMake(cell.width-40, 12.5, 25, 25);
        [_loseBtn setImage:MIMAGE(@"WalletCard_cardManger_loseBtn_nomal") forState:UIControlStateNormal];
        [_loseBtn setImage:MIMAGE(@"WalletCard_cardManger_loseBtn_select") forState:UIControlStateSelected];
        [_loseBtn addTarget:self action:@selector(tapTheLoseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_loseBtn];

//        if ([_cardItem.cardStatus isEqualToString:@"NORMAL"]) {
//            _loseBtn.selected = NO;
//        }else{
//            _loseBtn.selected = YES;
//        }

    }else{
        cardImage.image = MIMAGE(@"WalletCard_list_unrealCard");

        topLabel.text = @"删除钱包卡";
        bottomLabel.text = @"删除后,可以通过重新添加卡恢复";

        UIImageView *accsView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.width-30, 15, 20, 20)];
        accsView.image = MIMAGE(@"WalletCard_list_access");
        [cell addSubview:accsView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheCellToDelete)];
        [cell addGestureRecognizer:tap];
    }
    
    [self.view addSubview:cell];
}

- (void)tapTheCellToDelete{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"警告" message:@"确定要删除卡片信息么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alter.tag = 101;
    [alter show];
}


/*
- (void)tapTheLoseBtn:(UIButton *)button{
    
    if (button.isSelected) {
        [self cancleLostCard];
    }else{
        [self lostCard];
    }
}
*/
/*
- (void)lostCard{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client lossCardWithCardNo:_cardItem.cardNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        
        if (result) {
            
            //切换勾选状态
            _loseBtn.selected = YES;
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"挂失成功" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alter show];
            
        }else{
            //切换勾选状态
            _loseBtn.selected = NO;
            
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"挂失失败" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alter show];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];

    }];
}
*/

/*
- (void)cancleLostCard{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client removeLossCardWithCardNo:_cardItem.cardNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        
        if (result) {
            
            //切换勾选状态
            _loseBtn.selected = NO;
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"取消挂失成功" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alter show];
            
        }else{
            
            //切换勾选状态
            _loseBtn.selected = YES;
            
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"取消挂失失败" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alter show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];

    }];
}
*/
- (void)deleteTheCard{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client deleteCardRelateWithCardId:_cardItem.cardId];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        
        if (result) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"删除成功" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 102;
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"删除失败" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alter show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];

}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 1) {
        [self deleteTheCard];
    }
    
    if (alertView.tag == 102) {
        NSArray *conts = self.navigationController.viewControllers;
        if (conts.count >=2 ) {
            [self.navigationController popToViewController:conts[1] animated:YES];
        }
    }
}
@end

//
//  FPRedPacketWithDrawCashViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/9.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketWithDrawCashViewController.h"
#import "FPRedPacketWithDrawListViewController.h"

#import "FPTextField.h"

@interface FPRedPacketWithDrawCashViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) FPTextField *blanceField;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UILabel *blance;
@end

@implementation FPRedPacketWithDrawCashViewController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    self.view = view;
    
    [self installCoustomView];
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
    self.title = @"申请提现";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(tabRightButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    // Do any additional setup after loading the view.
}

- (void)installCoustomView{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHigh-64)];
    backImage.backgroundColor = COLOR_STRING(@"#4F4F4F");
    backImage.image = [UIImage imageNamed:@"redPacket_withdraw_image"];
    backImage.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(45, 40, ScreenWidth, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = COLOR_STRING(@"#808080");
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = @"可提现金额";
    label.textAlignment = NSTextAlignmentLeft;
    [backImage addSubview:label];
    
    _blance = [[UILabel alloc]initWithFrame:CGRectMake(0, label.bottom+20, ScreenWidth, 30)];
    _blance.backgroundColor = [UIColor clearColor];
    _blance.textColor = COLOR_STRING(@"#FF5B5C");
    _blance.font = [UIFont boldSystemFontOfSize:30];
    _blance.text =[NSString stringWithFormat:@"%0.2f 元",self.redPackteInfo.accountBalance/100];
    _blance.textAlignment = NSTextAlignmentCenter;
    [backImage addSubview:_blance];
    
//    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label.left, blance.bottom+10, ScreenWidth, 20)];
//    label2.backgroundColor = [UIColor clearColor];
//    label2.textColor = COLOR_STRING(@"#CCCCCC");
//    label2.font = [UIFont systemFontOfSize:18];
//    label2.text = @"输入提现金额";
//    label2.textAlignment = NSTextAlignmentLeft;
//    [backImage addSubview:label2];
//    
//    _blanceField = [[FPTextField alloc] initWithNoRectOffsetFrame:CGRectMake(label.left, label2.bottom+5, ScreenWidth-(2*label.left), 40)];
//    _blanceField.textAlignment = NSTextAlignmentLeft;
//    _blanceField.font = [UIFont systemFontOfSize:16];
//    _blanceField.backgroundColor = COLOR_STRING(@"#F2F6F7");
//    _blanceField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _blanceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _blanceField.keyboardType = UIKeyboardTypeDecimalPad;
//    _blanceField.delegate = self;
//    _blanceField.layer.masksToBounds = YES;
//    _blanceField.layer.cornerRadius = 5;
//    [backImage addSubview:_blanceField];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(label.left, _blance.bottom+10, ScreenWidth, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = COLOR_STRING(@"#CCCCCC");
    label3.font = [UIFont boldSystemFontOfSize:18];
    label3.text = @"提现方式";
    label3.textAlignment = NSTextAlignmentLeft;
    [backImage addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(label.left, label3.bottom+15, ScreenWidth-(2*label.left), 40)];
    label4.backgroundColor =  COLOR_STRING(@"#F2F6F7");
    label4.textColor = COLOR_STRING(@"#808080");
    label4.font = [UIFont systemFontOfSize:18];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.layer.masksToBounds = YES;
    label4.layer.cornerRadius = 5;
    [backImage addSubview:label4];
    
    NSString *text = @"  提现到 富之富 账户";
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = [text rangeOfString:@"富之富"];
    [attText setAttributes:@{NSForegroundColorAttributeName :
                                 COLOR_STRING(@"#FF5B5C")} range:range];
    
    label4.attributedText = attText;
    
    UIImageView *imageAcss = [[UIImageView alloc]initWithFrame:CGRectMake(label4.width-30, 10, 20, 20)];
    imageAcss.image = MIMAGE(@"redPacket_withdraw_acss");
    [label4 addSubview:imageAcss];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(label.left, label4.bottom+30, ScreenWidth-(2*label.left), 40);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_sureButton addTarget:self action:@selector(tapSureButtonPay) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 5;
    [backImage addSubview:_sureButton];
    
    if (self.redPackteInfo.accountBalance <= 0) {
        _sureButton.backgroundColor = [UIColor grayColor];
        _sureButton.enabled = NO;
    }else{
        _sureButton.backgroundColor = COLOR_STRING(@"#FEDB69");
        _sureButton.enabled = YES;
    }
    
    [self.view addSubview:backImage];
}

- (void)tapSureButtonPay{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramter = [client withdrawWithAccountNo:_redPackteInfo.accountNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];

    [client POST:kFPPost parameters:paramter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"申请提现成功!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 102;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"申请提现失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];

    }];
}

- (void)tabRightButton{
    FPRedPacketWithDrawListViewController *controller = [[FPRedPacketWithDrawListViewController alloc]init];
    controller.hasWithDrawSucceed = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 102) {
        _blance.text =[NSString stringWithFormat:@"%0.2f 元",0.00];
        _sureButton.enabled = NO;
        _sureButton.backgroundColor = [UIColor grayColor];
        
        FPRedPacketWithDrawListViewController *controller = [[FPRedPacketWithDrawListViewController alloc]init];
        controller.hasWithDrawSucceed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    float bottom = _blanceField.bottom;
    float temp = ScreenHigh - bottom-64-40;
    if (temp-216 < 0) {
        [self setFieldViewTranfromWithY:temp-216];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self setFieldViewTranfromWithY:0];

}

- (void)setFieldViewTranfromWithY:(CGFloat)Y{
    CGAffineTransform transFormY = CGAffineTransformMakeTranslation(0, Y);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = transFormY;
    }];
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

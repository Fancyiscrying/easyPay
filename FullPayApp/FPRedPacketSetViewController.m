//
//  FPRedPacketSetViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRedPacketSetViewController.h"

#define TOP_LABEL @"总数  %@  个,每个  %0.2f  元,总计金额  %0.2f  元"
#define BOTTOM_LABEL @"剩余红包  %@  (个)  剩余金额  %0.2f  (元)"

@interface FPRedPacketSetViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong)UILabel *originalLabel;
@property (nonatomic, strong)UILabel *nowLabel;
@property (nonatomic, strong)UIButton *stopButton;
@end

@implementation FPRedPacketSetViewController

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
    self.title = @"红包设置";
    // Do any additional setup after loading the view.
}

- (void)installCoustomView{
    
    _originalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 20)];
    _originalLabel.backgroundColor = [UIColor clearColor];
    _originalLabel.textAlignment = NSTextAlignmentCenter;
    _originalLabel.font = [UIFont systemFontOfSize:14];
    _originalLabel.textColor = COLOR_STRING(@"#333333");
    if (_redPackteItem == nil) {
        NSString *str = [NSString stringWithFormat:TOP_LABEL,@"0",0.00,0.00];
        _originalLabel.attributedText = [str transformNumberColorOfString:nil];
    }else{
        NSString *str = [NSString stringWithFormat:TOP_LABEL,_redPackteItem.totalCount,_redPackteItem.amt,_redPackteItem.totalAmt];
        _originalLabel.attributedText = [str transformNumberColorOfString:nil];
    }
    
    [self.view addSubview:_originalLabel];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, _originalLabel.bottom+10, ScreenWidth-10, 80)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 47, 47)];
    image.backgroundColor = [UIColor whiteColor];
    image.image = MIMAGE(@"redPacket_set_packet_image");
    [view addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(image.right+20, image.top+10, ScreenWidth, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"当前我的红包信息";
    label.textColor = COLOR_STRING(@"#B2B2B2");
    [view addSubview:label];

    _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopButton.frame = CGRectMake(view.width-70,label.top , 60, 25);
    [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_stopButton setTitle:@"终止派发" forState:UIControlStateNormal];
    _stopButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    _stopButton.backgroundColor = _redPackteItem ==nil ?COLOR_STRING(@"#B2B2B2"): COLOR_STRING(@"#FF5B5C");
    _stopButton.enabled = _redPackteItem == nil ? NO : YES;

    [_stopButton addTarget:self action:@selector(tapButtonStop) forControlEvents:UIControlEventTouchUpInside];
    _stopButton.layer.masksToBounds = YES;
    _stopButton.layer.cornerRadius = 3;
    [view addSubview:_stopButton];
    
    _nowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom+5, ScreenWidth, 20)];
    _nowLabel.backgroundColor = [UIColor clearColor];
    _nowLabel.textAlignment = NSTextAlignmentCenter;
    _nowLabel.font = [UIFont systemFontOfSize:16];
    
    if (_redPackteItem == nil) {
        NSString *str = [NSString stringWithFormat:BOTTOM_LABEL,@"0",0.00];
        _nowLabel.attributedText = [str transformNumberColorOfString:nil];
    }else{
        NSString *str = [NSString stringWithFormat:BOTTOM_LABEL,_redPackteItem.surplusCount,_redPackteItem.surplusAmt];
        _nowLabel.attributedText = [str transformNumberColorOfString:nil];
    }
    [view addSubview:_nowLabel];
    
    [self.view addSubview:view];
    
    
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(5, view.bottom+20, ScreenWidth-10, 50)];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 5;
    alertView.layer.borderColor = COLOR_STRING(@"#82CCFB").CGColor;
    alertView.layer.borderWidth = 0.5;
    
    UILabel *alert = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, alertView.width-20, 40)];
    alert.backgroundColor = [UIColor clearColor];
    alert.text = @"选择“终止派发”,剩余的红包将被禁止派发,资金会转移到您的可提账户内。";
    alert.font = [UIFont systemFontOfSize:11];
    alert.textColor = [UIColor grayColor];
    alert.numberOfLines = 2;
    [alertView addSubview:alert];
    
    [self.view addSubview:alertView];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    background.center = CGPointMake(ScreenWidth/2, alertView.top);
    background.image = [UIImage imageNamed:@"BG"];
    [self.view addSubview:background];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    title.center = CGPointMake(ScreenWidth/2, alertView.top);
    title.backgroundColor = [UIColor clearColor];
    title.text = @"提示";
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor grayColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)tapButtonStop{
    [self stopDistribute];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark NetWorking

- (void)stopDistribute{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters8 = [client stopDistributeWithDistributeId:_redPackteItem.redPackteId];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters8 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"终止成功!" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 101;
            [alter show];
            _stopButton.backgroundColor = [UIColor grayColor];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"终止失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showToastMessage:kNetworkErrorMessage];

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

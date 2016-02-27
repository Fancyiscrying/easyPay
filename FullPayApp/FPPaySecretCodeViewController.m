//
//  FPPaySecretCodeViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/15.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPPaySecretCodeViewController.h"
#import "ProgressView.h"

@interface FPPaySecretCodeViewController()
@property (nonatomic, strong)UILabel *payCode;
@property (nonatomic, strong)ProgressView *progressView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *payTip;
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)int totalTime;
@property (nonatomic, assign)int timeLeft;

@property (nonatomic, assign)BOOL tapValue;
@property (nonatomic, assign)BOOL needRefresh;

@end

@implementation FPPaySecretCodeViewController
- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = COLOR_STRING(@"EDF1F2");
    self.view = view;
    
    [self createCoustomView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appEnterForeGround) name:@"PaySecretEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appEnterBackGround) name:@"PaySecretEnterBackground" object:nil];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PaySecretEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PaySecretEnterBackground" object:nil];

    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad{
    self.title = @"手机宝令";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
    _timeLeft = 0;
    _tapValue = NO;
    _needRefresh = YES;
    [self getPayCode];
    
}


- (void)createCoustomView{
    _payCode = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 50)];
    _payCode.backgroundColor = ClearColor;
    _payCode.textColor = COLOR_STRING(@"#73B0F9");
    _payCode.font = SystemBoldFontSize(40);
    _payCode.textAlignment = NSTextAlignmentCenter;
   // _payCode.text = @"1 2 3 4 5 6";
    [self.view addSubview:_payCode];
    
    _payTip = [[UILabel alloc]initWithFrame:CGRectMake(0, _payCode.bottom+30, ScreenWidth, 20)];
    _payTip.backgroundColor = ClearColor;
    _payTip.textColor = COLOR_STRING(@"#909090");
    _payTip.font = SystemFontSize(16);
    _payTip.textAlignment = NSTextAlignmentCenter;
    _payTip.text = @"手机宝令 60 秒更新一次";
    [self.view addSubview:_payTip];
    
    _progressView = [[ProgressView alloc]initWithFrame:CGRectMake(ScreenWidth/4, _payTip.bottom+20, ScreenWidth/2, 2*ScreenWidth/3)];
    _progressView.arcUnfinishColor = COLOR_STRING(@"#73B0F9");
    _progressView.arcFinishColor = COLOR_STRING(@"#73B0F9");
    _progressView.arcBackColor = COLOR_STRING(@"#DDDDDD");
    _progressView.percent = 1;
    [self.view addSubview:_progressView];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
    _timeLabel.center = _progressView.center;
    _timeLabel.backgroundColor = ClearColor;
    _timeLabel.textColor = COLOR_STRING(@"#73B0F9");
    _timeLabel.font = SystemFontSize(25);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"00 秒";
    [self.view addSubview:_timeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapProgressView)];
    [_progressView addGestureRecognizer:tap];

}

- (void)getPayCode{
    if (_needRefresh == NO) {
        return;
    }
    
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findSecretWithMobile:[Config Instance].personMember.mobile andMemberNo:[Config Instance].memberNo];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // [hud hide:YES];
        _tapValue = NO;

        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        
        if (result) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            NSString *code = [returnObj objectForKey:@"secretValue"];
            NSMutableString *mutableCode = [[NSMutableString alloc]initWithString:code];
            for (int i=0; i<code.length-1; i++) {
                [mutableCode insertString:@" " atIndex:2*i+1];
            }
            _payCode.text = mutableCode;
            
            _totalTime = [[returnObj objectForKey:@"second"]intValue];
            _timeLeft = [[returnObj objectForKey:@"second"]intValue];
            
            _payTip.text = [NSString stringWithFormat:@"手机宝令 %d 秒更新一次",_totalTime];
            _timeLabel.text = [NSString stringWithFormat:@"%d 秒",_totalTime];

            [self timeStartCountDown];
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"获取失败" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alter show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // [hud hide:YES];
        _tapValue = YES;
        [UtilTool showToastViewBase:self.view andMessage:@"请求超时!" Offset:130];
    }];
}

- (void)timeStartCountDown{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimes:) userInfo:nil repeats:YES];
}

-(void)updateTimes:(NSTimer *)theTimer
{
    _timeLeft -= [theTimer timeInterval];
    if (_timeLeft == 0) {
        [theTimer invalidate];
        theTimer = nil;
        
        [self getPayCode];
    }
    NSString *times = [NSString stringWithFormat:@"%d 秒",_timeLeft];
    _timeLabel.text = times;
    
    _progressView.percent = 1-(float)_timeLeft/_totalTime;
}

- (void)appEnterForeGround{
    _needRefresh = YES;
}

- (void)appEnterBackGround{
    _needRefresh = NO;
}

- (void)tapProgressView{
    if (_tapValue == YES || _timeLeft == 0) {
        [self getPayCode];
    }
}

@end

//
//  FPDispatch2DCodeViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14/12/1.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPDispatch2DCodeViewController.h"
#import "QRCodeGenerator.h"
#import "AESCrypt.h"

@interface FPDispatch2DCodeViewController (){
    BOOL firstRequst;
    BOOL startRefresh;
}
@property (nonatomic, strong) UIImageView *img_2DimCode;
@property (nonatomic, strong) UIView      *leftRedpacket;
@property (nonatomic, strong) UIView      *leftButton;
@property (nonatomic, strong) UILabel     *leftPacket_lbl;
@property (nonatomic, strong) UIImageView  *NO_2DimCode;
@property (nonatomic, strong) UIImageView *img_2DimCode_status_on;
@property (nonatomic, strong) UIImageView *img_2DimCode_status_off;
@property (nonatomic, strong) NSString *redpacketDispatchNo;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FPDispatch2DCodeViewController

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = COLOR_STRING(@"#EC4A4D");
    self.view = view;
    
    [self installCoustomView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    startRefresh = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    startRefresh = NO;
    
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发红包";
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backButton;
    
//    UIBarButtonItem *right =[[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(tapTheRightButton)];
//    self.navigationItem.rightBarButtonItem = right;
    
//[self made2DimageCode:@"1234567890"];
    _redpacketDispatchNo = @"";
    firstRequst = YES;
    startRefresh = YES;
    [self getNewRedPacketToDistribute];

}

- (void)click_LeftButton{
    NSArray *controllers = self.navigationController.viewControllers;
    for (UIViewController *temp in controllers) {
        if ([temp isMemberOfClass:NSClassFromString(@"FPRedPacketHomeViewController")]) {
            [self.navigationController popToViewController:temp animated:NO];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)installCoustomView{
    
    UIImageView *circle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 263, 250)];
    circle.backgroundColor = [UIColor clearColor];
    circle.center = CGPointMake(ScreenWidth/2, ScreenHigh/2-64-10);
    circle.image = MIMAGE(@"redpacket_2DCode_circle");
    [self.view addSubview:circle];
    
    UIImageView *folwer = [[UIImageView alloc]initWithFrame:CGRectMake(40, circle.top-(ScreenWidth-80)*144/364/1.5, ScreenWidth-80, (ScreenWidth-80)*144/364)];
    folwer.backgroundColor = [UIColor clearColor];
    folwer.image = MIMAGE(@"redpacket_2DCode_flower");
    [self.view addSubview:folwer];
    
    _img_2DimCode = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    _img_2DimCode.backgroundColor = [UIColor whiteColor];
    _img_2DimCode.center = CGPointMake(ScreenWidth/2, ScreenHigh/2-64-10);
    _img_2DimCode.userInteractionEnabled = YES;
    [self.view addSubview:_img_2DimCode];
    
    _NO_2DimCode = [[UIImageView alloc]initWithFrame:_img_2DimCode.frame];
    _NO_2DimCode.backgroundColor = COLOR_STRING(@"#BEBEBE");
    _NO_2DimCode.image = MIMAGE(@"redpacket_2DCode_none");
    [self.view insertSubview:_NO_2DimCode belowSubview:_img_2DimCode];
    
    _img_2DimCode_status_on = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 30, 30)];
    _img_2DimCode_status_on.center = CGPointMake(_img_2DimCode.width/2, _img_2DimCode.height/2);
    _img_2DimCode_status_on.backgroundColor = [UIColor clearColor];
    _img_2DimCode_status_on.image = MIMAGE(@"redpacket_2DCode_status_on");
    _img_2DimCode_status_on.hidden = YES;
    [_img_2DimCode addSubview:_img_2DimCode_status_on];
    
    _img_2DimCode_status_off = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 40, 40)];
    _img_2DimCode_status_off.center = CGPointMake(_img_2DimCode.width/2, _img_2DimCode.height/2);
    _img_2DimCode_status_off.backgroundColor = [UIColor clearColor];
    _img_2DimCode_status_off.image = MIMAGE(@"redpacket_2DCode_status_off");
    _img_2DimCode_status_off.hidden = YES;
    [_img_2DimCode addSubview:_img_2DimCode_status_off];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg2Dcode)];
    [_img_2DimCode addGestureRecognizer:tap];
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _img_2DimCode.bottom+10, ScreenWidth, 20)];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textAlignment  = NSTextAlignmentCenter;
    alertLabel.textColor = COLOR_STRING(@"#FECA9E");
    alertLabel.font = [UIFont boldSystemFontOfSize:14];
    alertLabel.text = @"每发完一个,请点击刷新";
    [self.view addSubview:alertLabel];
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, circle.top-35, ScreenWidth, 20)];
    topLabel.backgroundColor = COLOR_STRING(@"#EC4A4D");
    topLabel.textAlignment  = NSTextAlignmentCenter;
    topLabel.textColor = COLOR_STRING(@"#9D2F31");
    topLabel.font = [UIFont boldSystemFontOfSize:16];
    topLabel.text = @"给TA扫一扫，完成红包派发";
    [topLabel sizeToFit];
    topLabel.left = (ScreenWidth-topLabel.width)/2;
    [self.view addSubview:topLabel];
    
    _leftButton = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-25, circle.bottom+25, 50, 50)];
    _leftButton.backgroundColor = [UIColor clearColor];
    _leftButton.layer.masksToBounds = YES;
    _leftButton.layer.cornerRadius = 25;
    _leftButton.hidden = NO;
    [self.view addSubview:_leftButton];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0.3;
    [_leftButton addSubview:bg];

    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = CGRectMake(5, 5, 40, 40);
    [Button setImage:MIMAGE(@"redpacket_2DCode_left_btn") forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(tapTheLeftButtonBottom) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton addSubview:Button];
    
    _leftRedpacket = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-85, circle.bottom+15, 170, 40)];
    _leftRedpacket.backgroundColor = [UIColor clearColor];
    _leftRedpacket.layer.masksToBounds = YES;
    _leftRedpacket.layer.cornerRadius = 5;
    _leftRedpacket.alpha = 0;
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _leftRedpacket.width, _leftRedpacket.height)];
    back.backgroundColor = [UIColor blackColor];
    back.alpha = 0.3;
    [_leftRedpacket addSubview:back];
    
    _leftPacket_lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,_leftRedpacket.width, _leftRedpacket.height)];
    _leftPacket_lbl.backgroundColor = [UIColor clearColor];
    _leftPacket_lbl.font = [UIFont boldSystemFontOfSize:16];
    _leftPacket_lbl.textAlignment = NSTextAlignmentCenter;
    _leftPacket_lbl.textColor = COLOR_STRING(@"#FFFFFF");
    _leftPacket_lbl.text = @"剩余红包：0 个";
    [_leftRedpacket addSubview:_leftPacket_lbl];
    
    [self.view addSubview:_leftRedpacket];
}

- (void)showStatusImageWith:(BOOL)status{
    if (status) {
        _img_2DimCode_status_off.hidden = YES;
        _img_2DimCode_status_on.hidden = NO;
    }else{
        _img_2DimCode_status_off.hidden = NO;
        _img_2DimCode_status_on.hidden = YES;
    }
}

//制作加密二维码
- (void)made2DimageCode:(NSString *)receiveNo{
    NSString *secrityMessage = [AESCrypt encrypt:receiveNo password:AESEncryKey];

    NSString *message = [NSString stringWithFormat:@"[redpacket]%@",secrityMessage];

    UIImage *QR2Dimage = [QRCodeGenerator qrImageForString:message imageSize:240];
    self.img_2DimCode.image = QR2Dimage;
    
    [self showStatusImageWith:YES];
    
    if(!firstRequst){
        [UIView transitionWithView:_img_2DimCode
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            
                        } completion:^(BOOL finished) {
                            
                        }];
    }
}

- (void)tapTheLeftButtonBottom{
    
   // [self clickLeftToRefresh];
    
    float Y = _leftRedpacket.alpha>0 ? 0 : 40;
    
    CGAffineTransform tramsform = CGAffineTransformMakeTranslation(0, Y);
    [UIView animateWithDuration:0.3 animations:^{
        _leftRedpacket.alpha = Y>0 ? 1 : 0;
        _leftButton.transform = tramsform;
    }];
    
}
//- (void)tapTheRightButton{
//    [self getNewRedPacketToDistribute];
//}

- (void)tapImg2Dcode{
    
    [self getNewRedPacketToDistribute];

}
#pragma mark NetWorking

- (void)clickLeftToRefresh{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client getNewRedPacketToDistributeWithCurrentRePacketId:_currentRePacketId];
  
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            NSString *receiveNo = [returnObj objectForKey:@"receiveNo"];
            int surplusCount = [[returnObj objectForKey:@"surplusCount"] intValue];
            if (surplusCount>0) {
                if ([receiveNo isEqualToString:_redpacketDispatchNo]) {
                    //二维码可用
                }else{
                    //二维码不可用
                    _redpacketDispatchNo = receiveNo;
                    [self showStatusImageWith:NO];
                    //一秒后刷新
                    [self performSelector:@selector(made2DimageCode:) withObject:receiveNo afterDelay:1];
                }
                _leftPacket_lbl.text = [NSString stringWithFormat:@"剩余红包：%d 个",surplusCount];
                
                if (startRefresh) {
                    [self performSelector:@selector(clickLeftToRefresh) withObject:nil afterDelay:1];
                }
             
            }else{
                _leftPacket_lbl.text = [NSString stringWithFormat:@"剩余红包：%d 个",0];
                [UIView transitionWithView:_img_2DimCode
                                  duration:0.6
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    
                                } completion:^(BOOL finished) {
                                    _img_2DimCode.hidden = YES;
                                    _NO_2DimCode.hidden = NO;
                                }];
            }
            
        }else{
            NSString *errorCode = [responseObject objectForKey:@"errorCode"];
            
            if ([errorCode isEqualToString:@"mkt_rp_distribute_status_end"]) {
                _leftPacket_lbl.text = [NSString stringWithFormat:@"剩余红包：%d 个",0];
                [UIView transitionWithView:_img_2DimCode
                                  duration:0.6
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    
                                } completion:^(BOOL finished) {
                                    _img_2DimCode.hidden = YES;
                                    _NO_2DimCode.hidden = NO;
                                }];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FPDEBUG(@"%@",error);
    }];

}
- (void)getNewRedPacketToDistribute{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client getNewRedPacketToDistributeWithCurrentRePacketId:_currentRePacketId];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            NSString *receiveNo = [returnObj objectForKey:@"receiveNo"];
            int surplusCount = [[returnObj objectForKey:@"surplusCount"] intValue];
            
            if (surplusCount > 0) {
                if (receiveNo.length>0) {
                    _leftPacket_lbl.text = [NSString stringWithFormat:@"剩余红包：%d 个",surplusCount];
                    if(_redpacketDispatchNo.length <= 0){
                        _redpacketDispatchNo = receiveNo;
                        [self made2DimageCode:receiveNo];
                    }else{
                        if ([receiveNo isEqualToString:_redpacketDispatchNo]) {
                            //二维码可用
                        }else{
                            //二维码不可用
                            [self showStatusImageWith:NO];
                            _redpacketDispatchNo = receiveNo;
                            //一秒后刷新
                            [self performSelector:@selector(made2DimageCode:) withObject:receiveNo afterDelay:1];
                        }
                    
                    }
                    
                    //动画
                    if (!firstRequst) {
                        
                        
                        [UIView transitionWithView:_img_2DimCode
                                          duration:0.6
                                           options:UIViewAnimationOptionTransitionCurlUp
                                        animations:^{
                                            
                                        } completion:^(BOOL finished) {
                                            
                                        }];
                    }else{
                        [self clickLeftToRefresh];
                    }
                    
                }
            }else{
                _leftPacket_lbl.text = [NSString stringWithFormat:@"剩余红包：%d 个",0];
                
                [UIView transitionWithView:_img_2DimCode
                                  duration:0.6
                                   options:UIViewAnimationOptionTransitionCurlUp
                                animations:^{
                                    
                                } completion:^(BOOL finished) {
                                    _img_2DimCode.hidden = YES;
                                    _NO_2DimCode.hidden = NO;
                                }];
            }
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            NSString *errorCode = [responseObject objectForKey:@"errorCode"];
            
            if ([errorCode isEqualToString:@"mkt_rp_distribute_status_end"]) {
                _leftPacket_lbl.text = [NSString stringWithFormat:@"剩余红包：%d 个",0];
                
                if (!firstRequst) {
                    [UIView transitionWithView:_img_2DimCode
                                      duration:0.6
                                       options:UIViewAnimationOptionTransitionCurlUp
                                    animations:^{
                                        
                                    } completion:^(BOOL finished) {
                                        _img_2DimCode.hidden = YES;
                                        _NO_2DimCode.hidden = NO;
                                    }];
                }
                
                return ;
            }
            
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"刷新失败!" message:errInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
        
        firstRequst = NO;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(firstRequst){
            [self clickLeftToRefresh];
        }
        firstRequst = NO;
        [hud hide:YES];
        FPDEBUG(@"%@",error);
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

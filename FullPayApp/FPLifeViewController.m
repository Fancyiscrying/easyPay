//
//  FPLifeViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-12.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPLifeViewController.h"
#import "FPLotteryViewController.h"
#import "FPRechargeValueViewController.h"
#import "FPGroupBuyViewController.h"
#import "FPLotteryWebViewController.h"
#import "FPNameAndStaffIdViewController.h"
#import "FPFullWalletViewController.h"
#import "FPWalletCardNumViewController.h"
#import "FPSSTDownloadWabViewController.h"
#import "FPRedPacketHomeViewController.h"
#import "FPWalletCardListViewController.h"
#import "FPTrendViewController.h"
#import "FPRestaurantManagerWebviewController.h"

#import "FPNavLoginViewController.h"

typedef enum{
    clickLottery,
    clickHightLottery
}ClickType;

//获取地理位置
#import <CoreLocation/CoreLocation.h>

@interface FPLifeViewController ()<UIAlertViewDelegate,CLLocationManagerDelegate>
{
    ClickType clickType;
}
@property (strong, nonatomic) NSString *gpcLotteryURL;

//map
@property (nonatomic) CLLocationManager  *locationManager;
@property (nonatomic) CLLocation  *mylocation;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation FPLifeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"精彩富生活";
    
    [self installCustom];
    [self getGpcLotteryResourceURL];
   
    if ([Config Instance].personMember.nameAuthFlag) {
        [self getGenerateSign];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveGPCLotteryNotification:) name:kGPCLotteryBackNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)gotoLotteryView{
    
    if (self.launch_state == FPControllerStateAuthorization) {
        FPMethodMap *methodMap = [Config Instance].methodMap;
        if (methodMap && [[methodMap.methodMap allKeys] containsObject:@"FPLotteryViewController"]) {
            if ([[methodMap.methodMap objectForKey:@"FPLotteryViewController"] boolValue]) {
                FPLotteryViewController *lotteryController = [[FPLotteryViewController alloc] init];
                lotteryController.lotteryViewType = FPLotteryViewControllerTypeAuth;
                lotteryController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lotteryController animated:YES];
                
            } else {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"即将上线，敬请期待！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            FPLotteryViewController *lotteryController = [[FPLotteryViewController alloc] init];
            lotteryController.lotteryViewType = FPLotteryViewControllerTypeAuth;
            lotteryController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lotteryController animated:YES];
        }
    } else {
        [self click_ToLoginController];
    }
    
}

- (void)gotoHightLotteryView{
    if (self.launch_state == FPControllerStateAuthorization) {
        
        NSString *warnMsg = @"1、身份证 和 姓名 是领奖的凭证，请在“我的账户”里确认信息；\n2、如因用户未填写正确的身份信息，而造成的一切的损失，富之富概不负责，是否前往填写真实信息?";
        
        FPPersonMember *personMember = [Config Instance].personMember;
        if (!personMember.nameAuthFlag) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:warnMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完善本人信息",nil];
            alert.tag = 100;
            [alert show];
        }else{
            FPLotteryWebViewController *webController = [[FPLotteryWebViewController alloc] init];
            webController.title = @"我爱中彩票网";
            webController.webViewType = FPGPCLotteryViewControllerType;
            webController.gpcURL = self.gpcLotteryURL;

            webController.hidesBottomBarWhenPushed = YES;

            NSString *uriData = [webController getGenerateGpcSign];
            if (uriData != nil) {
                if (self.gpcLotteryURL != nil && self.gpcLotteryURL.length>0) {
                    if ([_gpcLotteryURL rangeOfString:@"?"].location == NSNotFound) {
                        webController.redirectUri = [NSString stringWithFormat:LOTTERYGETFORMART,_gpcLotteryURL,uriData];
                    } else {
                        webController.redirectUri = [NSString stringWithFormat:LOTTERYGETFORMART_WITH_SYMBOL,_gpcLotteryURL,uriData];
                    }
                }else{
                    [self getGpcLotteryResourceURL];
                }
                
                FPDEBUG(@"redirectUri:%@",webController.redirectUri);
                [self.navigationController pushViewController:webController animated:YES];
            }else{
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"参数错误！" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
    } else {
        [self click_ToLoginController];
    }

}

- (void)click_Spree:(UIButton *)sender
{
    if (self.launch_state == FPControllerStateAuthorization) {
        FPTrendViewController * trendViewController = [[FPTrendViewController alloc] init];
        trendViewController.trendType = FPTrendTypeDalibao;
        trendViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:trendViewController animated:YES];
    } else {
        [self click_ToLoginController];
    }
    
}

- (void)click_Lottery:(UIButton *)sender
{
    clickType = clickLottery;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *hasClick = [defaults objectForKey:HAS_CLICK_LOTTERY];
    if ([hasClick isEqualToString:@"YES"]) {
        if (self.mylocation != nil) {
            [self getCountry:self.mylocation];
        }else{
            [self mapLocationLoad];
            
        }
    }else{
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"服务提示" message:@"彩票应用仅限在中国区域内使用,需要使用“定位服务”来确定你的位置。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alter.tag = 101;
        [alter show];
    }
}

- (void)click_Recharge:(UIButton *)sender
{
    if (self.launch_state == FPControllerStateAuthorization) {
        FPRechargeValueViewController *controller = [[FPRechargeValueViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self click_ToLoginController];
    }
    
}

- (void)click_GroupBuy:(UIButton *)sender
{
    if (self.launch_state == FPControllerStateAuthorization) {
        NSString *memberNo = [Config Instance].memberNo;
        NSString *result = [memberNo md5Twice:[memberNo substringWithRange:NSMakeRange(1, 10)]];
        
        NSString *uri = [NSString stringWithFormat:FORMAT_GROUP,kGROUPBUY_BASEURI,kMainWebUri,memberNo,result];
        FPGroupBuyViewController *controller = [[FPGroupBuyViewController alloc] init];
        controller.groupViewType = FPGroupBuyViewControllerTypeAuth;
        [controller setRedirectUri:uri];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self click_ToLoginController];
    }
    
}
- (void)click_High_Lottery:(UIButton *)sender{
    clickType = clickHightLottery;
    
    if (self.launch_state == FPControllerStateAuthorization) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *hasClick = [defaults objectForKey:HAS_CLICK_LOTTERY];
        if ([hasClick isEqualToString:@"YES"]) {
            if (self.mylocation != nil) {
                [self getCountry:self.mylocation];
            }else{
                [self mapLocationLoad];
                
            }
        }else{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"服务提示" message:@"彩票应用仅限在中国区域内使用,需要使用“定位服务”来确定你的位置。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alter.tag = 101;
            [alter show];
        }
    } else {
        [self click_ToLoginController];
    }

    
    
}

- (void)click_ToLoginController
{
    [[Config Instance] setAutoLogin:NO];
    NSLog(@"[self presentingViewController]:%@,%@",[self presentingViewController],[self presentedViewController]);
    if ([self presentingViewController]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        FPNavLoginViewController   *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPNavLoginView"];
        controller.hidesBottomBarWhenPushed = YES;
        [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

- (void)click_FullWallet:(UIButton *)sender{
    
    //登录状态下可用
    if (self.launch_state == FPControllerStateAuthorization) {
        FPWalletCardListViewController *viewController = [[FPWalletCardListViewController alloc]init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [self click_ToLoginController];
    }
    
    /**
     *  以前逻辑 2015-04-08
     */
//    NSString *cardNo = [UtilTool getFullWalletCardNo];
//    if (cardNo.length > 0) {
//        FPFullWalletViewController *viewController = [[FPFullWalletViewController alloc]init];
//        viewController.cardNo = cardNo;
//        [self.navigationController pushViewController:viewController animated:YES];
//
//    }else{
//        FPWalletCardNumViewController *walletCardNo = [[FPWalletCardNumViewController alloc]init];
//        [self.navigationController pushViewController:walletCardNo animated:YES];
//    }
    
}

- (void)click_SuiShouTao:(UIButton *)sender{
    NSString *urlStr = @"gotoReadilyTao://gotosuishoutao";
    NSURL *sstURL = [NSURL URLWithString:urlStr];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:sstURL]) {
        [app openURL:sstURL];
    }else{
        FPSSTDownloadWabViewController *controller = [[FPSSTDownloadWabViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)click_RedPacket:(UIButton*)sender{
    if (self.launch_state == FPControllerStateAuthorization) {
        
        FPPersonMember *personMember = [Config Instance].personMember;
        if (!personMember.nameAuthFlag) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"此功能需实名认证才可使用!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往实名",nil];
            alert.tag = 100;
            [alert show];
        
        }else{
            FPRedPacketHomeViewController *controller = [[FPRedPacketHomeViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
    }else {
        [self click_ToLoginController];
    }
}

- (void)click_Manager:(UIButton *)sender
{
    //登录状态下可用
    if (self.launch_state == FPControllerStateAuthorization) {
        FPRestaurantManagerWebviewController *viewController = [[FPRestaurantManagerWebviewController alloc]init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [self click_ToLoginController];
    }
}

- (void)getGpcLotteryResourceURL{
    
    FPClient *client = [FPClient sharedClient];
    NSDictionary *parameter = [client findGpcLotteryResource];
    NSLog(@"%@",parameter);
    [client POST:kFPPost parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"%@",responseObject);
        BOOL result = [[responseObject objectForKey:@"result"] boolValue];
        if (result) {
            NSString *gpcURL = [responseObject objectForKey:@"returnObj"];
            if (gpcURL.length > 0) {
                self.gpcLotteryURL = gpcURL;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)getGenerateSign
{
    FPLotterySign *lottery = [Config Instance].lotterySign;
    if (!lottery) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [UtilTool showHUD:@"正在通讯" andView:self.view andHUD:hud];
        [FPLotterySign getLotterySignWithBlock:^(FPLotterySign *lotterySign,NSError *error) {
            [hud hide:YES];
            if (error) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                if (lotterySign.result) {
                    [[Config Instance] setLotterySign:lotterySign];
                } else {
//                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:lotterySign.errorInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                }
            }
        }];
    }
}


- (void)installCustom
{
//    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.btn_Lottery addTarget:self action:@selector(click_Lottery:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_Recharge addTarget:self action:@selector(click_Recharge:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_GroupBuy addTarget:self action:@selector(click_GroupBuy:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_high_lottery addTarget:self action:@selector(click_High_Lottery:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_FullWallet addTarget:self action:@selector(click_FullWallet:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_SuiShouTao addTarget:self action:@selector(click_SuiShouTao:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_RedPacket addTarget:self action:@selector(click_RedPacket:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_Spree addTarget:self action:@selector(click_Spree:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_Manager addTarget:self action:@selector(click_Manager:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark NSNotification delegate
- (void)reciveGPCLotteryNotification:(NSNotification *)notification{
    [self click_High_Lottery:nil];
}
#pragma mark location
- (void)mapLocationLoad
{
    if ([CLLocationManager locationServicesEnabled]){
        
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted||
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"彩票应用需开启定位" message:@"请在“设置->隐私->定位服务”中，确认“定位”和“富之富”为开启状态" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alter show];
        }else{
            if (self.locationManager == Nil) {
                self.locationManager = [[CLLocationManager alloc] init];
                
                float IOSVersion = [UtilTool getIOSVersion];
                if (IOSVersion>=8.0) {
                    [self.locationManager requestAlwaysAuthorization];
                }
                self.locationManager.delegate = self;
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                self.locationManager.distanceFilter = 1000;
            }
            
            _hud = [[MBProgressHUD alloc] initWithView:self.view];
            [UtilTool showHUD:@"正在通讯" andView:self.view andHUD:_hud];
            
            [self.locationManager startUpdatingLocation];
        }
    }else{
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"彩票应用需开启定位" message:@"请在“设置->隐私->定位服务”中，确认“定位”和“富之富”为开启状态" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alter show];
    }
}

#pragma mark -CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *current = [locations lastObject];
    
    if (self.mylocation == nil) {
        self.mylocation = current;
        [self getCountry:current];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_hud hide:YES];
    FPDEBUG(@"didFailWithError");
    //    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    //    alter.tag = 203;
    //    [alter show];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
    //        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您关闭了定位功能，将无法使用彩票功能!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    //        //alter.tag = kAlertTag + 4;
    //        [alter show];
    //    }
}

- (void)getCountry:(CLLocation *)location{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        [_hud hide:YES];
        if (error == nil && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks[0];
            NSLog(@"%@",placemark.country);
            NSString *country = placemark.country;
            if ([country isEqualToString:@"中国"] || [country isEqualToString:@"China"]) {
                if (clickType == clickLottery) {
                    [self gotoLotteryView];

                }else if (clickType == clickHightLottery){
                    [self gotoHightLotteryView];
                }
                
            }else{
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"彩票应用仅限在中国区域内使用!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alter.tag = 4;
                [alter show];
            }
        }
    }];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        NSString *click = @"YES";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:click forKey:HAS_CLICK_LOTTERY];
        [defaults synchronize];
        [self mapLocationLoad];
    }
    
    if (alertView.tag == 100 && buttonIndex == 1) {
        //前往实名
        FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }

}

@end

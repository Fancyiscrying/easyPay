//
//  FPAppDelegate.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-11.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "FPLockViewController.h"
#import "FPNavLoginViewController.h"
#import "FPLoginViewController.h"
#import "FPTabBarViewController.h"
#import "FPTakeTelphoneController.h"

#import "TWMessageBarManager.h"
#import "Reachability.h"
#import "FPAppVersion.h"
#import "BPush.h"

#import "FPUserLogin.h"
#import "AESCrypt.h"


#import "FPTakeTelphoneController.h"

#define USER_PASSWORD @"userpassword"


@implementation FPAppDelegate

static bool isBackgroundStatues;
static bool isComeFromLottery;
static myDate *lastBackGroundTime = nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    isBackgroundStatues = YES;
    isComeFromLottery = NO;
    _hasCheckAppVersion = NO;
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 延长启动动画时间
//    [NSThread sleepForTimeInterval:2.0];
    
    [self checkReachability];
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
        //[[Config Instance] setAutoLogin:NO];
        
        [[Config Instance] setPersonMember:nil];
        
        FPDEBUG(@"everLaunched:YES");
        
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        FPDEBUG(@"firstLaunch:NO");
    }


    //启动画面全屏，这里再显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    //开启statusbar的网络通讯图标
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //百度云推送初始化
    [BPush setupChannel:launchOptions];
    // 必须。参数对象必须实现(void)onMethod:(NSString*)method response:(NSDictionary*)data 方法,本示例中为 self
    [BPush setDelegate:self];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //iOS8注册推送
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //iOS8之前，这里还是原来的代码
        //for apns
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound) ];
    }
    
    
    NSUserDefaults *stdDefault = [NSUserDefaults standardUserDefaults];
    BOOL isFirstLaunch = [[stdDefault objectForKey:@"firstLaunch"] boolValue];
    //判断是否是第一次运行
    if (isFirstLaunch) {
        [[Config Instance] setAutoLogin:NO];
        FPTakeTelphoneController *controller = [[FPTakeTelphoneController alloc]init];
        FPNavLoginViewController *navController = [[FPNavLoginViewController alloc]initWithRootViewController:controller];
        
        self.window.rootViewController = navController;
    }else{
        [self checkIfNeedSetGesturePWD];
    }
    
/***********************************************************
    //mark  调试界面所用
    FPTakeTelphoneController *controller = [[FPTakeTelphoneController alloc]init];
    FPNavLoginViewController *navController = [[FPNavLoginViewController alloc]initWithRootViewController:controller];
    self.window.rootViewController = navController;
    
**********************************************************/
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (launchOptions) {
        NSDictionary *pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            [self handleRemoteNotification:application userInfo:pushNotificationKey];
        }
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    lastBackGroundTime = [self getCurrentTime];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    isBackgroundStatues = YES;
    isComeFromLottery = NO;
    
    lastBackGroundTime = [self getCurrentTime];
    
    NSDate *now = [NSDate date];
    [FPTokenTool setTokenBackgroundTime:now];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySecretEnterBackground" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    /**
     *  首先做token有效期验证
     */
    
    if ([Config Instance].isAutoLogin) {
        BOOL result = [self manageNeedUpdateUserLoginToken];
        if (result) {
            return;
        }
    }
//    else{
//        FPLoginViewController *login = [[FPLoginViewController alloc]init];
//        FPNavLoginViewController *nav = [[FPNavLoginViewController alloc]initWithRootViewController:login];
//        login.isToRoot = YES;
//        self.window.rootViewController = nav;
//        
//    }

    
    //读取手势密码
    NSUserDefaults *stdDefault = [NSUserDefaults standardUserDefaults];
    NSString *pattern = [self getUserGesturePWD];
    if (![pattern isEqualToString:SET_GESUTREPWD_OFF]) {
        [stdDefault setObject:pattern forKey:kCurrentPattern];
        [stdDefault synchronize];
    }
    
    isBackgroundStatues = [self isNeedShowLockView];
    
    if(self.window.rootViewController.presentedViewController == nil
       && [Config Instance].isAutoLogin
       && ![pattern isEqualToString:SET_GESUTREPWD_OFF]
       && ![pattern isEqualToString:EVER_SET_GESUTREPWD]
       && isBackgroundStatues
       && !isComeFromLottery){
        
		FPLockViewController *lockVc = [[FPLockViewController alloc]init];
		lockVc.infoLabelStatus = InfoStatusNormal;
		[self.window.rootViewController presentViewController:lockVc animated:NO completion:^{
			//
		}];
	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySecretEnterForeground" object:nil];

    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 百度云推送设置
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
//    FPDEBUG(@"deviceToken:%@",token);
    [BPush registerDeviceToken:deviceToken];
    //必须。可以在其它时机调用,只有在该方法返回(通过 onMethod:response:回调)绑定成功时,app 才能接收到 Push 消息。一个 app 绑定成功至少一次即可(如 果 access token 变更请重新绑定)。
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSString *error_str = [NSString stringWithFormat: @"%@", error];
//    FPDEBUG(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
   // NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];

    if (application.applicationState == UIApplicationStateActive) {
        if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != nil) {
            /*
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知"
                                                                message:[NSString stringWithFormat:@"%@", alert]
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            [UtilTool showToastToView:self.window.rootViewController.view andMessage:alert];
        */
        }
    }    
    // 可选
    [BPush handleNotification:userInfo];
    
}

// 必须，如果正确调用了setDelegate，在bindChannel之后，结果在这个回调中返回。
// 若绑定失败，请进行重新绑定，确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        FPDEBUG(@"BPushRequestMethod_BindResult:%@",res);
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        //int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
       // NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        //帐号绑定
        if (![Config Instance].isAutoLogin) {
            return;
        }
        NSString *memberNo = [Config Instance].personMember.memberNo;
        FPClient *client = [FPClient sharedClient];
        NSDictionary *parmaters = [client addBoundInfoChannelId:channelid andUserId:userid andAppId:appid andMemberNo:memberNo];
        [client POST:kFPPost parameters:parmaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
            BOOL result = [[responseObject objectForKey:@"result"] boolValue];
            if (result) {
                FPDEBUG(@"addBoundInfo:绑定成功");
            }else{
                FPDEBUG(@"addBoundInfo:绑定失败");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //FPDEBUG(@"addBoundInfo:绑定失败")
        }];
      
    }
}

- (void)handleRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo
{
    
}

#pragma mark 友盟组件设置
- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:@"App Store"];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    [MobClick checkUpdate:@"发现新版本" cancelButtonTitle:@"忽略" otherButtonTitles:@"更新"];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
}

#pragma mark -
#pragma mark application call back
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{ NSString *urlScheme = [url scheme];
    NSString *urlstring = [url absoluteString];
    if ([urlScheme isEqualToString:@"fpcallback"]) {
        //[[tftPlugin shareInstance] callBackHandle:url];
    }else if([urlScheme isEqualToString:@"lotterycallback"]){
        isComeFromLottery = YES;
        NSArray *returnObj = [urlstring componentsSeparatedByString:@"//"];
        if (returnObj.count >= 2) {
            NSString *notString = [returnObj lastObject];
            if (notString.length>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kLotteryBackNotification object:notString];
                
            }
        }
    }else if([urlScheme isEqualToString:@"gpccallback"]){
        isComeFromLottery = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kGPCLotteryBackNotification object:nil];
                

    }
    
    return YES;
}

- (BOOL)checkReachability
{
    __block BOOL result = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"mobile.futongcard.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            result = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            result = NO;
        });
    };
    
    [reach startNotifier];
    
    return result;
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if(![reach isReachable]) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"警告" description:@"网络连接失败,请查看网络是否连接正常！" type:TWMessageBarMessageTypeInfo];
    }
}

- (NSString *)getUserGesturePWD{
    //读取手势密码
    NSString *pattern = SET_GESUTREPWD_OFF;
    if ([Config Instance].personMember) {
        NSString *tel = [Config Instance].personMember.mobile;
        pattern = [FPTelGesturePWD objectValueForKey:tel];
    }
   
    
    return pattern;
}

//检测是否需要强制设置手势密码
- (void)checkIfNeedSetGesturePWD{
    NSString *gesturePWD = [self getUserGesturePWD];
    if ([gesturePWD isEqualToString:EVER_SET_GESUTREPWD] && [Config Instance].isAutoLogin) {
        //先把手势设置为关闭状态
        if ([Config Instance].personMember) {
            NSString *tel = [Config Instance].personMember.mobile;
            [FPTelGesturePWD resetGesturePassword:SET_GESUTREPWD_OFF andTelNumber:tel];
        }

        
        FPLockViewController *controller = [[FPLockViewController alloc]init];
        controller.isFirstTimeSetting = YES;
        
        [UtilTool setRootViewController:controller];
    }else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        FPTabBarViewController   *controller = [storyBoard instantiateViewControllerWithIdentifier:@"FPTabBarView"];
        //NSString *PWD = [self getUserGesturePWD];
        if ([Config Instance].autoLogin) {
            controller.userState = FPControllerStateAuthorization;
        }else {
            controller.userState = FPControllerStateNoAuthorization;
        }
        self.window.rootViewController = controller;
    }
}

#pragma mark 关于进入后台后手势密码的开启

- (myDate *)getCurrentTime{
    NSDate *now = [NSDate date];
    myDate *date = [[myDate alloc]initWithDate:now];
    if (date != nil) {
        return date;
    }else{
    
        return nil;
    }
}

- (BOOL)isNeedShowLockView{
    if (lastBackGroundTime == nil) {
        return YES;
    }else{
        
        myDate *date = [self getCurrentTime];
        
        int dayCurr = [date.day intValue];
        int dayLast = [lastBackGroundTime.day intValue];
        
        int hourCurr = [date.hour intValue];
        int hourLast = [lastBackGroundTime.hour intValue];
        
        int minCurr = [date.minute intValue];
        int minLast = [lastBackGroundTime.minute intValue];

        if (dayCurr > dayLast) {
            return YES;
        }else if(hourCurr > hourLast){
            return YES;
        }else if(minCurr- minLast >= BACKGROUND_MAX_TIME_MINUTE){
            return YES;
        }else{
            return NO;
        }
        
    }
}

/**
 *  是否要更新token (在已登录状态下)
 */
#pragma mark
- (BOOL)manageNeedUpdateUserLoginToken{
    if ([FPTokenTool isUserUnuseLongTime]) {
        [Config Instance].autoLogin = NO;
        FPLoginViewController *login = [[FPLoginViewController alloc]init];
        FPNavLoginViewController *nav = [[FPNavLoginViewController alloc]initWithRootViewController:login];
        login.isNotReturn = YES;
        self.window.rootViewController = nav;

        return YES;
    }else{
        if (![FPTokenTool isTokenIsAvailable]) {
            NSString *scrityPass = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PASSWORD];
            NSString *userPWD = [AESCrypt decrypt:scrityPass password:AESEncryKey];
            
            [FPUserLogin globalUserLoginWithLoginId:[Config Instance].personMember.mobile andPwd:userPWD andBlock:^(FPUserLogin *userInfo, NSError *error) {
                /**
                 更新token
                 */
                if(userInfo.result){
                    FPDEBUG(@"appdelegate刷新token成功");
                }
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"刷新token成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                [alert show];
                
                
            }];
        }
        
        return NO;
    }
}

@end

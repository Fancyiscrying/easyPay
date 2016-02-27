//
//  FPLotteryWebViewController.m
//  FullPayApp
//
//  Created by mark zheng on 13-11-19.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "FPLotteryWebViewController.h"
#import "FPViewController.h"
#import "FPLoginViewController.h"
//#import "FPCardRechargeViewController.h"
#import "FPLotteryStruct.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"

#define IMAGE_APP_BACKGROUND @"BG"
#define BUTTON_BACKOFF @"Btn-backoff.png"
#define BUTTON_BACKON @"Btn-backon.png"
#define BUTTON_FORWARDOFF @"Btn-forwardoff.png"
#define BUTTON_FORWARDON @"Btn-forwardon.png"
#define BUTTON_HOME @"Btn-home.png"
#define IMAGE_TOOLBAR_BACK @"Img-toolbar-back.png"

#ifdef DEBUG
#define kLOTTERY_MOBILE_PAYMENT_REQUEST @"http://test.futongcard.com:6082/preprocess/mobile/payment/request.do"
#else
#define kLOTTERY_MOBILE_PAYMENT_REQUEST @"http://caipiao.futongcard.com/preprocess/mobile/payment/request.do"
#endif

#define TOOLBAR_HEIGHT 44
#define kDELAYTIME 3.0

@interface FPLotteryWebViewController ()

{
    UIBarButtonItem *back;
    UIBarButtonItem *forward;
    UIBarButtonItem *home;
    
    NSString *reloadUri;
}

@property (nonatomic,strong) UIActivityIndicatorView *activity;

@end

@implementation FPLotteryWebViewController

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:IMAGE_APP_BACKGROUND];
    [view addSubview:background];
    
    self.webView = [[UIWebView alloc] initWithFrame:view.bounds];
    //self.webView.height = ScreenHigh-24;
    [view addSubview:self.webView];
    
    self.activity = [[UIActivityIndicatorView alloc] init];
    [self.activity setFrame:CGRectMake(0, 0, 80, 80)];
    [self.activity setCenter:CGPointMake(view.bounds.size.width/2, (view.bounds.size.height - 40)/2)];
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activity setHidesWhenStopped:YES];
    [self.activity setBackgroundColor:[UIColor grayColor]];
    [self.activity setAlpha:0.5];
    [view addSubview:self.activity];
    
    self.view = view;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //[self.navigationController setToolbarHidden:YES animated:NO];
    self.navigationController.navigationBar.translucent = NO;

    if (![self.activity isAnimating]) {
        [self.activity startAnimating];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ([self.activity isAnimating]) {
        [self.activity stopAnimating];
    }
}

NSString* encodeURL(NSString* unescapedString)
{

    NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)unescapedString, NULL,(CFStringRef)@"+/|%^", kCFStringEncodingUTF8 ));
    
    return escapedUrlString;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    if (self.webViewType == FPGPCLotteryViewControllerType) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.leftBarButtonItem = leftItem;
        leftItem.title = @"";
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
        [rightItem setTintColor:[UIColor orangeColor]];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        rightItem.title = @"取消";
    }
    
    FPDEBUG(@"url:%@",self.redirectUri);
    if (self.redirectUri) {
        NSURL *url = [NSURL URLWithString:self.redirectUri];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        [self.webView setScalesPageToFit:YES];
        [self.webView setBackgroundColor:[UIColor clearColor]];
        [self.webView setOpaque:NO];
        [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self.webView setDelegate:self];
    }
}

- (void)clickRightItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickLeftButton:(id)sender
{
    if ([self.activity isAnimating]) {
        [self.activity stopAnimating];
    }
    
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    if (self.webViewType == FPLotteryViewControllerTypeNoAuth) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if(self.webViewType == FPGPCLotteryViewControllerType) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        
        BOOL hasController = NO;
        for (id controller in [self.navigationController viewControllers]) {
            if ([controller isKindOfClass:[FPLotteryViewController class]]) {
                hasController = YES;
                ((FPLotteryViewController *)controller).lotteryViewType = self.webViewType;
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
        if (hasController == NO) {
            FPLotteryViewController *controller = [[FPLotteryViewController alloc] init];
            controller.lotteryViewType = self.webViewType;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.delegate = self;
            transition.subtype = kCATransitionFromLeft;
            
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:controller animated:YES];
            
        } 
    }
}

#pragma mark - webview Delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    FPDEBUG(@"url:%@",[[[request URL] relativePath] trimSpace]);
    FPDEBUG(@"webview:%@",request.mainDocumentURL.relativePath);
    
    NSString *urlString = [[[request URL] absoluteString] trimSpace];
    FPDEBUG(@"%@",urlString);
    
    if ([urlString isEqualToString:kLOTTERY_MOBILE_PAYMENT_REQUEST]) {
        NSData *data = [request HTTPBody];
        NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        urlString = [NSString stringWithFormat:@"%@?%@",urlString,strData];
        NSURL *payURL = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:payURL]) {
            
            [self clickLeftButton:nil];
            [[UIApplication sharedApplication] openURL:payURL];
            return NO;
        }
    }

    if ([urlString hasPrefix:@"objc://"]) {
        FPDEBUG(@"here");
        NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
        if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
        {
            NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"@"];
            NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
            FPDEBUG(@"arrFucnameAndParameter:%@",arrFucnameAndParameter);
            FPDEBUG(@"funcStr:%@",funcStr);
            
            if (1 == [arrFucnameAndParameter count])
            {
                // 没有参数
                if([funcStr isEqualToString:@"doFunc1"])
                {
                    
                    /*调用本地函数1*/
                    FPDEBUG(@"doFunc1");
                    
                }
            }
            else
            {
                //有参数的
                if([funcStr isEqualToString:@"onlogin_click"])
                {
                    NSString *parameter1 = [arrFucnameAndParameter objectAtIndex:1];
                    [self onClickLogin:parameter1];
                }else if ([funcStr isEqualToString:@"gpc_onlogin_click"]){
                    NSString *parameter1 = [arrFucnameAndParameter objectAtIndex:1];
                    [self gpc_onlogin_click:parameter1];
                }
            }
        }
        return NO;
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.activity isAnimating]) {
        [self.activity stopAnimating];
    }
    
    [self updateToolbarState];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad:webView];
    
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
    reloadUri = [error.userInfo objectForKey:@"NSErrorFailingURLStringKey"];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[error localizedDescription] message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"再尝试一次",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self clickLeftButton:nil];
    } else {
        if (reloadUri != nil && reloadUri.length > 0) {
            NSURL *url = [NSURL URLWithString:reloadUri];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        }
    }
}

//
-(void)onBackButton
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
-(void)onForwardButton
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
-(void)onHomePage
{
    [self clickLeftButton:nil];
}

-(void)onReloadButton
{
    [self.webView reload];
}
-(void)onStopButton
{
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateToolbarState
{
    back.enabled = [self.webView canGoBack];
    forward.enabled = [self.webView canGoForward];
}

-(void)customToolbar
{
    [self.navigationController.toolbar setTintColor:[UIColor blackColor]];
    [self.navigationController.toolbar setAlpha:0.5f];
    
    back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_BACKON] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
    
    forward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_FORWARDON] style:UIBarButtonItemStylePlain target:self action:@selector(onForwardButton)];
    
    home = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_HOME] style:UIBarButtonItemStylePlain target:self action:@selector(onHomePage)];
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpace setWidth:20.0f];
    
    NSArray *arrayItems = [NSArray arrayWithObjects:back,fixedSpace,forward,spaceButton,home, nil];
    [self setToolbarItems:arrayItems animated:NO];
}

#pragma mark - objc <--> javascript
-(void)onClickLogin:(NSString *)redirectUri
{
    FPDEBUG(@"red:%@",redirectUri);
    redirectUri = [redirectUri stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    FPDEBUG(@"red1:%@",redirectUri);
    NSString *uri = nil;
    if (self.webViewType == FPLotteryViewControllerTypeAuth) {
        NSString *uriData = [self getGenerateSign];
        if (uriData != nil) {
            if ([redirectUri rangeOfString:@"?"].location == NSNotFound) {
                uri = [NSString stringWithFormat:LOTTERYGETFORMART,redirectUri,uriData];
            } else {
                uri = [NSString stringWithFormat:LOTTERYGETFORMART_WITH_SYMBOL,redirectUri,uriData];
            }
            uri = [self replaceStr:uri];
            FPDEBUG(@"red2:%@",uri);
            NSURL *url = [NSURL URLWithString:uri];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        }
    }else{
        
//        FPLoginViewController *loginController = [[FPLoginViewController alloc] init];
//        //    [self.navigationController setHidesBottomBarWhenPushed:YES];
//        loginController.redirectUri = redirectUri;
//        [self.navigationController pushViewController:loginController animated:YES];
//        [self.navigationController setToolbarHidden:YES animated:NO];
    }
}

- (void)gpc_onlogin_click:(NSString *)redirectUri{
    FPDEBUG(@"red:%@",redirectUri);
    NSString *uri = nil;
    
    NSString *uriData = [self getGenerateGpcSign:redirectUri];
    if (uriData != nil && _gpcURL != nil) {
        if ([redirectUri rangeOfString:@"?"].location == NSNotFound) {
            uri = [NSString stringWithFormat:LOTTERYGETFORMART,_gpcURL,uriData];
        } else {
            uri = [NSString stringWithFormat:LOTTERYGETFORMART_WITH_SYMBOL,_gpcURL,uriData];
        }
        uri = [self replaceStr:uri];
        FPDEBUG(@"red2:%@",uri);
        NSURL *url = [NSURL URLWithString:uri];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }

}

-(NSString *)getGenerateSign
{
    FPLotterySign *lotterySign = [Config Instance].lotterySign;
    if (!lotterySign) {
        return nil;
    }
    
    NSString *dataStr = nil;
    NSString *encryptStr = nil;
    
    dataStr = encodeURL(lotterySign.allInfo.data);
    encryptStr = encodeURL(lotterySign.allInfo.encryptKey);
    
    NSString *urlParam = [NSString stringWithFormat:@"encryptKey=%@&data=%@",encryptStr,dataStr];
    
    return urlParam;
}

-(NSString *)getGenerateGpcSign
{
    FPLotterySign *lotterySign = [Config Instance].lotterySign;
    if (!lotterySign) {
        return nil;
    }
    
    NSString *dataStr = nil;
    NSString *encryptStr = nil;
    
    dataStr = encodeURL(lotterySign.gpcInfo.data);
    encryptStr = encodeURL(lotterySign.gpcInfo.encryptKey);
    
    NSString *urlParam = [NSString stringWithFormat:@"encryptKey=%@&data=%@",encryptStr,dataStr];
    
    return urlParam;
}
//高频彩超时情况的参数组装

-(NSString *)getGenerateGpcSign:(NSString *)paramters
{
    FPLotterySign *lotterySign = [Config Instance].lotterySign;
    if (!lotterySign) {
        return nil;
    }
    
    NSString *dataStr = nil;
    NSString *encryptStr = nil;
    
    dataStr = encodeURL(lotterySign.gpcInfo.data);
    encryptStr = encodeURL(lotterySign.gpcInfo.encryptKey);
    
    NSString *urlParam = [NSString stringWithFormat:@"encryptKey=%@&data=%@&callBackUrl=%@",encryptStr,dataStr,paramters];
    
    return urlParam;
}

-(NSString *)replaceStr:(NSString *)urlStr
{
    NSString *ret = urlStr;
    
    if (nil == urlStr) {
        return ret;
    }
    
    NSArray *repStr = @[@"#",@"|"];
    
    for (NSString *str in repStr) {
        NSString *tmp = [NSString stringWithFormat:@"%%%X",[str UTF8String][0]];
        ret = [ret stringByReplacingOccurrencesOfString:str withString:tmp];
    }
    
    return ret;
}

@end

//
//  FPPARechargeWebController.m
//  FullPayApp
//
//  Created by lc on 14-9-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPARechargeWebController.h"
#import "FPTradeBillsViewController.h"
#import "FPMyAssetViewController.h"

#define BOUNDRY @"0xKhTmLbOuNdArY"

@interface FPPARechargeWebController ()<UIWebViewDelegate,NSURLConnectionDataDelegate>
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSURLRequest *oldRequst;
@property (nonatomic) BOOL hasTrust;
@property (nonatomic) BOOL hasRecharge;

@end

@implementation FPPARechargeWebController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"快捷支付";
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    
    _hasTrust = NO;
    _hasRecharge = NO;
    [self installCustom];

    // Do any additional setup after loading the view.
}

- (void)installCustom
{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;

    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    //    [UtilTool showHUD:@"正在检查" andView:self.view andHUD:hud];
    
    [self.view addSubview:self.hud];
    
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
    NSLog(@"urlstr:%@",_urlString);
    //_urlString = [NSString stringWithFormat:@"http://10.186.255.32:8080/merchant-demo/test.jsp"];
    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:url];
    request.timeoutInterval = 20;
    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=UTF-8"] forHTTPHeaderField:@"Content-Type"];
    
    NSData *postData = [self getParamtersStringWith:_paramters];
   // NSString *jsonS = [[NSString alloc]initWithData:post encoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [self.webView loadRequest:request];
    [self.webView setScalesPageToFit:YES];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.webView setDelegate:self];
    
}

- (void)click_LeftButton:(UIButton *)sender{
    if (_hasRecharge) {
        NSArray *controllers = self.navigationController.viewControllers;
        for (UIViewController *controller in controllers) {
            if ([controller isKindOfClass:NSClassFromString(@"FPRechargeConfirmViewController")]) {
                [self.navigationController popToViewController:controller animated:NO];
                
                return;
            }
        }
        
        [self.navigationController popToRootViewControllerAnimated:NO];

    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [request.URL scheme];
    NSLog(@"scheme = %@",scheme);
    
    NSString *urlString = [[[request URL] absoluteString] trimSpace];
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
                NSString *funcStr1 = [arrFucnameAndParameter objectAtIndex:1];
                //有参数的
                if([funcStr1 isEqualToString:@"MyAssets"])
                {
                    //NSString *parameter1 = [arrFucnameAndParameter objectAtIndex:1];
                    // 跳到我的资产页面
                    [self onClicklogin:funcStr1];
                }else if ([funcStr1 isEqualToString:@"TradeBill"]){
                    //NSString *parameter1 = [arrFucnameAndParameter objectAtIndex:1];
                    // 跳到交易账单页面
                    [self onClicklogin:funcStr1];
                }
            }
        }
        return NO;
    }
    
    //判断是不是https
    if ([scheme isEqualToString:@"https"] && _hasTrust == NO) {
        _oldRequst = request;
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
        [webView stopLoading];
        return NO;
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
    if ([webView canGoBack]) {
        _hasRecharge = YES;
    }
    
    if (self.bankCardNO.length>0) {
        NSString *js_string_focus = [NSString stringWithFormat:@"document.getElementsByName('cardNumber')[0].focus();"];
        [webView stringByEvaluatingJavaScriptFromString:js_string_focus];
        
        NSString *js_string = [NSString stringWithFormat:@"document.getElementsByName('cardNumber')[0].value='%@';",self.bankCardNO];
        [webView stringByEvaluatingJavaScriptFromString:js_string];
        
        NSString *js_string_f = [NSString stringWithFormat:@"document.getElementsByName('cardNumber')[0].blur();"];
        [webView stringByEvaluatingJavaScriptFromString:js_string_f];
        
       /// NSString *js_string_foc = [NSString stringWithFormat:@"document.getElementsById('selectBankTypesLi')[0].focus();"];
       // [webView stringByEvaluatingJavaScriptFromString:js_string_foc];

    }
  
//    NSString *lJs = @"document.documentElement.innerHTML";
//    NSString *lHtml1 = [webView stringByEvaluatingJavaScriptFromString:lJs];
//    FPDEBUG(@"%@",lHtml1);
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.hud hide:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection%@  %zd",[[challenge protectionSpace] authenticationMethod],(ssize_t)[challenge previousFailureCount]);
    
    if ([challenge previousFailureCount] == 0)
    {
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}
#pragma mark ================= NSURLConnectionDataDelegate <nsurlconnectiondelegate>
        
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    
    NSLog(@"%@",request);
    return request;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _hasTrust = YES;

    //webview 重新加载请求。
    [self.webView loadRequest:_oldRequst];
    [connection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData *)getParamtersStringWith:(NSDictionary *)paramter{
    NSArray *keyArray = [paramter allKeys];
    NSMutableString *string = [[NSMutableString alloc]init];
    for (NSString *key in keyArray) {
        
        id value = [paramter objectForKey:key];
        if (value == [NSNull null]) {
            value = @"";
        }

        NSString *temp = [NSString stringWithFormat:@"%@=%@&",key,value];
        
        [string appendString:temp];
    }
    
    if (string.length>0) {
        NSString *result = [string substringToIndex:string.length-1];
        NSData *postData = [result dataUsingEncoding:NSUTF8StringEncoding];
        return postData;
    }
    
    return nil;
}

/*
 * funcStr:根据此字符串检测是跳转到我的资产还是交易账单页面
 * MyAssets 我的资产 TradeBill 交易账单
 */
- (void)onClicklogin:(NSString *)funcStr
{
    if (![Config Instance].isAutoLogin) {
        return;
    }
    
    if ([funcStr isEqualToString:@"MyAssets"]) {
        // 我的资产
        FPMyAssetViewController *controller = [[FPMyAssetViewController alloc] init];
        controller.accountItem = [Config Instance].accountItem;
        [self.navigationController pushViewController:controller animated:YES];
              
    }else if ([funcStr isEqualToString:@"TradeBill"]){
        // 交易账单
        FPTradeBillsViewController *controller = [[FPTradeBillsViewController alloc] initWithNibName:nil bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

@end

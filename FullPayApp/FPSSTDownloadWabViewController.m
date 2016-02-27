//
//  FPSSTDownloadWabViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 14-9-24.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPSSTDownloadWabViewController.h"

#define IMAGE_APP_BACKGROUND @"BG"
#define BUTTON_BACKOFF @"web_BtnBackoff.png"
#define BUTTON_BACKON @"web_BtnBackon.png"
#define BUTTON_FORWARDOFF @"web_BtnForwardoff.png"
#define BUTTON_FORWARDON @"web_BtnForwardon.png"
#define BUTTON_HOME @"web_BtnHome.png"
#define IMAGE_TOOLBAR_BACK @"Img-toolbar-back.png"

#define TOOLBAR_HEIGHT 44
#define kDELAYTIME 2.0
@interface FPSSTDownloadWabViewController ()<UIWebViewDelegate>{
    UIBarButtonItem *back;
    UIBarButtonItem *forward;
    UIBarButtonItem *home;
    BOOL isHomePage;
    BOOL isClickHome;
}
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation FPSSTDownloadWabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setToolbarHidden:YES];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden  = NO;

}
- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:ScreenBounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"随手淘";
    isClickHome = YES;
    
    [self installCustom];
    [self customToolbar];
    // Do any additional setup after loading the view.
}

- (void)installCustom
{
    self.webView = [[UIWebView alloc] initWithFrame:ScreenBounds];
    self.webView.delegate = self;
    self.webView.height = ScreenHigh-45;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    //    [UtilTool showHUD:@"正在检查" andView:self.view andHUD:hud];
    
    [self.view addSubview:self.hud];
    
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
    
    NSURL *url = [NSURL URLWithString:kSST_DOWNLOAD];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:url];
    request.timeoutInterval = 20;
    
    [self.webView loadRequest:request];
    [self.webView setScalesPageToFit:YES];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.webView setDelegate:self];
    
}

-(void)customToolbar
{
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHigh-110, ScreenWidth, 50)];
    [_toolBar setTintColor:[UIColor blackColor]];
    //[toolBar setAlpha:0.5f];
    back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_BACKON] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
    
    forward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_FORWARDON] style:UIBarButtonItemStylePlain target:self action:@selector(onForwardButton)];
    
    home = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_HOME] style:UIBarButtonItemStylePlain target:self action:@selector(onHomePage)];
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpace setWidth:20.0f];
    
    NSArray *arrayItems = [NSArray arrayWithObjects:back,fixedSpace,forward,spaceButton,home, nil];
    [_toolBar setItems:arrayItems];
    [self.view addSubview:_toolBar];

    //[self setToolbarItems:arrayItems animated:NO];
}

#pragma mark button actions
-(void)onBackButton
{   isClickHome = NO;
    ///fulllife-web/groupbuy/input_psw.do
    if ([self.webView canGoBack]) {
     [self.webView goBack];
    }
}
-(void)onForwardButton
{
    isClickHome = NO;
    isHomePage = NO;
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

-(void)onHomePage
{
    isClickHome = YES;
    [self setNaviagtionHidden];
    NSURL *url = [NSURL URLWithString:kSST_DOWNLOAD];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

/* 设计3秒之后隐藏navigationbar状态条 ，进入主页时，显示状态条*/
-(void)setNaviagtionHidden
{
    /*因为self.timer是strong类型的，所以每次调用最好检查一下，这是一种方法，也可以放在handle方法里面，执行结束后来进行，依个人喜好了。*/
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kDELAYTIME target:self selector:@selector(handleHiddenNavigationbar:) userInfo:nil repeats:NO];
}

-(void)handleHiddenNavigationbar:(NSTimer *)timer
{
    if (![self.navigationController isNavigationBarHidden]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 64);
            _toolBar.transform = transform;
        }];
    
    }
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
    
    NSLog(@"didfinishLoad");
    NSLog(@"url:%@",[webView.request.URL absoluteString]);
    NSLog(@"webview:%@",webView.request.mainDocumentURL.relativePath);
    
    NSString *urlPath = [webView.request.URL absoluteString];
    if (urlPath != nil && urlPath.length > 0) {
        if ([urlPath isEqualToString:kSST_DOWNLOAD] && isClickHome) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
                _toolBar.transform = transform;
            }];
            
            [self setNaviagtionHidden];
            isHomePage = YES;
        } else {
            if (![self.navigationController isNavigationBarHidden]) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                
                [UIView animateWithDuration:0.2 animations:^{
                    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 64);
                    _toolBar.transform = transform;
                }];
            }
            
            isHomePage = NO;
        }
        
     
    }
    
    forward.enabled = [self.webView canGoForward];

    if (isHomePage) {
        back.enabled = NO;
    } else {
        back.enabled = [self.webView canGoBack];
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

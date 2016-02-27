//
//  FPHelpViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-25.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPHelpViewController.h"

#define IMAGE_APP_BACKGROUND @"BG.png"
#define BUTTON_BACKOFF @"web_BtnBackoff.png"
#define BUTTON_BACKON @"web_BtnBackon.png"
#define BUTTON_FORWARDOFF @"web_BtnForwardoff.png"
#define BUTTON_FORWARDON @"web_BtnForwardon.png"
//#define BUTTON_HOME @"web_BtnHome.png"
//#define IMAGE_TOOLBAR_BACK @"Img-toolbar-back.png"

@interface FPHelpViewController ()
{
    UIBarButtonItem *back;
    UIBarButtonItem *forward;
    UIBarButtonItem *refresh;
}

@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSString *helpUri;

@end

@implementation FPHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
//    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:IMAGE_APP_BACKGROUND];
    [view addSubview:background];
    
    self.webView = [[UIWebView alloc] initWithFrame:view.bounds];
    [view addSubview:self.webView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    //    [UtilTool showHUD:@"正在检查" andView:self.view andHUD:hud];
    
    [view addSubview:self.hud];
    
    self.view = view;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hud hide:YES];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"帮助";
    [self customToolbar];
    
    self.helpUri = [NSString stringWithFormat:@"%@/app/help.html",[FPClient ServerAddress]];
    
    NSURL *url = [NSURL URLWithString:self.helpUri];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setScalesPageToFit:YES];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.webView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customToolbar
{
//    self.navigationController.toolbar setFrame:<#(CGRect)#>
    [self.navigationController.toolbar setTintColor:[UIColor blackColor]];
    [self.navigationController.toolbar setAlpha:0.5f];
    
    back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_BACKON] style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
    
    forward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_FORWARDON] style:UIBarButtonItemStylePlain target:self action:@selector(onForwardButton)];
    
    //    refresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_REFRESH] style:UIBarButtonItemStylePlain target:self action:@selector(onReloadButton)];
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpace setWidth:20.0f];
    
    NSArray *arrayItems = [NSArray arrayWithObjects:back,fixedSpace,forward,spaceButton, nil];
    [self setToolbarItems:arrayItems animated:NO];
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad:webView];
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

@end

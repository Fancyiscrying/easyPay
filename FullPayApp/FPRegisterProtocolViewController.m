//
//  FPRegisterProtocolViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-24.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRegisterProtocolViewController.h"

@interface FPRegisterProtocolViewController () <UIWebViewDelegate>

@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation FPRegisterProtocolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [self.hud hide:YES];
}

/* loadView 只有在不使用xib时，由开发者自己制定view时实现，
 调用顺序是 init 、loadview、viewDidLoad、viewWillAppear、viewDidAppear
 在使用self.view而view为nil时，就会调用loadview，开发者不要自己调用之
 如果有xib，那么编译器就会忽视loadview，而且开发者也不应该实现loadview
 在loadview中绘图，在viewDidLoad中进一步完善
 在loadview中永远不要[super loadview]
 
 注解：在使用loadview和没有使用的情况下，由于webview在viewdidl中加载
 使得在activity消失后有一个空窗期，体验不是很好。使用loadview效果好很多。
 */
-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.image = [UIImage imageNamed:@"BG"] ;
    
    [self.view addSubview:background];
    
    CGRect webRect = self.view.bounds;
//    webRect.origin.y = 64.0f;
    self.webView = [[UIWebView alloc] initWithFrame:webRect];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    
    [view addSubview:self.hud];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"使用条款和隐私政策";
    
    NSString *path = [NSString stringWithFormat:@"%@/app/agreement.html",[FPClient ServerAddress]];
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
    [self.webView setScalesPageToFit:YES];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.webView setDelegate:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end

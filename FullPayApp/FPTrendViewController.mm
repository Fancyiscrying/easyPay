//
//  FPTrendViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-12.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPTrendViewController.h"

#define DYNAMIC @"/app/dynamic.html"
#define Dalibao @"/app/dalibao.html"

#define BUTTON_BACKON @"recharge_bt_back.png"


@interface FPTrendViewController ()

@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSString *trendUri;
@property (nonatomic,strong) UIButton *back;
@property (nonatomic,strong) NSString * url;

@end

@implementation FPTrendViewController

static NSString *myTableViewCellIndentifier = @"itemTrendCell";

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
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hud hide:YES];
    
    if (self.trendType == FPTrendTypeDalibao) {
        _back.hidden = YES;
    }else if (self.trendType == FPTrendTypeDynmic){
    
        if (!self.webView.canGoBack) {
            _back.hidden = YES;
        }
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.trendType == FPTrendTypeDynmic) {
        self.navigationItem.title = @"动态播报";
        self.url = DYNAMIC;
        [self installCustom];
    }else if (self.trendType == FPTrendTypeDalibao){
        self.navigationItem.title = @"大礼包";
        self.url = Dalibao;
        
        [self postFulllifeService];
    }
    
    _back = [UIButton buttonWithType:UIButtonTypeCustom];
    _back.frame = CGRectMake(5, 12, 20, 20);
    [_back setImage:[UIImage imageNamed:BUTTON_BACKON] forState:UIControlStateNormal];
    _back.backgroundColor = [UIColor clearColor];
    [_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    _back.hidden = YES;
    [self.navigationController.navigationBar addSubview:_back];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back:sender{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)postFulllifeService
{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client userfulllifeService];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        if (result) {
            self.url = [responseObject objectForKey:@"returnObj"];
            [self installCustom];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        
    }];

}

- (void)installCustom
{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    //    [UtilTool showHUD:@"正在检查" andView:self.view andHUD:hud];
    
    [self.view addSubview:self.hud];
    
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
    NSString *service = [FPClient ServerAddress];
    
    NSString *urlStr;
    
    if (self.trendType == FPTrendTypeDynmic) {
        urlStr = [NSString stringWithFormat:@"%@%@",service,self.url];
    }else if (self.trendType == FPTrendTypeDalibao){
        urlStr = self.url;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
    [self.webView setScalesPageToFit:YES];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.webView setDelegate:self];

}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UtilTool showHUD:@"正在加载" andView:self.view andHUD:self.hud];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
    self.back.hidden = !webView.canGoBack;

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad:webView];
}


@end

//
//  FPGroupBuyViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPGroupBuyViewController.h"

#define IMAGE_APP_BACKGROUND @"BG"
#define BUTTON_BACKOFF @"web_BtnBackoff.png"
#define BUTTON_BACKON @"web_BtnBackon.png"
#define BUTTON_FORWARDOFF @"web_BtnForwardoff.png"
#define BUTTON_FORWARDON @"web_BtnForwardon.png"
#define BUTTON_HOME @"web_BtnHome.png"
#define IMAGE_TOOLBAR_BACK @"Img-toolbar-back.png"

#define TOOLBAR_HEIGHT 44
#define kDELAYTIME 3.0

@interface FPGroupBuyViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIBarButtonItem *back;
    UIBarButtonItem *forward;
    UIBarButtonItem *home;
    BOOL isHomePage;
    
    NSString *reloadUri;
}

@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation FPGroupBuyViewController

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
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:IMAGE_APP_BACKGROUND];
    [view addSubview:background];
    
    CGRect  webRect = view.bounds;
    webRect.size.height -= 44;
    
    self.webView = [[UIWebView alloc] initWithFrame:webRect];
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
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO];
    if (![self.activity isAnimating]) {
        [self.activity startAnimating];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES];
    if ([self.activity isAnimating]) {
        [self.activity stopAnimating];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"团购";
    self.navigationController.navigationBar.translucent = NO;
    [self customToolbar];
    
    if (self.redirectUri) {
        NSURL *url = [NSURL URLWithString:self.redirectUri];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        [self.webView setScalesPageToFit:YES];
        [self.webView setBackgroundColor:[UIColor clearColor]];
        [self.webView setOpaque:NO];
        [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self.webView setDelegate:self];
        self.webView.scrollView.delegate = self;
    }
}

-(void)clickLeftButton:(id)sender
{
    
    if ([self.activity isAnimating]) {
        [self.activity stopAnimating];
    }
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    if (self.groupViewType == FPGroupBuyViewControllerTypeNoAuth) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        BOOL hasController = NO;
        for (id controller in [self.navigationController viewControllers]) {
            if ([controller isKindOfClass:[FPViewController class]]) {
                hasController = YES;
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
        if (hasController == NO) {
            FPViewController *controller = [[FPViewController alloc] init];
            //            controller.personMember = [Config Instance].personMember;
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
    NSLog(@"url:%@",[[[request URL] relativePath] trimSpace]);
    NSLog(@"webview:%@",request.mainDocumentURL.relativePath);
    
    //    if (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeOther) {
    
    NSString *lJs = @"document.documentElement.innerHTML";
    NSString *lHtml1 = [webView stringByEvaluatingJavaScriptFromString:lJs];
    NSLog(@"***********************%@",lHtml1);
    
    NSString *urlString = [[[request URL] absoluteString] trimSpace];
    NSLog(@"%@",urlString);
    if ([urlString hasPrefix:@"objc://"]) {
        NSLog(@"here");
        NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
        if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
        {
            NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"@"];
            NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
            NSLog(@"arrFucnameAndParameter:%@",arrFucnameAndParameter);
            NSLog(@"funcStr:%@",funcStr);
            
            if (1 == [arrFucnameAndParameter count])
            {
                // 没有参数
                if([funcStr isEqualToString:@"doFunc1"])
                {
                    
                    /*调用本地函数1*/
                    NSLog(@"doFunc1");
                    
                }
            }
            else
            {
                //有参数的
                if([funcStr isEqualToString:@"onlogin_click"])
                {
                    NSString *parameter1 = [arrFucnameAndParameter objectAtIndex:1];
                    [self onClickLogin:parameter1];
                }
                else if([funcStr isEqualToString:@"onrecharge_click"])
                {
                    NSString *parameter1 = [arrFucnameAndParameter objectAtIndex:1];
                    [self onClickRecharge:parameter1];
                }
            }
        }
        return NO;
    }
    
    if (![request.mainDocumentURL.relativePath isEqualToString:kMainWebUri]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        isHomePage = NO;
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"didfinishLoad");
    NSLog(@"url:%@",[[[webView.request URL] relativePath] trimSpace]);
    NSLog(@"webview:%@",webView.request.mainDocumentURL.relativePath);

    NSString *urlPath = webView.request.mainDocumentURL.relativePath;
    if (urlPath != nil && urlPath.length > 0) {
        if ([urlPath isEqualToString:kMainWebUri]) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self setNaviagtionHidden];
            isHomePage = YES;
        } else {
            if (![self.navigationController isNavigationBarHidden]) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }
            
            isHomePage = NO;
        }
        
        if ([urlPath isEqualToString:kOrderUri]) {
            forward.enabled = NO;
        } else {
            forward.enabled = [self.webView canGoForward];
        }
    } else {
        forward.enabled = [self.webView canGoForward];
    }
    
    if ([self.activity isAnimating]) {
        [self.activity stopAnimating];
    }

    if (isHomePage) {
        back.enabled = NO;
    } else {
        back.enabled = [self.webView canGoBack];
    }
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
    ///fulllife-web/groupbuy/input_psw.do
    if ([self.webView canGoBack]) {
        FPDEBUG(@"back:%@",[[self.webView.request URL] relativePath]);
        NSString *strUri = [[self.webView.request URL] relativePath];
        if ([strUri isEqualToString:kPayPageUri] || [strUri isEqualToString:kPayResultUri]) {
            [self onHomePage];
        } else {
            [self.webView goBack];
        }
    }
}
-(void)onForwardButton
{
    isHomePage = NO;
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
-(void)onHomePage
{
    NSString *memberNo = [Config Instance].memberNo;
    NSString *result = [memberNo md5Twice:[memberNo substringWithRange:NSMakeRange(1, 10)]];
    
    NSString *uri = nil;
    if (self.groupViewType == FPGroupBuyViewControllerTypeNoAuth) {
        uri = [NSString stringWithFormat:FORMAT_GROUP,kGROUPBUY_BASEURI,kMainWebUri,@"",@""];
    } else {
        uri = [NSString stringWithFormat:FORMAT_GROUP,kGROUPBUY_BASEURI,kMainWebUri,memberNo,result];
    }
    
    NSURL *url = [NSURL URLWithString:uri];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
    }
}
#pragma mark - uiscrolldelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*加上同步操作非常必要，因为scrollviewdidscroll在contentoffset每次变化时都会调用，所以如果不加上下面的操作，很有可能造成内存不足的情况，而且频繁的调用，也会对想要的效果有些影响。*/
    @synchronized(scrollView){
        if (isHomePage) {
            if (scrollView.contentOffset.y > 0.0) {
                if (![self.navigationController isNavigationBarHidden]) {
                    [self.navigationController setNavigationBarHidden:YES animated:YES];
                }
            } else {
                if ([self.navigationController isNavigationBarHidden]) {
                    [self.navigationController setNavigationBarHidden:NO animated:YES];
                    [self setNaviagtionHidden];
                }
            }
        }
    }
}

#pragma mark - objc <--> javascript
-(void)onClickLogin:(NSString *)redirectUri
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSString *memberNo = [Config Instance].memberNo;
    NSString *result = [memberNo md5Twice:[memberNo substringWithRange:NSMakeRange(1, 10)]];
    
    NSString *uri = nil;
    if (self.groupViewType == FPGroupBuyViewControllerTypeAuth) {
        uri = [NSString stringWithFormat:FORMAT_GROUP,kGROUPBUY_BASEURI,kMainWebUri,memberNo,result];
        NSURL *url = [NSURL URLWithString:uri];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    } else {
        

    }
}

-(void)onClickRecharge:(NSString *)redirectUri
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [UtilTool setHomeViewRootController];
    
}

@end

//
//  FPDimScanViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPDimScanViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FPPayAmtViewController.h"
#import "FPDimScanPayViewController.h"
#import "FPRedPacketReceiveViewController.h"
#import "AESCrypt.h"

#define kScanRect CGRectMake((ScreenWidth-220)/2, 60, 220, 220)

@interface FPDimScanViewController ()<UIAlertViewDelegate>

@property BOOL hasSetFocus;

@end

@implementation FPDimScanViewController

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    if (_session != nil && timer != nil) {
        [_session startRunning];
        [timer setFireDate:[NSDate date]];
    }
  
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    if (_viewComeFrom == DimScanViewComeFromHomePage) {
        self.navigationItem.title = @"二维码支付";
    }else if(_viewComeFrom == DimScanViewComeFromRedPackte){
        self.navigationItem.title = @"领红包";
    }
    
    UIBarButtonItem *Item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem setLeftBarButtonItem:Item];
    
//    CALayer *topBlur = [CALayer layer];
//    topBlur.backgroundColor = [UIColor blackColor].CGColor;
//    topBlur.frame = self.view.frame;
//    topBlur.opacity = 0.8;
//    [self.view.layer addSublayer:topBlur];
    [self setCropRect:kScanRect];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 300, 290, 40)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.font = [UIFont systemFontOfSize:12.0f];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.text=@"将二维码放入框内，即可自动扫描";
    [self.view addSubview:labIntroudction];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth -220)/2, 70, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.02];

}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 70+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 70+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)backAction
{
    [timer invalidate];

    [self.navigationController popViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:^{
   // }];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    

    [_output setRectOfInterest:CGRectMake((124)/ScreenHigh,((ScreenWidth-220)/2)/ScreenWidth, 220/ScreenHigh, 220/ScreenWidth)];
    
    NSLog(@"rectOfInterest:%@",NSStringFromCGRect(self.view.frame));
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];

    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;

    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        if (_viewComeFrom == DimScanViewComeFromHomePage) {
            [self anylistMessage:stringValue];
        }else if (_viewComeFrom == DimScanViewComeFromRedPackte){
            [self anylistRedPackteReceiveNo:stringValue];
        }
        
        
    } else {
        NSLog(@"无扫描信息");
        return;
    }
    
    NSLog(@"metadataObjects:%@,%@",metadataObjects,captureOutput);
    AudioServicesPlaySystemSound(1012);
    return;
    
    [_session stopRunning];
    
    if (![self.presentedViewController isBeingDismissed]) {
        [self dismissViewControllerAnimated:NO completion:^
         {
             [timer invalidate];
             NSLog(@"%@",stringValue);
         }];
    }
}

- (void)anylistMessage:(NSString *)message{
    if ([message hasPrefix:@"[fzf]"]) {
        [self anylistSecretMessage:message];
    }else if([message hasPrefix:@"[redpacket]"]){
        [self anylistRedPackteReceiveNo:message];
    }else{
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"非法的二维码,请重新确认后扫描!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描", nil];
        alert.tag = 101;
        [alert show];
        return;
    }
}

- (void)anylistRedPackteReceiveNo:(NSString *)message{
    if (message.length < 11) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"非法的红包二维码,请重新确认后扫描!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描", nil];
        alert.tag = 101;
        [alert show];
        return;
    }
    
    //NSLog(@"message:%@",message);
    NSString *title = [message substringToIndex:11];
    NSString *mes = [message substringFromIndex:11];
    mes = [AESCrypt decrypt:mes password:AESEncryKey];

    //检验是否是富之富二维码
    if ([title isEqualToString:@"[redpacket]"]) {
        
        FPRedPacketReceiveViewController *controller = [[FPRedPacketReceiveViewController alloc]init];
        controller.receiveNo = mes;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"非法的红包二维码,请重新确认后扫描!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描", nil];
        alert.tag = 101;
        [alert show];
    }

}

- (void)anylistSecretMessage:(NSString *)message{
    if (message.length < 5 || message == nil) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"非法的富之富二维码名片,请重新确认后扫描!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描", nil];
        alert.tag = 101;
        [alert show];
        return;
    }
    
    //NSLog(@"message:%@",message);
    NSString *title = [message substringToIndex:5];
    NSString *mes = [message substringFromIndex:5];
    
    //检验是否是富之富二维码
    if ([title isEqualToString:@"[fzf]"]) {
        mes = [AESCrypt decrypt:mes password:AESEncryKey];
       // NSLog(@"aesMes:%@",mes);
        NSArray *array = [mes componentsSeparatedByString:@"|"];
        //NSLog(@"富之富二维码%@",array);
        NSString *telNumber = array[0];
        NSString *name = array[1];
        if ([telNumber checkTel]) {
            ContactsInfo  *transferData = [[ContactsInfo alloc]init];
            transferData.toMemberPhone = telNumber;
            transferData.toMemberName = name;
            /*
            FPPayAmtViewController *controller = [[FPPayAmtViewController alloc]init];
            controller.showPhoneNumberField = NO;
            controller.isFromDimScanViewController = YES;
            controller.toTelNumber = telNumber;
            controller.toName = array[1];
             */
            
            FPClient *client = [FPClient sharedClient];
            NSDictionary *paramters = [client findPersonMemberExistByMobile:telNumber];
            [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                BOOL result = [[responseObject objectForKey:@"result"]boolValue];
                if (result) {
                    BOOL returnObj = [[responseObject objectForKey:@"returnObj"] boolValue];
                    if (returnObj) {
                        FPDimScanPayViewController *controller = [[FPDimScanPayViewController alloc]init];
                        controller.transferData = transferData;
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"会员不存在" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描", nil];
                        alert.tag = 101;
                        [alert show];
                    }
                    
                }else{
                    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"非法的富之富二维码名片,请重新确认后扫描!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描", nil];
                    alert.tag = 101;
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
                
            }];
            
        }else{
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"非法的富之富二维码名片,请重新确认后扫描!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描", nil];
            alert.tag = 101;
            [alert show];
        }
    }else{
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"非法的富之富二维码名片,请重新确认后扫描!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描", nil];
        alert.tag = 101;
        [alert show];
    }
}

#pragma mark----UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 1) {
        [_session startRunning];
        [timer setFireDate:[NSDate date]];

    }
    
    if (alertView.tag == 101 && buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCropRect:(CGRect)cropRect
{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}

@end

//
//  FPAddFutongCardViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-20.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPAddFutongCardViewController.h"

@interface FPAddFutongCardViewController () <UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, strong) NSString *signCode;
@property (nonatomic, strong) NSString *remark;

@end

@implementation FPAddFutongCardViewController

const NSInteger kFieldTag = 100;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    self.view = view;
    
    self.fld_CardNo = [[ZHTextField alloc] init];
    self.fld_CardNo.frame = CGRectMake(20, 22, 280, 45);
    self.fld_CardNo.placeholder = @"富通卡卡号";
    self.fld_CardNo.textAlignment = NSTextAlignmentLeft;
    self.fld_CardNo.backgroundColor = [UIColor whiteColor];
    self.fld_CardNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_CardNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_CardNo.keyboardType = UIKeyboardTypeNumberPad;
    self.fld_CardNo.delegate = self;
    self.fld_CardNo.tag = kFieldTag;
    [view addSubview:self.fld_CardNo];
    
    self.fld_SignCode = [[ZHTextField alloc] init];
    self.fld_SignCode.frame = CGRectMake(20, 70, 280, 45);
    self.fld_SignCode.placeholder = @"注册码";
    self.fld_SignCode.textAlignment = NSTextAlignmentLeft;
    self.fld_SignCode.backgroundColor = [UIColor whiteColor];
    self.fld_SignCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_SignCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_SignCode.keyboardType = UIKeyboardTypeNumberPad;
    self.fld_SignCode.delegate = self;
    self.fld_SignCode.tag = kFieldTag + 1;
    [view addSubview:self.fld_SignCode];
    
    self.fld_Remark = [[ZHTextField alloc] init];
    self.fld_Remark.frame = CGRectMake(20, 125, 280, 45);
    self.fld_Remark.placeholder = @"为该卡设置一个备注名";
    self.fld_Remark.textAlignment = NSTextAlignmentLeft;
    self.fld_Remark.backgroundColor = [UIColor whiteColor];
    self.fld_Remark.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_Remark.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_Remark.keyboardType = UIKeyboardTypeDefault;
    self.fld_Remark.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:self.fld_Remark];
    
    _btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_NextStep.frame = CGRectMake(20, 180, 280, 45);
    [_btn_NextStep setBackgroundColor:[UIColor orangeColor]];
    [_btn_NextStep setTitle:@"确定" forState:UIControlStateNormal];
    [_btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btn_NextStep];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"添加富通卡";
    
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_CardNo isFirstResponder]) {
        [self.fld_CardNo resignFirstResponder];
    }
    
    if ([self.fld_SignCode isFirstResponder]) {
        [self.fld_SignCode resignFirstResponder];
    }
    
    if ([self.fld_Remark isFirstResponder]) {
        [self.fld_Remark resignFirstResponder];
    }
}

- (void)click_NextStep:(UIButton *)sender
{
    self.cardNo = [self.fld_CardNo.text trimOnlySpace];
    self.signCode = [self.fld_SignCode.text trimOnlySpace];
    
    if ([self.cardNo checkPrepayCardNo] == NO) {
        [self.fld_CardNo becomeFirstResponder];
        return;
    }
    if ([self.signCode checkRegisterCode] == NO) {
        [self.fld_SignCode becomeFirstResponder];
        return;
    }
    
    self.remark = [self.fld_Remark.text trimSpace];
    if (self.remark.length > kCardRemarkMaxLength) {
        self.remark = [self.remark substringToIndex:kCardRemarkMaxLength];
    }
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userCardBindCheck:memberNo andCardNo:self.cardNo andSignCode:self.signCode];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理中" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *object = [responseObject objectForKey:@"returnObj"];
            NSLog(@"%@",object);
            double cashAmount = [[object objectForKey:@"cashAmount"] doubleValue];
            NSString *memberNo = [Config Instance].memberNo;
            NSMutableString *message = [NSMutableString stringWithCapacity:50];
            [message appendFormat:@"卡号：%@\n",self.cardNo];
            [message appendFormat:@"卡内金额：%.02f 元\n",cashAmount/100];
            [message appendFormat:@"将添加到您的账号:%@\n",memberNo];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"卡绑定" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"绑定卡失败" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userCardBinding:memberNo andCardNo:self.cardNo andSignCode:self.signCode andCardRemark:self.remark];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理中" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            [self showToastMessage:@"绑卡成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"绑定卡失败" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

#pragma mark - delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string checkNumber]) {
        return YES;
    }
    
    NSMutableString *temp = [NSMutableString stringWithString:textField.text];
    [temp insertString:string atIndex:range.location];
    
    NSString *tempStr = [temp trimOnlySpace];
    NSMutableString *text = [NSMutableString stringWithString:tempStr];
    
    int rem = tempStr.length%4;
    int con = (int)tempStr.length/4;
    if (rem == 0) {
        con = con -1;
    }
    for (int i=1; i<=con; i++) {
        [text insertString:@" " atIndex:(4*i+(i-1))];
    }
    
    NSInteger fieldLen = 0;
    if (textField.tag == kFieldTag) {
        fieldLen = 20;
    } else {
        fieldLen = 10;
    }

    if(text.length>=fieldLen){
        
        [textField setText:[text substringToIndex:fieldLen]];
        [textField resignFirstResponder];

        return NO;
        
    }
    textField.text = text;
    
    [textField setBankCardTextFieldCursorWithRange:range];
    
    return NO;
}

@end

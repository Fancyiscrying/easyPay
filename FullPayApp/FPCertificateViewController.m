//
//  FPCertificateViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPCertificateViewController.h"
#import "FPIdVerifyConfirmViewController.h"
#import "AFFNumericKeyboard.h"

@interface FPCertificateViewController () <UITextFieldDelegate,AFFNumericKeyboardDelegate>
{
    AFFNumericKeyboard *keyboard;
}

@end

@implementation FPCertificateViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.view = view;
    
    self.fld_CertNo = [[ZHTextField alloc] init];
    self.fld_CertNo.frame = CGRectMake(0, 20, 320, 50);
    self.fld_CertNo.placeholder = @"证件号码:(不区分大小写)";
    self.fld_CertNo.textAlignment = NSTextAlignmentLeft;
    self.fld_CertNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_CertNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_CertNo.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.fld_CertNo.backgroundColor = [UIColor whiteColor];
    self.fld_CertNo.delegate = self;
    
    keyboard = [[AFFNumericKeyboard alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216, 320, 216)];
    self.fld_CertNo.inputView = keyboard;
    keyboard.delegate = self;
    [self.view addSubview:self.fld_CertNo];

    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 90, 290, 45);
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_NextStep.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.btn_NextStep.enabled = NO;
    [self.view addSubview:self.btn_NextStep];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"身份证件信息 2/3";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_CertNo isFirstResponder]) {
        [self.fld_CertNo resignFirstResponder];
    }
}

-(void)click_NextStep:(id)sender
{
    self.idVerifyInfo.certTypeName = @"身份证号码";
    self.idVerifyInfo.certType = @"I_CARD";
    self.idVerifyInfo.certNo = [self.fld_CertNo.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![self.idVerifyInfo.certNo checkIdCard]) {
        return;
    };

    FPIdVerifyConfirmViewController *controller = [[FPIdVerifyConfirmViewController alloc] init];
    controller.idVerifyInfo = self.idVerifyInfo;
    controller.result = YES;
    [self.navigationController pushViewController:controller animated:YES];
//    [self certTypeCheck];
}

-(void)certTypeCheck
{
    NSString *memberNo = [Config Instance].memberNo;
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userCertCheck:memberNo andCertNo:self.idVerifyInfo.certNo andCertTypeCode:self.idVerifyInfo.certType];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理中" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        
        FPIdVerifyConfirmViewController *controller = [[FPIdVerifyConfirmViewController alloc] init];
        controller.idVerifyInfo = self.idVerifyInfo;
        controller.result = [[responseObject objectForKey:@"result"] boolValue];
        [self.navigationController pushViewController:controller animated:YES];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField text];
    if (text) {
        self.btn_NextStep.enabled = YES;
    }
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    [textField setText:newString];
    
    NSInteger fieldLen = 18;
    NSString *trimSpaceString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (trimSpaceString.length >= fieldLen) {
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
        return NO;
    }
    
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:range.location+1];
    UITextPosition *end = [textField positionFromPosition:start offset:0];
    UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
    
    textField.selectedTextRange = textRange;
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *text = textField.text;
    if (text.length > 0) {
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }
}

#pragma mark - AFNumbericDelegate

-(void)changeKeyboardType
{
    [self passcodeValue:@"X"];
}

-(void)numberKeyboardBackspace
{
    if (self.fld_CertNo.text.length != 0)
    {
        //推算出光标的位置
        UITextRange *textRange = self.fld_CertNo.selectedTextRange;
        UITextPosition *start = [self.fld_CertNo positionFromPosition:textRange.start offset:-1];
        UITextPosition *end = [self.fld_CertNo positionFromPosition:textRange.end offset:-1];
        UITextRange *range = [self.fld_CertNo textRangeFromPosition:start toPosition:textRange.end];
        [self.fld_CertNo replaceRange:range withText:@""];
        //设置光标位置
        UITextRange *cuurRange = [self.fld_CertNo textRangeFromPosition:start toPosition:end];
        self.fld_CertNo.selectedTextRange = cuurRange;

        FPDEBUG(@"str1:%@",self.fld_CertNo.text);
        
        if (self.fld_CertNo.text.length >= 15) {
            [keyboard setSpecialButtonEnable:YES];
        } else {
            [keyboard setSpecialButtonEnable:NO];
        }
    }
}

-(void)numberKeyboardInput:(NSInteger)number
{
    [self passcodeValue:[NSString stringWithFormat:@"%ld",(long)number]];
}

- (void)passcodeValue:(NSString *)value
{
    //推算出光标的位置
    UITextRange *textRange = self.fld_CertNo.selectedTextRange;
    [self.fld_CertNo replaceRange:textRange withText:value];
    
    if (self.fld_CertNo.text.length > 18) {
        self.fld_CertNo.text = [self.fld_CertNo.text substringToIndex:18];
    }
    [self.fld_CertNo sendActionsForControlEvents:UIControlEventEditingChanged];
    
    FPDEBUG(@"str:%@",self.fld_CertNo.text);
    
    if (self.fld_CertNo.text.length >= 15) {
        [keyboard setSpecialButtonEnable:YES];
    } else {
        [keyboard setSpecialButtonEnable:NO];
    }
}

@end

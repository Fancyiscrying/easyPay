//
//  FPPayAmtViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPayAmtViewController.h"
#import "FPPayConfirmViewController.h"
#import "FPDataBaseManager.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define kNumberFieldHeight  55.0f

@interface FPPayAmtViewController () <ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,FPPositivePayViewDelegate>
{
    CGFloat  numberFieldHeight;
}

@property (nonatomic,strong) NSString   *phoneNumber;
@property (nonatomic,strong) FPPersonMember  *personInfo;

@property (nonatomic,strong) FPPositivePayView *positivePayView;

@property (nonatomic,assign) double amount;

@end

@implementation FPPayAmtViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    numberFieldHeight= 0.0;
    
    if (self.showPhoneNumberField) {
        UIView *phoneNumber = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
        phoneNumber.backgroundColor = [UIColor whiteColor];
        
        self.fld_PhoneNumber = [[ZHTextField alloc] initWithFrame:CGRectMake(90, 0, phoneNumber.width-140, 50)];
        self.fld_PhoneNumber.placeholder = @"手机号码";
        self.fld_PhoneNumber.backgroundColor = [UIColor clearColor];
        self.fld_PhoneNumber.textAlignment = NSTextAlignmentLeft;
        self.fld_PhoneNumber.font = [UIFont systemFontOfSize:15.0f];
        self.fld_PhoneNumber.textColor = [UIColor orangeColor];
        self.fld_PhoneNumber.backgroundColor = [UIColor whiteColor];
        self.fld_PhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.fld_PhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        self.fld_PhoneNumber.delegate = self;
    
        [phoneNumber addSubview:self.fld_PhoneNumber];
        
        UILabel *star = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 10, 20)];
        star.backgroundColor = [UIColor whiteColor];
        star.text = @"*";
        star.textColor = [UIColor redColor];
        [phoneNumber addSubview:star];
        UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(25, 8, 70, 30)];
        pay.text = @"收款人账户";
        pay.font = [UIFont systemFontOfSize:14];
        [phoneNumber addSubview:pay];
        [view addSubview:phoneNumber];
        
        self.btn_PhoneList = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_PhoneList.frame = CGRectMake(255, 10, 50, 50);
        self.btn_PhoneList.right = ScreenWidth - 5;
        self.btn_PhoneList.backgroundColor = [UIColor whiteColor];
        [self.btn_PhoneList setImage:MIMAGE(@"login_ic_ID") forState:UIControlStateNormal];
        [self.btn_PhoneList addTarget:self action:@selector(click_GetMobileNo:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.btn_PhoneList];
        
        numberFieldHeight = kNumberFieldHeight;
    }
    
    self.lbl_Tip1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + numberFieldHeight, 40, 21)];
    self.lbl_Tip1.text = @"收款人:";
    self.lbl_Tip1.backgroundColor = [UIColor clearColor];
    self.lbl_Tip1.textAlignment = NSTextAlignmentRight;
    self.lbl_Tip1.font = [UIFont systemFontOfSize:12.0f];
    self.lbl_Tip1.textColor = [UIColor darkGrayColor];
    [view addSubview:self.lbl_Tip1];
    
    self.lbl_InPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(80, 10+ numberFieldHeight, 200, 21)];
    self.lbl_InPhoneNumber.textColor = [UIColor orangeColor];
    self.lbl_InPhoneNumber.textAlignment = NSTextAlignmentLeft;
    self.lbl_InPhoneNumber.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:self.lbl_InPhoneNumber];
    
    UIView *payAmt = [[UIView alloc]initWithFrame:CGRectMake(0, 40+ numberFieldHeight, ScreenWidth, 50)];
    payAmt.backgroundColor = [UIColor whiteColor];
    
    self.fld_PayAmt = [[FPTextField alloc] initWithFrame:payAmt.bounds];
    self.fld_PayAmt.placeholder = @"￥ 0.00";
    self.fld_PayAmt.backgroundColor = [UIColor whiteColor];
    self.fld_PayAmt.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_PayAmt.keyboardType = UIKeyboardTypeDecimalPad;
    self.fld_PayAmt.delegate = self;
    self.fld_PayAmt.left = 50;
    [payAmt addSubview:self.fld_PayAmt];
    UILabel *star = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 10, 20)];
    star.backgroundColor = [UIColor whiteColor];
    star.text = @"*";
    star.textColor = [UIColor redColor];
    [payAmt addSubview:star];
    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(25, 8, 70, 30)];
    pay.text = @"付款金额";
    pay.font = [UIFont systemFontOfSize:14];
    [payAmt addSubview:pay];
    [view addSubview:payAmt];
    
    UILabel *banlance = [[UILabel alloc] initWithFrame:CGRectMake(20, 100+ numberFieldHeight, 60, 21)];
    banlance.textColor = [UIColor darkGrayColor];
    banlance.textAlignment = NSTextAlignmentLeft;
    banlance.font = [UIFont systemFontOfSize:12.0f];
    banlance.text = @"可用余额";
    [view addSubview:banlance];
    
    self.lbl_Balance = [[UILabel alloc] initWithFrame:CGRectMake(90, 100+ numberFieldHeight, 100, 21)];
    self.lbl_Balance.textColor = [UIColor orangeColor];
    self.lbl_Balance.textAlignment = NSTextAlignmentLeft;
    self.lbl_Balance.font = [UIFont systemFontOfSize:12.0f];
    self.lbl_Balance.text = @"可用余额 0.00";
    [view addSubview:self.lbl_Balance];
    
    UIView *remark = [[UIView alloc]initWithFrame:CGRectMake(0, 130+ numberFieldHeight, ScreenWidth, 50)];
    remark.backgroundColor = [UIColor whiteColor];
    
    self.fld_Remark = [[FPTextField alloc] initWithFrame:remark.bounds];
    self.fld_Remark.placeholder = @"10个字以内";
    self.fld_Remark.backgroundColor = [UIColor whiteColor];
    self.fld_Remark.delegate = self;
    self.fld_Remark.left = 50;
    [remark addSubview:self.fld_Remark];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 80, 30)];
    message.text = @"留言(可不填)";
    message.font = [UIFont systemFontOfSize:14];
    [remark addSubview:message];

    [view addSubview:remark];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 200 + numberFieldHeight, 290, 45);
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep addTarget:self action:@selector(click_NextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_NextStep.enabled = NO;
    [view addSubview:self.btn_NextStep];
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getAccountInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"我要转账";
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    if (_isComeFromPeoplePicker) {
        if (_theSelectPhoneNum.length>0) {
            self.fld_PhoneNumber.text = _theSelectPhoneNum;
            [self textFieldDidEndEditing:self.fld_PhoneNumber];
        }
    }
    
    if (!self.transferData) {
        self.transferData = [[ContactsInfo alloc] init];
        
        if (_isFromDimScanViewController == YES) {
            self.transferData.toMemberPhone = _toTelNumber;
            self.transferData.toMemberName = _toName;
        }
        if (self.transferData.toMemberPhone && self.transferData.toMemberName) {
            
            self.lbl_InPhoneNumber.text = [NSString stringWithFormat:@"%@ %@",self.transferData.toMemberPhone,self.transferData.toMemberName];
        }
        
    } else {
        
        if (self.transferData.toMemberPhone && self.transferData.toMemberName) {
            NSString *name = self.transferData.toMemberName;
            if (name.length >=1) {
                name = [name substringFromIndex:1];
                name = [NSString stringWithFormat:@"*%@",name];
            }
            NSString *phone = self.transferData.toMemberPhone;
            phone = [phone changeMoblieToFormatMoblie];
            self.lbl_InPhoneNumber.text = [NSString stringWithFormat:@"%@  %@",phone,name];
        }
        /*
        NSMutableString *amtStr = [NSMutableString stringWithString:self.transferData.toAmount];
        [amtStr insertString:@"." atIndex:(self.transferData.toAmount.length - 2)];
        
        self.fld_PayAmt.text = amtStr;
        self.fld_Remark.text = self.transferData.toRemark;
         */
    }
    
    FPAccountInfoItem *accountItem = [[Config Instance] accountItem];
    if (accountItem) {
        self.amount = [accountItem.accountAmount doubleValue];
        
        self.lbl_Balance.text = [NSString stringWithFormat:@"%0.2f",self.amount/100];
    }
    
}

- (void)createPositiveViewWithPayMoreThanLimt:(BOOL)more{
    FPPositivePayView *temp = nil;
    BOOL pass = [Config Instance].personMember.noPswLimitOn;
    if (pass && !more) {
      temp = [[FPPositivePayView alloc]initWithInputPassWordView:NO andWithRemark:YES];
    }else{
      temp = [[FPPositivePayView alloc]initWithInputPassWordView:YES andWithRemark:YES];
    }
    temp.delegate = self;
    temp.hidden = NO;
    
    _positivePayView = temp;
    [self.tabBarController.view addSubview:_positivePayView];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_PhoneNumber isFirstResponder]) {
        [self.fld_PhoneNumber resignFirstResponder];
    }
    
    if ([self.fld_PayAmt isFirstResponder]) {
        [self.fld_PayAmt resignFirstResponder];
    }
    
    if ([self.fld_Remark isFirstResponder]) {
        [self.fld_Remark resignFirstResponder];
    }
}

- (void)click_NextStep:(id)sender
{
    [self.view endEditing:YES];
    
    if (_isFromDimScanViewController == YES) {
        [self checkPersonByPhoneNumber:self.transferData.toMemberPhone];
    }
    
    if ([self.transferData.toMemberPhone checkTel] == NO) {
        [self.fld_PhoneNumber becomeFirstResponder];
        return;
    }
    
    //转账金额不能为0，不能大于用于实际余额，
    NSString *amt = [self.fld_PayAmt.text trimSpace];
    [self.fld_PayAmt resignFirstResponder];
    if ([amt checkAmt] == NO) {
        [self.fld_PayAmt becomeFirstResponder];
        return;
    }
    self.transferData.toAmount = [UtilTool decimalNumberMutiplyWithString:amt andValue:kAMT_PROPORTION];
    
    if ([self.transferData.toAmount doubleValue] > self.amount ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"转账金额大于可用余额!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        [self.fld_PayAmt becomeFirstResponder];
        return;
    } else if([self.transferData.toAmount doubleValue] <= 0.0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"转账金额必须大于零!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
        [self.fld_PayAmt becomeFirstResponder];
        return;
    }
    
    NSInteger userPay = [self.transferData.toAmount integerValue];
    if ([Config Instance].personMember.nameAuthFlag) {
        NSInteger payMax = [[Config Instance].appParams.realNamePayMaxAmount integerValue];
        
        if (userPay > payMax) {
            [self.fld_PayAmt becomeFirstResponder];
            NSString *warnStr = [NSString stringWithFormat:@"抱歉！此次支付超出单笔支出限额，单笔最高支付限额为%.2f元",payMax/100.0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
        
    } else {
        NSInteger payMax = [[Config Instance].appParams.unRealNamePayMaxAmount integerValue];
        
        if (userPay > payMax) {
            [self.fld_PayAmt becomeFirstResponder];
            NSString *warnStr = [NSString stringWithFormat:@"抱歉！此次支付超出单笔支出限额，单笔最高支付限额为%.2f元",payMax/100.0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:warnStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            return;
        }
    }
    
    NSString *remarkStr = [self.fld_Remark.text trimSpace];
    self.transferData.toRemark = remarkStr.length > 0 ? remarkStr : @"";
    self.transferData.fromMemberNo = [Config Instance].personMember.memberNo;
    
    //创建提交订单
    NSInteger limit = [[Config Instance].appParams.noPswAmountLimit integerValue];
    BOOL more = (userPay > limit) ? YES : NO;
    
    [self createPositiveViewWithPayMoreThanLimt:more];
    _positivePayView.transferData = self.transferData;
    _positivePayView.hidden = NO;
    
    /*
    FPPayConfirmViewController *controller = [[FPPayConfirmViewController alloc] init];
    controller.transferData = self.transferData;
    [self.navigationController pushViewController:controller animated:YES];
     */
}

#pragma mark 获取余额信息
- (void)getAccountInfo
{
    [FPAccountInfo getFPAccountInfoWithBlock:^(FPAccountInfo *cardInfo,NSError *error){
        if (error) {
            
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (cardInfo.result) {
                [[Config Instance]setAccountItem:cardInfo.accountItem];
                double amount = [cardInfo.accountItem.accountAmount doubleValue];
                self.amount = amount;
                self.lbl_Balance.text = [NSString stringWithFormat:@"%0.2f",amount/100];
            } else {
                
            }
        }
    }];
    
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.fld_Remark) {
        [self setViewTranfromWithY:-100];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.fld_PhoneNumber) {
        
        NSMutableString *changeString = [NSMutableString stringWithString:string];
        [changeString replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, changeString.length)];
        
        NSMutableString *temp = [NSMutableString stringWithString:textField.text];
        [temp insertString:changeString atIndex:range.location];
        
        NSString *phone = [temp trimOnlySpace];
        
        if (![changeString checkNumber]&& changeString.length<11) {
            return YES;
        }
        
        if (phone.length >= 11) {
            phone = [phone changeMoblieToFormatMoblie];
            [textField setText:phone];
            [textField resignFirstResponder];
            return NO;
        }
        phone = [phone changeMoblieToFormatMoblie];
        [textField setText:phone];
        
        [textField setPhoneTextFieldCursorWithRange:range];
        
        return NO;

    }else{
        return YES;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.fld_Remark) {
        NSString *text = textField.text;
        if (text.length > 10) {
            text = [text substringToIndex:10];
            [textField setText:text];
        }
    }

    
    if (textField == self.fld_Remark) {
        [self setViewTranfromWithY:0];
    }
    
    if (self.fld_PayAmt.text.length>0) {
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }
    
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    self.phoneNumber = [self.fld_PhoneNumber.text trimOnlySpace];
    if (self.phoneNumber.length != kPhoneNumberLength
        && _isFromDimScanViewController == NO
        && _showPhoneNumberField == YES) {
        [UtilTool showToastToViewAtHead:self.view andMessage:@"输入手机号不正确！"];
        return;
    }
    if (_isFromDimScanViewController == NO && _showPhoneNumberField == YES) {
        [self checkPersonByPhoneNumber:self.phoneNumber];
    }

}

- (void)click_GetMobileNo:(UIButton *)sender
{
    ABPeoplePickerNavigationController *picker;
    if(!picker){
        picker = [[ABPeoplePickerNavigationController alloc] init];
        // place the delegate of the picker to the controll
        NSArray *displayedItems = [NSArray arrayWithObject:
                                   [NSNumber numberWithInt:kABPersonPhoneProperty]];
        picker.displayedProperties = displayedItems;
        picker.peoplePickerDelegate = self;
    }
    
    // showing the picker
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)checkPersonByPhoneNumber:(NSString *)phoneNumber {

    NSString *mobileNumber = [[Config Instance] personMember].mobile;
    if ([phoneNumber isEqualToString:mobileNumber]) {
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"收款方账号不能等于付款方账号!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alter.tag = 200;
        [alter setContentMode:UIViewContentModeCenter];
        [alter show];
        
        return;
    }
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userInformation:phoneNumber];
    if (!_isFromDimScanViewController) {
        self.lbl_InPhoneNumber.text = @"正在查询...";
    }
   
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *object = [responseObject objectForKey:@"returnObj"];
            NSLog(@"%@",object);
            
            self.personInfo =[[FPPersonMember alloc] initWithAttributes:object];
            self.transferData.toMemberNo = self.personInfo.memberNo;
            self.transferData.toMemberPhone = phoneNumber;
            self.transferData.toMemberAvator = self.personInfo.headAddress;
            
            if (!_isFromDimScanViewController) {
                if (self.personInfo.nameAuthFlag) {
                    
                    NSString *name = self.personInfo.memberName;
                    if (name.length>=1) {
                        self.lbl_InPhoneNumber.text = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
                        self.transferData.toMemberName = name;
                    }
                    
                } else {
                    self.transferData.toMemberName = @"";
                    self.lbl_InPhoneNumber.text = @"对方未实名认证";
                    self.transferData.toMemberName = @"未实名用户";
                }
                
                //[self.fld_PayAmt becomeFirstResponder];
            }
            
           
            
        } else {
            if (!_isFromDimScanViewController) {
                self.lbl_InPhoneNumber.text = @"查询失败";
            }
            
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:errInfo message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            alter.tag = 200;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            //            self.fieldMobileNo.text = @"";
            //            [self.fieldMobileNo becomeFirstResponder];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[Config Instance] setAutoLogin:NO];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}
#pragma mark--- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200) {
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark FPPositivePayViewDelegate
- (void)positivePayViewHasPayAway{
    [self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    return YES;
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    
    if (property == kABPersonPhoneProperty) {
        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        
        int index = (int)ABMultiValueGetIndexForIdentifier(phoneMulti,identifier);
        
        NSString *phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        
        //do something
        phone = [phone iphoneFormat];
        if ([phone checkTel]) {
            self.fld_PhoneNumber.text = phone;
            
            [peoplePicker dismissViewControllerAnimated:YES completion:^{
                [self textFieldDidEndEditing:self.fld_PhoneNumber];
            }];
        }
    }
    
    return NO;
}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    
    if (property == kABPersonPhoneProperty) {
        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        
        int index = (int)ABMultiValueGetIndexForIdentifier(phoneMulti,identifier);
        
        NSString *phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        
        //do something
        phone = [phone iphoneFormat];
        if ([phone checkTel]) {
            self.fld_PhoneNumber.text = phone;
            
            [peoplePicker dismissViewControllerAnimated:YES completion:^{
                [self textFieldDidEndEditing:self.fld_PhoneNumber];
            }];
        }
    }
    
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    // assigning control back to the main controller
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setViewTranfromWithY:(CGFloat)Y{
    CGAffineTransform transFormY = CGAffineTransformMakeTranslation(0, Y);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = transFormY;

    }];
}

@end

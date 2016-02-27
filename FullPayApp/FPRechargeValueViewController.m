//
//  FPRechargeValueViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPRechargeValueViewController.h"
#import "FPRechargeConfirmViewController.h"
#import "FPMobileRechargeModel.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define NOTICE_TIPS @"请先输入充值手机号！"

@interface FPRechargeValueViewController () <ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate,FPPositivePayViewDelegate>

@property (nonatomic,strong) NSDictionary    *priceList;
@property (nonatomic,strong) NSArray    *priceArray;

@property (nonatomic,strong) NSArray    *telecomRechargeOptions;
@property (nonatomic,strong) NSString   *userPhoneTelecom;

@property (nonatomic,strong) MobileOption   *selectOption;

@property (nonatomic,assign) NSInteger  selectedTag;
@property (nonatomic,strong) NSString   *phoneNumber;

@property (nonatomic,strong) FPPositivePayView *positivePayView;

@end

@implementation FPRechargeValueViewController

#define kButtonFlag 200

- (void)loadView
{
//    self.priceList = @{@30,@50,@100,@300};
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.fld_PhoneNumber = [[ZHTextField alloc] initWithFrame:CGRectMake(15, 10, 239, 50)];
    self.fld_PhoneNumber.placeholder = @"手机号码";
    self.fld_PhoneNumber.backgroundColor = [UIColor clearColor];
    self.fld_PhoneNumber.textAlignment = NSTextAlignmentLeft;
    self.fld_PhoneNumber.font = [UIFont systemFontOfSize:16.0f];
    self.fld_PhoneNumber.textColor = [UIColor orangeColor];
    self.fld_PhoneNumber.backgroundColor = [UIColor whiteColor];
    self.fld_PhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_PhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.fld_PhoneNumber.delegate = self;
    [view addSubview:self.fld_PhoneNumber];
    
    self.btn_PhoneList = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_PhoneList.frame = CGRectMake(255, 10, 50, 50);
    self.btn_PhoneList.backgroundColor = [UIColor whiteColor];
    [self.btn_PhoneList setImage:MIMAGE(@"login_ic_ID") forState:UIControlStateNormal];
    [self.btn_PhoneList addTarget:self action:@selector(click_GetMobileNo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_PhoneList];
    
    self.lbl_TelComp = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 140, 20)];
//    self.lbl_TelComp.text = @"中国移动";
    self.lbl_TelComp.textColor = [UIColor darkGrayColor];
    self.lbl_TelComp.textAlignment = NSTextAlignmentLeft;
    self.lbl_TelComp.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:self.lbl_TelComp];
    
    self.btn_FirstValue = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_FirstValue.frame = CGRectMake(15, 90, 144, 45);
    self.btn_FirstValue.backgroundColor = [UIColor clearColor];
    [self.btn_FirstValue setTitle:@"30 元" forState:UIControlStateNormal];
    [self.btn_FirstValue setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn_FirstValue setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btn_FirstValue setBackgroundImage:[UIImage imageNamed:@"publish_bt_category_white"] forState:UIControlStateNormal];
    [self.btn_FirstValue setBackgroundImage:[UIImage imageNamed:@"publish_bt_category_grey"] forState:UIControlStateSelected];
    
    [self.btn_FirstValue addTarget:self action:@selector(click_SelRechargePrice:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_FirstValue.tag = kButtonFlag;
    [view addSubview:self.btn_FirstValue];
    
    self.btn_SecondValue = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_SecondValue.frame = CGRectMake(161, 90, 144, 45);
    self.btn_SecondValue.backgroundColor = [UIColor clearColor];
    [self.btn_SecondValue setTitle:@"50 元" forState:UIControlStateNormal];
    [self.btn_SecondValue setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn_SecondValue setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btn_SecondValue setBackgroundImage:[UIImage imageNamed:@"publish_bt_category_white"] forState:UIControlStateNormal];
    [self.btn_SecondValue setBackgroundImage:[UIImage imageNamed:@"publish_bt_category_grey"] forState:UIControlStateSelected];
    
    [self.btn_SecondValue addTarget:self action:@selector(click_SelRechargePrice:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_SecondValue.tag = kButtonFlag + 1;
    [view addSubview:self.btn_SecondValue];
    
    self.btn_ThirdValue = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_ThirdValue.frame = CGRectMake(15, 137, 144, 45);
    self.btn_ThirdValue.backgroundColor = [UIColor clearColor];
    [self.btn_ThirdValue setTitle:@"100 元" forState:UIControlStateNormal];
    [self.btn_ThirdValue setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn_ThirdValue setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btn_ThirdValue addTarget:self action:@selector(click_SelRechargePrice:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_ThirdValue setBackgroundImage:[UIImage imageNamed:@"publish_bt_category_white"] forState:UIControlStateNormal];
    [self.btn_ThirdValue setBackgroundImage:[UIImage imageNamed:@"publish_bt_category_grey"] forState:UIControlStateSelected];
    
    self.btn_ThirdValue.tag = kButtonFlag + 2;
    self.btn_ThirdValue.selected = YES;
    self.selectedTag = self.btn_ThirdValue.tag;    //默认的选择
    [view addSubview:self.btn_ThirdValue];
    
    self.btn_FourValue = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_FourValue.frame = CGRectMake(161, 137, 144, 45);
    self.btn_FourValue.backgroundColor = [UIColor clearColor];
    [self.btn_FourValue setTitle:@"300 元" forState:UIControlStateNormal];
    [self.btn_FourValue setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn_FourValue setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btn_FourValue addTarget:self action:@selector(click_SelRechargePrice:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_FourValue setBackgroundImage:[UIImage imageNamed:@"publish_bt_category_white"] forState:UIControlStateNormal];
    [self.btn_FourValue setBackgroundImage:[UIImage imageNamed:@"publish_bt_category_grey"] forState:UIControlStateSelected];
    
    self.btn_FourValue.tag = kButtonFlag + 3;
    [view addSubview:self.btn_FourValue];
    
    self.priceArray = @[self.btn_FirstValue,self.btn_SecondValue,self.btn_ThirdValue,self.btn_FourValue];
    
    UILabel *lbl_Tip1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, 40, 20)];
    lbl_Tip1.text = @"优惠价";
    lbl_Tip1.textColor = [UIColor darkGrayColor];
    lbl_Tip1.textAlignment = NSTextAlignmentLeft;
    lbl_Tip1.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:lbl_Tip1];
    
    self.lbl_RealPrice = [[UILabel alloc] initWithFrame:CGRectMake(65, 185, 140, 20)];
    self.lbl_RealPrice.text = @"99.7元";
    self.lbl_RealPrice.textColor = [UIColor redColor];
    self.lbl_RealPrice.textAlignment = NSTextAlignmentLeft;
    self.lbl_RealPrice.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:self.lbl_RealPrice];
    
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 225, 290, 45);
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"话费充值 1/2";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    NSString *phoneNum = [UtilTool getRechargePhoneNum];
    if (phoneNum.length == 13) {
        self.fld_PhoneNumber.text = phoneNum;
        [self textFieldDidEndEditing:self.fld_PhoneNumber];
        self.btn_NextStep.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_PhoneNumber isFirstResponder]) {
        [self.fld_PhoneNumber resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    if (self.fld_PhoneNumber.text.length>11) {
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }
    
    self.phoneNumber = [self.fld_PhoneNumber.text trimOnlySpace];
    if (self.phoneNumber.length != kPhoneNumberLength ) {
        [UtilTool showToastToViewAtHead:self.view andMessage:@"输入手机号不正确！"];
        //[self.fld_PhoneNumber becomeFirstResponder];
        return;
    }
    if (![self.phoneNumber checkTel]) {
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [FPMobileRechargeModel getTelecomRechargeOptionsWithMobileNo:self.phoneNumber andBlock:^(FPMobileRechargeModel *dataInfo,NSError *error){
        [hud setHidden:YES];
        if (error) {
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (dataInfo.result) {
                self.telecomRechargeOptions = dataInfo.telecomRechargeOptions;
                self.userPhoneTelecom = dataInfo.userPhoneTelecom;
                
                self.lbl_TelComp.text = [self getTelecom:self.userPhoneTelecom];
                
                UIButton *defaultButton = (UIButton *)[self.view viewWithTag:self.selectedTag];
                [self click_SelRechargePrice:defaultButton];
            } else {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:dataInfo.errorInfo delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
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
            if (phone.length >= 11) {
                phone = [phone changeMoblieToFormatMoblie];
            }
            self.fld_PhoneNumber.text = phone;
            self.btn_NextStep.enabled = YES;
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
            if (phone.length >= 11) {
                phone = [phone changeMoblieToFormatMoblie];
            }
            self.fld_PhoneNumber.text = phone;
            self.btn_NextStep.enabled = YES;
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

- (void)click_SelRechargePrice:(UIButton *)sender
{
    FPDEBUG(@"phone:%@",self.phoneNumber);
    if (!self.phoneNumber || self.phoneNumber.length != kPhoneNumberLength) {
        [self showToastMessage:NOTICE_TIPS];
        return;
    }
    
    self.selectedTag = sender.tag;
    
    sender.selected = !sender.isSelected;
    if (self.telecomRechargeOptions) {
        MobileOption *item = self.telecomRechargeOptions[sender.tag - kButtonFlag];
        self.lbl_RealPrice.text = [NSString stringWithFormat:@"%.2f元",item.payAmount];
        self.selectOption = item;
    }
    
    for (UIButton *btn in self.priceArray) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

- (void)click_NextStep:(id)sender
{
    if (!self.phoneNumber || self.phoneNumber.length == 0 ) {
        [self showToastMessage:NOTICE_TIPS];
        return;
    }
    
    if (![self.phoneNumber checkTel]) {
        return;
    }
    
    [UtilTool saveRechargePhoneNum:self.fld_PhoneNumber.text];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:self.phoneNumber forKey:@"mobileRechargeNo"];
    [paramter setObject:self.selectOption forKey:@"mobileRechargeOption"];
    
    [self createPositiveViewWithPayMoreThanLimt:YES andParamter:paramter];
    
    /**
     
     returns: 现已不用跳转
     */
//    FPRechargeConfirmViewController *controller = [[FPRechargeConfirmViewController alloc] init];
//    controller.mobileNo = self.phoneNumber;
//    controller.mobileOption = self.selectOption;
//    controller.userPhoneTelecom = self.userPhoneTelecom;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)createPositiveViewWithPayMoreThanLimt:(BOOL)more andParamter:(NSDictionary *)paramter{
    
    FPPositivePayView *temp = nil;
    BOOL pass = [Config Instance].personMember.noPswLimitOn;
    if (pass && !more) {
        temp = [[FPPositivePayView alloc]initWithMobileRechargeTypeWithParamters:paramter andHasPass:NO];
    }else{
        temp = [[FPPositivePayView alloc]initWithMobileRechargeTypeWithParamters:paramter andHasPass:YES];
    }
    temp.delegate = self;
    temp.hidden = NO;
    
    _positivePayView = temp;
    [self.tabBarController.view addSubview:_positivePayView];
    
}

#pragma mark FPPositivePayViewDelegate
- (void)positivePayViewHasPayAway{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Util
- (NSString *)getTelecom:(NSString *)telecom
{
    if ([telecom isEqualToString:@"CHINAMOBILE"]) {
        return @"中国移动";
    } else if ([telecom isEqualToString:@"CHINAUNICOM"]) {
        return @"中国联通";
    } else if ([telecom isEqualToString:@"CHINATELCOM"]){
        return @"中国电信";
    } else {
        return @"未知";
    }
}

@end

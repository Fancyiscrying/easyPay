//
//  FPAddBankCardViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPAddBankCardViewController.h"
#import "FPCommitBankCardController.h"
#import "FPCardRechargeViewController.h"

#define IMG_WHITEBACK @"Box 06.png"

#define IMG_BTNLIST @"enterbanknum_bt_down"
#define IMG_BTNLIST_UP @"enterbanknum_bt_up"

@interface FPAddBankCardViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong) NSDictionary    *bankList;
@property (nonatomic,strong) NSArray    *bankNames;
@property (nonatomic,strong) NSString   *bankCardId;

@end

@implementation FPAddBankCardViewController

const NSInteger kAddBankFieldTag = 100;

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    self.lbl_Tips = [[UILabel alloc] init];
    self.lbl_Tips.frame = CGRectMake(20.0f, 10.0f, 278.0f, 33.0f);
    self.lbl_Tips.adjustsFontSizeToFitWidth = YES;
    self.lbl_Tips.textColor = MCOLOR(@"text_color");
    self.lbl_Tips.font = [UIFont systemFontOfSize:13.0f];
    self.lbl_Tips.numberOfLines = 0;
    [view addSubview:self.lbl_Tips];
    
    self.fld_BankList = [[ZHTextField alloc] init];
    self.fld_BankList.frame = CGRectMake(0, 40, 270, 50);
    //        self.fld_CertType.placeholder = @"证件号码:(不区分大小写)";
    self.fld_BankList.textAlignment = NSTextAlignmentLeft;
    self.fld_BankList.backgroundColor = [UIColor whiteColor];
    //        self.fld_CertType.userInteractionEnabled = NO;
    self.fld_BankList.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [view addSubview:self.fld_BankList];
    
    self.btn_Choose = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_Choose.frame = CGRectMake(270, 40, 50, 50);
    [self.btn_Choose setBackgroundImage:MIMAGE(IMG_BTNLIST) forState:UIControlStateNormal];
    [self.btn_Choose setBackgroundImage:MIMAGE(IMG_BTNLIST_UP) forState:UIControlStateSelected];
    [self.btn_Choose addTarget:self action:@selector(clickShowList:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btn_Choose];
    
    UILabel *lbl_Tips = [[UILabel alloc] init];
    lbl_Tips.frame = CGRectMake(20.0f, 100.0f, 278.0f, 20.0f);
    lbl_Tips.adjustsFontSizeToFitWidth = YES;
    lbl_Tips.textColor = MCOLOR(@"text_color");
    lbl_Tips.font = [UIFont systemFontOfSize:11.0f];
    lbl_Tips.numberOfLines = 0;
    lbl_Tips.text = @"请输入银行卡号:";
    [view addSubview:lbl_Tips];
    
    self.fld_BankCardNo = [[ZHTextField alloc] init];
    self.fld_BankCardNo.frame = CGRectMake(0, 125, 320, 50);
    self.fld_BankCardNo.placeholder = @"银行卡卡号";
    self.fld_BankCardNo.backgroundColor = [UIColor whiteColor];
    self.fld_BankCardNo.textAlignment = NSTextAlignmentLeft;
    self.fld_BankCardNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.fld_BankCardNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fld_BankCardNo.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.fld_BankCardNo.keyboardType = UIKeyboardTypeNumberPad;
    self.fld_BankCardNo.delegate = self;
    self.fld_BankCardNo.tag = kAddBankFieldTag;
    [view addSubview:self.fld_BankCardNo];
    
    self.lbl_Notice = [[UILabel alloc] init];
    self.lbl_Notice.frame = CGRectMake(20.0f, 180.0f, 278.0f, 33.0f);
    self.lbl_Notice.adjustsFontSizeToFitWidth = YES;
    self.lbl_Notice.textColor = MCOLOR(@"text_color");
    self.lbl_Notice.font = [UIFont systemFontOfSize:10.0f];
    self.lbl_Notice.numberOfLines = 0;
    self.lbl_Notice.text = @"提示：充值不支持信用卡，请输入储蓄卡卡号。";
    [view addSubview:self.lbl_Notice];
    
    self.btn_NextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_NextStep.frame = CGRectMake(15, 223, 290, 44);
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_YELL) forState:UIControlStateNormal];
    [self.btn_NextStep setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [self.btn_NextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:MCOLOR(@"text_color") forState:UIControlStateNormal];
    [self.btn_NextStep setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.btn_NextStep addTarget:self action:@selector(clickNextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_NextStep.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.btn_NextStep.enabled = NO;
    [view addSubview:self.btn_NextStep];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; //这里设置了就可以自定义高度了，一般默认是无法修改其216像素的高度
    self.pickerView.frame = CGRectMake(0, view.frame.size.height - 162, view.frame.size.width, 162);
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    self.fld_BankList.inputView = self.pickerView;
//    self.fld_BankList.delegateDone = self;
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"输入银行卡号";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    self.lbl_Tips.text = [NSString stringWithFormat:@"富之富账户:%@",[Config Instance].personMember.mobile];
    
    [self getBankCardList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getBankCardList
{
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userSupportBankList:memberNo];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        FPDEBUG(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *returnObj = responseObject[@"returnObj"];
            if ([returnObj count] > 0) {
                self.bankList = [returnObj copy];
                self.bankNames = [self.bankList allValues];
                
                self.fld_BankList.text = self.bankNames[0];
                [self.pickerView selectRow:0 inComponent:0 animated:YES];
                
                [self.pickerView reloadAllComponents];
            }

        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"查询银行信息失败!" message:errInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)clickNextStep:(id)sender
{
    NSString *cardNo = [self.fld_BankCardNo.text trimOnlySpace];
    if (cardNo.length == 0) {
        return;
    }
    NSString *bankName = [self.fld_BankList.text trimSpace];
    if (bankName.length == 0) {
        return;
    }
    NSString *bankCode =[self.bankList allKeysForObject:bankName][0];
    if (bankCode.length == 0) {
        return;
    }
    NSString *memberName = [Config Instance].personMember.memberName;
    if (memberName.length == 0) {
        return;
    }
    
    NSMutableDictionary *bankCard = [[NSMutableDictionary alloc]init];
    [bankCard setObject:cardNo forKey:@"cardNo"];
    [bankCard setObject:bankName forKey:@"bankName"];
    [bankCard setObject:bankCode forKey:@"bankCode"];
    [bankCard setObject:memberName forKey:@"memberName"];
    
    FPCommitBankCardController *controller = [[FPCommitBankCardController alloc]init];
    controller.bankCard = bankCard;
    [self.navigationController pushViewController:controller animated:YES];
   
}

-(void)clickShowList:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if ([self.fld_BankList isFirstResponder]) {
        [self.fld_BankList resignFirstResponder];
    } else {
        [self.fld_BankList becomeFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.fld_BankList isFirstResponder]) {
        self.btn_Choose.selected = !self.btn_Choose.isSelected;
        [self.fld_BankList resignFirstResponder];
    }
    
    if ([self.fld_BankCardNo isFirstResponder]) {
        [self.fld_BankCardNo resignFirstResponder];
    }
}

#pragma mark - picker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.bankNames count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.bankNames[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.fld_BankList.text = self.bankNames[row];
}

#pragma mark - fptextfield
//-(void)clickDone:(FPTextField *)sender
//{
//    NSInteger row = [self.pickerView selectedRowInComponent:0];
//
//    sender.text = self.bankNames[row];
//    
//    self.btn_Choose.selected = !self.btn_Choose.isSelected;
//
//}

#pragma mark - delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *tempText = textField.text;
    tempText = [tempText trimSpace];
    
    if(tempText.length > 7){
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }
    
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
    if(text.length>=23){
        
        [textField resignFirstResponder];
        [textField setText:[text substringToIndex:23]];
        return NO;
        
    }
    textField.text = text;
    
    [textField setBankCardTextFieldCursorWithRange:range];
    
    return NO;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *text = textField.text;
    text = [text trimSpace];
    
    if(text.length > 4){
        self.btn_NextStep.enabled = YES;
    }else{
        self.btn_NextStep.enabled = NO;
    }

}
#pragma mark UIAlertView  delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}


@end

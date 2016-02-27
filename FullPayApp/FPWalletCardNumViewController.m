//
//  FPWalletCardNumViewController.m
//  FullPayApp
//
//  Created by lc on 14-8-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPWalletCardNumViewController.h"
#import "FPTextField.h"

@interface FPWalletCardNumViewController ()<FPTextFieldDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) FPTextField *textField;
@property (copy, nonatomic) NSString *numberStr;

@end

@implementation FPWalletCardNumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenWidth, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"请输入您的16位富钱包卡号";
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    
    _textField = [[FPTextField alloc]initWithFrame:CGRectMake(-30, 0, ScreenWidth+30, 40)];
    _textField.top = label.bottom+10;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    //textField.text = @"+86";
    _textField.delegateDone = self;
    _textField.delegate = self;
    [_textField becomeFirstResponder];
    [view addSubview:_textField];

    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(20, 160, 280, 35);
    nextButton.top = _textField.bottom +30;
    [nextButton setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
    [nextButton setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(click_Next:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 5;
    [view addSubview:nextButton];

    [view addSubview:_textField];
    self.view = view;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"富钱包";
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click_Next:(UIButton *)sender{
    [self touchesBegan:nil withEvent:nil];
    NSString *num = [_numberStr trimOnlySpace];
    if (num.length>0) {
        FPClient *client = [FPClient sharedClient];
        NSDictionary *paramters = [client addCardRelateWithMemberNo:[Config Instance].memberNo andCardNo:num];
        [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BOOL result = [[responseObject objectForKey:@"result"]boolValue];
            if (result) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加成功" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                alert.delegate = self;
                alert.tag = 101;
                [alert show];
            }else{
                NSString *errorInfo= [responseObject objectForKey:@"errorInfo"];

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加失败" message:errorInfo delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showToastMessage:kNetworkErrorMessage];

        }];
        
//        [UtilTool saveFullWalletCardNo:_numberStr];
//        FPFullWalletViewController *walletView = [[FPFullWalletViewController alloc]init];
//        walletView.cardNo = _numberStr;
//        
//        [self.navigationController pushViewController:walletView animated:YES];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark---FPTextFieldDelegate
-(void)clickDone:(FPTextField *)sender{
    _numberStr = sender.text;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _numberStr = _textField.text;
    [self.view endEditing:YES];
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
    
    if(text.length>=19){
        
        [textField resignFirstResponder];
        [textField setText:[text substringToIndex:19]];
        return NO;
        
    }
    
    textField.text = text;
    
    [textField setBankCardTextFieldCursorWithRange:range];
    
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *card = textField.text;
    if (card.length > 19){
        card = [card substringToIndex:19];
    }
    textField.text = card;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

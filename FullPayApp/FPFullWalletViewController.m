//
//  FPFullWalletViewController.m
//  FullPayApp
//
//  Created by lc on 14-8-13.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPFullWalletViewController.h"
#import "FPTextField.h"
#import "FPWalletTradeViewController.h"
#import "FPFullWalletRechargeViewController.h"

@interface FPFullWalletViewController ()<UITextFieldDelegate,FPTextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) FPTextField *textField;
@property (strong, nonatomic) NSArray *tableList;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation FPFullWalletViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    _textField = [[FPTextField alloc]initWithFrame:CGRectMake(30, 20, ScreenWidth-30, 40)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    _textField.text = _cardNo;
    if (_cardNo == nil) {
        NSString *cardNo = [UtilTool getFullWalletCardNo];
        _textField.text = cardNo;
    }

    //textField.text = @"+86";
    _textField.delegateDone = self;
    _textField.delegate = self;
    [view addSubview:_textField];
    
    UILabel *fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 70, 40)];
    fieldLabel.backgroundColor = [UIColor whiteColor];
    fieldLabel.textAlignment = NSTextAlignmentLeft;
    fieldLabel.font = [UIFont systemFontOfSize:13];
    fieldLabel.text = @"    卡号";
    fieldLabel.textColor = [UIColor blackColor];
    [view addSubview:fieldLabel];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300) style:UITableViewStyleGrouped];
    _tableView.top = _textField.bottom;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    
    [view addSubview:_tableView];
    
    view.backgroundColor = [UIColor whiteColor];
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self textFieldDidEndEditing:_textField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"富钱包";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    self.tableList = @[@[@"充值"],@[@"收支明细"]];
}

#pragma mark---FPTextFieldDelegate
-(void)clickDone:(FPTextField *)sender{
    _cardNo = sender.text;
    [UtilTool saveFullWalletCardNo:_cardNo];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _cardNo = _textField.text;
    [self.view endEditing:YES];
    [UtilTool saveFullWalletCardNo:_cardNo];

}


#pragma mark  UITableView  datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.tableList[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
    cell.accessoryView = accessoryView;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *cardNo = self.textField.text;
    [UtilTool saveFullWalletCardNo:cardNo];

    if (indexPath.section == 0){
        
        BOOL autologin = [Config Instance].isAutoLogin;
        if (autologin) {
            
            FPFullWalletRechargeViewController *controller = [[FPFullWalletRechargeViewController alloc]init];
            controller.cardNo = cardNo;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [UtilTool setLoginViewRootController];
        }
        
    }else if (indexPath.section == 1) {
        
        FPWalletTradeViewController *walletView = [[FPWalletTradeViewController alloc]init];
        NSString *card = [cardNo trimOnlySpace];
        walletView.cardItem.cardNo = card;
        [self.navigationController pushViewController:walletView animated:YES];
    }
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
        
        [textField setText:[text substringToIndex:19]];
        [textField resignFirstResponder];

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
    if (card.length == 0) {
        card = @"";
    }
    [UtilTool saveFullWalletCardNo:card];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

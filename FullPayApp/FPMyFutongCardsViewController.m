//
//  FPMyFutongCardsViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMyFutongCardsViewController.h"
#import "FPMyFutongCardsCell.h"
#import "FPAddFutongCardViewController.h"
#import "FPFutongCard.h"

#define TIP1 @"提示：可关联富通卡数量，实名账户%d张，非实名账户%d张。"

@interface FPMyFutongCardsViewController () <UITableViewDelegate,UITableViewDataSource,FPMyFutongCardsCellDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSString   *noticeTips;
@property (nonatomic,strong) NSArray    *arrayCards;
@property (nonatomic,assign) NSUInteger cardsCount;

@property (nonatomic,strong) NSString   *updateRemarkForCardNo;

@end

@implementation FPMyFutongCardsViewController

static NSString *myTableViewCellIndentifier = @"itemMyFutongCardsCell";
static NSString *myTableViewCellIndentifier1 = @"itemAddMyFutongCardsCell";

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
    [self.tabBarController.tabBar setHidden:YES];
    [self getFutongCardList];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"BG.png"];
    [self.view addSubview:bg];
    
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"我的富通卡";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    FPDEBUG(@"rect:%@",NSStringFromCGRect(self.view.bounds));
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
   // [self.view addSubview:self.tableView];
    
    [self.tableView
     registerClass:[FPMyFutongCardsCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    [self.tableView
     registerClass:[UITableViewCell class] forCellReuseIdentifier:myTableViewCellIndentifier1];
    
    self.tableView.height = ScreenHigh - 60;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = YES;

    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    [self.view addSubview:self.tableView];
    

    [self initData];
    [self getFutongCardList];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.arrayCards.count == 0) {
        return 2;
    }else{
        return 3;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        if (self.arrayCards.count == 0) {
            return 1;
        }else{
            return [self.arrayCards count];
        }
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ if(self.arrayCards.count >0){
    if (indexPath.section == 0 ) {
        FPMyFutongCardsCell* cell;
        if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
            if (cell == nil) {
                cell = [[FPMyFutongCardsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
            }
        }
        
        FPFutongCardItem *card = [self.arrayCards objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCardItem:card];
        cell.delegate = self;
        
        return cell;
    } else {
        UITableViewCell* cell;
        if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1 forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier1];
            }
        }
        
        if (indexPath.section == 1) {
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            cell.imageView.image = [UIImage imageNamed:@"user_ic_futong"];
            
            cell.textLabel.text = @"添加富通卡";
            
            UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
            cell.accessoryView = accessoryView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else {
            cell.textLabel.text =self.noticeTips;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
            cell.textLabel.numberOfLines = 0;
            cell.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
        }
        
        return cell;
    }
}else{
        UITableViewCell* cell;
        if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1 forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier1];
            }
        }
        
        if (indexPath.section == 0) {
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            cell.imageView.image = [UIImage imageNamed:@"user_ic_futong"];
            
            cell.textLabel.text = @"添加富通卡";
            
            UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ic_enter"]];
            cell.accessoryView = accessoryView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else {
            cell.textLabel.text =self.noticeTips;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
            cell.textLabel.numberOfLines = 0;
            cell.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
        }
        
        return cell;

    
  }
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.arrayCards.count != 0) {
            return 60.0f;
        }
    }
    
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.arrayCards.count != 0) {
        if (section == 0) {
        return 0.1;
        }
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 || (indexPath.section == 0 && self.arrayCards.count ==0 )) {
        
        BOOL alterFlag = NO;
        NSInteger curCardCount = 0;
        BOOL isRealName = [Config Instance].personMember.nameAuthFlag;
        if (!isRealName) {
            curCardCount = [[Config Instance].appParams.unRealNameBindCardLimit integerValue];
            if (self.cardsCount >= curCardCount) {
                alterFlag = YES;
            }
        } else {
            curCardCount = [[Config Instance].appParams.realNameBindCardLimit integerValue];
            if (self.cardsCount >= curCardCount) {
                alterFlag = YES;
            }
        }
        
        if (alterFlag) {
            NSString *msg = [NSString stringWithFormat:@"抱歉，您可以绑定的最大卡数量为%ld(张)！",(long)curCardCount];
            [self showToastMessage:msg];
        } else {
            FPAddFutongCardViewController   *controller = [[FPAddFutongCardViewController alloc] init];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)initData
{
    NSInteger realNameCardCount = [[Config Instance].appParams.realNameBindCardLimit integerValue];
    NSInteger unRealNameCardCount = [[Config Instance].appParams.unRealNameBindCardLimit integerValue];

    self.noticeTips = [NSString stringWithFormat:TIP1,(int)realNameCardCount,(int)unRealNameCardCount];
    
    [self.tableView reloadData];
}

- (void)getFutongCardList
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [FPFutongCard getFPFutongCardWithBlock:^(FPFutongCard *cardInfo,NSError *error){
        [hud hide:YES];
        if (error) {
            [self showToastMessage:kNetworkErrorMessage];
        } else {
            if (cardInfo.result) {
                self.cardsCount = cardInfo.cardsCount;
                
                self.arrayCards = cardInfo.futongCard;

                [self.tableView reloadData];

            } else {
                //[self showToastMessage:cardInfo.errorInfo];
                [self.tableView reloadData];
            }
        }
    }];

}

#pragma mark - FPMyFutongCardsCellDelegate
-(void)updateFutongCardStatus:(FPMyFutongCardsCell *)sender
{
    FPMyFutongCardsCell *cell = (FPMyFutongCardsCell *)sender;
    NSString *cardNo = [cell.cardItem.cardNo trimOnlySpace];
    FPDEBUG(@"%@",cardNo);
    
    NSString *cardStatus;
    NSString *message;
    //cell.btnClose.selected = !cell.btnClose.isSelected;
    if (cell.btn_Switch.selected == NO) {
        FPDEBUG(@"1、%d",cell.btn_Switch.isSelected);
        cardStatus = @"FREEZE";
        message = @"冻结成功";
    } else {
        FPDEBUG(@"2、%d",cell.btn_Switch.isSelected);
        cardStatus = @"NORMAL";
        message = @"解冻成功";
    }
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userCardStatus:cardNo withCardStatus:cardStatus];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            cell.btn_Switch.selected = !cell.btn_Switch.isSelected;
            [self getFutongCardList];
            [self.tableView reloadData];
            
            [self showToastMessage:message];
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            [self showToastMessage:errInfo];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];
    }];
}

- (void)updateFutongCardRemark:(FPMyFutongCardsCell *)sender
{
    self.updateRemarkForCardNo = [sender.cardItem.cardNo trimOnlySpace];
    UIAlertView *checkPwd = [[UIAlertView alloc] initWithTitle:@"修改备注名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    checkPwd.contentMode = UIViewContentModeLeft;
    checkPwd.alertViewStyle = UIAlertViewStylePlainTextInput;
    [checkPwd show];
    
    UITextField *newName = [checkPwd textFieldAtIndex:0];
    newName.delegate = self;
    [newName setPlaceholder:@"请输入备注名(最多10个字符)"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    } else {
        //得到输入框
        UITextField *fldRemark=[alertView textFieldAtIndex:0];
        NSString *newRemarkStr = [fldRemark.text trimSpace];
        if (newRemarkStr.length > 0) {
            if (newRemarkStr.length > kCardRemarkMaxLength) {
                newRemarkStr = [newRemarkStr substringToIndex:kCardRemarkMaxLength];
            }
            
            [self updateCardRemark:[fldRemark.text trimSpace]];
        }
    }
}

-(void)updateCardRemark:(NSString *)newRemark
{
    if (!self.updateRemarkForCardNo || self.updateRemarkForCardNo.length <= 0) {
        return;
    }
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userCardRemark:self.updateRemarkForCardNo andUserDesc:newRemark];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {

            [self getFutongCardList];
            [self.tableView reloadData];
            
            [self showToastMessage:@"更新成功"];
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            [self showToastMessage:errInfo];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        FPDEBUG(@"%@",error);
        [self showToastMessage:kNetworkErrorMessage];
    }];
}
#pragma mark UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length > 9) {
        return NO;
    }else{
        return YES;
    }
}

@end

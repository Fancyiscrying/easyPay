//
//  FPPayTypeViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPayTypeViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "FPPayAmtViewController.h"
#import "FPDimScanViewController.h"
#import "FPNavigationViewController.h"
#import "FPBankCardListViewController.h"

#import "FPDataBaseManager.h"
#import "UIImageView+AFNetworking.h"
#import "FPPayListCell.h"

@interface FPPayTypeViewController () <UITableViewDataSource,UITableViewDelegate,FPPayListCellDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic,strong) NSArray *contactItems;
@property (nonatomic,strong) ABPeoplePickerNavigationController *picker;;

@end

@implementation FPPayTypeViewController

static NSString *myTableViewCellIndentifier = @"itemPayTypeCell";

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    UIView *firstLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    firstLine.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    leftImage.backgroundColor = [UIColor clearColor];
    leftImage.image = [UIImage imageNamed:@"home_pay_user_linkman"];
    [firstLine addSubview:leftImage];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 200, 60)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"选择通讯录好友转账";
    lab.font = [UIFont systemFontOfSize:18.0f];
    [firstLine addSubview:lab];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-35, 15, 30, 30)];
    rightImage.backgroundColor = [UIColor clearColor];
    rightImage.image = [UIImage imageNamed:@"home_ic_enter"];
    [firstLine addSubview:rightImage];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [firstLine addSubview:line];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFirstLine)];
    [firstLine addGestureRecognizer:tapGesture];
    
    [view addSubview: firstLine];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, firstLine.bottom, ScreenWidth, ScreenHigh-100-62) style:UITableViewStylePlain];
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
    [view addSubview:self.tableView];
    
    
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        _picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
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
    
    [self getImages];
    [self addBottomBar];
}

-(void)addBottomBar{
    
    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHigh-114, ScreenWidth/2, 50)];
    left.backgroundColor = COLOR_STRING(@"#82CCFB");
//    left.layer.masksToBounds = YES;
//    left.layer.borderWidth = 0.5;
//    left.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView *imageLeft = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/4-20, 0, 40, 40)];
    imageLeft.image = MIMAGE(@"home_pay_bottom_linkman");
    [left addSubview:imageLeft];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, left.width, 20)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"转账到富之富账户";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:12];
    
    [left addSubview:lable];
    
    [self.view addSubview:left];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheLeftBottomButton)];
    [left addGestureRecognizer:tap];
    
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2, left.top, ScreenWidth/2, 50)];
    right.backgroundColor = COLOR_STRING(@"#82CCFB");
//    right.layer.masksToBounds = YES;
//    right.layer.borderWidth = 0.5;
//    right.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView *imageRight = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/4-20, 0, 40, 40)];
    imageRight.image = MIMAGE(@"home_pay_bottom_bankcard");
    [right addSubview:imageRight];
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, left.width, 20)];
    lable1.backgroundColor = [UIColor clearColor];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"转账到银行卡";
    lable1.textColor = [UIColor whiteColor];
    lable1.font = [UIFont systemFontOfSize:12];

    [right addSubview:lable1];
    
    [self.view addSubview:right];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheRightBottomButton)];
    [right addGestureRecognizer:tap1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-0.5, right.top + 10, 1, 30)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}

- (void)getImages{
    _contactItems = [self contactItems];
    for (ContactsInfo *item in _contactItems) {
        ImageUtils *imgUtils = [ImageUtils Instance];
        [imgUtils getImageWithMemberNo:item.toMemberNo andHeadAddress:item.toMemberAvator andBlock:^(UIImage *image, bool result) {
            [self.tableView reloadData];
        }];
    }
}

- (void)click_AutoPay:(UIButton *)sender
{
    FPDimScanViewController *controller = [[FPDimScanViewController alloc] init];
    FPNavigationViewController  *navController = [[FPNavigationViewController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navController animated:YES completion:^{
        
    }];

    
}

- (void)getInMember:(NSString *)phoneNumber {
    
    NSString *inMobileNo = [phoneNumber trimSpace];
    if ([inMobileNo checkTel] == NO) {
        return;
    }
    
    NSString *mobileNumber = [[Config Instance] personMember].mobile;
    if ([inMobileNo isEqualToString:mobileNumber]) {
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"收款方账号不能等于付款方账号!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alter.tag = 200;
        [alter setContentMode:UIViewContentModeCenter];
        [alter show];
        
        return;
    }
    
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userInformation:inMobileNo];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            NSDictionary *object = [responseObject objectForKey:@"returnObj"];
            NSLog(@"%@",object);
            
            FPPayAmtViewController *controller = [[FPPayAmtViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        } else {
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"查询信息失败" message:errInfo delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            alter.tag = 200;
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[Config Instance] setAutoLogin:NO];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark buttonActions
- (void)tapFirstLine{
    
    if(!_picker){
        _picker = [[ABPeoplePickerNavigationController alloc] init];
        // place the delegate of the picker to the controll
        NSArray *displayedItems = [NSArray arrayWithObject:
                                   [NSNumber numberWithInt:kABPersonPhoneProperty]];
        
        _picker.displayedProperties = displayedItems;
        _picker.peoplePickerDelegate = self;
    }
    
    // showing the picker
    [self presentViewController:_picker animated:YES completion:nil];
   
    
}
- (void)tapTheLeftBottomButton{
    FPPayAmtViewController *controller = [[FPPayAmtViewController alloc] init];
    controller.showPhoneNumberField = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tapTheRightBottomButton{
    /**
     提现业务，由于业务商谈中，暂时屏蔽
     
     **
     
     提现开启 （2015-06-07日）
     */
    
    FPBankCardListViewController *controller = [[FPBankCardListViewController alloc] init];
    controller.viewComeForm = BankCardListViewComeFormPayAmtCard;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
     
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
    
//    NSArray *phones = [self getPhones:person];
//     
//    //一些处理...
//    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"手机号码"
//                                                       delegate:self
//                                              cancelButtonTitle:nil
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:nil];
//    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//    for(NSString *pho in phones)
//    {
//        [sheet addButtonWithTitle:pho];
//    }
//    [sheet addButtonWithTitle:@"取消"];
//    sheet.cancelButtonIndex = phones.count;
//    
//    if(phones.count>0){
//        [sheet showInView:[UIApplication sharedApplication].keyWindow];
//    }else{
//        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//    }
    
    if (property == kABPersonPhoneProperty) {
        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        
        int index = (int)ABMultiValueGetIndexForIdentifier(phoneMulti,identifier);
        
        NSString *phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        
        //do something
        phone = [phone iphoneFormat];
        if ([phone checkTel]) {
            
            [peoplePicker dismissViewControllerAnimated:YES completion:^{
                FPPayAmtViewController *controller = [[FPPayAmtViewController alloc] init];
                controller.showPhoneNumberField = YES;
                controller.theSelectPhoneNum = phone;
                controller.isComeFromPeoplePicker = YES;
                [self.navigationController pushViewController:controller animated:YES];
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
        
        //NSString *phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        
        //do something
        phone = [phone iphoneFormat];
        if ([phone checkTel]) {
            
            [peoplePicker dismissViewControllerAnimated:YES completion:^{
                FPPayAmtViewController *controller = [[FPPayAmtViewController alloc] init];
                controller.showPhoneNumberField = YES;
                controller.theSelectPhoneNum = phone;
                controller.isComeFromPeoplePicker = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }];
            
        }
    }
    
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    // assigning control back to the main controller
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myTableViewCellIndentifier];
    }
    
    ContactsInfo *item = self.contactItems[indexPath.row];
    FPDEBUG(@"amount:%@",item.toAmount);
    
    UIImage *img_Photo = nil;
    ImageUtils *imgUtils = [ImageUtils Instance];
    UIImage *showImage = [imgUtils getImageWithMemberNo:item.toMemberNo andHeadAddress:item.toMemberAvator];
    if (showImage) {
        UIImage *reSize = [[ImageUtils Instance] reSizeImage:showImage toSize:CGSizeMake(50, 50)];
        
        img_Photo = reSize;
    }
    [cell.imageView setImage:img_Photo];
    if (cell.imageView.image == nil) {
        [cell.imageView setImage:MIMAGE(@"perinfor_img_user_none")];

    }

    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 5.0;
    
    NSString *tempStr = item.toMemberName;
    if (tempStr && tempStr.length > 1) {
        if (![tempStr isEqualToString:@"未实名用户"]) {
            tempStr = [tempStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        }
    }
    cell.textLabel.text = tempStr;
    
    tempStr = item.toMemberPhone;
    if (tempStr && tempStr.length >= 11) {
        tempStr = [tempStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@" **** "];
    }
    cell.detailTextLabel.text = tempStr;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
    return cell;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FPPayAmtViewController *controller = [[FPPayAmtViewController alloc] init];
    controller.showPhoneNumberField = NO;
    controller.transferData = self.contactItems[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath) {
            ContactsInfo *item = self.contactItems[indexPath.row];
            FPDataBaseManager *center = [FPDataBaseManager shareCenter];
            [center deleteTable_CantactWhereToMember:item];
            _contactItems = [self regetContactItems];
            [self.tableView reloadData];
            
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (NSArray *)contactItems
{
    if (!_contactItems) {
        FPDataBaseManager *center = [FPDataBaseManager shareCenter];
        [center createTable_Cantact];
        
        NSString *memberNo = [Config Instance].memberNo;
        
        NSArray *items = [center getTop5ItemTable_Cantact:memberNo];
        
        FPDEBUG(@"count:%lu",(unsigned long)[items count]);
        _contactItems = [NSArray arrayWithArray:items];
    }
    
    return _contactItems;
}
- (NSArray *)regetContactItems{
        FPDataBaseManager *center = [FPDataBaseManager shareCenter];
        [center createTable_Cantact];
        
        NSString *memberNo = [Config Instance].memberNo;
        
        NSArray *items = [center getTop5ItemTable_Cantact:memberNo];
        
        FPDEBUG(@"count:%lu",(unsigned long)[items count]);
        if (!_contactItems) {
            _contactItems = [[NSArray alloc]init];
        }
    return items;
}

- (void)testDB
{
    FPDataBaseManager *center = [FPDataBaseManager shareCenter];
    
//    [center dropTable_Cantact];
    [center createTable_Cantact];
    
    ContactsInfo *item = [[ContactsInfo alloc] init];
    item.fromMemberNo = [Config Instance].memberNo;
    item.toMemberNo = @"222222222222222";
    item.toMemberAvator = @"Icon.png";
    item.toMemberName = @"郑文超";
    item.toMemberPhone = @"18718867801";
    item.toRemark = @"赏你的";
    item.toAmount = @"1200";
    
//    [center deleteTable_Cantact];
    
    [center updateIfExistTable_Cantact:item];
    
    NSArray *items = [center getAllItemTable_Cantact:[Config Instance].memberNo];
    if (items.count > 0) {
        for (ContactsInfo *item in items) {
            NSLog(@"fromMemberNo:%@",item.fromMemberNo);
            NSLog(@"toMemberNo:%@",item.toMemberNo);
            NSLog(@"toMemberPhone:%@",item.toMemberPhone);
            NSLog(@"toMemberName:%@",item.toMemberName);
            NSLog(@"toRemark:%@",item.toRemark);
            NSLog(@"toAmount:%@",item.toAmount);
        }
    }

}

- (NSArray *)getPhones:(ABRecordRef)person
{
    NSMutableArray* phoneList = [[NSMutableArray alloc] init];
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (phones){
        long count = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < count; i++) {
            NSString *phoneLabel     = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            NSString *phoneNumber    = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            
            NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
            
            [phoneList addObject:phoneNumber];
            
        }
    }
    CFRelease(phones);
    return phoneList;
}

@end

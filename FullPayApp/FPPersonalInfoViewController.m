//
//  FPPersonalInfoViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-17.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPersonalInfoViewController.h"
#import "FPPersonalInfoCell.h"
#import "FPMy2DimCodeViewController.h"
#import "FPMyPhotoViewController.h"
#import "FPCheckUserIdViewController.h"
#import "FPNameAndStaffIdViewController.h"
#import "FPCheckOldPhoneViewController.h"

@interface FPPersonalInfoViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) NSArray *itemTitles;
@property (nonatomic,strong) NSArray *itemImages;
@property (nonatomic,strong) NSArray *itemDetails;

@end

@implementation FPPersonalInfoViewController

static NSString *myTableViewCellIndentifier = @"itemPersonalCell";

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
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    [self.tableView
     registerClass:[FPPersonalInfoCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    FPPersonMember *personMember = [Config Instance].personMember;
    
    NSString *idNumber = @"";
    NSString *foxconnId = @"";
    NSArray *names1 = @[];
    if (personMember.nameAuthFlag) {
        names1 = @[personMember.memberName];
        NSString *idInfo = [personMember.certNo copy];
        if (idInfo.length > 4) {
            NSUInteger len = idInfo.length - 4;
            NSMutableString *replaceStr = [[NSMutableString alloc] initWithCapacity:0];
            for (int i = 0; i < len; i++) {
                [replaceStr appendString:@"*"];
            }
            
            idNumber = [idInfo stringByReplacingCharactersInRange:NSMakeRange(3, len) withString:replaceStr];
        } else {
            idNumber = idInfo;
        }
        
        NSString *jobId = [personMember.jobNumFoxconn copy];
        if (jobId.length > 4) {
            NSUInteger len = jobId.length - 4;
            NSMutableString *replaceStr = [[NSMutableString alloc] initWithCapacity:0];
            for (int i = 0; i < len; i++) {
                [replaceStr appendString:@"*"];
            }
            
            foxconnId = [jobId stringByReplacingCharactersInRange:NSMakeRange(3, len) withString:replaceStr];
        } else {
            foxconnId = jobId;
        }

    }else{
        names1 = @[@"未实名认证"];
    }
    
    NSArray *names2 = @[@"身份证件信息",@"工号信息",@"个人二维码"];
    NSArray *names3 = @[@"注册手机号"];
    NSArray *images1 = @[MIMAGE(@"perinfor_img_user_none")];
    NSArray *images2 = @[MIMAGE(@"perinfor_ic_id"),MIMAGE(@"perinfor_ic_workid"),MIMAGE(@"perinfor_ic_2dim")];
    NSArray *images3 = @[MIMAGE(@"perinfor_ic_phonenum")];
    NSArray *detail1 = @[personMember.mobile];
    NSArray *detail2 = @[idNumber,foxconnId,personMember.mobile];
    NSArray *detail3 = @[personMember.mobile];
    
    ImageUtils *imgUtils = [ImageUtils Instance];
    UIImage *showImage = [imgUtils getImageWithMemberNo:personMember.memberNo andHeadAddress:personMember.headAddress];
    if (showImage) {
        UIImage *reSize = [[ImageUtils Instance] reSizeImage:showImage toSize:CGSizeMake(49, 49)];
        
        images1 = @[reSize];
    }
    
    self.itemTitles = @[names1,names2,names3];
    self.itemImages = @[images1,images2,images3];
    self.itemDetails = @[detail1,detail2,detail3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemTitles[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPPersonalInfoCell* cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    cell.section = indexPath.section;
    cell.row = indexPath.row;
    if (indexPath.section == 0) {
        
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 24.5;
        
        cell.lbl_Mark.text = @"更改头像";
        
    } else if(indexPath.section == 1) {
        if (indexPath.row != 2) {
            cell.accessoryView.hidden = YES;
        }
    } else if(indexPath.section == 2) {
        cell.lbl_Mark.text = @"修改";
    }
    
    [cell.imageView setContentMode:UIViewContentModeScaleToFill];
    cell.imageView.image = [self.itemImages[indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [self.itemTitles[indexPath.section] objectAtIndex:[indexPath row]];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    NSArray *detail = self.itemDetails[indexPath.section];
    cell.detailTextLabel.text = detail[indexPath.row];
    
    if (indexPath.section == 0 && ![Config Instance].personMember.nameAuthFlag) {
        
        UIButton *toName = [UIButton buttonWithType:UIButtonTypeCustom];
        toName.frame = CGRectMake(0, 0, 100, 30);
        toName.top = 5;
        toName.left = 60;
        [toName addTarget:self action:@selector(gotoNameAndStaffIdViewController) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:toName];
    }
    
   
    return cell;
}

#pragma mark--UITapGestureRecognizer action 前往实名
- (void)gotoNameAndStaffIdViewController{
    //前往实名
    FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70.0f;
    }
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 18.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        FPMyPhotoViewController *controller = [[FPMyPhotoViewController alloc] init];
        
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            FPMy2DimCodeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FPMy2DimCodeView"];
            controller.comeForm = comeFormPersonIfo;

            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        if ([Config Instance].personMember.nameAuthFlag) {
            FPCheckUserIdViewController *controller = [[FPCheckUserIdViewController alloc] init];
            controller.comeFrom = comeFromPersonallInfo;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            
            FPCheckOldPhoneViewController *controller = [[FPCheckOldPhoneViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此功能需实名认证才可使用!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往实名", nil];
//            alert.tag = 101;
//            [alert show];

        }
        
        
    }
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 1) {
        //前往实名
        FPNameAndStaffIdViewController *controller = [[FPNameAndStaffIdViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];

    }
}



@end

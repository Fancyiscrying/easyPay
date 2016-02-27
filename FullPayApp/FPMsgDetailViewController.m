//
//  FPMsgDetailViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-18.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMsgDetailViewController.h"
#import "FPMsgDetailCell.h"
#import "FPDetilMessage.h"

@interface FPMsgDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *comeFrom;
@property (strong, nonatomic) UILabel *context;

@property (strong, nonatomic) FPDetilMessage *detilMessage;
@end

@implementation FPMsgDetailViewController

static NSString *myTableViewCellIndentifier = @"itemMsgDetailCell";

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"私信详情";
    
    [self.tableView
     registerClass:[FPMsgDetailCell class] forCellReuseIdentifier:myTableViewCellIndentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.userInteractionEnabled = NO;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    [self getDetilMessageInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- NETWorking
- (void)getDetilMessageInfo{
    NSString *memberNo =[Config Instance].personMember.memberNo;
    [FPDetilMessage findMessageInfoMessageId:_mes.messageId andMemberNo:memberNo andReaded:_mes.readed andBlock:^(FPDetilMessage *detilMessage, NSError *error){
        if (detilMessage.result) {
            self.detilMessage = detilMessage;
            [self.tableView reloadData];
        }else{
            [self showToastMessage:detilMessage.errorInfo];
        }
        
        if (error != nil) {
            [UtilTool showToastToView:self.view andMessage:kNetworkErrorMessage];
        }
        
    }];
}

#pragma mark table view datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPMsgDetailCell *cell;
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)]) {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCellIndentifier];
        if (cell == nil) {
            cell = [[FPMsgDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myTableViewCellIndentifier];
        }
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"  %@",_detilMessage.createDate];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"来自：%@",_detilMessage.senderName];
    } else {
        //cell.textLabel.text = [NSString stringWithFormat:@"    %@",_message.content];
        //cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
        if (_detilMessage.content.length > 0) {
            float height = [self getContextHeight:_detilMessage.content];
            
            UILabel *context = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 0)];
            context.numberOfLines = 0;
            context.backgroundColor = [UIColor clearColor];
            context.height = height +15;
            context.font = [UIFont systemFontOfSize:14];
            context.text = [NSString stringWithFormat:@"       %@",_detilMessage.content];
            
            [cell addSubview:context];
        }
        
    }
    
    
    return cell;
}

#pragma mark tableview data delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0f;
    }
    //float height = [self getContextHeight:_message.content];

    return ScreenHigh;
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
}

//获得一段文字的高
- (float)getContextHeight:(NSString *)str{
    
    float height = 0;
    UIFont *font = [UIFont systemFontOfSize:14.0f];//11 一定要跟label的显示字体大小一致
    //设置字体
    CGSize size = CGSizeMake(300, 20000.0f);
    //注：这个宽：280 是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    height = size.height;
    return height;
    
}


@end

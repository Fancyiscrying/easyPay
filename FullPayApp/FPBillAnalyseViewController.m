//
//  FPBillAnalyseViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPBillAnalyseViewController.h"
#import "UIButton+UIButtonImageWithLabel.h"

@implementation BillData

-(BillData *)initWithDictionary:(NSDictionary *)diction
{
    self.discountAmt = [[diction objectForKey:@"discountAmt"] doubleValue];
    self.expenditurAmt = [[diction objectForKey:@"expenditurAmt"] doubleValue];
    self.expenditurCount = [[diction objectForKey:@"expenditurCount"] longValue];
    self.expenditurInt = [[diction objectForKey:@"expenditurInt"] longValue];
    self.incomeAmt = [[diction objectForKey:@"incomeAmt"] doubleValue];
    self.incomeCount = [[diction objectForKey:@"incomeCount"] longValue];
    self.incomeInt = [[diction objectForKey:@"incomeInt"] longValue];;
    
    return  self;
}

@end

@interface FPBillAnalyseViewController ()

@property (nonatomic,assign) FPBillAnalyseShowStyle baShowNow;

@end

@implementation FPBillAnalyseViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    UIImageView *background = [[UIImageView alloc] initWithFrame:view.bounds];
    background.image = [UIImage imageNamed:@"BG"];
    [view addSubview:background];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, 320, view.bounds.size.height - 44);
    scrollView.scrollEnabled = YES;
    scrollView.alwaysBounceHorizontal = NO;
    
    self.btn1Month = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1Month.frame = CGRectMake(20, 7, 73, 23);
    self.btn1Month.backgroundColor = [UIColor clearColor];
    [self.btn1Month setTitle:@"最近1个月" forState:UIControlStateNormal];
    [self.btn1Month setTitleColor:MCOLOR(@"text_color") forState:UIControlStateNormal];
    self.btn1Month.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.btn1Month addTarget:self action:@selector(clickShow1Month:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.btn1Month];
    
    self.btn3Month = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn3Month.frame = CGRectMake(124, 7, 73, 23);
    self.btn3Month.backgroundColor = [UIColor clearColor];
    [self.btn3Month setTitle:@"最近3个月" forState:UIControlStateNormal];
    [self.btn3Month setTitleColor:MCOLOR(@"text_color") forState:UIControlStateNormal];
    self.btn3Month.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.btn3Month addTarget:self action:@selector(clickShow3Month:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.btn3Month];
    
    self.btn6Month = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn6Month.frame = CGRectMake(228, 7, 73, 23);
    self.btn6Month.backgroundColor = [UIColor clearColor];
    [self.btn6Month setTitle:@"最近6个月" forState:UIControlStateNormal];
    [self.btn6Month setTitleColor:MCOLOR(@"text_color") forState:UIControlStateNormal];
    self.btn6Month.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.btn6Month addTarget:self action:@selector(clickShow6Month:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.btn6Month];
    
    UIImageView *imgRed = [[UIImageView alloc] initWithFrame:CGRectMake(70, 50, 180, 180)];
    imgRed.image = MIMAGE(@"billanalyze_ic_red");
    [scrollView addSubview:imgRed];
    
    UIImageView *imgGreen = [[UIImageView alloc] initWithFrame:CGRectMake(70, 283, 180, 180)];
    imgGreen.image = MIMAGE(@"billanalyze_ic_green");
    [scrollView addSubview:imgGreen];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 265, 320, 1)];
    imgLine.image = MIMAGE(@"confirmation_dottedline");
    [scrollView addSubview:imgLine];
    
    UILabel *tip1 = [[UILabel alloc] init];
    tip1.frame = CGRectMake(139, 106, 42, 21);
    tip1.backgroundColor = [UIColor clearColor];
    tip1.textAlignment = NSTextAlignmentCenter;
    tip1.textColor = MCOLOR(@"minus_amt_label_color");
    tip1.font = [UIFont systemFontOfSize:14.0f];
    tip1.text = @"支出:";
    [scrollView addSubview:tip1];
    
    self.labelExpenditureAmt = [[UILabel alloc] init];
    self.labelExpenditureAmt.frame = CGRectMake(70, 134, 180, 21);
    self.labelExpenditureAmt.backgroundColor = [UIColor clearColor];
    self.labelExpenditureAmt.textAlignment = NSTextAlignmentCenter;
    self.labelExpenditureAmt.textColor = MCOLOR(@"text_color");
    self.labelExpenditureAmt.font = [UIFont systemFontOfSize:14.0f];
    [scrollView addSubview:self.labelExpenditureAmt];
    
    UILabel *tip4 = [[UILabel alloc] init];
    tip4.frame = CGRectMake(70, 236, 76, 21);
    tip4.backgroundColor = [UIColor clearColor];
    tip4.textAlignment = NSTextAlignmentCenter;
    tip4.textColor = MCOLOR(@"text_color");
    tip4.font = [UIFont systemFontOfSize:14.0f];
    tip4.text = @"为您节约";
    [scrollView addSubview:tip4];
    
    self.labelDiscountAmt = [[UILabel alloc] init];
    self.labelDiscountAmt.frame = CGRectMake(149, 236, 101, 21);
    self.labelDiscountAmt.backgroundColor = [UIColor clearColor];
    self.labelDiscountAmt.textAlignment = NSTextAlignmentCenter;
    self.labelDiscountAmt.textColor = [UIColor redColor];
    self.labelDiscountAmt.font = [UIFont systemFontOfSize:14.0f];
    [scrollView addSubview:self.labelDiscountAmt];
    
    UILabel *tip2 = [[UILabel alloc] init];
    tip2.frame = CGRectMake(139, 331, 42, 21);
    tip2.backgroundColor = [UIColor clearColor];
    tip2.textAlignment = NSTextAlignmentCenter;
    tip2.textColor = MCOLOR(@"minus_amt_label_color");
    tip2.font = [UIFont systemFontOfSize:14.0f];
    tip2.text = @"收入";
    [scrollView addSubview:tip2];
    
    self.labelIncomeAmt = [[UILabel alloc] init];
    self.labelIncomeAmt.frame = CGRectMake(70, 362, 180, 21);
    self.labelIncomeAmt.backgroundColor = [UIColor clearColor];
    self.labelIncomeAmt.textAlignment = NSTextAlignmentCenter;
    self.labelIncomeAmt.textColor = MCOLOR(@"text_color");
    self.labelIncomeAmt.font = [UIFont systemFontOfSize:14.0f];
    [scrollView addSubview:self.labelIncomeAmt];
    
    UILabel *tip3 = [[UILabel alloc] init];
    tip3.frame = CGRectMake(70, 471, 42, 21);
    tip3.backgroundColor = [UIColor clearColor];
    tip3.textAlignment = NSTextAlignmentCenter;
    tip3.textColor = MCOLOR(@"minus_amt_label_color");
    tip3.font = [UIFont systemFontOfSize:14.0f];
    tip3.text = @"返现";
    tip3.hidden = YES;
    [scrollView addSubview:tip3];
    
    self.labelIncomeInt = [[UILabel alloc] init];
    self.labelIncomeInt.frame = CGRectMake(122, 471, 128, 21);
    self.labelIncomeInt.backgroundColor = [UIColor clearColor];
    self.labelIncomeInt.textAlignment = NSTextAlignmentLeft;
    self.labelIncomeInt.textColor = [UIColor redColor];
    self.labelIncomeInt.font = [UIFont systemFontOfSize:14.0f];
    self.labelIncomeInt.hidden = YES;
    [scrollView addSubview:self.labelIncomeInt];
    
    [scrollView setContentSize:CGSizeMake(320, 500)];
    [view addSubview:scrollView];
    
    self.view = view;
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
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
    self.navigationItem.title = @"账单分析";
    self.navigationController.navigationBar.translucent = NO;
    
    [self billQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {

        if (self.baShowNow == FPBillAnalyseShowLeft) {
            [self clickShow3Month:nil];
        } else if (self.baShowNow == FPBillAnalyseShowCenter) {
            [self clickShow6Month:nil];
        } else {
            return;
        }
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {

        if (self.baShowNow == FPBillAnalyseShowLeft) {
            return;
        } else if (self.baShowNow == FPBillAnalyseShowCenter) {
            [self clickShow1Month:nil];
        } else {
            [self clickShow3Month:nil];
        }
    }
}

-(void)billQuery
{
    NSString *memberNo = [Config Instance].memberNo;
    FPClient *urlClient = [FPClient sharedClient];
    NSDictionary *parameters = [urlClient userTradeStatistics:memberNo];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [urlClient POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue] == YES) {
            
            self.billAnalyseData = [responseObject objectForKey:@"returnObj"];
            [self clickShow3Month:self.btn3Month];
            self.baShowNow = FPBillAnalyseShowCenter;
            
        }else{
            NSString *errInfo = [responseObject objectForKey:@"errorInfo"];
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"查询账单分析失败" message:errInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alter setContentMode:UIViewContentModeCenter];
            [alter show];
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        NSLog(@"%@",error);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)clickShow1Month:(id)sender {
    
    self.baShowNow = FPBillAnalyseShowLeft;
    
    [self.btn1Month.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.btn3Month.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.btn6Month.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.btn1Month addLine:self.btn1Month];
    [self.btn3Month removeLine:self.btn3Month];
    [self.btn6Month removeLine:self.btn6Month];
    BillData *data = [[BillData alloc] initWithDictionary:[self.billAnalyseData objectForKey:@"30"]];
    [self showLabelData:data];
}

- (void)clickShow3Month:(id)sender {
    
    self.baShowNow = FPBillAnalyseShowCenter;
    
    [self.btn1Month.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.btn3Month.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.btn6Month.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.btn3Month addLine:self.btn3Month];
    [self.btn1Month removeLine:self.btn1Month];
    [self.btn6Month removeLine:self.btn6Month];
    BillData *data = [[BillData alloc] initWithDictionary:[self.billAnalyseData objectForKey:@"90"]];
    [self showLabelData:data];
}

- (void)clickShow6Month:(id)sender {
    
    self.baShowNow = FPBillAnalyseShowRight;
    
    [self.btn1Month.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.btn3Month.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.btn6Month.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.btn6Month addLine:self.btn6Month];
    [self.btn1Month removeLine:self.btn1Month];
    [self.btn3Month removeLine:self.btn3Month];
    BillData *data = [[BillData alloc] initWithDictionary:[self.billAnalyseData objectForKey:@"180"]];
    [self showLabelData:data];
}

-(void)showLabelData:(BillData *)data
{
    self.labelExpenditureAmt.text = [NSString stringWithFormat:@"%.02f元",data.expenditurAmt/100];
    self.labelDiscountAmt.text = [NSString stringWithFormat:@"%.02f元",data.discountAmt/100];
    //    self.labelExpenditureInt.text = [NSString stringWithFormat:@"%ld",data.expenditurInt/100];
    self.labelIncomeAmt.text = [NSString stringWithFormat:@"%.02f元",data.incomeAmt/100];
    self.labelIncomeInt.text = [NSString stringWithFormat:@"%ld富米",data.incomeInt];
}

@end

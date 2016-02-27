//
//  FPWalletCardListViewController.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/7.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardListViewController.h"
#import "FPWalletCardListModel.h"
#import "FPWalletCardListTable.h"
#import "FPWalletCardNumViewController.h"
#import "FPWalletCardInfoDetilController.h"
#import "FPWalletApplyRealCardController.h"


@interface FPWalletCardListViewController()<UITableViewRefreshDelegate>
@property (nonatomic, strong) FPWalletCardListTable *table;

@end

@implementation FPWalletCardListViewController


- (void)loadView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHigh-NavBarHeight)];
    view.backgroundColor = COLOR_STRING(@"EDF1F2");
    
    _table = [[FPWalletCardListTable alloc]initWithFrame:view.bounds style:UITableViewStylePlain];
    _table.refreshDelegate = self;
    [view addSubview:_table];
    
    [self addTableFootView];
    
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    [self loadCardListData];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

}

- (void)viewDidLoad{
    self.title = @"富钱包";

    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:SystemFontSize(12),NSFontAttributeName, nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"申请实名卡" style:UIBarButtonItemStylePlain target:self action:@selector(tapRightButton)];
    [right setTitleTextAttributes:attribute forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    [back setTitle:@""];
    self.navigationItem.backBarButtonItem = back;
    
}


- (void)addTableFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    footView.backgroundColor = ClearColor;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(15, 10, footView.width-30, 35);
    [nextButton setBackgroundImage:MIMAGE(COMM_BTN_BLUE) forState:UIControlStateNormal];
    [nextButton setBackgroundImage:MIMAGE(COMM_BTN_GRAY) forState:UIControlStateDisabled];
    [nextButton setTitle:@"添加新卡" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(clickAddCard) forControlEvents:UIControlEventTouchUpInside];
    nextButton.titleLabel.font = SystemFontSize(14);
    [footView addSubview:nextButton];
    
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 5;
    
    [_table setTableFooterView:footView];

}

- (void)clickAddCard{
    FPWalletCardNumViewController *controller = [[FPWalletCardNumViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tapRightButton{
    FPWalletApplyRealCardController *controller = [[FPWalletApplyRealCardController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadCardListData{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [UtilTool showHUD:@"正在处理" andView:self.view andHUD:hud];
    
    [FPWalletCardListModel findCardRelate:[Config Instance].memberNo andBlock:^(FPWalletCardListModel *cardListModel, NSError *error) {
        [hud hide:YES];
        _table.cardList = cardListModel.carList;
        [_table reloadData];
    }];
}

#pragma mark UITableViewRefreshDelegate
- (void)tableView:(RTTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletCardListItem *item = _table.cardList[indexPath.row];
    
    FPWalletCardInfoDetilController *controller = [[FPWalletCardInfoDetilController alloc]init];
    controller.cardId = item.cardId;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

//
//  FPBankCardListViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-28.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

typedef enum {
    BankCardListViewComeFormCardRecharge,
    BankCardListViewComeFormPayAmtCard

}BankCardListViewComeForm;

@interface FPBankCardListViewController : UITableViewController
@property (nonatomic, assign)BankCardListViewComeForm viewComeForm;
@end

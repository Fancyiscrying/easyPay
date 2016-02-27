//
//  FPBillAnalyseViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-3-3.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"

/*
 returnObj =     {
 180 =         {
 discountAmt = 240;
 expenditurAmt = 3960;
 expenditurInt = 0;
 incomeAmt = 380300;
 incomeInt = 0;
 };
 30 =         {
 discountAmt = 240;
 expenditurAmt = 3960;
 expenditurInt = 0;
 incomeAmt = 380300;
 incomeInt = 0;
 };
 90 =         {
 discountAmt = 0;
 expenditurAmt = 41984;
 expenditurCount = 21967;
 expenditurInt = 0;
 incomeAmt = 100000;
 incomeCount = 1;
 incomeInt = 0;
 };
 };
 */
@interface BillData : NSObject

@property (nonatomic,assign) double discountAmt;
@property (nonatomic,assign) double expenditurAmt;
@property (nonatomic,assign) long expenditurCount;
@property (nonatomic,assign) long expenditurInt;
@property (nonatomic,assign) double incomeAmt;
@property (nonatomic,assign) long incomeCount;
@property (nonatomic,assign) long incomeInt;

-(BillData *)initWithDictionary:(NSDictionary *)diction;

@end

typedef NS_ENUM(NSInteger, FPBillAnalyseShowStyle) {
    FPBillAnalyseShowLeft = 0,
    FPBillAnalyseShowCenter,
    FPBillAnalyseShowRight,
};

@interface FPBillAnalyseViewController : FPViewController

@property (nonatomic,strong) NSDictionary *billAnalyseData;

@property (strong, nonatomic) UILabel *labelExpenditureAmt;
@property (strong, nonatomic) UILabel *labelDiscountAmt;
//@property (strong, nonatomic) UILabel *labelExpenditureInt;
@property (strong, nonatomic) UILabel *labelIncomeAmt;
@property (strong, nonatomic) UILabel *labelIncomeInt;

@property (strong, nonatomic) UIButton *btn1Month;
@property (strong, nonatomic) UIButton *btn3Month;
@property (strong, nonatomic) UIButton *btn6Month;

@end

//
//  FPWalletCardAnalyzeModel.h
//  FullPayApp
//
//  Created by 刘通超 on 15/4/13.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyzeMonthItem : NSObject

@property (nonatomic, assign) double payeeAmt;
@property (nonatomic, assign) double payerAmt;
@property (nonatomic, assign) int outPayPercent;
@property (nonatomic, assign) int stsMonth;

@end

@interface AnalyzeTotal : NSObject

@property (nonatomic, assign) double payeeAmt;
@property (nonatomic, assign) double payerAmt;
@property (nonatomic, assign) double totalCount;

@end

@interface FPWalletCardAnalyzeModel : NSObject
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorInfo;
@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) AnalyzeTotal *totalItem;
@property (nonatomic, strong) NSMutableArray *analyzeList;


+ (void)findMonthStsWithAccountNo:(NSString *)accountNo andStart:(NSString *)start andBlock:(void(^)(FPWalletCardAnalyzeModel *analyzeModel, NSError *error))block;

@end

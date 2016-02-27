//
//  FPWalletCardAnalyzeModel.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/13.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardAnalyzeModel.h"

@implementation AnalyzeMonthItem

@end

@implementation AnalyzeTotal

@end

@implementation FPWalletCardAnalyzeModel

+ (void)findMonthStsWithAccountNo:(NSString *)accountNo andStart:(NSString *)start andBlock:(void(^)(FPWalletCardAnalyzeModel *analyzeModel, NSError *error))block{
    
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findMonthStsWithAccountNo:accountNo andStart:start];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDEBUG(@"%@",responseObject);
        
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        FPWalletCardAnalyzeModel *analyzeModel = [[FPWalletCardAnalyzeModel alloc]init];
        analyzeModel.analyzeList = [[NSMutableArray alloc]init];
        analyzeModel.result = result;
        if (result) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            NSDictionary *totalIte = [returnObj objectForKey:@"otherData"];
            analyzeModel.totalItem = [AnalyzeTotal objectWithKeyValues:totalIte];
            
            NSArray *rows = [returnObj objectForKey:@"rows"];
            NSArray *list = [AnalyzeMonthItem objectArrayWithKeyValuesArray:rows];
            int tempTitle = 0;
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            for (int i=0; i<list.count; i++) {
                AnalyzeMonthItem *temp = list[i];
                if (temp.payerAmt == 0 && temp.payeeAmt == 0) {
                    temp.outPayPercent = 50;
                }else if(temp.payerAmt == 0){
                    temp.outPayPercent = 0;
                }else{
                    temp.outPayPercent = (int)100*temp.payerAmt/(temp.payeeAmt+temp.payerAmt);
                }
                
                if (temp.stsMonth/100 == tempTitle) {
                    [tempArray addObject:temp];

                }else{
                    if (tempArray.count > 0) {
                        NSArray *inArry = [[NSArray alloc]initWithArray:tempArray];
                        [analyzeModel.analyzeList addObject:inArry];
                    }
                    tempTitle = temp.stsMonth/100;
                    [tempArray removeAllObjects];
                    [tempArray addObject:temp];
                }
                
                if (i == list.count-1) {
                    NSArray *inArry = [[NSArray alloc]initWithArray:tempArray];
                    [analyzeModel.analyzeList addObject:inArry];
                }
            }

        }else{
            analyzeModel.errorCode = [responseObject objectForKey:@"errorCode"];
            analyzeModel.errorInfo = [responseObject objectForKey:@"errorInfo"];
        }

        if (block) {
            block(analyzeModel,nil);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end

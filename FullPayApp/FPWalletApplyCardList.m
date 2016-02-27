//
//  FPWalletApplyCardList.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/10.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletApplyCardList.h"

@implementation ApplyItem

@end

@implementation ApplyTotalItem

@end

@implementation FPWalletApplyCardList

+ (void)getCardApplyWithMemberNo:(NSString *)memberNo andBlock:(void(^)(FPWalletApplyCardList *applyCardList, NSError *error))block{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findCardApplyWithMemberNo:memberNo];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        FPWalletApplyCardList *applyCardList = [[FPWalletApplyCardList alloc]init];
        applyCardList.applyList = [[NSArray alloc]init];
        applyCardList.result = result;
        if (result) {
            NSDictionary *returnObj = [responseObject objectForKey:@"returnObj"];
            NSDictionary *totalIte = [returnObj objectForKey:@"otherData"];
            applyCardList.totalItem = [ApplyTotalItem objectWithKeyValues:totalIte];
            
            NSArray *rows = [returnObj objectForKey:@"rows"];
            applyCardList.applyList = [ApplyItem objectArrayWithKeyValuesArray:rows];
            
        }else{
            applyCardList.errorCode = [responseObject objectForKey:@"errorCode"];
            applyCardList.errorInfo = [responseObject objectForKey:@"errorInfo"];
        }
        
        if (block) {
            block(applyCardList,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];

}
@end

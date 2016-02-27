//
//  FPWalletCardListModel.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/7.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardListModel.h"

@implementation WalletCardDetilItem


@end

@implementation WalletCardListItem

@end

@implementation FPWalletCardListModel
+(void)findCardRelate:(NSString *)memberNo andBlock:(void(^)(FPWalletCardListModel* cardListModel ,NSError *error))block{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findCardRelateWithMemberNo:memberNo];
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL result = [[responseObject objectForKey:@"result"]boolValue];
        FPWalletCardListModel *cardListModel = [[FPWalletCardListModel alloc]init];
        cardListModel.carList = [[NSMutableArray alloc]init];
        cardListModel.result = result;
        if (result) {
            NSArray *returnObj = [responseObject objectForKey:@"returnObj"];
            for (NSDictionary *temp in returnObj) {
                
                WalletCardListItem *item = [WalletCardListItem objectWithKeyValues:temp];
                item.cardId = [temp objectForKey:@"id"];
                
                [cardListModel.carList addObject:item];
            }
        }else{
            cardListModel.errorCode = [responseObject objectForKey:@"errorCode"];
            cardListModel.errorInfo = [responseObject objectForKey:@"errorInfo"];
        }
        
        if (block) {
            block(cardListModel,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];

}
@end

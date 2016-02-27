//
//  FPDetilMessage.m
//  FullPayApp
//
//  Created by 刘通超 on 14-10-16.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPDetilMessage.h"

@implementation FPDetilMessage
- (id)initWithAttributes:(NSDictionary *)attributes{
    _result = [[attributes objectForKey:@"result"]boolValue];
    if (_result) {
        NSDictionary *returnObj = [attributes objectForKey:@"returnObj"];
        _content = [returnObj objectForKey:@"content"];
        _createDate = [returnObj objectForKey:@"createDate"];
        _senderName = [returnObj objectForKey:@"senderName"];
    }else{
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}


+ (void)findMessageInfoMessageId:(NSString *)messageId andMemberNo:(NSString *)memberNo andReaded:(BOOL)readed andBlock:(void (^)(FPDetilMessage *detilMessage , NSError *error))block{
    FPClient *client = [FPClient sharedClient];
    NSDictionary *paramters = [client findMessageInfoMessageId:messageId andMemberNo:memberNo andReaded:readed];
    
    [client POST:kFPPost parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FPDetilMessage *detilMessage = [[FPDetilMessage alloc]initWithAttributes:responseObject];
        if (block) {
            block(detilMessage,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}
@end

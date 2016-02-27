//
//  FPMessageList.m
//  FullPayApp
//
//  Created by lc on 14-6-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//
/*
 messageId   消息id
 senderId     消息发起者id
 receiverName 会员名称
 createTime  消息创建时间
 content 消息内容
 deviceId     设备id
 title 消息标题
 readStatus  阅读状态
 appCode app标示
 sendStatus  发送状态
 sendTime    发送时间
 audit       审核状态
 auditorId   审核人id
 auditorNickName  审核人昵称
 receiverId 接收者id
 deleteStatus  消息删除状态（1未删除  0删除）
 pushType 推送类型
 */
#import "FPMessageList.h"

@implementation userMessage

- (userMessage *)initWithAttributes:(NSDictionary *)attributes{
    
    self.messageId = [attributes objectForKey:@"id"];
    self.content = [attributes objectForKey:@"content"];
    self.createDate = [attributes objectForKey:@"createDate"];
    self.readed = [[attributes objectForKey:@"readed"] boolValue];

    return self;

}

@end

@implementation FPMessageList

-(FPMessageList *)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _result = [[attributes objectForKey:@"result"] boolValue];
    if (_result) {
        if ([attributes objectForKey:@"returnObj"] != [NSNull null]) {
           
            NSDictionary *returnObj = [attributes objectForKey:@"returnObj"];
            NSArray *messages = [returnObj objectForKey:@"rows"];
            if (messages.count > 0) {
                NSMutableArray *messageArray = [NSMutableArray arrayWithCapacity:messages.count];
                
                for (NSDictionary *messageInfo in messages) {
                   
                    userMessage *messageItem = [[userMessage alloc]initWithAttributes:messageInfo];
                    [messageArray addObject:messageItem];
                }
                
                self.messageItems = messageArray;
            } else {
                _result = NO;
            }
        } else {
            _result = NO;
        }
        
        if (_result == NO) {
            _errorInfo = @"未查询到你所需要的信息";
        }
        
    } else {
        _errorInfo = [attributes objectForKey:@"errorInfo"];
    }
    
    return self;
}



+ (void)findMessageList:(NSString *)start
               andLimit:(NSString *)limit
            andMemberNo:(NSString *)memberNo
                    and:(void(^)(FPMessageList *messageList ,NSError *error))block{

    if (start.length>0 && limit.length>0 && memberNo.length>0) {
        FPClient *clientUrl = [FPClient sharedClient];
        NSDictionary *parameters = [clientUrl findMineMessageInfoPage:start andCreateDate:[Config Instance].personMember.createDate andLimit:limit andMemberNo:memberNo];
        
        [clientUrl POST:kFPPost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            FPDEBUG(@"findMineMessageInfo: %@",responseObject);
            FPMessageList *messageList = [[FPMessageList alloc]initWithAttributes:responseObject];
            if (block) {
                block(messageList,nil);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                block(nil,error);
            }
        }];
    }
    
}


@end

//
//  FPDetilMessage.h
//  FullPayApp
//
//  Created by 刘通超 on 14-10-16.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 errorCode = "";
 errorInfo = "";
 result = 1;
 returnObj =     {
 content = "";
 createDate = "";
 senderName = "";
 };
 validateCode = "";
 */

@interface FPDetilMessage : NSObject

@property (assign, nonatomic) BOOL result;
@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *errorInfo;
@property (strong, nonatomic) NSString *createDate;
@property (strong, nonatomic) NSString *senderName;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)findMessageInfoMessageId:(NSString *)messageId andMemberNo:(NSString *)memberNo andReaded:(BOOL)readed andBlock:(void (^)(FPDetilMessage *detilMessage , NSError *error))block;
@end

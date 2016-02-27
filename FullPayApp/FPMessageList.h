//
//  FPMessageList.h
//  FullPayApp
//
//  Created by lc on 14-6-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

/*
 content = setContent;
 createDate = "2014-10-16 16:24:42";
 id = 4;
 readed = 0;
 */

#import <Foundation/Foundation.h>

@interface userMessage : NSObject
@property (copy, nonatomic) NSString *messageId;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *createDate;
@property (assign, nonatomic) BOOL    readed;


- (userMessage *)initWithAttributes:(NSDictionary *)attributes;

@end

@interface FPMessageList : NSObject

@property (readonly) BOOL   result;
@property (readonly) NSString *errorInfo;

@property (strong, nonatomic) NSMutableArray *messageItems;

+ (void)findMessageList:(NSString *)start
               andLimit:(NSString *)limit
            andMemberNo:(NSString *)memberNo
                    and:(void(^)(FPMessageList *messageList ,NSError *error))block;

@end

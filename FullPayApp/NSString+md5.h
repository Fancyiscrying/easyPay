//
//  NSString+md5.h
//  AFNetworkingDemo
//
//  Created by mark zheng on 13-7-2.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (md5)

-(NSString *)md5HexDigest;
-(NSData *)md5BlockBytes;
-(NSString *)md5Twice:(NSString *)privateKey;
-(NSData *)md5Encrypt:(NSString *)privateKey;

@end

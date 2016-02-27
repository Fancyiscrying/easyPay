//
//  NSString+md5.m
//  AFNetworkingDemo
//
//  Created by mark zheng on 13-7-2.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "NSString+md5.h"

@implementation NSString (md5)

-(NSString *)md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X",result[i]];
    }
    
    return [hash lowercaseString];
}

-(NSString *)md5Twice:(NSString *)privateKey
{
    NSMutableString *oneStr = [NSMutableString string];
    [oneStr appendString:[self md5HexDigest]];
    [oneStr appendString:privateKey];
    
    return oneStr.md5HexDigest;
}

-(NSData *)md5BlockBytes
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    
    NSData *data = [NSData dataWithBytes:result length:16];
    
    return data;
}

-(NSData *)md5Encrypt:(NSString *)privateKey
{
    NSMutableString *oneStr = [NSMutableString string];
    [oneStr appendString:self];
    [oneStr appendString:privateKey];

    return oneStr.md5BlockBytes;
}

@end

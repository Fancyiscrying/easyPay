//
//  FPMethodMap.m
//  FullPayApp
//
//  Created by mark zheng on 14-1-10.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPMethodMap.h"

#define kMethodMap @"methodMap"

@implementation FPMethodMap

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.methodMap = [attributes copy];
    
    return self;
}

#pragma mark -
#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.methodMap forKey:kMethodMap];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.methodMap = [aDecoder decodeObjectForKey:kMethodMap];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    FPMethodMap *temp = [[self class]allocWithZone:zone];
    temp.methodMap = [self.methodMap copyWithZone:zone];
    
    return temp;
}

@end

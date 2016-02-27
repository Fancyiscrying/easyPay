//
//  FPAppParams.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPAppParams.h"

@implementation FPAppParams
- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _customerServiceTelephone = [attributes objectForKey:@"customerServiceTelephone"];
    _noteLimitOn = [attributes objectForKey:@"noteLimitOn"];
    _noteLimitOff = [attributes objectForKey:@"noteLimitOff"];
    _allUserRgeMinAmount = [attributes objectForKey:@"allUserRgeMinAmount"];
    _realNameAcctMaxBalance = [attributes objectForKey:@"realNameAcctMaxBalance"];
    _realNameBindCardLimit = [attributes objectForKey:@"realNameBindCardLimit"];
    _realNamePayMaxAmount = [attributes objectForKey:@"realNamePayMaxAmount"];
    _realNameRgeMaxAmount = [attributes objectForKey:@"realNameRgeMaxAmount"];
    _unRealNameAcctMaxBalance = [attributes objectForKey:@"unRealNameAcctMaxBalance"];
    _unRealNameBindCardLimit = [attributes objectForKey:@"unRealNameBindCardLimit"];
    _noPswAmountLimit = [attributes objectForKey:@"noPswAmountLimit"];
    _unRealNamePayMaxAmount = [attributes objectForKey:@"unRealNamePayMaxAmount"];
    _unRealNameRgeMaxAmount = [attributes objectForKey:@"unRealNameRgeMaxAmount"];
    
    _realNamePayAmountLimit = [attributes objectForKey:@"realNamePayAmountLimit"];
    _unRealNamePayAmountLimit = [attributes objectForKey:@"unRealNamePayAmountLimit"];
    
    _offlineRgeMinAmount = [attributes objectForKey:@"offlineRgeMinAmount"];
    _offlineRgeMaxAmount = [attributes objectForKey:@"offlineRgeMaxAmount"];
    
    _withdrawFee = [attributes objectForKey:@"withdrawFee"];
    _withdrawFeeMode = [attributes objectForKey:@"withdrawFeeMode"];
    _withdrawMaxFeeAmt = [attributes objectForKey:@"withdrawMaxFeeAmt"];
    _withdrawMinAmt = [attributes objectForKey:@"withdrawMinAmt"];

    _offlineLossEffectiveTime = [attributes objectForKey:@"offlineLossEffectiveTime"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.customerServiceTelephone forKey:@"customerServiceTelephone"];
    [encoder encodeObject:self.noteLimitOn forKey:@"noteLimitOn"];
    [encoder encodeObject:self.noteLimitOff forKey:@"noteLimitOff"];
    [encoder encodeObject:self.allUserRgeMinAmount forKey:@"allUserRgeMinAmount"];
    [encoder encodeObject:self.realNameAcctMaxBalance forKey:@"realNameAcctMaxBalance"];
    [encoder encodeObject:self.realNameBindCardLimit forKey:@"realNameBindCardLimit"];
    [encoder encodeObject:self.realNamePayMaxAmount forKey:@"realNamePayMaxAmount"];
    [encoder encodeObject:self.realNameRgeMaxAmount forKey:@"realNameRgeMaxAmount"];
    
    [encoder encodeObject:self.unRealNameAcctMaxBalance forKey:@"unRealNameAcctMaxBalance"];
    [encoder encodeObject:self.unRealNameBindCardLimit forKey:@"unRealNameBindCardLimit"];
    [encoder encodeObject:self.noPswAmountLimit forKey:@"noPswAmountLimit"];
    [encoder encodeObject:self.unRealNamePayMaxAmount forKey:@"unRealNamePayMaxAmount"];
    [encoder encodeObject:self.unRealNameRgeMaxAmount forKey:@"unRealNameRgeMaxAmount"];
    
    [encoder encodeObject:self.realNamePayAmountLimit forKey:@"realNamePayAmountLimit"];
    [encoder encodeObject:self.unRealNamePayAmountLimit forKey:@"unRealNamePayAmountLimit"];

    [encoder encodeObject:self.offlineRgeMaxAmount forKey:@"offlineRgeMaxAmount"];
    [encoder encodeObject:self.offlineRgeMinAmount forKey:@"offlineRgeMinAmount"];
    
    [encoder encodeObject:self.withdrawFee forKey:@"withdrawFee"];
    [encoder encodeObject:self.withdrawFeeMode forKey:@"withdrawFeeMode"];
    [encoder encodeObject:self.withdrawMaxFeeAmt forKey:@"withdrawMaxFeeAmt"];
    [encoder encodeObject:self.withdrawMinAmt forKey:@"withdrawMinAmt"];
    
    [encoder encodeObject:self.offlineLossEffectiveTime forKey:@"offlineLossEffectiveTime"];

    
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.customerServiceTelephone = [decoder decodeObjectForKey:@"customerServiceTelephone"];
        self.noteLimitOn = [decoder decodeObjectForKey:@"noteLimitOn"];
        self.noteLimitOff = [decoder decodeObjectForKey:@"noteLimitOff"];
        self.allUserRgeMinAmount = [decoder decodeObjectForKey:@"allUserRgeMinAmount"];
        self.realNameAcctMaxBalance = [decoder decodeObjectForKey:@"realNameAcctMaxBalance"];
        self.realNameBindCardLimit = [decoder decodeObjectForKey:@"realNameBindCardLimit"];
        self.realNamePayMaxAmount = [decoder decodeObjectForKey:@"realNamePayMaxAmount"];
        self.realNameRgeMaxAmount = [decoder decodeObjectForKey:@"realNameRgeMaxAmount"];
        
        self.unRealNameAcctMaxBalance = [decoder decodeObjectForKey:@"unRealNameAcctMaxBalance"];
        self.unRealNameBindCardLimit = [decoder decodeObjectForKey:@"unRealNameBindCardLimit"];
        self.noPswAmountLimit = [decoder decodeObjectForKey:@"noPswAmountLimit"];
        self.unRealNamePayMaxAmount = [decoder decodeObjectForKey:@"unRealNamePayMaxAmount"];
        self.unRealNameRgeMaxAmount = [decoder decodeObjectForKey:@"unRealNameRgeMaxAmount"];
        
        self.realNamePayAmountLimit = [decoder decodeObjectForKey:@"realNamePayAmountLimit"];
        self.unRealNamePayAmountLimit = [decoder decodeObjectForKey:@"unRealNamePayAmountLimit"];
        
        self.offlineRgeMaxAmount = [decoder decodeObjectForKey:@"offlineRgeMaxAmount"];
        self.offlineRgeMinAmount = [decoder decodeObjectForKey:@"offlineRgeMinAmount"];
        
        self.withdrawFee = [decoder decodeObjectForKey:@"withdrawFee"];
        self.withdrawFeeMode = [decoder decodeObjectForKey:@"withdrawFeeMode"];
        self.withdrawMaxFeeAmt = [decoder decodeObjectForKey:@"withdrawMaxFeeAmt"];
        self.withdrawMinAmt = [decoder decodeObjectForKey:@"withdrawMinAmt"];
        
        self.offlineLossEffectiveTime = [decoder decodeObjectForKey:@"offlineLossEffectiveTime"];

    }
    return  self;
}

@end

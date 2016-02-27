//
//  FPPersonMember.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-21.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPPersonMember.h"

@implementation FPPersonMember

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _address = [attributes objectForKey:@"address"];
    _age = [attributes objectForKey:@"age"];
    _certNo = [attributes objectForKey:@"certNo"];
    _certTypeCode = [attributes objectForKey:@"certTypeCode"];
    _certValidBeginDate = [attributes objectForKey:@"certValidBeginDate"];
    _certValidEndDate = [attributes objectForKey:@"certValidEndDate"];
    _createDate = [attributes objectForKey:@"createDate"];
    _createId = [attributes objectForKey:@"createId"];
    _cycleLoginFailTimes = [[attributes objectForKey:@"cycleLoginFailTimes"] integerValue];
    _email = [attributes objectForKey:@"email"];
    _gender = [attributes objectForKey:@"gender"];
    _headAddress = [attributes objectForKey:@"headAddress"];
    _memberId = [[attributes objectForKey:@"id"] integerValue];
    _job = [attributes objectForKey:@"job"];
    _jobNumFoxconn = [attributes objectForKey:@"jobNumFoxconn"];
    _lastLoginDate = [attributes objectForKey:@"lastLoginDate"];
    _lockStatus = [attributes objectForKey:@"lockStatus"];
    _loginName = [attributes objectForKey:@"loginName"];
    _memberName = [attributes objectForKey:@"memberName"];
    _memberNo = [attributes objectForKey:@"memberNo"];
    _memberSrc = [attributes objectForKey:@"memberSrc"];
    
    _mobile = [attributes objectForKey:@"mobile"];
    _nameAuthFlag = [[attributes objectForKey:@"nameAuthFlag"] boolValue];
    _nationalCode = [attributes objectForKey:@"nationalCode"];
    _nickName = [attributes objectForKey:@"nickName"];
    _noPswLimitOn = [[attributes objectForKey:@"noPswLimitOn"] boolValue];
    _noteLimitOn = [[attributes objectForKey:@"noteLimitOn"] boolValue];
//    _payLimitOn = [[attributes objectForKey:@"payLimitOn"] boolValue];
    _noPswLimit = [attributes objectForKey:@"noPswLimit"];
    _noteLimit = [attributes objectForKey:@"noteLimit"];
    _payLimit = [attributes objectForKey:@"payLimit"];
    _remark = [attributes objectForKey:@"remark"];
    
    _safeFlag = [attributes objectForKey:@"safeFlag"];
    _status = [attributes objectForKey:@"status"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.age forKey:@"age"];
    [encoder encodeObject:self.certNo forKey:@"certNo"];
    [encoder encodeObject:self.certTypeCode forKey:@"certTypeCode"];
    [encoder encodeObject:self.certValidBeginDate forKey:@"certValidBeginDate"];
    [encoder encodeObject:self.certValidEndDate forKey:@"certValidEndDate"];
    [encoder encodeObject:self.createDate forKey:@"createDate"];
    [encoder encodeObject:self.createId forKey:@"createId"];
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.cycleLoginFailTimes] forKey:@"cycleLoginFailTimes"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.headAddress forKey:@"headAddress"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.memberId] forKey:@"memberId"];
    
    [encoder encodeObject:self.job forKey:@"job"];
    [encoder encodeObject:self.jobNumFoxconn forKey:@"jobNumFoxconn"];
    [encoder encodeObject:self.lastLoginDate forKey:@"lastLoginDate"];
    [encoder encodeObject:self.lockStatus forKey:@"lockStatus"];
    [encoder encodeObject:self.loginName forKey:@"loginName"];
    [encoder encodeObject:self.memberName forKey:@"memberName"];
    
    [encoder encodeObject:self.memberNo forKey:@"memberNo"];
    [encoder encodeObject:self.memberSrc forKey:@"memberSrc"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:[NSNumber numberWithBool:self.nameAuthFlag] forKey:@"nameAuthFlag"];
    [encoder encodeObject:self.nationalCode forKey:@"nationalCode"];
    
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.remark forKey:@"remark"];
    [encoder encodeObject:self.safeFlag forKey:@"safeFlag"];
    [encoder encodeObject:self.status forKey:@"status"];
    
    [encoder encodeObject:[NSNumber numberWithBool:self.noPswLimitOn] forKey:@"noPswLimitOn"];
    [encoder encodeObject:[NSNumber numberWithBool:self.noteLimitOn] forKey:@"noteLimitOn"];
//    [encoder encodeObject:[NSNumber numberWithBool:self.payLimitOn] forKey:@"payLimitOn"];o

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.address = [decoder decodeObjectForKey:@"address"];
        self.age = [decoder decodeObjectForKey:@"age"];
        self.certNo = [decoder decodeObjectForKey:@"certNo"];
        self.certTypeCode = [decoder decodeObjectForKey:@"certTypeCode"];
        self.certValidBeginDate = [decoder decodeObjectForKey:@"certValidBeginDate"];
        self.certValidEndDate = [decoder decodeObjectForKey:@"certValidEndDate"];
        self.createDate = [decoder decodeObjectForKey:@"createDate"];
        self.createId = [decoder decodeObjectForKey:@"createId"];
        self.cycleLoginFailTimes = [[decoder decodeObjectForKey:@"cycleLoginFailTimes"] integerValue];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.headAddress = [decoder decodeObjectForKey:@"headAddress"];
        self.memberId = [[decoder decodeObjectForKey:@"memberId"] integerValue];
        self.job = [decoder decodeObjectForKey:@"job"];
        self.jobNumFoxconn = [decoder decodeObjectForKey:@"jobNumFoxconn"];
        self.lastLoginDate = [decoder decodeObjectForKey:@"lastLoginDate"];
        self.lockStatus = [decoder decodeObjectForKey:@"lockStatus"];
        self.loginName = [decoder decodeObjectForKey:@"loginName"];
        self.memberName = [decoder decodeObjectForKey:@"memberName"];
        self.memberNo = [decoder decodeObjectForKey:@"memberNo"];
        self.memberSrc = [decoder decodeObjectForKey:@"memberSrc"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.nameAuthFlag = [[decoder decodeObjectForKey:@"nameAuthFlag"] boolValue];
        
        self.nationalCode = [decoder decodeObjectForKey:@"nationalCode"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.remark = [decoder decodeObjectForKey:@"remark"];
        self.safeFlag = [decoder decodeObjectForKey:@"safeFlag"];
        self.status = [decoder decodeObjectForKey:@"status"];
        
        self.noPswLimitOn = [[decoder decodeObjectForKey:@"noPswLimitOn"] boolValue];
        self.noteLimitOn = [[decoder decodeObjectForKey:@"noteLimitOn"] boolValue];
//        self.payLimitOn = [[decoder decodeObjectForKey:@"payLimitOn"] boolValue];
    }
    return  self;
}

@end

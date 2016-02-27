//
//  NSString+Util.m
//  FullPayApp
//
//  Created by mark zheng on 13-8-29.
//  Copyright (c) 2013年 fullpay. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

#define MOBILE_LEN 11
#define NUMBERSPERIOD @"0123456789\b"
//校验是否是数字
-(BOOL)checkNumber
{
    NSString *string = self;
    NSString *regex = @"[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

-(NSString *)iphoneFormat
{
    NSArray *chars = @[@"(",@")",@"-",@"（",@"）",@" ",@" "];
    
    NSString *result = self;
    for (NSString *str in chars) {
        result = [result stringByReplacingOccurrencesOfString:str withString:@""];
    }
    
    if (result.length > MOBILE_LEN) {
        NSInteger index = result.length - MOBILE_LEN;
        result = [result substringFromIndex:index];
    }
    
    NSLog(@"mobile:%@",result);
    return result;
}

-(NSString *)formatPhoneNumber
{
    NSArray *chars = @[@"(",@")",@"-",@"（",@"）",@" "];
    
    NSString *result = self;
    for (NSString *str in chars) {
        result = [result stringByReplacingOccurrencesOfString:str withString:@""];
    }

    return result;
}

- (BOOL)checkTel
{
    if (self == nil) {
        return NO;
    }
    NSString *str = [self trimSpace];
    if ([str length] == 0) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data_null_prompt", nil) message:NSLocalizedString(@"tel_no_null", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"手机号不能为空!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
//    NSString *regex = @"^((13[0-9])|(147|145)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSString *regex = @"^((13[0-9])|(147|145)|(15[0-9])|(18[0-9]))\\d{8}$";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
    }
    
    return YES;
}

-(BOOL)checkPwd
{
    NSString *str = [self trimSpace];
    if ([str length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码不能为空!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
    }
    
    return YES;
}

//检查设置的登录密码
-(BOOL)checkLoginPwd
{
    BOOL result = YES;
    NSString *str = [self trimSpace];
    if (str.length < 6 || str.length > 12 ) {
        [self showAlert:nil andMessage:@"登录密码长度须为6~12位!"];
        
        result = NO;
    } else {
        NSString *regex = @"^[0-9a-zA-Z_]\\w{4,10}[0-9a-zA-Z_]$";
        NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        if ([numPredicate evaluateWithObject:str] == NO) {
            [self showAlert:nil andMessage:@"密码必须为6~12位数字、字母或下划线!"];
            result = NO;
        }
    }
    
    return result;
}
//检查支付密码
/*
 \d
 
 任意一个数字，0~9 中的任意一个
 
 \w
 
 任意一个字母或数字或下划线，也就是 A~Z,a~z,0~9,_ 中任意一个
 
 \s
 
 包括空格、制表符、换页符等空白字符的其中任意一个
 
 .
 
 小数点可以匹配除了换行符（\n）以外的任意一个字符
 */
-(BOOL)checkPayPwd
{
    BOOL result = YES;
    NSString *str = [self trimSpace];
    if ([str length] != 6) {
        [self showAlert:nil andMessage:@"支付密码长度须为6位数字!"];
        
        result = NO;
    } else {
        NSString *regex = @"^[0-9]\\d{4}[0-9]$";
        NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        if ([numPredicate evaluateWithObject:str] == NO) {
            [self showAlert:nil andMessage:@"支付密码必须为6位数字!"];
            result = NO;
        }
    }

    return result;
}

//校验真实姓名
-(BOOL)checkRealName
{
    BOOL result = YES;
    NSString *str = [self trimSpace];
    if (str.length == 0) {
        [self showAlert:nil andMessage:@"姓名不能为空!"];
        
        result = NO;
    }
    
    return result;
}

//校验身份证
-(BOOL)checkIdCard
{
    BOOL result = YES;
    NSString *str = [self trimSpace];
    if (str.length != 15 && str.length != 18) {
        [self showAlert:nil andMessage:@"身份证长度为15或18位!"];
        
        result = NO;
    } else {
        NSString *regex = @"(^\\d{15}$)|(^\\d{17}([0-9]|（X|x）)$)";
        NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        if ([numPredicate evaluateWithObject:str] == NO) {
            [self showAlert:nil andMessage:@"身份证不正确!"];
            result = NO;
        }
    }
    
    return result;
}

//校验验证码
-(BOOL)checkCaptcha
{
    NSString *str = [self trimSpace];
    if ([str length] == 0) {
        [self showAlert:nil andMessage:@"验证码不能为空!"];
        return NO;
    }
    
    return YES;
}

//校验预付卡卡号
-(BOOL)checkPrepayCardNo
{
    NSString *str = [self trimSpace];
    if ([str length] != 16) {
        [self showAlert:nil andMessage:@"输入卡号不正确!"];
        return NO;
    }
    
    return YES;
}
//校验注册码
-(BOOL)checkRegisterCode
{
    NSString *str = [self trimSpace];
    if ([str length] != 8) {
        [self showAlert:nil andMessage:@"输入注册码不正确!"];
        return NO;
    }
    
    return YES;
}

//金额校验
-(BOOL)checkAmt
{
    BOOL result = YES;
    NSString *str = [self trimSpace];
    NSString *regex = @"(^(([1-9]\\d*)(\\.\\d{1,2})?)$)|(^0\\.0?([1-9]\\d?)$)";
    //NSString *regex = @"(^([1-9]\\d*)(\\.\\d{1,2})?$)|(^0.0?[1-9]{2})";
    NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([numPredicate evaluateWithObject:str] == NO) {
        [self showAlert:nil andMessage:@"金额输入不正确!"];
        result = NO;
    }
    
    return result;
}

//金额充值校验
-(BOOL)checkRechargeAmt
{
    BOOL result = YES;
    NSString *str = [self trimSpace];
    //NSString *regex = @"(^(([1-9]\\d*)(\\.\\d{1,2})?)$)|(^0\\.0?([1-9]\\d?)$)";
//    NSString *regex = @"(^[1-9]\\d{0,7}$)";
    NSString *regex = @"(^[1-9]\\d*$)";
    NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([numPredicate evaluateWithObject:str] == NO) {
        [self showAlert:nil andMessage:@"充值金额必须为整数"];
        result = NO;
    }
    
    return result;
}

-(NSString *)trimSpace
{
    NSString *str = self;
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
    str = [str stringByTrimmingCharactersInSet:characterSet];
    
    return str;
}

//格式化卡号
-(NSString *)formateCardNo
{
    NSString *tempStr = [self trimOnlySpace];
    NSMutableString *text = [NSMutableString stringWithString:tempStr];
    
    int rem = tempStr.length%4;
    int con = (int)tempStr.length/4;
    if (rem == 0) {
        con = con -1;
    }
    for (int i=1; i<=con; i++) {
        [text insertString:@" " atIndex:(4*i+(i-1))];
    }
    
    return text;
}

// 正常号转银行卡号 － 增加4位间的空格
//-(NSString *)normalNumToBankNum
//{
//    NSString *tmpStr = [self trimOnlySpace];
//    
//    int size = (tmpStr.length / 4);
//    
//    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
//    for (int n = 0;n < size; n++)
//    {
//        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
//    }
//    
//    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
//    
//    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
//    
//    return tmpStr;
//}

// 银行卡号转正常号 － 去除4位间的空格
-(NSString *)trimOnlySpace
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(void)showAlert:(NSString*)title andMessage:(NSString *)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    [alert show];
}

//正常手机号转格式手机号
- (NSString *)changeMoblieToFormatMoblie{
    NSMutableString *tempString = [NSMutableString stringWithString:self];
    
    if (tempString.length >= 8) {
        [tempString insertString:@" " atIndex:3];
        [tempString insertString:@" " atIndex:8];
    }else if(tempString.length >= 4){
        [tempString insertString:@" " atIndex:3];
    }
    NSString *resultStr = [NSString stringWithFormat:@"%@",tempString];
    
    return resultStr;
}

//设置文本中数字的颜色
-(NSMutableAttributedString *)transformNumberColorOfString:(UIColor *)color{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    int length = (int)self.length;
    for (int i=0;i<length;i++){
        NSRange range = NSMakeRange(i, 1);
        NSString *sub = [self substringWithRange:range];
        if ([sub checkNumber] || [sub isEqualToString:@"."]) {
            if (color==nil) {
                [attributedString setAttributes:@{NSForegroundColorAttributeName :
                                                [UIColor redColor]} range:range];
            }else{
                [attributedString setAttributes:@{NSForegroundColorAttributeName :
                                                color} range:range];
            }
        }
    }
    
    return attributedString;
}

//元转成分
- (NSString *)transformYuanToCents{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:self];
    
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:kAMT_PROPORTION];
    
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    
    return [product stringValue];
}
//分转成元
- (NSString *)transformCentsToYuan{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:self];
    
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:kAMT_PROPORTION];
    
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByDividingBy:multiplierNumber];
    
    return [product stringValue];
}

+ (NSString *)simpMoney:(double)money{
    long intMoney = money;
    
    if(money<=0){
        return @"0";
    }
    if (money <100) {
        if (intMoney%10>0) {
            return [NSString stringWithFormat:@"%0.2f",money/100];
        }else{
            return [NSString stringWithFormat:@"%0.1f",money/100];
        }
    }
    if (intMoney%100 > 0) {
        if (intMoney%10>0) {
            return [NSString stringWithFormat:@"%0.2f",money/100];
        }else{
            return [NSString stringWithFormat:@"%0.1f",money/100];
        }
    }else{
        return [NSString stringWithFormat:@"%0.0f",money/100];
    }
}


//获得一段文字的高

- (float)getTextHeightWithSystemFontSize:(float)fontSize andTextWidth:(float)width{
    
    float height = 0;
    UIFont *font = [UIFont systemFontOfSize:fontSize];//11 一定要跟label的显示字体大小一致
    //设置字体
    CGSize size = CGSizeMake(width, 20000.0f);
    //注：这个宽：300 是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    height = size.height;
    
    return height;
}


- (CGFloat)getHeightWithFontSize:(CGFloat)fontsize andWidth:(CGFloat)width{
       // 计算文本的大小  ios7.0
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                                     attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontsize] forKey:NSFontAttributeName]        // 文字的属性
                                                        context:nil].size;
    
    return textSize.height;
}
@end

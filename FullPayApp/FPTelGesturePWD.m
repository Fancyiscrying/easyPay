//
//  FPTelGesturePWD.m
//  FullPayApp
//
//  Created by lc on 14-6-14.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPTelGesturePWD.h"

#define TELGESTURE_PLIST @"TelGesturePWD"
#define PLIST_FIELNAME @"TelGesturePWD.plist"
#define kAdEncodeKey @"TelGesturePWD"

@implementation FPTelGesturePWD

//修改手势密码
+ (BOOL)resetGesturePassword:(NSString *)PWD andTelNumber:(NSString *)telNumber{
    if (PWD.length > 0 && telNumber.length > 0) {
        NSString *path = [self getPlistPath];
        FPDEBUG(@"path:%@",path);
        NSMutableDictionary *telGesture = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        if (telGesture) {
            [telGesture setObject:PWD forKey:telNumber];
            
            [telGesture writeToFile:path atomically:YES];
            return YES;
            
        }else{
            return NO;
        }
    }else{
        return NO;
    }

}

+ (BOOL)addTelGesturePassword:(NSString *)PWD andTelNumber:(NSString *)telNumber{
    if (PWD.length > 0 && telNumber.length > 0) {
        NSString *path = [self getPlistPath];
        NSMutableDictionary *telGesture = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        
            if (telGesture == nil) {
                telGesture = [[NSMutableDictionary alloc]init];
            }
            
            [telGesture setObject:PWD forKey:telNumber];
            
            [telGesture writeToFile:path atomically:YES];
            
            return YES;
        
    }else{
        return NO;
    }
}

+ (NSString *)objectValueForKey:(NSString *)telNumber{
    if (telNumber.length > 0) {
        NSString *path = [self getPlistPath];
        NSMutableDictionary *telGesture = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        
        if (telGesture) {
            NSString *gesturePWD = [telGesture objectForKey:telNumber];
            if (gesturePWD.length > 0 ) {
                return gesturePWD;
            }else{
                return nil;
            }
           
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

//检验是否已经登录过
+ (BOOL)isFirstLaunch:(NSString *)telNmuber{
    
    NSArray *allTel = [self allTelNumberKeys];
    if (allTel == nil || allTel.count == 0) {
        return YES;
    }else {
        int count = (int)allTel.count;
        for (int i=0 ; i<count; i++) {
            if ([telNmuber isEqualToString:allTel[i]]) {
                return NO;
            }
        }
        return YES;
    }
    
}

///////////////////////////////////////////////////

+ (NSArray *)allTelNumberKeys{
    NSString *path = [self getPlistPath];
    NSMutableDictionary *telGesture = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    if (telGesture) {
        NSArray *allKeys = [telGesture allKeys];
        
        return allKeys;
    }else {
        return nil;
    }
   
    
}

+ (NSString *)getPlistPath{
    //NSString *path = [[NSBundle mainBundle] pathForResource:TELGESTURE_PLIST ofType:@"plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
   NSString *path = [documentsDirectory stringByAppendingPathComponent:PLIST_FIELNAME];
    
    return path;
}

@end

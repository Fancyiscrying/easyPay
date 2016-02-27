//
//  FPLockViewController.h
//  FullPayApp
//
//  Created by mark zheng on 14-2-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPViewController.h"
#import "SPLockScreen.h"

#define kCurrentPattern											@"KeyForCurrentPatternToUnlock"
#define kCurrentPatternTemp										@"KeyForCurrentPatternToUnlockTemp"

typedef enum {
	InfoStatusFirstTimeSetting = 0,
	InfoStatusConfirmSetting,
	InfoStatusFailedConfirm,
	InfoStatusNormal,
	InfoStatusFailedMatch,
	InfoStatusSuccessMatch
}	InfoStatus;

@interface FPLockViewController : FPViewController

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *bottomLabel;
@property (strong, nonatomic) UIImageView *userImage;
@property (nonatomic) BOOL isFirstTimeSetting;
@property (strong, nonatomic) SPLockScreen *lockScreenView;
@property (nonatomic) InfoStatus infoLabelStatus;

@end

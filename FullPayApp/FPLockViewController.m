//
//  FPLockViewController.m
//  FullPayApp
//
//  Created by mark zheng on 14-2-19.
//  Copyright (c) 2014年 fullpay. All rights reserved.
//

#import "FPLockViewController.h"
#import "NormalCircle.h"
#import "ImageUtils.h"
#import "ColorUtils.h"
#import "FPAppDelegate.h"

#import "FPNavLoginViewController.h"
#import "FPLoginViewController.h"
#import "FPTelGesturePWD.h"

@interface FPLockViewController () <LockScreenDelegate,UIAlertViewDelegate>

@property (nonatomic) NSInteger wrongGuessCount;


@property (nonatomic) NSNumber *selectNumber;
@property (nonatomic,strong) FPPersonMember *personMember;
@property (nonatomic, strong) UIButton *lostNumber;
@property (nonatomic, strong) UIButton *useOtherNmu;
@end

@implementation FPLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorUtils hexStringToColor:@"#28252c"];
    self.personMember = [Config Instance].personMember;
    self.wrongGuessCount = 4;
    
//    UIButton    *btn_Cancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_Cancel.frame = CGRectMake(20, 180, 280, 45);
//    [btn_Cancel setBackgroundColor:[UIColor orangeColor]];
//    [btn_Cancel setTitle:@"确定" forState:UIControlStateNormal];
//    [btn_Cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn_Cancel addTarget:self action:@selector(click_Dismiss:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn_Cancel];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
    
	self.lockScreenView = [[SPLockScreen alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
	self.lockScreenView.center = self.view.center;
	self.lockScreenView.delegate = self;
	self.lockScreenView.backgroundColor = [UIColor clearColor];
    self.lockScreenView.allowClosedPattern = YES;
	[self.view addSubview:self.lockScreenView];
	
	self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 20)];
	self.infoLabel.backgroundColor = [UIColor clearColor];
	self.infoLabel.font = [UIFont systemFontOfSize:14];
	self.infoLabel.textColor = [UIColor darkGrayColor];
    if (_isFirstTimeSetting == YES) {
        _infoLabel.textColor = [ColorUtils hexStringToColor:@"d8261c"];
        //FFAA22
    }
	self.infoLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.infoLabel];
    
    _lockScreenView.top = _infoLabel.bottom+10;
    _bottomLabel.bottom = ScreenHigh-40;
	
	[self updateOutlook];
    
    if (_isFirstTimeSetting == YES) {
        
        [self showLastLock];
        
        _bottomLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomLabel.frame = CGRectMake(125, 0, 150, 20);
        [_bottomLabel setTitle:@"重新绘制手势" forState:UIControlStateNormal];
        [_bottomLabel setTitleColor:[ColorUtils hexStringToColor:@"#FFFFF5"] forState:UIControlStateNormal];
        _bottomLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        _bottomLabel.frame = CGRectMake(125, ScreenHigh-50, 150, 20);
        _bottomLabel.left = (ScreenWidth - _bottomLabel.width)/2;
        _bottomLabel.hidden = YES;
        [_bottomLabel addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
      
        [self.view addSubview:_bottomLabel];
        
    }else{
        _userImage = [[UIImageView alloc]initWithFrame:CGRectMake((320-60)/2, 40, 60, 60)];
        _userImage.layer.cornerRadius = 30;
        _userImage.layer.masksToBounds = YES;
        _userImage.layer.borderWidth = 2;
        _userImage.layer.borderColor = [UIColor whiteColor].CGColor;
        
        ImageUtils *image = [ImageUtils Instance];
        [image getImage:self.userImage andMemberNo:self.personMember.memberNo andHeadAddress:self.personMember.headAddress];
        if (_userImage.image == nil) {
            _userImage.image = [UIImage imageNamed:@"home_head_none.png"];
        }
        [self.view addSubview:_userImage];
        
        _lostNumber = [UIButton buttonWithType:UIButtonTypeCustom];
        _lostNumber.frame = CGRectMake(200, ScreenHigh-50, 100, 20);
        [_lostNumber setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        _lostNumber.titleLabel.font = [UIFont systemFontOfSize:12];
        [_lostNumber setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _lostNumber.backgroundColor = [UIColor clearColor];
        [_lostNumber addTarget:self action:@selector(loseHandPWD) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_lostNumber];
        
        _useOtherNmu = [UIButton buttonWithType:UIButtonTypeCustom];
        _useOtherNmu.frame = CGRectMake(30, ScreenHigh-50, 100, 20);
        [_useOtherNmu setTitle:@"用其他账号登陆" forState:UIControlStateNormal];
        _useOtherNmu.titleLabel.font = [UIFont systemFontOfSize:12];
        [_useOtherNmu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _useOtherNmu.backgroundColor = [UIColor clearColor];
        [_useOtherNmu addTarget:self action:@selector(loginOtherUser) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_useOtherNmu];
        
        self.view.userInteractionEnabled = YES;
        
        
    }

    
	
	// Test with Circular Progress
}

- (void)showLastLock{
    CGFloat radius = 30.0;
    CGFloat topOffset = radius;
    
    NSString *numberStr = [_selectNumber stringValue];
    
	for (int i=0; i < 9; i++) {
        NSString *temp = [NSString stringWithFormat:@"%d",i+1];
		NormalCircle *circle = [[NormalCircle alloc]initwithRadius:radius];
        circle.isTop = YES;
        
        if (numberStr.length > 0 ) {
            NSRange range = [numberStr rangeOfString:temp];
            if (range.location != NSNotFound) {
                circle.isSelected = YES;
            }
        }
        
		int column =  i % 3;
		int row    = i / 3;
		CGFloat x = 145+column*15;
		CGFloat y = row*15 + topOffset+20;
		circle.center = CGPointMake(x, y);
		
		[self.view addSubview:circle];
	}
    
}

- (void)updateOutlook
{
	switch (self.infoLabelStatus) {
		case InfoStatusFirstTimeSetting:
			self.infoLabel.text = @"绘制手势图案";
			break;
		case InfoStatusConfirmSetting:
			self.infoLabel.text = @"再次绘制手势图案";
			break;
		case InfoStatusFailedConfirm:
			self.infoLabel.text = @"与上次设置不一致，请确认设置";
			break;
        case InfoStatusNormal:{
            NSMutableString *mobile = [NSMutableString stringWithString:self.personMember.mobile];
            if (mobile.length == 11){
                [mobile replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            self.infoLabel.text = mobile;
        }
			break;
		case InfoStatusFailedMatch:
			self.infoLabel.text = [NSString stringWithFormat:@"密码错误,您还可以输入%ld次",(long)self.wrongGuessCount];
			break;
		case InfoStatusSuccessMatch:
			self.infoLabel.text = @"Welcome !";
			break;
			
		default:
			break;
	}
	
}


#pragma -LockScreenDelegate

- (void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber
{
	NSUserDefaults *stdDefault = [NSUserDefaults standardUserDefaults];
	NSLog(@"self status: %d",self.infoLabelStatus);
    NSString * pattern = [patternNumber stringValue];
    if (_selectNumber == nil) {
        _selectNumber = [NSNumber new];
    }
    _selectNumber = patternNumber;
	switch (self.infoLabelStatus) {
		case InfoStatusFirstTimeSetting:
            
            [stdDefault removeObjectForKey:kCurrentPattern];
			[stdDefault setValue:patternNumber forKey:kCurrentPatternTemp];
            [stdDefault synchronize];
            
			self.infoLabelStatus = InfoStatusConfirmSetting;
			[self updateOutlook];
            [self showLastLock];
            _bottomLabel.hidden = YES;
			break;
		case InfoStatusFailedConfirm:
            
            if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPatternTemp]]) {
                
				[stdDefault setValue:patternNumber forKey:kCurrentPattern];
                
                NSString *mobile = [Config Instance].personMember.mobile;
                if ([FPTelGesturePWD isFirstLaunch:mobile]) {
                    [FPTelGesturePWD addTelGesturePassword:pattern andTelNumber:mobile];
                }else{
                    [FPTelGesturePWD resetGesturePassword:pattern andTelNumber:mobile];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = 103;
                [alert show];
                
			}else {
				self.infoLabelStatus = InfoStatusFailedConfirm;
				[self updateOutlook];
                //[self showLastLock];
                _bottomLabel.hidden = NO;
			}

            break;
		case InfoStatusConfirmSetting:
			if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPatternTemp]]) {
            
				[stdDefault setValue:patternNumber forKey:kCurrentPattern];
                
                NSString *mobile = [Config Instance].personMember.mobile;
                if ([FPTelGesturePWD isFirstLaunch:mobile]) {
                    [FPTelGesturePWD addTelGesturePassword:pattern andTelNumber:mobile];
                }else{
                    [FPTelGesturePWD resetGesturePassword:pattern andTelNumber:mobile];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = 103;
                [alert show];

			}else {
				self.infoLabelStatus = InfoStatusFailedConfirm;
				[self updateOutlook];
                //[self showLastLock];
                _bottomLabel.hidden = NO;
			}
			break;
		case  InfoStatusNormal:
        {
            NSString *gesturePassWord = [stdDefault objectForKey:kCurrentPattern];
			if([pattern isEqualToString:gesturePassWord]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
			else {
				self.infoLabelStatus = InfoStatusFailedMatch;
				[self updateOutlook];
			}
        }
			break;
		case InfoStatusFailedMatch:{
            
            NSString *gesturePassWord = [stdDefault objectForKey:kCurrentPattern];
			if([pattern isEqualToString:gesturePassWord]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
			else {
				self.wrongGuessCount --;
				self.infoLabelStatus = InfoStatusFailedMatch;
                if (_wrongGuessCount <= 0) {
                    [[Config Instance] setAutoLogin:NO];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您5次输入错误,手势密码失效,请重新登录。" delegate:self cancelButtonTitle:@"前往登录" otherButtonTitles: nil];
                    alert.tag = 101;
                    [alert show];
                    
                }
				[self updateOutlook];
			}
        }
			break;
		case InfoStatusSuccessMatch:{
             [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
		default:
			break;
	}
}
#pragma mark--buttonActions

- (void)resetPassword{
    _selectNumber = nil;
    self.infoLabelStatus = InfoStatusFirstTimeSetting;
    [self updateOutlook];
    [self showLastLock];
}

- (void)loginOtherUser{
    [[Config Instance] setAutoLogin:NO];
    [self goToLoginController];
}

- (void)loseHandPWD{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"忘记手势密码,需要重新登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
    alert.tag = 102;
    [alert show];
}

#pragma mark---uialertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        [self goToLoginController];
    }
    
    if (alertView.tag == 102 && buttonIndex == 1) {
        [[Config Instance] setAutoLogin:NO];
        [self goToLoginController];
    }
    
    if (alertView.tag == 103) {
        
        [self gotoHomePage];

    }
}

- (void)goToLoginController{
    FPAppDelegate *delegate = (FPAppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FPLoginViewController * loginVc = [storyBoard instantiateViewControllerWithIdentifier:@"FPLoginView"];
    FPNavLoginViewController   *controller = [[FPNavLoginViewController alloc] initWithRootViewController:loginVc];
    loginVc.isToRoot = YES;
    
    delegate.window.rootViewController = controller;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

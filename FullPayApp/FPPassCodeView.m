//
//  FPPassCodeViewController.m
//  PAPasscode Example
//
//  Created by mark zheng on 13-12-16.
//  Copyright (c) 2013年 Peer Assembly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FPPassCodeView.h"

#import "AFFNumericKeyboard.h"

#define PROMPT_HEIGHT   0
#define DIGIT_SPACING   0
#define DIGIT_WIDTH     45
#define DIGIT_HEIGHT    45
#define MARKER_WIDTH    40
#define MARKER_HEIGHT   40
#define MARKER_X        4
#define MARKER_Y        4
#define TEXTFIELD_MARGIN 8
#define SLIDE_DURATION  0.3

#define IMG_PASSWORD_BG @"paypswd-BG.png"
#define IMG_PASSWORD_SHOWDON @"paypswd-showdon-BG.png"


@interface FPPassCodeView ()<UITextFieldDelegate,AFFNumericKeyboardDelegate>
{
    AFFNumericKeyboard *keyboard;
}

@property (nonatomic,strong) UIImageView *backgroundImg;

- (void)handleCompleteField;
- (void)passcodeChanged:(id)sender;

@end

@implementation FPPassCodeView

-(id)initWithFrame:(CGRect)frame withSimple:(BOOL)simple
{
    self = [super initWithFrame:frame];
    if (self) {
        _simple = simple;
        _securet = YES;
        
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(5, 0, 320, 20);
        _titleLabel.textColor = MCOLOR(@"color_text_passcode");
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        CGFloat panelWidth = DIGIT_WIDTH*IMG_PASSCODE_COUNT+DIGIT_SPACING*(IMG_PASSCODE_COUNT - 1);
        if (_simple) {
            UIView *digitPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 22, panelWidth, DIGIT_HEIGHT)];
//            digitPanel.frame = CGRectOffset(digitPanel.frame, (contentView.bounds.size.width-digitPanel.bounds.size.width)/2, PROMPT_HEIGHT);
            digitPanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            
            self.backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, panelWidth, DIGIT_HEIGHT)];
            self.backgroundImg.image = [UIImage imageNamed:IMG_PASSWORD_BG];
            [digitPanel addSubview:self.backgroundImg];
            
            [contentView addSubview:digitPanel];
            
//            UIImage *backgroundImage = [UIImage imageNamed:@"papasscode_background"];
            CGFloat xLeft = 0;
            for (int i=0;i<IMG_PASSCODE_COUNT;i++) {
                UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIGIT_WIDTH, DIGIT_HEIGHT)];
//                backgroundImageView.image = backgroundImage;
                backgroundImageView.frame = CGRectOffset(backgroundImageView.frame, xLeft, 0);
                [digitPanel addSubview:backgroundImageView];
                digitImageViews[i] = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MARKER_WIDTH, MARKER_HEIGHT)];
                digitImageViews[i].autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
                digitImageViews[i].frame = CGRectOffset(digitImageViews[i].frame, backgroundImageView.frame.origin.x+MARKER_X, MARKER_Y);
                [digitPanel addSubview:digitImageViews[i]];
                xLeft += DIGIT_SPACING + DIGIT_WIDTH;
            }
            passcodeTextField = [[UITextField alloc] initWithFrame:digitPanel.frame];
            passcodeTextField.hidden = YES;
        } else {
            UIView *passcodePanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelWidth, DIGIT_HEIGHT)];
            passcodePanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            passcodePanel.frame = CGRectOffset(passcodePanel.frame, (contentView.bounds.size.width-passcodePanel.bounds.size.width)/2, PROMPT_HEIGHT);
//            passcodePanel.frame = CGRectInset(passcodePanel.frame, TEXTFIELD_MARGIN, TEXTFIELD_MARGIN);
            passcodePanel.layer.borderColor = [UIColor colorWithRed:0.65 green:0.67 blue:0.70 alpha:1.0].CGColor;
            passcodePanel.layer.borderWidth = 1.0;
            passcodePanel.layer.cornerRadius = 5.0;
            passcodePanel.layer.shadowColor = [UIColor whiteColor].CGColor;
            passcodePanel.layer.shadowOffset = CGSizeMake(0, 1);
            passcodePanel.layer.shadowOpacity = 1.0;
            passcodePanel.layer.shadowRadius = 1.0;
            passcodePanel.backgroundColor = [UIColor whiteColor];
            [contentView addSubview:passcodePanel];
            passcodeTextField = [[UITextField alloc] initWithFrame:CGRectInset(passcodePanel.frame, 6, 6)];
        }
        passcodeTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        passcodeTextField.borderStyle = UITextBorderStyleNone;
//        passcodeTextField.secureTextEntry = YES;
        passcodeTextField.textColor = [UIColor colorWithRed:0.23 green:0.33 blue:0.52 alpha:1.0];
        passcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        passcodeTextField.delegate = self;
        [passcodeTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
        [contentView addSubview:passcodeTextField];
        
    }
    return self;
}

-(void)setInputIdKeyboard:(BOOL)keyboardType
{
    if (keyboardType)
    {
        keyboard = [[AFFNumericKeyboard alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216, 320, 216)];
        passcodeTextField.inputView = keyboard;
        keyboard.delegate = self;
    } 
}

-(BOOL)isFirstResponse
{
    return [passcodeTextField isFirstResponder];
}
-(void)becomeFirstResponse
{
    self.backgroundImg.image = [UIImage imageNamed:IMG_PASSWORD_SHOWDON];
    [passcodeTextField becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(passCodeViewBecomeFirstResponse)]) {
        [self.delegate passCodeViewBecomeFirstResponse];
    }
}

-(void)resignFirstResponse
{
    self.backgroundImg.image = [UIImage imageNamed:IMG_PASSWORD_BG];
    [passcodeTextField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(passCodeViewResignFirstResponse)]) {
        [self.delegate passCodeViewResignFirstResponse];
    }
}

-(void)clearPasscode
{
    [self showScreenForPhase:1 animated:NO];
    self.passcode = @"";
}

/**
 *  获取passcode
 *
 *  @return 字符串
 */
-(NSString *)getPasscode
{
    return self.passcode;
}

#pragma mark - implementation helpers

- (void)handleCompleteField {
//    NSString *text = passcodeTextField.text;
//    NSLog(@"%@",text);
//    self.passcode = text;
    [self resignFirstResponse];
    if ([self.delegate respondsToSelector:@selector(handleCompleteField:)]) {
        [self.delegate handleCompleteField:self];
    }
}

- (void)passcodeChanged:(id)sender {
    NSString *text = passcodeTextField.text;
    self.passcode = text;
    if (_simple) {
        if ([text length] > IMG_PASSCODE_COUNT) {
            text = [text substringToIndex:IMG_PASSCODE_COUNT];
            return;
        }
        for (int i=0;i<IMG_PASSCODE_COUNT;i++) {
            digitImageViews[i].hidden = i >= [text length];
            if (i >= [text length] ) {
                break;
            }
            UIImage *markerImage;
            if (self.securet) {
                markerImage = [UIImage imageNamed:@"papasscode_marker"];
            } else {
                NSRange range = NSMakeRange(i, 1);
                
                NSString *imgName = [NSString stringWithFormat:@"%@.png",[text substringWithRange:range].lowercaseString];
                markerImage = [UIImage imageNamed:imgName];
            }
            
            digitImageViews[i].image = markerImage;
        }
        if ([text length] == IMG_PASSCODE_COUNT) {
            [self handleCompleteField];
        }
    }
}

- (void)showScreenForPhase:(NSInteger)newPhase animated:(BOOL)animated {
    CGFloat dir = (newPhase > phase) ? 1 : -1;
    if (animated) {
        UIGraphicsBeginImageContext(self.bounds.size);
        [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        snapshotImageView = [[UIImageView alloc] initWithImage:snapshot];
        snapshotImageView.frame = CGRectOffset(snapshotImageView.frame, -contentView.frame.size.width*dir, 0);
        [contentView addSubview:snapshotImageView];
    }
    phase = newPhase;
    passcodeTextField.text = @"";

    for (int i=0;i<IMG_PASSCODE_COUNT;i++) {
        digitImageViews[i].hidden = YES;
    }
    if (animated) {
        contentView.frame = CGRectOffset(contentView.frame, contentView.frame.size.width*dir, 0);
        [UIView animateWithDuration:SLIDE_DURATION animations:^() {
            contentView.frame = CGRectOffset(contentView.frame, -contentView.frame.size.width*dir, 0);
        } completion:^(BOOL finished) {
            [snapshotImageView removeFromSuperview];
            snapshotImageView = nil;
        }];
    }
}

#pragma mark - delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *text = [textField text];
    
    BOOL bChange =YES;
    if (text.length >= IMG_PASSCODE_COUNT)
        bChange = NO;
    
    if (range.length == 1) {
        bChange = YES;
    }
    
    return bChange;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *text = [textField text];
    
    if ([self.delegate respondsToSelector:@selector(passCodeView:checkPassCodeLength:)]) {
        [self.delegate passCodeView:self checkPassCodeLength:text];
    }
}
-(void)changeKeyboardType
{
    //    [self.textField resignFirstResponder];
    //    self.textField.inputView = nil;
    //    [self.textField becomeFirstResponder];
    [self passcodeValue:@"X"];
}

-(void)numberKeyboardBackspace
{
    if (passcodeTextField.text.length != 0)
    {
        passcodeTextField.text = [passcodeTextField.text substringToIndex:passcodeTextField.text.length -1];
        [self passcodeChanged:nil];
        FPDEBUG(@"str1:%@",passcodeTextField.text);
        
        if (passcodeTextField.text.length >= 5) {
            [keyboard setSpecialButtonEnable:YES];
        } else {
            [keyboard setSpecialButtonEnable:NO];
        }
    }
}

-(void)numberKeyboardInput:(NSInteger)number
{
    [self passcodeValue:[NSString stringWithFormat:@"%ld",(long)number]];
}

- (void)passcodeValue:(NSString *)value
{
    passcodeTextField.text = [passcodeTextField.text stringByAppendingString:value];
    if (passcodeTextField.text.length > IMG_PASSCODE_COUNT) {
        passcodeTextField.text = [passcodeTextField.text substringToIndex:IMG_PASSCODE_COUNT];
    }
    [passcodeTextField sendActionsForControlEvents:UIControlEventEditingChanged];
//    [self passcodeChanged:nil];
    
    FPDEBUG(@"str:%@",passcodeTextField.text);
    
    if (passcodeTextField.text.length >= 5) {
        [keyboard setSpecialButtonEnable:YES];
    } else {
        [keyboard setSpecialButtonEnable:NO];
    }
}

//刷新视图
- (void)refeshView{
    [self passcodeChanged:self];
}

@end

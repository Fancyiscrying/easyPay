//
//  TextField.m
//  CarClub
//
//  Created by 刘通超 on 15/3/13.
//  Copyright (c) 2015年 刘通超. All rights reserved.
//

#import "TextField.h"

@interface TextField()
@property (nonatomic, assign)CGFloat textLeft;
@end

@implementation TextField

- (id)init{
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _textLeft = 0;
        
        UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320, 50)];
        [topView setBarStyle:UIBarStyleBlackTranslucent];
        UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
        [doneButton setTintColor:[UIColor whiteColor]];
        NSArray *buttonArray = [NSArray arrayWithObjects:button1,button2,doneButton, nil];
        [topView setItems:buttonArray];
        
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [self setInputAccessoryView:topView];

    }
    
    return self;
}

- (void)setTextLeft:(CGFloat)left{
    _textLeft = left;
    [self textRectForBounds:self.bounds];
    [self editingRectForBounds:self.bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+_textLeft, bounds.origin.y, bounds.size.width-_textLeft, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+_textLeft, bounds.origin.y, bounds.size.width-_textLeft, bounds.size.height);
    return inset;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, 40, bounds.size.height);
    return inset;
}

-(void)resignKeyboard{
    [self resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  FPWalletCardAnalyzeCell.m
//  FullPayApp
//
//  Created by 刘通超 on 15/4/12.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "FPWalletCardAnalyzeCell.h"

@implementation FPWalletCardAnalyzeCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self installView];
    }
    
    return self;
}

- (void)installView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UILabel *month = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 45, 20)];
    month.backgroundColor = [UIColor clearColor];
    month.font = [UIFont boldSystemFontOfSize:16];
    month.textColor = COLOR_STRING(@"4D4D4D");
    month.textAlignment = NSTextAlignmentCenter;
    month.tag = 101;
    [backView addSubview:month];
    
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(month.right, month.top, ScreenWidth-140, 20)];
    progress.tag = 110;
    [backView addSubview:progress];
    
    UILabel *outlay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, progress.width/2, 20)];
    outlay.backgroundColor = COLOR_STRING(@"#65A7FB");
    outlay.font = [UIFont boldSystemFontOfSize:10];
    outlay.textColor = COLOR_STRING(@"#FFFFFF");
    outlay.textAlignment = NSTextAlignmentCenter;
    ///outlay.text = @"支出 50%";
    outlay.tag = 102;
    [progress addSubview:outlay];
    
    UILabel *income = [[UILabel alloc] initWithFrame:CGRectMake(progress.width/2, 0, progress.width/2, 20)];
    income.backgroundColor = COLOR_STRING(@"#FED030");
    income.font = [UIFont boldSystemFontOfSize:10];
    income.textColor = COLOR_STRING(@"#FFFFFF");
    income.textAlignment = NSTextAlignmentCenter;
    //income.text = @"收入 50%";
    income.tag = 103;
    [progress addSubview:income];
    
    UILabel *outlayTop = [[UILabel alloc] initWithFrame:CGRectMake(progress.left, 5, progress.width/2, 10)];
    outlayTop.backgroundColor = ClearColor;
    outlayTop.font = [UIFont boldSystemFontOfSize:8];
    outlayTop.textColor = COLOR_STRING(@"#808080");
    outlayTop.textAlignment = NSTextAlignmentLeft;
    //outlayTop.text = @"支出 50%";
    outlayTop.tag = 104;
    [backView addSubview:outlayTop];
    
    UILabel *incomeTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, progress.width/2, 10)];
    incomeTop.right = progress.right;
    incomeTop.backgroundColor = ClearColor;
    incomeTop.font = [UIFont boldSystemFontOfSize:8];
    incomeTop.textColor = COLOR_STRING(@"#808080");
    incomeTop.textAlignment = NSTextAlignmentRight;
    //incomeTop.text = @"收入 50%";
    incomeTop.tag = 105;
    [backView addSubview:incomeTop];
    
    UILabel *outlayRight = [[UILabel alloc] initWithFrame:CGRectMake(progress.right+5, 10, 85, 15)];
    outlayRight.backgroundColor = ClearColor;
    outlayRight.font = [UIFont boldSystemFontOfSize:10];
    outlayRight.textColor = COLOR_STRING(@"#333333");
    outlayRight.textAlignment = NSTextAlignmentLeft;
    outlayRight.tag = 106;
    [backView addSubview:outlayRight];
    
    UILabel *incomeRight = [[UILabel alloc] initWithFrame:CGRectMake(progress.right+5, 25, 85, 15)];
    incomeRight.backgroundColor = ClearColor;
    incomeRight.font = [UIFont boldSystemFontOfSize:10];
    incomeRight.textColor = COLOR_STRING(@"#333333");
    incomeRight.textAlignment = NSTextAlignmentLeft;
    incomeRight.tag = 107;
    [backView addSubview:incomeRight];
}

- (void)setAnalyzeItem:(AnalyzeMonthItem *)analyzeItem{
    UILabel *label1 = (UILabel *)[self viewWithTag:101];
    label1.text = [NSString stringWithFormat:@"%d 月",analyzeItem.stsMonth%100];
    
    UILabel *label2 = (UILabel *)[self viewWithTag:102];
    UILabel *label3 = (UILabel *)[self viewWithTag:103];
    UILabel *label4 = (UILabel *)[self viewWithTag:104];
    UILabel *label5 = (UILabel *)[self viewWithTag:105];

    
    UILabel *label6 = (UILabel *)[self viewWithTag:106];
    label6.text = [NSString stringWithFormat:@"支出: %@ 元",[NSString simpMoney:analyzeItem.payerAmt]];
                  
    UILabel *label7 = (UILabel *)[self viewWithTag:107];
    label7.text = [NSString stringWithFormat:@"收入: %@ 元",[NSString simpMoney:analyzeItem.payeeAmt]];
    
    
    UIView *view = (UIView *)[self viewWithTag:110];
    
    float width = view.width * analyzeItem.outPayPercent / 100;
    if (width > 50) {
        label2.text = [NSString stringWithFormat:@"支出: %d%%",analyzeItem.outPayPercent];
        if (view.width-width > 50) {
            label3.text = [NSString stringWithFormat:@"收入: %d%%", (100 - analyzeItem.outPayPercent)];
        }else{
            label5.text = [NSString stringWithFormat:@"收入: %d%%", (100 - analyzeItem.outPayPercent)];
        }
        
    }else{
        label4.text = [NSString stringWithFormat:@"支出: %d%%",analyzeItem.outPayPercent];
        
        if (view.width-width > 50) {
            label3.text = [NSString stringWithFormat:@"收入: %d%%", (100 - analyzeItem.outPayPercent)];
        }else{
            label5.text = [NSString stringWithFormat:@"收入: %d%%", (100 - analyzeItem.outPayPercent)];
        }
    }
    
    label2.width = width;
    label3.left = label2.right;
    label3.width = view.width-width;

}

@end

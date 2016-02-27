//
//  FPWalletCardAnalyzeTable.h
//  FullPayApp
//
//  Created by 刘通超 on 15/4/12.
//  Copyright (c) 2015年 fullpay. All rights reserved.
//

#import "RTTableView.h"

@interface FPWalletCardAnalyzeTable : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *analyzeList;
@end

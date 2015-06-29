//
//  SchoolViewTable.h
//  WoChuangFu
//
//  Created by 陈贵邦 on 15/6/17.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleBar.h"
typedef void(^Handler)(NSDictionary*);

@interface SchoolViewTable : UIViewController
@property(retain,nonatomic) UITableView *tableViewm;
@property(nonatomic,copy) Handler handler;
@property(retain,nonatomic) TitleBar *_titleBar;
@property(nonatomic,copy) NSArray* areArr;
@end

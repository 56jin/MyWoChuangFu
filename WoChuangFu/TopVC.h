//
//  TopVC.h
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-15.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstVC.h"

@interface TopVC : UIViewController<FirstDelegate,FirTabDelegate,UITableViewDataSource,UITableViewDelegate>{
    UINavigationController *FirNav;
    FirstVC *FirV;
    UITableView *Firtab;
    NSMutableArray *TabArr;
}

@property(nonatomic,retain)UINavigationController *FirNav;

@end

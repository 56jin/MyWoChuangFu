//
//  SIMPackageChooseVC.h
//  WoChuangFu
//
//  Created by 李新新 on 15-2-4.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Handler)(NSDictionary *dict); //需要处理的操作

@interface SIMPackageChooseVC : UIViewController

@property(nonatomic,strong) NSArray *dataSources;

@property(nonatomic,copy) Handler handler;

@end

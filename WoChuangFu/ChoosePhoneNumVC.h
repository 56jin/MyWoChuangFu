//
//  ChoosePhoneNumVC.h
//  WoChuangFu
//
//  Created by 李新新 on 15-1-29.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

//操作代码块
typedef void(^Handler)(NSDictionary *dict);

@interface ChoosePhoneNumVC : UIViewController

@property (nonatomic,copy)   Handler handler;
@property (nonatomic,strong) NSDictionary *params;

@end

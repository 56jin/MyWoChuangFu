//
//  ChooseAddressVC.h
//  WoChuangFu
//
//  Created by 李新新 on 14-12-29.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAddressVC : UIViewController

@property (nonatomic,copy)void(^block)(NSDictionary *);
@property (nonatomic,strong)NSMutableArray *cardOrderKeyValuelist;
@property (nonatomic,copy) NSString        *moduleId;

@end

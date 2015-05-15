//
//  NewChooseAddressVC.h
//  WoChuangFu
//
//  Created by 李新新 on 15-2-7.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewChooseAddressVC : UIViewController

@property (nonatomic,copy)void(^block)(NSDictionary *);
@property (nonatomic,strong)NSMutableArray *cardOrderKeyValuelist;
@property (nonatomic,copy) NSString        *moduleId;

@end

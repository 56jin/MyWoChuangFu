//
//  ChoosePackageVC.h
//  WoChuangFu
//
//  Created by duwl on 12/1/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePackageVC : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong)NSDictionary *attributes;//产品属性字典
@property (nonatomic,copy)void(^block)(NSDictionary *package);

@end

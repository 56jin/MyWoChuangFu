//
//  RegdistVC.h
//  WoChuangFu
//
//  Created by duwl on 11/6/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegdistVC : UIViewController<UIWebViewDelegate>

@property(nonatomic,copy) void(^block)(NSString *userName);

@end

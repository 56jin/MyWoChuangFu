//
//  QkFirstPageVC.h
//  WoChuangFu
//
//  Created by 郑渊文 on 15/1/17.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QkFirstPageVC : UIViewController
@property(nonatomic,copy)NSString *authKey;
@property(nonatomic,copy)NSMutableDictionary *myDic;
@property(nonatomic,copy)NSString *loadUrl;
@property(nonatomic,copy)NSMutableDictionary *requestDic;
@property(nonatomic,copy)NSString *upDateUrl;
@property(nonatomic,copy)NSString *appVersion;
@property(nonatomic,copy)NSDictionary *pushDic;
@property(nonatomic,copy)NSString *alias;
@property(nonatomic,assign)BOOL ifFirst;

@end

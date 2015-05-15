//
//  QiankaLogin.h
//  WoChuangFu
//
//  Created by 郑渊文 on 15/1/17.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiankaLogin : UIViewController

@property(nonatomic,strong)NSDictionary *myDic;
@property(nonatomic,strong)NSString *authKey;
@property(nonatomic,strong)NSString *returnUrl;
@property(nonatomic,copy)NSString *upDateUrl;
@property(nonatomic,copy)NSString *alias_Login;
@property(nonatomic,copy)NSString *pass_Url;
@end

//
//  LoginView.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/31.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate<NSObject>

@optional

- (void)didClickedRegister;
- (void)didClickedGetBackPassWord;
- (void)loginSuccess:(NSArray *)menus;
- (void)loginSuccessReture:(NSString *)loginString;

@end

@interface LoginView : UIView<HttpBackDelegate,UITextFieldDelegate>

@property(nonatomic,retain)   UITextField *NameTextField;
@property(nonatomic,copy)NSString *loadUrl;
@property(nonatomic,retain)   UITextField *PassTextField;
@property(nonatomic,assign) id<LoginViewDelegate> delegate;
@property(nonatomic,retain) NSDictionary          *SendDic;

@end

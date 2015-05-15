//
//  MyAlertView.h
//  YuWOGYPro
//
//  Created by syerven on 12-10-12.
//  Copyright (c) 2012年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAlertView : NSObject

//简单提示
+(void)showSimpleAlertView:(NSString*)message;

//简单提示（带标题）
+(void)showSimpleAlertView:(NSString*)message withTitle:(NSString*)titleString;

//简单代理提示
+(void)showSimpleAlertView:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag;

//简单代理提示（带标题）
+(void)showSimpleAlertView:(NSString*)message withTitle:(NSString*)titleString delegate:(id)delegate tag:(NSInteger)tag;

//标准提示（所有参数自己定义控制）
+(void)showAlertViewTitle:(NSString*)title 
                  message:(NSString*)message 
                 delegate:(id)delegate 
                      tag:(NSInteger)tag 
        cancelButtonTitle:(NSString*)cancelButtonTitle 
        otherButtonTitles:(NSString*)otherButtonTitles,...;

@end

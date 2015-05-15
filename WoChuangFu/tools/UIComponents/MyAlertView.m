//
//  MyAlertView.m
//  YuWOGYPro
//
//  Created by syerven on 12-10-12.
//  Copyright (c) 2012年 asiainfo-linkage. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView

+(void)showSimpleAlertView:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+(void)showSimpleAlertView:(NSString*)message withTitle:(NSString*)titleString
{
    if(nil == titleString){
        titleString = @"提示信息";
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:titleString
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+(void)showSimpleAlertView:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message 
                                                   delegate:delegate 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
    [alert release];
}

+(void)showSimpleAlertView:(NSString*)message withTitle:(NSString*)titleString delegate:(id)delegate tag:(NSInteger)tag
{
    if(nil == titleString){
        titleString = @"提示信息";
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:titleString
                                                    message:message 
                                                   delegate:delegate 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
    [alert release];
}

+(void)showAlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles,...
{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    id arg;
    va_list argList;
    if(nil != otherButtonTitles){
        va_start(argList, otherButtonTitles);
        while ((arg = va_arg(argList,id))) {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message 
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    alert.tag = tag;
    for(int i = 0; i < [argsArray count]; i++){
        [alert addButtonWithTitle:[argsArray objectAtIndex:i]];
    }
    [alert show];
    [alert release];
    
    [argsArray release];
}


@end

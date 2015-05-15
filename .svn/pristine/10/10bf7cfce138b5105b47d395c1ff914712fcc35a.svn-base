//
//  CrashExceptioinCatcher.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 14-3-10.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "NdUncaughtExceptionHandler.h"

NSString *applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    bussineDataService *bus=[bussineDataService sharedDataService];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
#ifdef AppStore
    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@\nbus.Targat:%@\nbus.rsp:%@\nVersion:%f\n,沃易购版本:%@\n,from:Appstore",
                     name,reason,[arr componentsJoinedByString:@"\n"],[[bus.target class] description],bus.rspInfo,version,[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    NSLog(@"%@",url);
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    NSLog(@"path==%@",path);
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
#else
    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@\nbus.Targat:%@\nbus.rsp:%@\nVersion:%f\n,沃易购版本:%@\n,from:ailk",
                     name,reason,[arr componentsJoinedByString:@"\n"],[[bus.target class] description],bus.rspInfo,version,[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    NSLog(@"%@",url);
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    NSLog(@"path==%@",path);
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
#endif
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
}

@implementation NdUncaughtExceptionHandler

-(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

@end

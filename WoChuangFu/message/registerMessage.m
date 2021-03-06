//
//  registMessage.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "registerMessage.h"

@implementation registerMessage

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:REGIST_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[REGIST_BIZCODE uppercaseString]];
    
    MyLog(@"%@",[requestInfo class]);
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              [requestInfo objectForKey:@"serverPhone"],@"serverPhone",
                              [requestInfo objectForKey:@"phoneNumber"],@"phoneNumber",
                              [requestInfo objectForKey:@"passWord"],@"passWord",
                               [requestInfo objectForKey:@"serverCode"],@"serverCode",
                              [requestInfo objectForKey:@"identifyCode"],@"identifyCode",
                              [requestInfo objectForKey:@"recommendCode"],@"recommendCode",
                              [requestInfo objectForKey:@"userType"],@"userType",nil];
                      
    
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    
    MyLog(@"检查选择页面报文:%@",requestStr);
    return requestStr;//[message hexStringDes:requestStr withEncrypt:YES];
}

//- (BOOL)isHouTai{
//    return [[requestInfo objectForKey:@"isHouTai"] boolValue];
//}

-(void)parseOther
{
    [super parseOther];
    [self parseMessage];
}

- (void)parseResponse:(NSString *)responseMessage
{
    [self parse:responseMessage];
}

+ (NSString*)getBizCode
{
    return REGIST_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return REGIST_BIZCODE;
}

-(void)parseMessage
{
    //需要解析在此处解析
    NSArray *keyArray = [[NSArray alloc] initWithObjects:nil];
    if (self.rspInfo != nil && [self.rspInfo isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *rInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSInteger cnt = [keyArray count];
        for (int i=0; i<cnt; i++) {
            NSString *keyStr = [keyArray objectAtIndex:i];
            NSString *valueStr = [rspInfo objectForKey:keyStr];
            if (valueStr) {
                [rInfo setObject:valueStr forKey:keyStr];
            }
        }
        if ([rInfo count] > 0) {
            self.rspInfo = rInfo;
        }
        [rInfo release];
    }
    [keyArray release];
}

@end

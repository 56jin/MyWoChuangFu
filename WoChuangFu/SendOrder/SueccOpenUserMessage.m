//
//  SueccOpenUserMessage.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/23.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SueccOpenUserMessage.h"

@implementation SueccOpenUserMessage
-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:SUECC_OPEN_USER_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[SUECC_OPEN_USER_BIZCODE uppercaseString]];
    
    NSObject *ICCID = [requestInfo objectForKey:@"iccid"]==nil?[NSNull null]:[requestInfo objectForKey:@"iccid"];
    NSObject *status = [requestInfo objectForKey:@"status"]==nil?[NSNull null]:[requestInfo objectForKey:@"status"];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              ICCID,@"iccid",
                              status,@"status",nil];
    
    
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    
    MyLog(@"消息中心报文:%@",requestStr);
    return requestStr;
}

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
    return SUECC_OPEN_USER_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return SUECC_OPEN_USER_BIZCODE;
}

-(void)parseMessage
{
    
}

@end

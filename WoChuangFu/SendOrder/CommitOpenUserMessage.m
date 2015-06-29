//
//  CommitOpenUserMessage.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/23.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "CommitOpenUserMessage.h"

@implementation CommitOpenUserMessage

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:COMMIT_OPEN_USER_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[COMMIT_OPEN_USER_BIZCODE uppercaseString]];
    
    
    NSObject *orderCode = [requestInfo objectForKey:@"orderCode"]==nil?[NSNull null]:[requestInfo objectForKey:@"orderCode"];
    NSObject *ICCID = [requestInfo objectForKey:@"ICCID"]==nil?[NSNull null]:[requestInfo objectForKey:@"ICCID"];
    NSObject *custName = [requestInfo objectForKey:@"custName"]==nil?[NSNull null]:[requestInfo objectForKey:@"custName"];
    NSObject *custNo = [requestInfo objectForKey:@"custNo"]==nil?[NSNull null]:[requestInfo objectForKey:@"custNo"];
    NSObject *custAddr = [requestInfo objectForKey:@"custAddr"]==nil?[NSNull null]:[requestInfo objectForKey:@"custAddr"];
    
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              orderCode,@"orderCode",
                              ICCID,@"iccid",
                              custName,@"custName",
                              custNo,@"custNo",
                              custAddr,@"custAddr",nil];
    
    
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
    return COMMIT_OPEN_USER_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return COMMIT_OPEN_USER_BIZCODE;
}

-(void)parseMessage
{
    
}
@end

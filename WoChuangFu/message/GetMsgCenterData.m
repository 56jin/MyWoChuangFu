//
//  GetMsgCenterData.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-29.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "GetMsgCenterData.h"

@implementation GetMsgCenterData

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:GETMSGCENTERDATA_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[GETMSGCENTERDATA_BIZCODE uppercaseString]];
    
    MyLog(@"%@",[requestInfo class]);
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              [requestInfo objectForKey:@"msgType"]==nil?[NSNull null]:[requestInfo objectForKey:@"msgType"],@"msgType",
                              [requestInfo objectForKey:@"msgId"]==nil?[NSNull null]:[requestInfo objectForKey:@"msgId"],@"msgId",
                              [requestInfo objectForKey:@"page"],@"page",
                              [requestInfo objectForKey:@"size"],@"size",nil];
    
    
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    
    MyLog(@"消息中心报文:%@",requestStr);
    return requestStr;//[message hexStringDes:requestStr withEncrypt:YES];
}

- (BOOL)isHouTai{
    return [[requestInfo objectForKey:@"isHouTai"] boolValue];
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
    return GETMSGCENTERDATA_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return GETMSGCENTERDATA_BIZCODE;
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

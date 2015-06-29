//
//  SearchOpenAccountOrderMessage.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/15.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SearchOpenAccountOrderMessage.h"

@implementation SearchOpenAccountOrderMessage

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:SEARCH_OPENACCOUNT_ORDER_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[SEARCH_OPENACCOUNT_ORDER_BIZCODE uppercaseString]];
    
    
    NSObject *orderCode = [requestInfo objectForKey:@"orderCode"]==nil?[NSNull null]:[requestInfo objectForKey:@"orderCode"];
    NSObject *phone = [requestInfo objectForKey:@"phone"]==nil?[NSNull null]:[requestInfo objectForKey:@"phone"];
    NSObject *certNum = [requestInfo objectForKey:@"certNum"]==nil?[NSNull null]:[requestInfo objectForKey:@"certNum"];
    NSObject *developCode = [requestInfo objectForKey:@"developCode"]==nil?[NSNull null]:[requestInfo objectForKey:@"developCode"];
    NSObject *enterWorker = [requestInfo objectForKey:@"enterWorker"]==nil?[NSNull null]:[requestInfo objectForKey:@"enterWorker"];
    NSObject *orderResult = [requestInfo objectForKey:@"orderResult"]==nil?[NSNull null]:[requestInfo objectForKey:@"orderResult"];
    NSObject *orderTypeResult = [requestInfo objectForKey:@"orderTypeResult"]==nil?[NSNull null]:[requestInfo objectForKey:@"orderTypeResult"];
    NSObject *telePhoneOrderId = [requestInfo objectForKey:@"telePhoneOrderId"]==nil?[NSNull null]:[requestInfo objectForKey:@"telePhoneOrderId"];
    
    NSObject *count = [requestInfo objectForKey:@"count"];
    NSObject *start = [requestInfo objectForKey:@"start"];
    
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              orderCode,@"orderCode",
                              phone,@"phone",
                              certNum,@"certNum",
                              developCode,@"developCode",
                              enterWorker,@"enterWorker",
                              orderResult,@"orderResult",
                              telePhoneOrderId,@"telePhoneOrderId",
                              orderTypeResult,@"orderTypeResult",
                              count,@"count",
                              start,@"start",nil];
    
    
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
    return SEARCH_OPENACCOUNT_ORDER_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return SEARCH_OPENACCOUNT_ORDER_BIZCODE;
}

-(void)parseMessage
{
}
@end

//
//  BaoCuoMessage.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 14-3-18.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "BaoCuoMessage.h"

@implementation BaoCuoMessage

-(void)dealloc
{
	[super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:BAOCUO_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,@"CGerror"];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              [requestInfo objectForKey:@"device_info"],@"device_info",
                              [requestInfo objectForKey:@"error_Content"],@"error_Content",nil];
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    MyLog(@"报错请求报文:%@",requestStr);
	return requestStr;//[message hexStringDes:requestStr withEncrypt:YES];
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
    return BAOCUO_BIZCODE;
}

- (NSString*)getBusinessCode
{
	return BAOCUO_BIZCODE;
}

-(void)parseMessage
{
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

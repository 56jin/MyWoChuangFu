//
//  LoginMessage.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-20.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "LoginMessage.h"
#import "GTMBase64_My.h"

@implementation LoginMessage

-(void)dealloc
{
	[super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:LOGIN_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[LOGIN_BIZCODE uppercaseString]];
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"userCode"],@"userCode",
                              [requestInfo objectForKey:@"passWd"],@"passWd",
                              [requestInfo objectForKey:@"type"],@"type",nil];
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    MyLog(@"登录报文:%@",requestStr);
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
    return LOGIN_BIZCODE;
}

- (NSString*)getBusinessCode
{
	return LOGIN_BIZCODE;
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

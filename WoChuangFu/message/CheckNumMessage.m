//
//  CheckNumMessage.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "CheckNumMessage.h"

@implementation CheckNumMessage

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:CHECKNUM_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[CHECKNUM_BIZCODE uppercaseString]];
    
    MyLog(@"%@",[requestInfo class]);
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              [requestInfo objectForKey:@"requestType"],@"requestType",
                              [requestInfo objectForKey:@"phoneNumber"],@"phoneNumber",nil];
    
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
    return CHECKNUM_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return CHECKNUM_BIZCODE;
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

//
//  GetRHKDcodeMessage.m
//  WoChuangFu
//
//  Created by 陈亦海 on 15/6/26.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "GetRHKDcodeMessage.h"

@implementation GetRHKDcodeMessage

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:GetRHKDcodeMessage_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[GetRHKDcodeMessage_BIZCODE uppercaseString]];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:
                              [requestInfo objectForKey:@"expand"],@"expand",
                              //                              [requestInfo objectForKey:@"sessionId"],@"sessionId",
                              [requestInfo objectForKey:@"netEssPkgId"],@"netEssPkgId",
                              [requestInfo objectForKey:@"net_type"],@"net_type",
                              [requestInfo objectForKey:@"phoneEssPkgId"],@"phoneEssPkgId",
                              [requestInfo objectForKey:@"woRhflag"],@"woRhflag",
                              [requestInfo objectForKey:@"userType"],@"userType",
                              nil];
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    
    NSLog(@"检查选择页面报文:%@",requestStr);
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
    
    
    return GetRHKDcodeMessage_BIZCODE;
}

- (NSString*)getBusinessCode
{
    
    return GetRHKDcodeMessage_BIZCODE;
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

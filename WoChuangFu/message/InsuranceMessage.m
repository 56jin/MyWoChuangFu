//
//  InsuranceMessage.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/26.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "InsuranceMessage.h"

@implementation InsuranceMessage


-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:INSURANCE_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[INSURANCE_BIZCODE uppercaseString]];
    
    MyLog(@"%@",[requestInfo class]);
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              [requestInfo objectForKey:@"custName"],@"custName",
                              [requestInfo objectForKey:@"custPhoneNum"],@"custPhoneNum",
                              [requestInfo objectForKey:@"custCertNum"],@"custCertNum",
                              [requestInfo objectForKey:@"phoneBrand"],@"phoneBrand",
                              [requestInfo objectForKey:@"phoneModel"],@"phoneModel",
                              [requestInfo objectForKey:@"phoneImeiNum"],@"phoneImeiNum",nil];
    
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
    return INSURANCE_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return INSURANCE_BIZCODE;
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

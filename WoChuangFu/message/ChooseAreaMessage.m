//
//  ChooseAreaMessage.m
//  WoChuangFu
//
//  Created by duwl on 12/19/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "ChooseAreaMessage.h"

@implementation ChooseAreaMessage
- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:CHOOSE_AREA_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[CHOOSE_AREA_BIZCODE uppercaseString]];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"provinceCode"]==nil?[NSNull null]:[requestInfo objectForKey:@"provinceCode"],@"provinceCode",
                              [requestInfo objectForKey:@"cityCode"]==nil?[NSNull null]:[requestInfo objectForKey:@"cityCode"],@"cityCode",
                              [requestInfo objectForKey:@"countryCode"]==nil?[NSNull null]:[requestInfo objectForKey:@"countryCode"],@"countryCode",nil];
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];

    MyLog(@"请求报文:%@",requestStr);
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
    return CHOOSE_AREA_BIZCODE;
}

- (NSString*)getBusinessCode
{
	return CHOOSE_AREA_BIZCODE;
}

-(void)parseMessage
{
    //需要解析在此处解析
    NSArray *keyArray = [[NSArray alloc] initWithObjects:
                         @"areas",nil];
    if (self.rspInfo!= nil && [self.rspInfo isKindOfClass:[NSDictionary class]]) {
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

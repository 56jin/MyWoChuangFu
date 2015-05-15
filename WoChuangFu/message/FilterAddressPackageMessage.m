//
//  FilterAddressPackageMessage.m
//  WoChuangFu
//
//  Created by 李新新 on 14-12-30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "FilterAddressPackageMessage.h"

@implementation FilterAddressPackageMessage

- (void)dealloc
{
	[super dealloc];
}
- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:FILTERADDRESSPACKAGE_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[FILTERADDRESSPACKAGE_BIZCODE uppercaseString]];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              [requestInfo objectForKey:@"addrId"],@"addrId",
                              [requestInfo objectForKey:@"bandAddress"] == nil?[NSNull null]:[requestInfo objectForKey:@"bandAddress"],@"bandAddress",
                              [requestInfo objectForKey:@"cityCode"],@"cityCode",
                              [requestInfo objectForKey:@"moduleId"],@"moduleId",
                              nil];
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    
    MyLog(@"检查地址套餐查询报文:%@",requestStr);
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
    return FILTERADDRESSPACKAGE_BIZCODE;
}

- (NSString*)getBusinessCode
{
	return FILTERADDRESSPACKAGE_BIZCODE;
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

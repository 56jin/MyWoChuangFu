//
//  MainPageMessage.m
//  WoChuangFu
//
//  Created by duwl on 12/10/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "MainPageMessage.h"

@implementation MainPageMessage
-(void)dealloc
{
	[super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:MAIN_PAGE_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,MAIN_PAGE_BIZCODE];
    
//    NSArray *arr=[NSArray arrayWithObjects:[requestInfo objectForKey:@"advType"], nil];
    //NSDictionary *bodyData = [NSNull null];//[[NSDictionary alloc] initWithObjectsAndKeys:
                              //requestClass,@"@class",
                              //nil];
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:nil];
    [headerData release];
//    [bodyData release];
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
    return MAIN_PAGE_BIZCODE;
}

- (NSString*)getBusinessCode
{
	return MAIN_PAGE_BIZCODE;
}

-(void)parseMessage
{
    //需要解析在此处解析
    NSArray *keyArray = [[NSArray alloc] initWithObjects:
                         @"datas",nil];
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

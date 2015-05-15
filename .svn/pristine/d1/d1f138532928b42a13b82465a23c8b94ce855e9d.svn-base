//
//  OrderMessage.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/12.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "SearchOrderMessage.h"

@implementation SearchOrderMessage

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:ORDERMESSAGE_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[ORDERMESSAGE_BIZCODE uppercaseString]];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                             requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              [requestInfo objectForKey:@"orderCode"],@"orderCode",
                              [requestInfo objectForKey:@"receiverPhoneNum"],@"receiverPhoneNum",
                              [requestInfo objectForKey:@"certNum"],@"certNum",
                              [requestInfo objectForKey:@"orderStatus"],@"orderStatus",
                              [requestInfo objectForKey:@"pageIndex"],@"pageIndex",
                              [requestInfo objectForKey:@"pageCount"],@"pageCount",nil];

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
    return ORDERMESSAGE_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return ORDERMESSAGE_BIZCODE;
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


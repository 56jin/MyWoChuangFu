//
//  CheckFLowMessage.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/26.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "CheckFLowMessage.h"
#define FLOW_OK     @"OK"
#define FLOW_FAIL   @"error"
#define FLOW_WAIT   @"......"
#define FLOW_SEP    @"\n"

@implementation CheckFLowMessage

-(void)dealloc
{
    [super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:CHECK_FLOW_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[CHECK_FLOW_BIZCODE uppercaseString]];
    
    NSObject *orderCode = [requestInfo objectForKey:@"orderCode"]==nil?[NSNull null]:[requestInfo objectForKey:@"orderCode"];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              orderCode,@"orderCode",nil];
    
    
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
    return CHECK_FLOW_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return CHECK_FLOW_BIZCODE;
}

-(void)parseMessage
{
    if (self.rspInfo != nil) {
        NSString *respDesc = [self.rspInfo objectForKey:@"respDesc"];
        if (respDesc != nil) {
            NSArray *itemArray = [respDesc componentsSeparatedByString:FLOW_SEP];
            NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSString *oneItem in itemArray) {
                NSRange suessRange = [oneItem rangeOfString:FLOW_OK];
                if (suessRange.length != 0) {
                    NSString *keyStr = [oneItem substringToIndex:suessRange.location];
                    NSDictionary *oneFlow = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             keyStr,@"key",
                                             @"Y",@"value", nil];
                    [itemList addObject:oneFlow];
                    [oneFlow release];
                    continue;
                }
                
                NSRange failRange = [oneItem rangeOfString:FLOW_FAIL];
                if (failRange.length != 0) {
                    NSString *keyStr = [oneItem substringToIndex:failRange.location];
                    NSDictionary *oneFlow = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             keyStr,@"key",
                                             @"N",@"value", nil];
                    [itemList addObject:oneFlow];
                    [oneFlow release];
                    continue;
                }
                NSRange waitRange = [oneItem rangeOfString:FLOW_WAIT];
                if (waitRange.length != 0) {
                    NSString *keyStr = [oneItem substringToIndex:waitRange.location];
                    NSDictionary *oneFlow = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             keyStr,@"key",
                                             @"W",@"value", nil];
                    [itemList addObject:oneFlow];
                    [oneFlow release];
                    continue;
                }
            }
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  itemList,@"respDesc", nil];
            self.rspInfo = data;
            [data release];
            [itemList release];
        }
    }

}

@end

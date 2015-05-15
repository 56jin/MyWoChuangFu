#import "ProductsMessage.h"

@implementation ProductsMessage

-(void)dealloc
{
	[super dealloc];
}

- (NSString *)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:PRODUCTS_BIZCODE,@"bizCode",nil];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[PRODUCTS_BIZCODE uppercaseString]];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              [requestInfo objectForKey:@"expand"]==nil?[NSNull null]:[requestInfo objectForKey:@"expand"],@"expand",
                              [requestInfo objectForKey:@"filter"],@"filter",
                              [requestInfo objectForKey:@"phoneBrand"],@"phoneBrand",
                              [requestInfo objectForKey:@"searchKey"],@"searchKey",
                              [requestInfo objectForKey:@"moduleId"],@"moduleId",
                              [requestInfo objectForKey:@"developerId"],@"developerId",
                              [requestInfo objectForKey:@"sortType"],@"sortType",
                              [requestInfo objectForKey:@"pageIndex"],@"pageIndex",
                              [requestInfo objectForKey:@"pageCount"],@"pageCount",
                              [requestInfo objectForKey:@"needType"],@"needType",
                              [requestInfo objectForKey:@"speciseId"],@"speciseId",
                              [requestInfo objectForKey:@"requestType"],@"requestType",
                              nil];
    [requestClass release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    
    MyLog(@"检查产品报文:%@",requestStr);
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
    return PRODUCTS_BIZCODE;
}

- (NSString*)getBusinessCode
{
	return PRODUCTS_BIZCODE;
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

//
//  PaymentUrlMessage.m
//  WoChuangFu
//
//  Created by duwl on 12/25/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "PaymentUrlMessage.h"

@implementation PaymentUrlMessage
@synthesize paymentUrl;

-(void)dealloc
{
    if(paymentUrl != nil){
        [paymentUrl release];
    }
    [super dealloc];
}

- (NSString *)getRequest
{
	return [requestInfo objectForKey:@"order_code"];//[message hexStringDes:requestStr withEncrypt:YES];
}

-(void)parseOther
{
    [super parseOther];
    [self parseMessage];
}

- (void)parseResponse:(NSString *)responseMessage
{
    NSLog(@"responseMessage=%@",responseMessage);
    paymentUrl = responseMessage;
}

+ (NSString*)getBizCode
{
    return PAYMENT_URL_BIZCODE;
}

- (NSString*)getBusinessCode
{
	return PAYMENT_URL_BIZCODE;
}

-(void)parseMessage
{
    
}
@end

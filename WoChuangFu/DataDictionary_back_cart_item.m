//
//  DataDictionary_back_cart_item.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-22.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "DataDictionary_back_cart_item.h"

@implementation DataDictionary_back_cart_item

@synthesize ITEM_CODE = _ITEM_CODE;
@synthesize ITEM_NAME = _ITEM_NAME;
@synthesize ITEM_URL = _ITEM_URL;

- (id)initWithDataItem:(NSDictionary *)dic
{
    NSDictionary *item = dic;
    if (self = [super init])
    {
        self.ITEM_CODE = [item objectForKey:@"ITEM_CODE"];
        self.ITEM_NAME = [item objectForKey:@"ITEM_NAME"];
        self.ITEM_URL = [item objectForKey:@"ITEM_URL"];
    }
    return self;
}

- (void)dealloc
{
    self.ITEM_NAME = nil;
    self.ITEM_CODE = nil;
    self.ITEM_URL = nil;
    [super dealloc];
}

@end

//
//  CreateOrderMessage.h
//  WoChuangFu
//
//  Created by duwl on 12/10/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "message.h"

#define CREATE_ORDER_BIZCODE @"cf0026"

@interface CreateOrderMessage : message<MessageDelegate>
{
    
}

+ (NSString*)getBizCode;

@end

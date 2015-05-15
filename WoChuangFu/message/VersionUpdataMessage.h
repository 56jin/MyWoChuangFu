//
//  VersionUpdataMessage.h
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-21.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "message.h"

#define VERSION_BIZCODE    @"c0001"

@interface VersionUpdataMessage : message<MessageDelegate>
{
}

+ (NSString*)getBizCode;

@end

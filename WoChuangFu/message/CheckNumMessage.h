//
//  CheckNumMessage.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "message.h"
#define CHECKNUM_BIZCODE     @"c0007"

@interface CheckNumMessage :message<MessageDelegate>
{
}

+ (NSString*)getBizCode;
@end

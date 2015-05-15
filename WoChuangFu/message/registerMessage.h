//
//  registMessage.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "message.h"

#define REGIST_BIZCODE     @"c0006"

@interface registerMessage : message<MessageDelegate>

+ (NSString*)getBizCode;

@end

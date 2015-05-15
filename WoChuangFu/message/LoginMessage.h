//
//  LoginMessage.h
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-20.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "message.h"

#define LOGIN_BIZCODE    @"c0003"

#define USER_IMSI		@""
#define USER_BRAND      @"APPLE"
#define USER_SVC        @""
#define USER_OS         @"IOS"

@interface LoginMessage : message<MessageDelegate>
{
}

+ (NSString*)getBizCode;

@end

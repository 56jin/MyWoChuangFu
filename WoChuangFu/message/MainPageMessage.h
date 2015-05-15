//
//  MainPageMessage.h
//  WoChuangFu
//
//  Created by duwl on 12/10/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "message.h"

#define MAIN_PAGE_BIZCODE   @"c0004"

@interface MainPageMessage : message<MessageDelegate>
{
    
}
+ (NSString*)getBizCode;
@end

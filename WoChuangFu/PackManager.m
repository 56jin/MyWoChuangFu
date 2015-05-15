//
//  PackManager.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/16.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "PackManager.h"

@implementation PackManager
static PackManager *_shareInstance;

+(PackManager *)shareInstance
{
    @synchronized ([PackManager class])
    {
        if (_shareInstance == nil)
        {
            _shareInstance = [[PackManager alloc] init];
        }
    }
    return _shareInstance;
}



@end

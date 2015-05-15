//
//  TimeManager.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/17.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "TimeManager.h"

@implementation TimeManager

static TimeManager *_shareInstance;

+(TimeManager *)shareInstance
{
    @synchronized ([TimeManager class])
    {
        if (_shareInstance == nil)
        {
            _shareInstance = [[TimeManager alloc] init];
        }
    }
    return _shareInstance;
}

@end

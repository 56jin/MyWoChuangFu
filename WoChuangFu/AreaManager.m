//
//  AreaManager.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/21.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "AreaManager.h"

@implementation AreaManager

static AreaManager *_shareInstance;

+(AreaManager *)shareInstance
{
    @synchronized ([AreaManager class])
    {
        if (_shareInstance == nil)
        {
            _shareInstance = [[AreaManager alloc] init];
        }
    }
    return _shareInstance;
}


@end

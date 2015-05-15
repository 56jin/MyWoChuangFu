//
//  NumberManager.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/11.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "NumberManager.h"
#import "NumberModel.h"

@implementation NumberManager

static NumberManager *_shareInstance;

+(NumberManager *)shareInstance
{
    @synchronized ([NumberManager class])
    {
        if (_shareInstance == nil)
        {
            _shareInstance = [[NumberManager alloc] init];
        }
    }
    return _shareInstance;
}



@end

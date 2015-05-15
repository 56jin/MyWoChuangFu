//
//  ProDuctShareManager.m
//  WoChuangFu
//
//  Created by 郑渊文 on 15/1/17.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ProDuctShareManager.h"

@implementation ProDuctShareManager

static ProDuctShareManager *_shareInstance;

+(ProDuctShareManager *)shareInstance
{
    @synchronized ([ProDuctShareManager class])
    {
        if (_shareInstance == nil)
        {
            _shareInstance = [[ProDuctShareManager alloc] init];
        }
    }
    return _shareInstance;
}

@end

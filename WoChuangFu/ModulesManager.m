//
//  ModulesManager.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-26.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ModulesManager.h"

@implementation ModulesManager

+(ModulesManager *)shareManager
{
    static ModulesManager *manager = nil;
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [[ModulesManager alloc] init];
        }
    }
    return manager;
}

@end

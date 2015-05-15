//
//  AreaModel.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/21.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

@synthesize areaName;
@synthesize areaCode;

-(void)exchangeNil
{
    if(areaName == nil) areaName = @"";
    if(areaCode == nil) areaCode = @"";
}

#pragma mark - NSCopying
// 复制
-(id)copyWithZone:(NSZone *)zone
{
    AreaModel *newItem = [[AreaModel allocWithZone: zone] init];

    newItem.areaName = self.areaName;
    newItem.areaCode = self.areaCode;

    
    return newItem;
}
@end

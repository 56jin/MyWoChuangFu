//
//  TimeManager.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/17.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeModel.h"

@interface TimeManager : NSObject

+(TimeManager *)shareInstance;
@property (nonatomic,retain) TimeModel *time;

@end

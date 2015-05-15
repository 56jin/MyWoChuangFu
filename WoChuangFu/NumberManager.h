//
//  NumberManager.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/11.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumberModel.h"

@interface NumberManager : NSObject

+(NumberManager *)shareInstance;
@property (nonatomic,retain) NumberModel *num;

@end

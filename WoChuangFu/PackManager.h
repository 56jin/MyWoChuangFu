//
//  PackManager.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/16.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "packModel.h"

@interface PackManager : NSObject

@property(nonatomic,strong) NSArray *packageModes;
+(PackManager *)shareInstance;
@property (nonatomic,retain) NSString *pack;

@end

//
//  AreaManager.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/21.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AreaModel.h"

@interface AreaManager : NSObject
+(AreaManager *)shareInstance;
//@property (nonatomic,retain) AreaModel *area;
@property (nonatomic,copy) NSMutableArray *areaList;
@property (nonatomic,copy)NSString *areaName;
@property (nonatomic,copy) NSMutableArray *areaIdList;
@property (nonatomic,copy) NSString *areaId;

@end

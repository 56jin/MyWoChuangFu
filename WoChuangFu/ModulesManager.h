//
//  ModulesManager.h
//  WoChuangFu
//
//  Created by 李新新 on 15-1-26.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModulesManager : NSObject

@property(nonatomic,strong) NSArray *modulesList;

+(ModulesManager *)shareManager;

@end

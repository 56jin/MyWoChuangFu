//
//  ProDuctShareManager.h
//  WoChuangFu
//
//  Created by 郑渊文 on 15/1/17.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProDuctShareManager : NSObject

+(ProDuctShareManager *)shareInstance;
@property (nonatomic,copy) NSDictionary *productShareDta;
@property (nonatomic,copy) NSString *authKey;
@end

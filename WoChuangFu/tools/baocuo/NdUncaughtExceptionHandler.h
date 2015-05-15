//
//  CrashExceptioinCatcher.h
//  EsayBuy
//
//  Created by 颜 梁坚 on 14-3-10.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NdUncaughtExceptionHandler : NSObject {
    
}

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;

@end

//
//  CityLog.h
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-30.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbSqlite.h"

@interface CityLog : NSObject

+(void)addCityLog:(NSString*)province City:(NSString*)city CityStr:(NSString*)citystr;
+(NSMutableArray*)queryWorkLogWithProvince_code:(NSString *)province_code;
+(void)dbCheck;
+(NSMutableArray*)queryWorkLogWithCity_code:(NSString *)City_code;

@end

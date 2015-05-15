//
//  CityLog.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-30.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "CityLog.h"

@implementation CityLog

+(void)addCityLog:(NSString*)province City:(NSString*)city CityStr:(NSString*)citystr{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = @"insert into City_Log(city_code,province_code,city_str) values(?,?,?)";
    NSArray* param = [[NSArray alloc] initWithObjects:city,province,citystr,nil];
    [db execute:sql params:param];
    [param release];
    [db release];
}

+(NSMutableArray*)queryWorkLogWithProvince_code:(NSString *)province_code{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = [NSString stringWithFormat:@"select city_code,city_str from City_Log where province_code='%@'",province_code];
    NSMutableArray* ret= [db query:sql columns:2];
    [db release];
    return ret;
}

+(NSMutableArray*)queryWorkLogWithCity_code:(NSString *)City_code{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = [NSString stringWithFormat:@"select city_str from City_Log where city_code='%@'",City_code];
    NSMutableArray* ret= [db query:sql columns:1];
    [db release];
    return ret;
}

+(void)dbCheck{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    BOOL isIn = [db hasTableByName:@"City_Log"];
    if(isIn==NO){
        NSString* sql = @"create table City_Log(city_code text(1000),province_code text(1000),city_str text(1000))";
        [db execute:sql params:nil];
    }else{
        //先删表
        NSString *sql = @"drop table City_Log";
        [db execute:sql params:nil];
        sql =  @"create table City_Log(city_code text(1000),province_code text(1000),city_str text(1000))";
        [db execute:sql params:nil];
    }
    [db release];
}

@end

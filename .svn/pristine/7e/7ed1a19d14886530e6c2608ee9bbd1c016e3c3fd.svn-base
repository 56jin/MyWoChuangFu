//
//  AreaLog.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-30.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "AreaLog.h"

@implementation AreaLog

+(void)addAreaLog:(NSString*)city Area:(NSString*)area AreaStr:(NSString*)areastr{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = @"insert into Area_Log(Area_code,city_code,Area_str) values(?,?,?)";
    NSArray* param = [[NSArray alloc] initWithObjects:area,city,areastr,nil];
    [db execute:sql params:param];
    [param release];
    [db release];
}

+(NSMutableArray*)queryWorkLogWithArea_code:(NSString *)city_code{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = [NSString stringWithFormat:@"select Area_code,Area_str from Area_Log where city_code='%@'",city_code];
    NSMutableArray* ret= [db query:sql columns:2];
    [db release];
    return ret;
}

+(NSMutableArray*)queryWorkLogWithArea_code1:(NSString *)Area_code{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = [NSString stringWithFormat:@"select Area_str from Area_Log where Area_code='%@'",Area_code];
    NSMutableArray* ret= [db query:sql columns:1];
    [db release];
    return ret;
}

+(void)dbCheck{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    BOOL isIn = [db hasTableByName:@"Area_Log"];
    if(isIn==NO){
        NSString* sql = @"create table Area_Log(Area_code text(1000),city_code text(1000),Area_str text(1000))";
        [db execute:sql params:nil];
    }else{
        //先删表
        NSString *sql = @"drop table Area_Log";
        [db execute:sql params:nil];
        sql =  @"create table Area_Log(Area_code text(1000),city_code text(1000),Area_str text(1000))";
        [db execute:sql params:nil];
    }
    [db release];
}

@end

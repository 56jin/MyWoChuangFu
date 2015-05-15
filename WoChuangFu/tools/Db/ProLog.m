//
//  ProLog.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-9-4.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "ProLog.h"

@implementation ProLog

+(void)addProLog:(NSString*)Pro ProStr:(NSString*)Prostr{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = @"insert into Pro_Log(Pro_code,Pro_str) values(?,?)";
    NSArray* param = [[NSArray alloc] initWithObjects:Pro,Prostr,nil];
    [db execute:sql params:param];
    [param release];
    [db release];
}

+(NSMutableArray*)queryAllProLog{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = [NSString stringWithFormat:@"select Pro_code,Pro_str from Pro_Log"];
    NSMutableArray* ret= [db query:sql columns:2];
    [db release];
    return ret;
}

+(NSMutableArray*)queryProLogWithPro_code:(NSString *)Pro_code{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    NSString* sql = [NSString stringWithFormat:@"select Pro_str from Pro_Log where Pro_code='%@'",Pro_code];
    NSMutableArray* ret= [db query:sql columns:1];
    [db release];
    return ret;
}

+(void)dbCheck{
    DbSqlite* db = [[DbSqlite alloc] initWithDbName:@"log.sqlite"];
    BOOL isIn = [db hasTableByName:@"Pro_Log"];
    if(isIn==NO){
        NSString* sql = @"create table Pro_Log(Pro_code text(1000),Pro_str text(1000))";
        [db execute:sql params:nil];
    }else{
        //先删表
        NSString *sql = @"drop table Pro_Log";
        [db execute:sql params:nil];
        sql =  @"create table Pro_Log(Pro_code text(1000),Pro_str text(1000))";
        [db execute:sql params:nil];
    }
    [db release];
}

@end

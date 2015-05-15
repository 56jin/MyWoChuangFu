//
//  DbSqlite.m
//  FuJianITSupport
//
//  Created by xiaomin zhou on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DbSqlite.h"

@implementation DbSqlite

@synthesize path;
@synthesize dbname;

-(id)initWithDbName:(NSString*)db{
    self = [super init];
    if(self!=nil){
        self.dbname = db;
    }
    return self;
}

-(void)readyDabase{
    NSError* err;
    [self getPath];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL ret = [fileManager fileExistsAtPath:self.path];
    if(ret){
        return;
    }
    else{
        NSString* defaultDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.dbname];
        
        ret = [fileManager copyItemAtPath:defaultDbPath toPath:self.path error:&err];
        if(!ret){
            NSLog(@"db error:%@",defaultDbPath);
        }
    }
}

-(void)getPath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    
    self.path = [documentDirectory stringByAppendingPathComponent:self.dbname];
}

-(NSMutableArray*)query:(NSString*)sql columns:(NSInteger)col{
    BOOL ret = YES;
    sqlite3_stmt *stmt = NULL;
    [self readyDabase];
    NSMutableArray* returnData = [[NSMutableArray alloc] init] ;
    @try{
        if(sqlite3_open([path UTF8String], &database)==SQLITE_OK){
            int ret = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
            if(ret!=SQLITE_OK){
                NSLog(@"%@ sqlite3_prepare_v2 error",sql);
                ret =  NO;
            }
            
            while(sqlite3_step(stmt)==SQLITE_ROW){
                NSMutableArray* row = [[NSMutableArray alloc] initWithCapacity:0];
                for(int i=0;i<col;i++){
                    const char* val= (char*)sqlite3_column_text(stmt, i);
                    NSString* nsval ;
                    if(val==NULL||strlen(val)==0)
                        nsval = nil;
                    else
                        nsval = [NSString stringWithUTF8String:val];
                    
                    if(nsval==nil){
                        [row addObject:@""];
                    }
                    else
                        [row addObject:nsval];
                    
                    val = NULL;
                    nsval = nil;
                }
                [returnData addObject:row];
                [row release];
            }
            
            NSLog(@"%@",sql);
        }
        else{
            NSLog(@"%@ sqlite3_open error",sql);
            ret =  NO;
        }
    }
    @catch(NSException *e){
        NSLog(@"%@",e.reason);
        NSLog(@"%@ error",sql);
        ret =  NO;
    }
    @finally{
        if(stmt!=NULL) sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    
    if(ret)
        return returnData;
//        return [returnData autorelease];
    else
        return nil;
}

-(BOOL)hasTableByName:(NSString*)tabname{
    NSString* sql = [NSString stringWithFormat: @"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@'",tabname];
    NSArray* arrNum = [self query:sql columns:1];
    NSArray* logrow = [arrNum objectAtIndex:0];
    if(arrNum!=nil&&arrNum.count>0&&[[logrow objectAtIndex:0] intValue]==1){
        return true;
    }else{
        return false;
    }
}

-(BOOL)execute:(NSString*)sql params:(NSArray*)param{
    BOOL ret = YES;
    sqlite3_stmt *stmt = NULL;
    [self readyDabase];
    @try{
        if(sqlite3_open([path UTF8String], &database)==SQLITE_OK){
            
            int ret = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
            if(ret!=SQLITE_OK){
                NSLog(@"%@ sqlite3_prepare_v2 error,ret=%d",sql,ret);
                ret = NO;
            }
            if(param!=nil&&param.count>0){
                for (int i=0; i<param.count; i++) {
                    NSString* tmp = [param objectAtIndex:i];
                    sqlite3_bind_text(stmt, i+1, [tmp UTF8String], -1, SQLITE_TRANSIENT);
                    //[tmp release];
                }
            }
            ret = sqlite3_step(stmt);
            
            if(ret==SQLITE_ERROR){
                NSLog(@"%@ sqlite3_step error",sql);
                ret = NO;
            }
            else{
                NSLog(@"%@",sql);
                ret = YES;
            }
        }
        else{
            NSLog(@"%@ sqlite3_open error",sql);
            ret = NO;
        }
    }
    @catch(NSException *e){
        NSLog(@"%@ error,%@",sql,[e name]);
        ret = NO;
    }
    @finally{
        if(stmt!=NULL) sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    return ret;
}

@end

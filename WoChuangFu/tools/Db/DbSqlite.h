//
//  DbSqlite.h
//  FuJianITSupport
//
//  Created by xiaomin zhou on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DbSqlite : NSObject{
    sqlite3* database;
    NSString* path;
    NSString* dbname;
}

@property (nonatomic,retain) NSString* path;
@property (nonatomic,retain) NSString* dbname;

-(id)initWithDbName:(NSString*)db;
-(void)readyDabase;
-(void)getPath;
-(NSMutableArray*)query:(NSString*)sql columns:(NSInteger)col;
-(BOOL)execute:(NSString*)sql params:(NSArray*)param;
-(BOOL)hasTableByName:(NSString*)tabname;

@end

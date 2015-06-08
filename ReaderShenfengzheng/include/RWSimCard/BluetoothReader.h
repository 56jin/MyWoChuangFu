//
//  BuletoothReader.h
//  RWSimCard
//
//  Created by BlueElf on 15/4/7.
//  Copyright (c) 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICardReader.h"
#import "btReader.h"
#import "IDCardInfo.h"

@interface BluetoothReader :NSObject<btReaderDelegate>{
    btReader* myReader;
    NSMutableData* photoData;
    IDCardInfo* idCardInfo;
    BOOL end;
    BOOL readFinish;
}

@property(nonatomic,assign) id<ReaderDelegate> readerDelegate;  //Delegate使用retain会导致索引循环引用导致内存泄露，并且极难发现

-(NSString *)transmitAPDU:(NSString *)apduString;   //返回adpuString处理的结果
-(BOOL)setPowerOn:(BOOL)powerOn;  //设置写卡器电源开关
-(BOOL)isPowerOn;   //返回电源状态
-(BOOL)readerReset; //写卡器复位
-(void)close;   //关闭写卡器驱动
-(int)getPower;    //获取电量
-(void)writeSN:(NSString *)SN;
-(NSString *)getSN;
-(BOOL)isReaderConnected;
-(IDCardInfo *)getIDCard;

@end
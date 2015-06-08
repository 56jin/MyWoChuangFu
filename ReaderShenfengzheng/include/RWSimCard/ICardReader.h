//
//  ICardReader.h
//  IOS_Client_Audio
//
//  Created by BlueElf on 13-4-18.
//  Copyright (c) 2013年 BlueElf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReaderDelegate.h"
#import "Readers/HuaHui/btReader/IDCardInfo.h"

@interface ICardReader : NSObject

+(id)init:(NSString *)readerType;
+(NSString *)transmitAPDU:(NSString *)apduString;   //返回adpuString处理的结果
+(BOOL)setPowerOn:(BOOL)isPowerOn;  //设置写卡器电源开关
+(BOOL)isPowerOn;   //返回电源状态
+(BOOL)isReaderConnected;   //返回写卡器连接状态
+(void)close;   //关闭写卡器驱动
+(int)getPower;    //获取电量
+(void)writeSN:(NSString *)SN;
+(NSString *)getSN;
+(BOOL)readerReset;
+(void)setDelegate:(id<ReaderDelegate>)readerDelegate;
+(IDCardInfo *)getIDCard;

@end

//
//  BlueToothDCAdapter.h
//  MiniApple
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCLinkInterface.h"
#import "DCProtocol.h"


//证件信息类
@interface IdCardInformation : NSObject
    @property (nonatomic) NSString *ident;          //证件号码
    @property (nonatomic) NSString *name;           //证件姓名
    @property (nonatomic) NSString *sex;            //性别
    @property (nonatomic) NSString *nation;         //民族
    @property (nonatomic) NSString *birthday;       //生日
    @property (nonatomic) NSString *address;        //地址
    @property (nonatomic) NSString *organization;   //发证机构
    @property (nonatomic) NSString *startDate;      //发证日期
    @property (nonatomic) NSString *effectiveDate;   //有效日期
    @property (nonatomic) NSString *devModelId;     //模块设备标识。
    @property (nonatomic) NSData *picBuffer;        //身份证图片
    @property (nonatomic) NSString *signature;      //证件签名
@end




/*
   蓝牙通信数据适配器。联合链路，协议，搜索设备等功能，并提供数据交互的接口。
 */
@interface BlueToothDCAdapter : NSObject

@property(nonatomic) Class linkDeviceSearchClass;  //通信链路设备搜索类
@property(nonatomic) DCLinkManager *manager;   //通信链路
@property(nonatomic) DCProtocol *dcProtocol;       //通信协议

@property(nonatomic) BOOL hasHandShake;            //是否已经握手,可以用KVO时时监测蓝牙链接状态。


//系统自动完成蓝牙的链接和查找
-(id)init;

//握手。
-(BOOL)handShake:(void(^)(NSObject *obj, NSError *error))callback;

//读身份证信息。采用块的方式进行数据处理,里面会对蓝牙的搜索和连接进行特殊处理
-(BOOL)readIdCard:(void(^)(IdCardInformation* cardinfo, NSError *error))callback;

//读取版本号
-(BOOL)readVersion:(void(^)(NSString* version, NSError *error))callback;


//读取SIM卡号。
-(BOOL)readICCID:(void(^)(NSString* iccid, NSError *error))callback;

//检查SIM卡是否是白卡,
-(BOOL)checkSIM:(void(^)(NSNumber *isblank, NSError *error))callback;

//写IMSI
-(BOOL)writeIMSI:(NSString*)imsi callback:(void(^)(NSNumber *isok, NSError *error))callback;


//写短信中心
-(BOOL)writeSMS:(NSString*)sms callback:(void(^)(NSNumber *isok, NSError *error))callback;



@end

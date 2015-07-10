//
//  BleTool.h
//  BLECardReaderDemoCode
//
//  Created by kaer on 15-3-24.
//  Copyright (c) 2015年 kaer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BR_Callback <NSObject>

//蓝牙连接状态代理，yes 蓝牙连接成功  no 蓝牙连接失败
-(void)BR_connectResult:(BOOL)isconnected;

@end

@interface BleTool : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(assign,nonatomic)id<BR_Callback> brcallback;

///初始化
-(id)init:(id)TargetVCl;

///扫描周围蓝牙阅读器
-(NSMutableArray*)ScanDeiceList:(float)scanTime;//scanTime扫描等待时间，秒

///连接蓝牙
-(void)connectBt:(NSString*)UUID; //uuid 要连接的设备uuid

///蓝牙断开
-(void)disconnectBt;

/**读卡
 *返回类型keys：
 *baseInfo的密文字符串是加密后的身份信息
 *picBitmap为图片数据
 */
-(NSDictionary*)readIDCardS;

/**相片解码方法，需要连接网络，返回类型NSDictionary
 *注：（app发布后不推荐使用此方法，此方法使用的卡尔公司的测试服务器，完成联调后将关闭，请使用DecodePicFunc: onSite:  方法，传入相片解码的url地址）
 *返回类型keys:
 *errCode 0为解码成功 -1解码失败
 *errDesc 在解码失败时有效，失败错误信息描述
 *DecPicData NSData型，解码成功时该key有效,解码后的相片信息
 */
-(NSDictionary*)DecodePicFunc:(NSData*)encPicData;


//相片解码方法，需要连接网络，返回类型NSDictionary
//入参：PicDecodeUrl 相片解码url
//返回类型keys:
//errCode 0为解码成功 -1解码失败
//errDesc 在解码失败时有效，失败错误信息描述
//DecPicData NSData型，解码成功时该key有效,解码后的相片信息
-(NSDictionary*)DecodePicFunc:(NSData*)encPicData onSite:(NSString*)PicDecodeUrl;

/**开卡
 *返回字典项键值如下:
 *errCode:0 成功，-1 失败
 *errDesc:失败时此字段有效,错误描述信息
 *kaikaData:NSData型，成功时此字段有效，开卡的数据
 */
-(NSDictionary *) KaiKa;


/*检查白卡
 *simType：sim卡类型  0表示2G   1表示3G
 *返回字典项键值如下：
 *errCode:1成功 0 失败 -2入参非法 2卡未插入 3不识别的sim卡 4卡插入但还未初始化
 *isBlank:0 白卡 1非白卡
 *IMSI2G NSData型 :2G卡的imsi
 *IMSI3G NSData型 :3G卡的imsi --该key只有输入形参类型是1，即3G的时候存在，形参是0，即2G的时候该key不存在
 */
-(NSDictionary *)CheckSIMisBlank:(int)simType;

/**写imsi
 *入参： imsi1 必填 ， imsi2 可选， 可选项不填的时候可传nil
 *出参： 1成功 0 失败 -2入参非法 2卡未插入 3不识别的sim卡 4卡插入但还未初始化
 */
-(int)WriteSIMCardwithIMSI1:(NSData*)IMSI2G andIMSI2:(NSData*)IMSI3G;

/**写短信中心
 *入参：PhoneNumber 手机号 手机号11位
 *     NumberIndex 短信中心号索引
 *出参： 1成功 0 失败 -2入参非法 2卡未插入 3不识别的sim卡 4卡插入但还未初始化
 */
-(int)WriteMsgCenter:(NSString *)PhoneNumber withNumberIndex:(Byte)NumberIndex;


/**
 *获取设备mac
 *返回类型keys:
 *errCode 0为获取mac成功 -1获取mac失败
 *errDesc 在获取mac失败时有效，失败错误信息描述
 *mac 获取mac成功时有效，设备mac
 */
-(NSDictionary*)getMac;

@end

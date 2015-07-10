//
//  DCLinkInterface.h
//  MiniApple
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


//设备的类型
typedef enum : NSUInteger {
    BlueToothDev_Type_V2,
    BlueToothDev_Type_V4,
} BlueToothDevType;

//管理器的状态
typedef enum : NSUInteger {
    DCM_State_Ready,      //正常状态
    DCM_State_Scaning,    //扫描中
    DCM_State_Disable,    //暂时没用。
} DCM_State;

//设备的状态
typedef enum : NSUInteger {
    DCD_State_Discovered,
    DCD_State_Connecting,
    DCD_State_ConnectedOK,
    DCD_State_ConnectedFail,
} DCD_State;

@class DCLinkManager;
@class BlueToothDev;

@protocol DCLinkDevDelegate <NSObject>

@optional

//设备数据接收通知
-(void) dcLinkDev:(BlueToothDev*)dev didDataRecv:(NSData*)data;

//设备数据发送结果通知
-(void)dcLinkDev:(BlueToothDev *)dev didDataSend:(NSError*)error;

@end

//蓝牙的抽象设备基类。支持2.0和4.0设备
@interface BlueToothDev : NSObject

@property(nonatomic,readonly) NSString *name;           //名字
@property(nonatomic,readonly) NSString *uuid;           //标识
@property(nonatomic) CGFloat  rssi;            //信号强度
@property(nonatomic) DCD_State state;         //状态：被发现，已连接，已关闭连接
@property(nonatomic, readonly) BlueToothDevType type;           //类型，是2.0还是4.0
@property(nonatomic, readonly, weak) DCLinkManager *manager;  


@property(nonatomic, weak) id<DCLinkDevDelegate> delegate;

-(void)sendData:(NSData*)data;

@end


//设备发现协议
@protocol DCLinkManagerDiscoverDelegate <NSObject>



//发现设备通知
-(void)dcLinkManager:(DCLinkManager*)manager discoverDevice:(NSArray*)devices;


@end


//链路层设备连接协议,这个给界面提供的。
@protocol DCLinkManagerDelegate <NSObject>


//蓝牙外设状态更新通知(就绪，搜索中，关闭）
-(void)dcLinkManager:(DCLinkManager*)manager didUpdateState:(NSInteger)state;


//设备连接结果通知
-(void)dcLinkManager:(DCLinkManager *)manager connectedDevice:(BlueToothDev*)device error:(NSError*)error;

//设备终止连接通知
-(void)dcLinkManager:(DCLinkManager *)manager disConnection:(BlueToothDev*)device;

@end



//链路管理器同时支持。
@interface DCLinkManager : NSObject 

//-(id)initWithDelegate:(id<DCLinkManagerDelegate>)delegate;

@property(nonatomic) DCM_State state;  //蓝牙外设的状态:0就绪,1搜索中,2未打开

@property(nonatomic,strong) NSMutableArray *discoveredDevices; //发现的蓝牙周边设备
@property(nonatomic) BlueToothDev *selectedDev;  //选择的设备。

@property(nonatomic,weak) id<DCLinkManagerDiscoverDelegate> discoverDelegate; //设备发现委托。
@property(nonatomic,weak) id<DCLinkManagerDelegate> delegate; //连接管理委托


-(void)startScanWithOption:(NSDictionary*)option;
-(void)stopScan;


//连接设备和断开连接。
-(void)connect:(BlueToothDev*)device;
-(void)disConnect;




@end

//
//  DCProtocol.h
//  MiniApple
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

//协议委托用于接收解析的数据
@protocol DCProtocolDelegate <NSObject>

//当有数据结果时回调
-(void)dcProtocolResult:(NSData*)rawData module:(unsigned char)module func:(unsigned char)func error:(NSError*)error;

@end

//数据通信协议，负责报文的封装和解析
//这里不解析数据部分的内容。协议基类。
@interface DCProtocol : NSObject

@property(nonatomic,weak) id<DCProtocolDelegate> delegate;

//模块号和功能号
-(NSData*)encode:(NSData*)rawData encry:(unsigned char)encry module:(unsigned char)module  func:(unsigned char)func;

-(void)decode:(NSData*)ripeData;

//删除数据重新解析。
-(void)reset;

@end

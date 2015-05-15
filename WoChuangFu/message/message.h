//
//  message.h
//  OSFastSell
//
//  Created by wu hui on 7/22/13
//  Copyright 2013 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDelegate.h"

#define JSON_BODY_REUEST   @"com.ailk.app.mapp.model.req.%@Request"

#define JSON_TEMP @"{\"@class\":\"com.ailk.app.mapp.model.GXCDatapackage\",\"header\":{%@},\"body\":%@}"

#define JSON_HEADER @"\"@class\":\"com.ailk.app.mapp.model.GXCHeader\",\"bizCode\":\"%@\",\"identityId\":null,\"respCode\":null,\"respMsg\":null,\"mode\":\"1\",\"sign\":null"

#define JSON_RESPCODE    @"respCode"
#define JSON_RESPMSG     @"respMsg"

@interface message : NSObject<MessageDelegate>{
	NSString* rspCode;
	NSString* rspDesc;
    
    NSString* responseInfo;
    
    NSDictionary *jsonRspData;
    
    //返回包体解析存储字典及发送包体字典
    NSDictionary *rspInfo;
    NSDictionary *requestInfo;
    
    NSString* bizCode;
    
    BOOL compressed;
    BOOL responseCompressed;
    
}

@property(nonatomic, retain)NSDictionary *jsonRspData;
@property(nonatomic, retain)NSString* rspCode;
@property(nonatomic, retain)NSString* rspDesc;
@property(nonatomic, retain)NSDictionary *rspInfo;
@property(nonatomic, retain)NSDictionary *requestInfo;
@property(nonatomic, retain)NSString* bizCode;
@property(nonatomic, retain)NSString* responseInfo;
@property(nonatomic, assign)BOOL compressed;
@property(nonatomic, assign)BOOL responseCompressed;


//公共解析部分
+(NSString*)getNetLinkErrorCode;
+(NSString*)getTimeOutErrorCode;
-(NSString*)getRspcode;
-(NSString*)getMSG;
+(NSString*)getRespondDescription:(NSString*)resCode;
//如果一个接口返回的报文只有第一级节点，可以调用此接口解析
//这样所有的数据都存储在：rspInfo中
-(void)parseRspcodeSubItemsToRspInfo;


- (void)parse:(NSString *)responseMessage;
//除了有第一级节点的报文，还有其他的报文，就必备重载这个函数
- (void)parseOther;
-(void)parseMessage;

//help
-(NSString *)getJSONHeader:(NSDictionary *)headData;
-(NSString *)getRequestJSONFromHeader:(NSDictionary *)headDic withBody:(NSDictionary *)bodyDic;
+(NSString*)getDeviceCode;
+(NSString*)getBizCode;
//加密
+(NSData *) geteSHAEncryptedPaylod:(NSString *)message;
+(NSString*)md5Encode:(NSString*)str;
+(NSString*)hexStringDes:(NSString*)str withEncrypt:(BOOL)bEncrypt;


@end

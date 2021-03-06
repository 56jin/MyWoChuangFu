//
//  bussineDataService.h
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-20.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpStatus.h"
#import "HttpConnector.h"
#import "message_def.h"

#define kForceUpdateTag         100
#define kLinkErrorTag           101
#define kTimeOutErrorTag        102
#define kSessionTimeOutTag      103

@protocol HttpBackDelegate<NSObject>

@required
//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestDidFinished:(NSDictionary*)info;
//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestFailed:(NSDictionary*)info;

@optional
//点击超时或者连接错误提示上的取消按钮的回调接口
- (void)cancelTimeOutAndLinkError;
@end

@interface bussineDataService : NSObject<UIAlertViewDelegate, HttpStatus>
{
    NSString*			receiveString;
	NSDictionary*		sendDataDic;
	NSString*			sendString;
	
	id<HttpBackDelegate>  target;
    SEL sendMessageSelector;
    HttpConnector* httpCnctor;
    
    // 一般都是第一级的节点的键值对，例如：RspCode=0000 ,key:"RspCode" value:"0000"
    NSDictionary*       rspInfo;
    NSString*			serversUrl;
}

@property (nonatomic,assign) id<HttpBackDelegate> target;
@property (nonatomic,retain) HttpConnector* httpCnctor;
@property (nonatomic,assign) SEL sendMessageSelector;
@property (nonatomic,retain) NSString*		receiveString;
@property (nonatomic,retain) NSString*		serversUrl;
@property (nonatomic,retain) NSDictionary*	sendDataDic;
@property (nonatomic,retain) NSString*		sendString;
@property (nonatomic,retain) NSDictionary*  rspInfo;
@property (nonatomic,retain) NSString *updateUrl;
@property (assign) BOOL HasLogIn;//判断是不是已经登录
@property (assign) BOOL LogInHttp;//判断是否登录接口调用
@property (nonatomic,retain) NSDictionary* TuiSongDic;
@property (nonatomic,retain) NSDictionary* loginInfo;

+(bussineDataService *) sharedDataService;
+(bussineDataService *) sharedDataServicee;

#pragma mark
#pragma mark - 登陆模块
- (void)login:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 检查更新
- (void)updateVersion:(NSDictionary *)parameters;

#pragma mark
#pragma mark - 报错提交
- (void)BaoCuoback:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 主页
- (void)zhuye:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 首页获取动态数据
- (void)mainPage:(NSDictionary *)parameters;

#pragma mark
#pragma mark - 下单
- (void)createOrder:(NSDictionary *)parameters;

#pragma mark
#pragma mark - 套餐
- (void)package:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 号码
- (void)number:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 订单
- (void)order:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 手机意外保
- (void)creatInsurance:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取商品
- (void)getProducts:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 上传照片
- (void)uploadPhoto:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 钱咖登陆
- (void)qiankaLogin:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取商品详情
- (void)getProductDetail:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 商品评价
- (void)ProductEvaluate:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取商品评价
- (void)getEvaluate:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 选择地区
- (void)chooseArea:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 验证码
- (void)checkNum:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取财富
- (void)getWealth:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 注册
- (void)regist:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 用户信息
- (void)getInfo:(NSDictionary *)paramters;


#pragma mark
#pragma mark - 获取支付url
-(void)paymentUrl:(NSDictionary*)paramters url:(NSString*)url key:(NSString*)key;

#pragma mark
#pragma mark - 过滤地址
-(void)filterAddress:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 过滤地址
-(void)filterAddressPackage:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 找回密码
-(void)getBackPwd:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取搜索页面信息
-(void)getSearchInfo:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取消息中心数据
-(void)getMsgCenterData:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 钱咖分享
- (void)qiankaShare:(NSDictionary *)paramters;


#pragma mark
#pragma mark - 加入机构
- (void)addJigou:(NSDictionary *)paramters;
#pragma mark - 机构查询
- (void)selectJigou:(NSDictionary *)paramters;
#pragma mark - 退出登录
- (void)usrtLogout:(NSDictionary *)paramters;
#pragma mark - 判断是否有权限进入实名返档
- (void)isRootPush:(NSDictionary *)paramters;
#pragma mark - 实名返档
- (void)sureGuiDang:(NSDictionary *)paramters;
#pragma mark - 沃校园管理确认下单
- (void)schoolOrderComfirm:(NSDictionary *)paramters;
#pragma mark 号码判断是否为联通号码
-(void)identifyManeger:(NSDictionary *)paramters;
#pragma mark 获取手机验证码
-(void)getIndentifyCode:(NSDictionary *)paramters;
#pragma mark 校验手机验证码
-(void)comfirmIndentifyCode:(NSDictionary *)paramters;
#pragma mark 校验身份证与手机号是否一致
-(void)sureSFZandIphoneNum:(NSDictionary *)paramters;
#pragma mark cf0046获取融合宽带信息
-(void)getRHKDInfo:(NSDictionary *)paramters;


#pragma mark
#pragma mark - 搜索派单开户订单
- (void)searchAccountOrder:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 开户
- (void)commitOpenUser:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 开户成功提交信息
- (void)suessCommitOpenUser:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 查看开户流程处理过程
- (void)checkFlow:(NSDictionary *)paramters;

@end

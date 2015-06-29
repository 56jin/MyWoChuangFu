//
//  bussineDataService.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-8-20.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "bussineDataService.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIDevice-Reachability.h"
#import "AreaLog.h"
#import "CityLog.h"
#import "ProLog.h"

@implementation bussineDataService

@synthesize target;
@synthesize httpCnctor;
@synthesize sendMessageSelector;
@synthesize receiveString;
@synthesize sendDataDic;
@synthesize sendString;
@synthesize rspInfo;
@synthesize updateUrl;
@synthesize HasLogIn;
@synthesize TuiSongDic;
@synthesize loginInfo;
@synthesize LogInHttp;
@synthesize serversUrl;

-(void)dealloc
{
	[receiveString release];
    [serversUrl release];
	[sendDataDic release];
	[sendString release];
    [httpCnctor release];
    if(rspInfo != nil){
        [rspInfo release];
    }
    if(loginInfo != nil){
        [loginInfo release];
    }
    if(TuiSongDic != nil){
        [TuiSongDic release];
    }
    [super dealloc];
}

#pragma mark -
#pragma mark bussineDataService inferface

// 单实例模式
static bussineDataService *sharedBussineDataService = nil;
// 单实例模式
static bussineDataService *sharedBussineDataServicee = nil;

+(bussineDataService*)sharedDataService {
    
    @synchronized ([bussineDataService class]) {
        if (sharedBussineDataService == nil) {
			sharedBussineDataService = [[bussineDataService alloc] sharedInit];
            return sharedBussineDataService;
        }
    }
    
    return sharedBussineDataService;
}

+(bussineDataService*)sharedDataServicee {
    
    @synchronized ([bussineDataService class]) {
        if (sharedBussineDataServicee == nil) {
            sharedBussineDataServicee = [[bussineDataService alloc] sharedInite];
            return sharedBussineDataServicee;
        }
    }
    
    return sharedBussineDataServicee;
}


-(id)sharedInite
{
    if (self = [super init]) {
        HttpConnector* _httpConnector = [[HttpConnector alloc] init];
        _httpConnector.serviceUrl = service_urlqq;
        self.serversUrl = service_urlqq;
        _httpConnector.isPostXML = NO;
        _httpConnector.statusDelegate = self;
        self.HasLogIn=NO;
        [_httpConnector setTimeout:20];
        [self setHttpCnctor:_httpConnector];
        [_httpConnector release];
    }
    
    return self;
}
-(id)sharedInit
{
	if (self = [super init]) {
		HttpConnector* _httpConnector = [[HttpConnector alloc] init];
        
		_httpConnector.serviceUrl = service_url;
        self.serversUrl = service_url;
        _httpConnector.isPostXML = NO;
		_httpConnector.statusDelegate = self;
        self.HasLogIn=NO;
        [_httpConnector setTimeout:20];
        [self setHttpCnctor:_httpConnector];
        [_httpConnector release];
	}
	
	return self;
}

- (void)sharedSendMessage:(id <MessageDelegate>)msg synchronously:(BOOL)isSynchronous
{
    self.httpCnctor.serviceUrl = self.serversUrl;
    self.httpCnctor.allowCompressed = YES;
    NSString* sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
    if(sessionId == nil){
        sessionId = @"";
    }
    MyLog(@"sessionId:%@",sessionId);
    if([msg isHouTai]){
        MyLog(@"请求的地址：%@",self.httpCnctor.serviceUrl);
        [self.httpCnctor sendMessage:msg synchronously:NO SessionId:sessionId];
    }else{
//        [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
        
        if (![[msg getBusinessCode] isEqualToString:COMMIT_OPEN_USER_BIZCODE] &&
            ![[msg getBusinessCode] isEqualToString:SUECC_OPEN_USER_BIZCODE]) {
            [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
        }
        
        
#ifdef STATIC_XML
        NSString* xmlFile = [[NSString alloc] initWithString:[[NSBundle mainBundle]
                                                              pathForResource:[msg getBusinessCode]
                                                              ofType:@"json"]];

        [self.httpCnctor sendMessage_static:msg xmlFile:xmlFile];
        [xmlFile release];
#else
        MyLog(@"请求的地址：%@",self.httpCnctor.serviceUrl);
        
        [self.httpCnctor sendMessage:msg synchronously:NO SessionId:sessionId];
#endif
    }
//    MyLog(@"%@\n %@",self.httpCnctor.httpRequest.requestHeaders,self.httpCnctor.httpRequest.userInfo);
}

-(NSDictionary*)handleRspInfo:(message *) msg
{
    NSString* rspCode = [msg getRspcode];
    NSString* bussineCode = msg.bizCode;
    NSString* rspDesc = [msg getMSG];
    //key: bussineCode value :; Key:errorCode, value: key:MSG, value:
    NSMutableDictionary* rspDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    [rspDic setObject:msg forKey:@"MESSAGE_OBJECT"];
    [rspDic setObject:rspCode forKey:@"errorCode"];
    [rspDic setObject:bussineCode forKey:@"bussineCode"];
    if (rspDesc != nil) {
        [rspDic setObject:rspDesc forKey:@"MSG"];
    }
    
    if ([rspCode isEqualToString:@"0001"]) {
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"登录超时，请重新登录！"//Session 过期
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        alertView.tag = kSessionTimeOutTag;
        [alertView show];
        [alertView release];
        return nil;
    }
    
    return rspDic;
}

-(void)noticeUI:(NSDictionary*)rspDic
{
    if (rspDic == nil) {
        return;
    }
    NSString* rspCode = [rspDic objectForKey:@"errorCode"];
    id<MessageDelegate> msg = [rspDic objectForKey:@"MESSAGE_OBJECT"];
    
    if ([rspCode isEqualToString:@"0001"]) {
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"Session 过期，请重新登陆！"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        alertView.tag = kSessionTimeOutTag;
        [alertView show];
        [alertView release];
        return;
    }
    
    if([rspCode isEqualToString:@"0000"]){
        if (nil != self.target && [self.target respondsToSelector:@selector(requestDidFinished:)]) {
            [self.target performSelector:@selector(requestDidFinished:) withObject:rspDic];
        }
    } else {
        if([msg isHouTai]){/*后台设置*/
            NSString* msg = [rspDic objectForKey:@"MSG"];
            if([rspDic objectForKey:@"MSG"] == [NSNull null]){
                msg = @"信息检验异常，请重新登录";
            }
            if(nil == msg){
                msg = @"信息检验异常，请重新登录";
            }
            UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"提示:" message:@"信息检验异常，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            aler.tag=50505;
            [aler show];
            [aler release];
        }else{
            if (nil != self.target && [self.target respondsToSelector:@selector(requestFailed:)]) {
                [self.target performSelector:@selector(requestFailed:) withObject:rspDic];
            }
        }
    }
}

- (void)readySharedSendMessage:(NSString*)messageClaseName
                         param:(NSDictionary*)parameters
                       funName:(NSString*)funName
                 synchronously:(BOOL)synchronously
{
    Class class =  NSClassFromString(messageClaseName);
    message* messageObject = (message*)[[class alloc] init];
    messageObject.requestInfo = parameters;
    SEL selector = NSSelectorFromString(funName);
    [self setSendMessageSelector:selector];
    self.sendDataDic = parameters;
    
    NSLog(@"\n\n  %@     ",self.sendDataDic);
    
    [self sharedSendMessage:messageObject synchronously:synchronously];
    [messageObject release];
}

- (void)readyUploadPhotoMessage:(NSString*)messageClaseName
                         param:(NSDictionary*)parameters
                       funName:(NSString*)funName
                 synchronously:(BOOL)synchronously
                            url:(NSString*)url
                        postKey:(NSString*)key
{
    self.httpCnctor.serviceUrl = url;//image_service_url;
    self.httpCnctor.allowCompressed = NO;
    Class class =  NSClassFromString(messageClaseName);
    message* messageObject = (message*)[[class alloc] init];
    messageObject.requestInfo = parameters;
    SEL selector = NSSelectorFromString(funName);
    [self setSendMessageSelector:selector];
    self.sendDataDic = parameters;
//    [self sharedSendMessage:messageObject synchronously:synchronously];
    [self.httpCnctor uploadPhotoMessage:messageObject synchronously:NO SessionId:@"" PostKey:key];
    [messageObject release];
}

#pragma mark -
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (kForceUpdateTag == alertView.tag) {
        // 强制升级
        if (alertView.cancelButtonIndex == buttonIndex)
        {
            MyLog(@"updateUrl:%@",self.updateUrl);
            NSURL* url = [NSURL URLWithString:self.updateUrl];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            exit(0);
        }
    }
    
    if (kLinkErrorTag == alertView.tag || kTimeOutErrorTag == alertView.tag) {
        //超时或者连接错误，重试
        if (buttonIndex == alertView.firstOtherButtonIndex || buttonIndex == 1) {
            
            NSLog(@"\n\n\n\n\n\n\n\n点击了重试\n\n\n\n\n\n");
            
            if ([self respondsToSelector:sendMessageSelector]) {
                [self performSelector:sendMessageSelector withObject:sendDataDic];
            }
        }
        
        if (buttonIndex == alertView.cancelButtonIndex) {
            if (nil != self.target && [self.target respondsToSelector:@selector(cancelTimeOutAndLinkError)]) {
                [self.target cancelTimeOutAndLinkError];
            }
        }
    }
    
    if (kSessionTimeOutTag == alertView.tag) {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passWord"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logSelf"];
//        //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"remember"];
//        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"HuanCun"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HuanCunXinxi"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        bussineDataService *bus=[bussineDataService sharedDataService];
//        bus.IsTuisong=NO;
//        bus.rspAddrInfo=nil;
//        bus.rspAdInfo=nil;
//        bus.rspStatInfo=nil;
//        bus.rspUserInfo=nil;
//        bus.rspInfo=nil;
//        bus.IsHuanCun=NO;
//        [(AppDelegate *)[UIApplication sharedApplication].delegate relogin];
    }
}


#pragma mark
#pragma mark - 检查更新
- (void)updateVersion:(NSDictionary *)parameters
{
    [self readySharedSendMessage:@"VersionUpdataMessage"
                           param:parameters
                         funName:@"updateVersion:"
                   synchronously:NO];
}

- (void)updateVersionFinished:(id <MessageDelegate>)msg
{
    VersionUpdataMessage *Msg = msg;
    
    NSString* rspCode = [Msg getRspcode];
    NSString* bussineCode = [Msg getBusinessCode];
    NSString* rspDesc = [Msg getMSG];
    
    if ([rspCode isEqualToString:@"0001"]) {
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"Session 过期，请重新登陆！"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        alertView.tag = kSessionTimeOutTag;
        [alertView show];
        [alertView release];
        return;
    }
    //key: bussineCode value :; Key:errorCode, value: key:MSG, value:
    NSMutableDictionary* rspDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [rspDic setObject:rspCode forKey:@"errorCode"];
    [rspDic setObject:bussineCode forKey:@"bussineCode"];
    if (rspDesc != nil) {
        [rspDic setObject:rspDesc forKey:@"MSG"];
    }
    self.rspInfo = Msg.rspInfo;
    
    if([rspCode isEqualToString:@"0000"]){
		// 版本正常
		NSString* currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
		NSDictionary* versionDic = Msg.rspInfo;
		NSString* lowestVersion = ([versionDic objectForKey:@"requiredVersion"]==[NSNull null]?nil:[versionDic objectForKey:@"requiredVersion"]);//服务器返回的最低版本号
		NSString* lastVersion = ([versionDic objectForKey:@"version"]==[NSNull null]?nil:[versionDic objectForKey:@"version"]);//服务器返回的最高版本号
		if (lowestVersion != nil &&lastVersion != nil &&([currentVersion compare:lowestVersion] == NSOrderedAscending)) //如果当前版本号比最低版本号还小，那么强制升级
		{
			//强制升级
            [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
            NSString* updateUrl_o = [NSString stringWithFormat:@"%@",[versionDic objectForKey:@"download"]];
            NSString* updateStr = [[NSString alloc] initWithFormat:@"%@",updateUrl_o];
            self.updateUrl = updateStr;
            [updateStr release];
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"系统需要强制升级！"
                                                                message:[Msg.rspInfo objectForKey:@"remark"]==[NSNull null]?@"":[Msg.rspInfo objectForKey:@"remark"]
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            alertView.tag = kForceUpdateTag;
            [alertView show];
            [alertView release];
		}
        else if(lowestVersion != nil && lastVersion != nil &&
                 (([currentVersion compare:lowestVersion] == NSOrderedSame) || ([currentVersion compare:lowestVersion] == NSOrderedDescending))&&
                 ([currentVersion compare:lastVersion] == NSOrderedAscending)) //如果当前版本号比最低版本大，同时比最新版本小，那么选择升级
		{
            //
            NSString* updateUrl_o = [NSString stringWithFormat:@"%@",[versionDic objectForKey:@"download"]];
            NSString* updateStr = [[NSString alloc] initWithFormat:@"%@",updateUrl_o];
            self.updateUrl = updateStr;
            [updateStr release];
            [rspDic setObject:@"7777" forKey:@"errorCode"];
            
            if (nil != self.target && [self.target respondsToSelector:@selector(requestDidFinished:)])
            {
                [self.target performSelector:@selector(requestDidFinished:) withObject:rspDic];
            }
		}
        else
        {
            if([msg isHouTai])
            {/*后台设置*/
                NSString *nameStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
                NSString *passStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"];
                if([nameStr isEqualToString:@""]||nameStr==nil)
                {
                    UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"提示" message:@"信息检验异常，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    aler.tag=50505;
                    [aler show];
                    [aler release];
                }
                else if([passStr isEqualToString:@""]||passStr==nil)
                {
                    UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"提示" message:@"信息检验异常，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    aler.tag=40404;
                    [aler show];
                    [aler release];
                }
                else
                {
                    bussineDataService *bussineService = [bussineDataService sharedDataService];
                    MyLog(@"userName_str==%@",nameStr);
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[nameStr stringByReplacingOccurrencesOfString:@"QA_" withString:@""],@"usercode",
                                          passStr,@"pwd",
                                          [NSNumber numberWithBool:YES],@"isHouTai",nil];
                    [bussineService login:data];
                    [data release];
                }
            }
            else
            {
                [rspDic setObject:@"4444" forKey:@"errorCode"];
                if (nil != self.target && [self.target respondsToSelector:@selector(requestDidFinished:)])
                {
                    [self.target performSelector:@selector(requestDidFinished:) withObject:rspDic];
                }
            }
		}
        //        [currentVersion release];
	}else if ([rspCode isEqualToString:@"0006"]) {
        if (nil != self.target && [self.target respondsToSelector:@selector(requestDidFinished:)]) {
            [self.target performSelector:@selector(requestDidFinished:) withObject:rspDic];
        }
	} else {
        if([msg isHouTai]){/*后台设置*/
            NSString* msg = [rspDic objectForKey:@"MSG"];
            if([rspDic objectForKey:@"MSG"] == [NSNull null]){
                msg = @"信息检验异常，请重新登录";
            }
            if(nil == msg){
                msg = @"信息检验异常，请重新登录";
            }
            UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"提示:" message:@"信息检验异常，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            aler.tag=50505;
            [aler show];
            [aler release];
        }else{
            if (nil != self.target && [self.target respondsToSelector:@selector(requestFailed:)]) {
                [self.target performSelector:@selector(requestFailed:) withObject:rspDic];
            }
        }
	}
    [rspDic release];
    
}

#pragma mark
#pragma mark - 登录
- (void)login:(NSDictionary *)paramters
{
    //    if ([[UIDevice currentDevice] networkAvailable]) {
    [self readySharedSendMessage:@"LoginMessage"
                           param:paramters
                         funName:@"login:"
                   synchronously:NO];
    //    }
}

- (void)loginFinished:(id<MessageDelegate>)msg
{
    LoginMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
        self.loginInfo=Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}



#pragma mark
#pragma mark - 钱咖分享
- (void)qiankaShare:(NSDictionary *)paramters
{
    [self readySharedSendMessage:@"ShareMessage"
                           param:paramters
                         funName:@"qiankaShare:"
                   synchronously:NO];
}
- (void)qiankaShareFinished:(id<MessageDelegate>)msg
{
    ShareMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}


#pragma mark
#pragma mark - 钱咖登陆
- (void)qiankaLogin:(NSDictionary *)paramters
{
    [self readySharedSendMessage:@"QianKaLoginMessage"
                           param:paramters
                         funName:@"qiankaLogin:"
                   synchronously:NO];
}

- (void)qiankaLoginFinished:(id<MessageDelegate>)msg
{
    QianKaLoginMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 主页
- (void)zhuye:(NSDictionary *)paramters
{
    //    if ([[UIDevice currentDevice] networkAvailable]) {
    [self readySharedSendMessage:@"ZhuYeMessage"
                           param:paramters
                         funName:@"zhuye:"
                   synchronously:NO];
    //    }
}

- (void)zhuyeFinished:(id<MessageDelegate>)msg
{
    ZhuYeMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 报错提交
- (void)BaoCuoback:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"BaoCuoMessage"
                               param:paramters
                             funName:@"BaoCuoback:"
                       synchronously:NO];
    }
}

- (void)BaoCuoFinished:(id<MessageDelegate>)msg
{
    BaoCuoMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 首页获取动态数据
- (void)mainPage:(NSDictionary *)parameters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"MainPageMessage"
                               param:parameters
                             funName:@"mainPage:"
                       synchronously:NO];
    }
}

-(void)mainPageFinished:(id<MessageDelegate>)msg
{
    MainPageMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 下单
- (void)createOrder:(NSDictionary *)parameters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"CreateOrderMessage"
                               param:parameters
                             funName:@"createOrder:"
                       synchronously:NO];
    }
}

-(void)createOrderFinished:(id<MessageDelegate>)msg
{
    CreateOrderMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}


#pragma mark
#pragma mark - 套餐
- (void)package:(NSDictionary *)paramters
{
    //    if ([[UIDevice currentDevice] networkAvailable]) {
    [self readySharedSendMessage:@"ChoosePackageMessage"
                           param:paramters
                         funName:@"package:"
                   synchronously:NO];
    //    }
}

- (void)packageFinished:(id<MessageDelegate>)msg
{
    ChoosePackageMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 手机意外保
- (void)creatInsurance:(NSDictionary *)paramters
{
    [self readySharedSendMessage:@"InsuranceMessage"
                           param:paramters
                         funName:@"creatInsurance:"
                   synchronously:NO];
}

- (void)creatInsuranceFinished:(id<MessageDelegate>)msg
{
    InsuranceMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 号码
- (void)number:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
    [self readySharedSendMessage:@"ChooseNumMessage"
                           param:paramters
                         funName:@"number:"
                   synchronously:NO];
     }
    
}

- (void)numberFinished:(id<MessageDelegate>)msg
{
    ChooseNumMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 验证码
- (void)checkNum:(NSDictionary *)paramters
{
    [self readySharedSendMessage:@"CheckNumMessage"
                           param:paramters
                         funName:@"checkNum:"
                   synchronously:NO];
}


- (void)checkNumFinished:(id<MessageDelegate>)msg
{
    CheckNumMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 获取财富
- (void)getWealth:(NSDictionary *)paramters
{
    [self readySharedSendMessage:@"WealthMessage"
                           param:paramters
                         funName:@"getWealth:"
                   synchronously:NO];
}

- (void)getWealthFinished:(id<MessageDelegate>)msg
{
    WealthMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}
#pragma mark
#pragma mark - 用户信息
- (void)getInfo:(NSDictionary *)paramters
{
    [self readySharedSendMessage:@"InfoMessage"
                           param:paramters
                         funName:@"getInfo:"
                   synchronously:NO];
}

- (void)getInfoFinished:(id<MessageDelegate>)msg
{
    InfoMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 注册
- (void)regist:(NSDictionary *)paramters
{
    [self readySharedSendMessage:@"registerMessage"
                           param:paramters
                         funName:@"regist:"
                   synchronously:NO];
}

- (void)registFinished:(id<MessageDelegate>)msg
{
    registerMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 订单
- (void)order:(NSDictionary *)paramters
{
    [self readySharedSendMessage:@"SearchOrderMessage"
                           param:paramters
                         funName:@"order:"
                   synchronously:NO];
}

- (void)orderFinished:(id<MessageDelegate>)msg
{
    SearchOrderMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 上传照片
- (void)uploadPhoto:(NSDictionary *)paramters
{
    [self readyUploadPhotoMessage:@"UploadPhotoMessage"
                           param:paramters
                         funName:@"uploadPhoto:"
                   synchronously:NO
                             url:image_service_url
                         postKey:@"imgBase64"];
}

- (void)uploadPhotoFinished:(id<MessageDelegate>)msg
{
    UploadPhotoMessage *Msg = msg;
//    NSDictionary *rspDic = [self handleRspInfo:Msg];
//    self.rspInfo = Msg.rspInfo;
    NSDictionary *receiveData = [[[NSDictionary alloc] initWithObjectsAndKeys:Msg.saveId,@"saveId",[Msg getBusinessCode],@"bussineCode" ,nil] autorelease];
    self.rspInfo = [receiveData retain];
//    [receiveData release];
    if (nil != self.target && [self.target respondsToSelector:@selector(requestDidFinished:)]) {
        [self.target performSelector:@selector(requestDidFinished:) withObject:self.rspInfo];
    }
}

-(void)paymentUrl:(NSDictionary*)paramters url:(NSString*)url key:(NSString*)key
{
    [self readyUploadPhotoMessage:@"PaymentUrlMessage"
                            param:paramters
                          funName:@"paymentUrl:"
                    synchronously:NO
                              url:url
                          postKey:key];
}

- (void)paymentUrlFinished:(id<MessageDelegate>)msg
{
    PaymentUrlMessage *Msg = msg;
    //    NSDictionary *rspDic = [self handleRspInfo:Msg];
    //    self.rspInfo = Msg.rspInfo;
    NSDictionary *receiveData = [[NSDictionary alloc] initWithObjectsAndKeys:Msg.paymentUrl,@"paymentUrl",[Msg getBusinessCode],@"bussineCode", nil];
    self.rspInfo = receiveData;
    [receiveData release];
    if (nil != self.target && [self.target respondsToSelector:@selector(requestDidFinished:)]){
        [self.target performSelector:@selector(requestDidFinished:) withObject:self.rspInfo];
    }
}

#pragma mark
#pragma mark - 获取商品
- (void)getProducts:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"ProductsMessage"
                               param:paramters
                             funName:@"getProducts:"
                       synchronously:NO];
    }
}
- (void)getProductsFinished:(id<MessageDelegate>)msg
{
    ProductsMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}
#pragma mark
#pragma mark - 获取商品详情
- (void)getProductDetail:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"ProductDetail"
                               param:paramters
                             funName:@"getProductDetail:"
                       synchronously:NO];
    }
}
- (void)getProductDetailFinished:(id<MessageDelegate>)msg
{
    ProductDetail *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}
#pragma mark
#pragma mark - 获取商品评价
- (void)ProductEvaluate:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"ProductEvaluateMessage"
                               param:paramters
                             funName:@"ProductEvaluate:"
                       synchronously:NO];
    }
}

- (void)ProductEvaluateFinished:(id<MessageDelegate>)msg
{
    ProductEvaluateMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 获取商品评价
- (void)getEvaluate:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"GetEvaluateMessage"
                               param:paramters
                             funName:@"getEvaluate:"
                       synchronously:NO];
    }
    
}
- (void)getEvaluateFinished:(id<MessageDelegate>)msg
{
    GetEvaluateMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 选择地区
- (void)chooseArea:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"ChooseAreaMessage"
                               param:paramters
                             funName:@"chooseArea:"
                       synchronously:NO];
    }
}

- (void)chooseAreaFinished:(id<MessageDelegate>)msg
{
    ChooseAreaMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 过滤地址
-(void)filterAddress:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"filterAddressMessage"
                               param:paramters
                             funName:@"filterAddress:"
                       synchronously:NO];
    }
}

-(void)filterAddressFinished:(id<MessageDelegate>)msg
{
    filterAddressMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 过滤地址套餐
-(void)filterAddressPackage:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"FilterAddressPackageMessage"
                               param:paramters
                             funName:@"filterAddressPackage:"
                       synchronously:NO];
    }
}
-(void)filterAddressPackageFinished:(id<MessageDelegate>)msg
{
    FilterAddressPackageMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}
#pragma mark
#pragma mark - 找回密码
-(void)getBackPwd:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"GetBackPwdMessage"
                               param:paramters
                             funName:@"getBackPwd:"
                       synchronously:NO];
    }
}
-(void)getBackPwdFinished:(id<MessageDelegate>)msg
{
    GetBackPwdMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}
#pragma mark
#pragma mark - 获取搜索页面信息
-(void)getSearchInfo:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"GetSearchInfoMessage"
                               param:paramters
                             funName:@"getSearchInfo:"
                       synchronously:NO];
    }
}
-(void)getSearchInfoFinished:(id<MessageDelegate>)msg
{
    GetSearchInfoMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 获取消息中心数据
-(void)getMsgCenterData:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"GetMsgCenterData"
                               param:paramters
                             funName:@"getMsgCenterData:"
                       synchronously:NO];
    }
}
-(void)getMsgCenterDataFinished:(id<MessageDelegate>)msg
{
    GetMsgCenterData *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark - 加入机构
- (void)addJigou:(NSDictionary *)paramters{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"GetAddJiGouMessage"
                               param:paramters
                             funName:@"getAddJiGou:"
                       synchronously:NO];
//        [self readySharedSendMessage:@"QianKaLoginMessage"
//                               param:paramters
//                             funName:@"qiankaLogin:"
//                       synchronously:NO];

    }

}

-(void)getAddJiGouFinished:(id<MessageDelegate>)msg
{
    GetAddJiGouMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark - 机构查询
- (void)selectJigou:(NSDictionary *)paramters{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"GetSelectJiGouMessage"
                               param:paramters
                             funName:@"getSelectJiGou:"
                       synchronously:NO];
    }

}

-(void)getSelectJiGouFinished:(id<MessageDelegate>)msg
{
    GetSelectJiGouMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark - 退出登录
- (void)usrtLogout:(NSDictionary *)paramters {
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"UserLogoutMessage"
                               param:paramters
                             funName:@"userLogout:"
                       synchronously:NO];
    }

}

-(void)userLogoutFinished:(id<MessageDelegate>)msg
{
    UserLogoutMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark - 判断是否有权限进入实名返档
- (void)isRootPush:(NSDictionary *)paramters {
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"RealNameYesOrNoMessage"
                               param:paramters
                             funName:@"realNameYesOrNo:"
                       synchronously:NO];
    }

}

-(void)realNameYesOrNoFinished:(id<MessageDelegate>)msg
{
    RealNameYesOrNoMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark - 实名返档
- (void)sureGuiDang:(NSDictionary *)paramters {
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"RealFangDangMessage"
                               param:paramters
                             funName:@"realFangDang:"
                       synchronously:NO];
    }
}

-(void)realFangDangFinished:(id<MessageDelegate>)msg
{
    RealFangDangMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark 沃校园办理确认下单
-(void)schoolOrderComfirm:(NSDictionary *)paramters{
    
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"XXXXXXXX"
                               param:paramters
                             funName:@"xxxxxxx:"
                       synchronously:NO];
    }
    
}

#pragma mark 号码验证
-(void)identifyManeger:(NSDictionary *)paramters{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"IndentifyMessage"
                               param:paramters
                             funName:@"identifyManeger:"
                       synchronously:NO];
    }
}

#pragma mark 号码判断是否为联通号码Finished
-(void)identifyManegerFinished:(id<MessageDelegate>)msg{
    IndentifyMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark 获取手机验证码
-(void)getIndentifyCode:(NSDictionary *)paramters{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"GetIndentifyCodeMessage"
                               param:paramters
                             funName:@"getIndentifyCode:"
                       synchronously:NO];
    }
}

#pragma mark 获取验证码Finished
-(void)getIndentifyCodeFinished:(id<MessageDelegate>)msg{
    GetIndentifyCodeMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark 校验手机验证码
-(void)comfirmIndentifyCode:(NSDictionary *)paramters{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"ComfirmIndentifyMessage"
                               param:paramters
                             funName:@"comfirmIndentify:"
                       synchronously:NO];
    }
}
#pragma mark 校验手机验证码Finished
-(void)comfirmIndentifyFinished:(id<MessageDelegate>)msg{
    ComfirmIndentifyMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}


#pragma mark 校验身份证与手机号是否一致
-(void)sureSFZandIphoneNum:(NSDictionary *)paramters {
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"OpenNetworkUserMessage"
                               param:paramters
                             funName:@"OpenNetworkUser:"
                       synchronously:NO];
    }

}
#pragma mark 校验身份证与手机号是否一致Finished
-(void)OpenNetworkUserFinished:(id<MessageDelegate>)msg{
    OpenNetworkUserMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark cf0046获取融合宽带信息
-(void)getRHKDInfo:(NSDictionary *)paramters {
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"GetRHKDcodeMessage"
                               param:paramters
                             funName:@"getRHKDcode:"
                       synchronously:NO];
    }

}

#pragma mark cf0046获取融合宽带信息Finished
-(void)getRHKDcodeFinished:(id<MessageDelegate>)msg{
    GetRHKDcodeMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 派单开户订单搜索
- (void)searchAccountOrder:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"SearchOpenAccountOrderMessage"
                               param:paramters
                             funName:@"searchAccountOrder:"
                       synchronously:NO];
    }
}

-(void)searchAccountOrderFinished:(id<MessageDelegate>)msg
{
    SearchOpenAccountOrderMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}


#pragma mark
#pragma mark - 开户
- (void)commitOpenUser:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"CommitOpenUserMessage"
                               param:paramters
                             funName:@"commitOpenUser:"
                       synchronously:NO];
    }
}

-(void)commitOpenUserFinished:(id<MessageDelegate>)msg
{
    CommitOpenUserMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}


#pragma mark
#pragma mark - 开户成功提交信息
- (void)suessCommitOpenUser:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"SueccOpenUserMessage"
                               param:paramters
                             funName:@"suessCommitOpenUser:"
                       synchronously:NO];
    }
}

-(void)suessCommitOpenUserFinished:(id<MessageDelegate>)msg
{
    SueccOpenUserMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 查看开户流程处理过程
- (void)checkFlow:(NSDictionary *)paramters
{
    if ([[UIDevice currentDevice] networkAvailable]) {
        [self readySharedSendMessage:@"CheckFLowMessage"
                               param:paramters
                             funName:@"checkFlow:"
                       synchronously:NO];
    }
}

-(void)checkFlowFinished:(id<MessageDelegate>)msg
{
    CheckFLowMessage *Msg = msg;
    NSDictionary *rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
        self.rspInfo = Msg.rspInfo;
    }
    [self noticeUI:rspDic];
}


#pragma mark -
#pragma mark http 回调接口
- (void)requestDidFinished:(id<MessageDelegate>)msg
{
    if([msg isHouTai]){
        MyLog(@"后台");
    }else{
//        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        if (![[msg getBusinessCode] isEqualToString:COMMIT_OPEN_USER_BIZCODE] &&
            ![[msg getBusinessCode] isEqualToString:SUECC_OPEN_USER_BIZCODE]) {
            [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        }
        MyLog(@"不是后台");
    }
    
    if([[msg getBusinessCode] isEqualToString:LOGIN_BIZCODE]) {
        [self loginFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:VERSION_BIZCODE]) {
        [self updateVersionFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:BAOCUO_BIZCODE]) {
        [self BaoCuoFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:ZHUYE_BIZCODE]) {
        [self zhuyeFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:MAIN_PAGE_BIZCODE]) {
        [self mainPageFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:CREATE_ORDER_BIZCODE]){
        [self createOrderFinished:msg];
    }
    else if ([[msg getBusinessCode] isEqualToString:CHOOSEPACKAGE_BIZCODE]) {
        [self packageFinished:msg];
    }
    else if ([[msg getBusinessCode] isEqualToString:CHOOSENUMBER_BIZCODE]) {
        [self numberFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:ORDERMESSAGE_BIZCODE]) {
        [self orderFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:UPLOAD_PHOTO_BIZCODE]) {
        [self uploadPhotoFinished:msg];
    }
    else if ([[msg getBusinessCode] isEqualToString:PRODUCTS_BIZCODE]) {
        [self getProductsFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:PRODUCTDETAIL_BIZCODE]) {
        [self getProductDetailFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:PRODUCTEVALUATE_BIZCODE]) {
        [self ProductEvaluateFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:GETEVALUATE_BIZCODE]) {
        [self getEvaluateFinished:msg];
    } else  if ([[msg getBusinessCode] isEqualToString:CHOOSE_AREA_BIZCODE]) {
        [self chooseAreaFinished:msg];
    }else  if ([[msg getBusinessCode] isEqualToString:PAYMENT_URL_BIZCODE]) {
        [self paymentUrlFinished:msg];
    }else  if ([[msg getBusinessCode] isEqualToString:INSURANCE_BIZCODE]) {
        [self creatInsuranceFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:FILTERADDRESS_BIZCODE]){
        [self filterAddressFinished:msg];
    }else  if ([[msg getBusinessCode] isEqualToString:CHECKNUM_BIZCODE]){
        [self checkNumFinished:msg];
    }else  if ([[msg getBusinessCode] isEqualToString:REGIST_BIZCODE]) {
        [self registFinished:msg];
    }else  if ([[msg getBusinessCode] isEqualToString:INFO_BIZCODE]) {
        [self getInfoFinished:msg];
    }else  if ([[msg getBusinessCode] isEqualToString:WEALTH_BIZCODE]) {
        [self getWealthFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:FILTERADDRESSPACKAGE_BIZCODE]){
        [self filterAddressPackageFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:GETBACKPWD_BIZCODE]){
        [self getBackPwdFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:GETSEARCHINFO_BIZCODE]){
        [self getSearchInfoFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:GETMSGCENTERDATA_BIZCODE]){
        [self getMsgCenterDataFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:QIANKALOGIN_BIZCODE]) {
        [self qiankaLoginFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:GetSelectJiGouMessage_BIZCODE]) {
        [self getSelectJiGouFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:GetAddJiGouMessage_BIZCODE]) {
        [self getAddJiGouFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:UserLogoutMessage_BIZCODE]) {
        [self userLogoutFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:RealNameYesOrNoMessage_BIZCODE]) {
        [self realNameYesOrNoFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:RealFangDangMessage_BIZCODE]) {
        [self realFangDangFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:GetIndentifyCodeMessage_BIZCODE]) {
        [self getIndentifyCodeFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:OpenNetworkUserMessage_BIZCODE]) {
        [self OpenNetworkUserFinished:msg];
    }
    else if([[msg getBusinessCode] isEqualToString:GetRHKDcodeMessage_BIZCODE]) {
        [self getRHKDcodeFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:SEARCH_OPENACCOUNT_ORDER_BIZCODE]){
        [self searchAccountOrderFinished:msg];
    }else if ([[msg getBusinessCode] isEqualToString:COMMIT_OPEN_USER_BIZCODE]){
        [self commitOpenUserFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:SUECC_OPEN_USER_BIZCODE]){
        [self suessCommitOpenUserFinished:msg];
    }else if([[msg getBusinessCode] isEqualToString:CHECK_FLOW_BIZCODE]){
        [self checkFlowFinished:msg];
    }
    



}

- (void)requestFailed:(NSDictionary*)errorInfo
{
	id<MessageDelegate> msg = [errorInfo objectForKey:@"MESSAGE_OBJECT"];
    if([msg isHouTai]){
        MyLog(@"后台");
    }else{
        MyLog(@"不是后台");
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        
        NSString* errorCode = [errorInfo objectForKey:@"STATUS_CODE"];
        MyLog(@"%@",errorCode);
        NSString* bussineCode = [msg getBusinessCode];
        NSString* rspDesc = [message getRespondDescription:errorCode];
        
        NSMutableDictionary* rspDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [rspDic setObject:errorCode forKey:@"errorCode"];
        [rspDic setObject:bussineCode forKey:@"bussineCode"];
        if (rspDesc != nil) {
            [rspDic setObject:rspDesc forKey:@"MSG"];
        }
        
        if ([[message getNetLinkErrorCode] isEqualToString:errorCode]) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:rspDesc
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"重试",nil];
            alertView.tag = kLinkErrorTag;
            [alertView show];
            [alertView release];
            
            [rspDic release];
            return;
        }
        
        if ([[message getTimeOutErrorCode] isEqualToString:errorCode]) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:rspDesc
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"重试",nil];
            alertView.tag = kTimeOutErrorTag;
            [alertView show];
            [alertView release];
            
            [rspDic release];
            return;
        }
        
        if (nil != self.target && [self.target respondsToSelector:@selector(requestFailed:)]) {
            [self.target performSelector:@selector(requestFailed:) withObject:rspDic];
        }
        
        [rspDic release];
	}
}

@end

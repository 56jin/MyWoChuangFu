//
//  AppDelegate.m
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-10.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "AppDelegate.h"
#import "TopVC.h"
#import "MainVC.h"
#import "CommitVC.h"
#import "MainSearchVC.h"
#import "MyWocfVC.h"
#import "SystemSetVC.h"
#import "SettingVC.h"
#import "FileHelpers.h"
#import "Push/APService.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "YXApi.h"
#import "TencentOpenAPI/QQApi.h"
#import "WeiboSDK.h"
#import "RennSDK/RennSDK.h"
#import "WeiboApi.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "NewMainSearchVC.h"
#import "ChildTabBarController.h"
#import "GuidePageVC.h"
#import "MessageCenterVC.h"
#import "ProDuctShareManager.h"
#import "QiankaLogin.h"
#import "QkFirstPageVC.h"
#import "ContractVC.h"
#import "FansVC.h"
#import "ProductShareVC.h"
#import "KeychainItemWrapper.h"

@implementation AppDelegate

@synthesize isLogin = isLogin;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [APService setTags:[NSSet setWithObjects:nil] alias:@"jw1415" callbackSelector:nil target:nil];
    //开启异步定位
    dispatch_async(dispatch_get_current_queue(), ^{
        [self startLocation];
    });
    
    application.statusBarHidden=NO;
    application.statusBarStyle=UIStatusBarStyleBlackOpaque;
    //首次打开APP 创建缓存文件夹
    //    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];隐藏状态栏
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"firstLaunch"]==nil) {
        [[NSFileManager defaultManager] createDirectoryAtPath:pathInCacheDirectory(@"com.xmly") withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"]!=nil) {
        [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"] ==[NSNull null];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    isLogin = NO;  //每次启动默认不登录
    
//   [self initTabBar];
    
    NSString *isFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"];
    if (isFirst == nil) {
        GuidePageVC *guidePageVC = [[GuidePageVC alloc] init];
        self.window.rootViewController = guidePageVC;
        [guidePageVC release];
    }else{
        [self initTabBar];
    }

    [self.window makeKeyAndVisible];
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];
    
    [ShareSDK registerApp:@"270dd29b5016"];
    [self addShared];
    [ShareSDK setInterfaceOrientationMask:SSInterfaceOrientationMaskPortrait];
    
    return YES;
}


-(void)showSimpleAlertView:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)startLocation
{
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
//#ifdef __IPHONE_8_1
        if(IOS8) {
            [locationManager requestAlwaysAuthorization];//添加这句®
        }
        
//#endif
    }
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // 停掉定位
    [locationManager stopUpdatingLocation];
    // 反向地理解析
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *mark = [placemark objectAtIndex:0];
         [[NSUserDefaults standardUserDefaults] setObject:mark.locality forKey:@"currentCity"];
         [[NSUserDefaults standardUserDefaults] synchronize];
//         MyLog(@"%@",mark.locality);           // 南宁市
//         MyLog(@"%@",mark.administrativeArea); // 广西壮族自治区
     }];
    [geocoder release];
    [locationManager release];
}

-(void)initTabBar
{
    tabBarVC = [[ChildTabBarController alloc] init];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version>=5.0&&version<7.0){
        tabBarVC.tabBar.tintColor=[ComponentsFactory createColorByHex:@"#353333"];//tabber背景的颜色
    }else if(version>=7.0){
        [tabBarVC.tabBar setTintColor:[UIColor orangeColor]];//tabber下面选择图标的颜色
    }
    tabBarVC.delegate=self;
    
    self.window.rootViewController = tabBarVC;
    //search
    NewMainSearchVC* searchVC = [[NewMainSearchVC alloc] init];
    searchVC.tabBarItem.title = @"搜索";
    searchVC.tabBarItem.image = [UIImage imageNamed:@"icon_navbar_search.png"];
//    searchVC.tabBarController.tabBar.backgroundColor = [UIColor redColor];
//    [searchVC.tabBarController.tabBar setTranslucent:YES];
//    searchVC.tabBarController.tabBar.alpha = 0.1;
//    searchVC.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"搜索"
//                                                        image:[UIImage imageNamed:@"icon_navbar_search.png"]
//                                                          tag:0] autorelease];
    ChildNavigationController* searchNC = [[ChildNavigationController alloc] initWithRootViewController:searchVC];
    [searchVC release];
    //main
    MainVC* mainVC = [[MainVC alloc] init];
    mainVC.tabBarItem.title = @"商城";
    mainVC.tabBarItem.image = [UIImage imageNamed:@"icon_navbar_home.png"];
//    mainVC.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"商城"
//                                                      image:[UIImage imageNamed:@"icon_navbar_home.png"]
//                                                         tag:0]autorelease];
    ChildNavigationController* mainNC = [[ChildNavigationController alloc]initWithRootViewController:mainVC];
    [mainVC release];
    //my wocf
    MyWocfVC* myWocfVC = [[MyWocfVC alloc] init];
    myWocfVC.tabBarItem.title = @"登陆";
    myWocfVC.tabBarItem.image = [UIImage imageNamed:@"icon_navbar_Diamond.png"];
//    myWocfVC.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"登陆"
//                                                      image:[UIImage imageNamed:@"icon_navbar_Diamond.png"]
//                                                          tag:0]autorelease];
    ChildNavigationController* myWocfNC = [[ChildNavigationController alloc]initWithRootViewController:myWocfVC];
    [myWocfVC release];
    //system set
    SettingVC* setVC = [[SettingVC alloc] init];
    setVC.tabBarItem.title = @"设置";
    setVC.tabBarItem.image = [UIImage imageNamed:@"icon_navbar_set.png"];
//    setVC.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"设置"
//                                                        image:[UIImage imageNamed:@"icon_navbar_set.png"]
//                                                       tag:0]autorelease];
    ChildNavigationController* systemSetNC = [[ChildNavigationController alloc]initWithRootViewController:setVC];
    [setVC release];
    
    NSArray* ncArr = [[NSArray alloc] initWithObjects:mainNC,searchNC,myWocfNC,systemSetNC,nil];
    [searchNC release];
    [mainNC release];
    [myWocfNC release];
    [systemSetNC release];
    for(int i=0;i<ncArr.count;i++){
        ((ChildNavigationController*)[ncArr objectAtIndex:i]).navigationBar.tintColor = [ComponentsFactory createColorByHex:@"#F6F6F6"];
    }
    tabBarVC.viewControllers = ncArr;
#ifdef __IPHONE_7_0
    tabBarVC.tabBar.barTintColor = [ComponentsFactory createColorByHex:@"#2b2c2d"];
#else
    tabBarVC.tabBar.barStyle = UIBarStyleBlack;
#endif
    [ncArr release];
    tabBarVC.selectedIndex = 0;
    [tabBarVC release];
}

-(void)addShared{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1104332770"
                           appSecret:@"xFUKk062HXaWLoEm"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx2a39114bd0c8df53" wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    [ShareSDK connectQQWithAppId:@"QQ41D2C7E2" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"QQ41D2C7E2"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     **/
//    [ShareSDK connectRenRenWithAppId:@"226427"
//                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
//                   renrenClientClass:[RennClient class]];
    
    /**
     连接开心网应用以使用相关功能，此应用需要引用KaiXinConnection.framework
     http://open.kaixin001.com上注册开心网开放平台应用，并将相关信息填写到以下字段
     **/
//    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
//                            appSecret:@"da32179d859c016169f66d90b6db2a23"
//                          redirectUri:@"http://www.sharesdk.cn/"];
    
    /**
     连接易信应用以使用相关功能，此应用需要引用YiXinConnection.framework
     http://open.yixin.im/上注册易信开放平台应用，并将相关信息填写到以下字段
     **/
//    [ShareSDK connectYiXinWithAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
//                           yixinCls:[YXApi class]];
    
    //连接邮件
//    [ShareSDK connectMail];
}

+(AppDelegate*)shareMyApplication
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

+ (CGFloat)sharePhoneHeight
{
    CGRect frame = [UIScreen mainScreen].bounds;
    return frame.size.height;
}

+ (CGFloat)sharePhoneWidth
{
    CGRect frame = [UIScreen mainScreen].bounds;
    return frame.size.width;
}

+ (CGFloat)sharePhoneBarHeight
{
    return 20;
}

+ (CGFloat)sharePhoneContentHeight
{
    CGRect frame = [UIScreen mainScreen].bounds;
    return frame.size.height - [self sharePhoneBarHeight]-TAB_BAR_HEIGHT;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return NO;
}

#pragma mark
#pragma mark - NotificationPush
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
//    NSString *tokenStr = [[deviceToken description] stringByTrimmingCharactersInSet:
//                          [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    NSString* token = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    bussineDataService *bus=[bussineDataService sharedDataService];
//    bus.DeviceToken=token;
    MyLog(@"%@",deviceToken);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    MyLog(@"Failed to get token, error:%@", error_str);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //在此处理接收到的消息。
    [APService handleRemoteNotification:userInfo];
    MyLog(@"didReceiveRemoteNotification:%@",userInfo);
    tabBarVC.selectedIndex = [tabBarVC.viewControllers count]-1;
    MessageCenterVC *messageVC = [[MessageCenterVC alloc] init];
    ChildNavigationController *navVC = (ChildNavigationController *)[tabBarVC.viewControllers lastObject];
    navVC.navigationBarHidden = YES;
    [navVC pushViewController:messageVC animated:YES];
    [message release];
//    if([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"messagetype"]] isEqualToString:@"01"]){//url
//        application.applicationIconBadgeNumber=0;
//        bussineDataService *bus=[bussineDataService sharedDataService];
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"您收到一条版本升级消息"
//                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
//                                                       delegate:self
//                                              cancelButtonTitle:@"查看"
//                                              otherButtonTitles:@"取消",nil];
//        alter.tag=20205;
//        [alter show];
//        [alter release];
//        bus.TuiSongDic=userInfo;
//    }else{
////        [topV.FirNav popToRootViewControllerAnimated:YES];
//    }
}

#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
    
    tabBarVC.selectedIndex = [tabBarVC.viewControllers count]-1;
    MessageCenterVC *messageVC = [[MessageCenterVC alloc] init];
    ChildNavigationController *navVC = (ChildNavigationController *)[tabBarVC.viewControllers lastObject];
    navVC.navigationBarHidden = YES;
    [navVC pushViewController:messageVC animated:YES];
    [message release];
//    MyLog(@"didReceiveRemoteNotification:%@",userInfo);
//    if([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"messagetype"]] isEqualToString:@"01"]){//url
//        application.applicationIconBadgeNumber=0;
//        bussineDataService *bus=[bussineDataService sharedDataService];
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"您收到一条版本升级消息"
//                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
//                                                       delegate:self
//                                              cancelButtonTitle:@"查看"
//                                              otherButtonTitles:@"取消",nil];
//        alter.tag=20205;
//        [alter show];
//        [alter release];
//        bus.TuiSongDic=userInfo;
//    }else{
//
//    }
}
#endif

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if(alertView.tag==20205){
        if([buttonTitle isEqualToString:@"查看"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            
#ifdef AppStore
            NSString *str2 = [NSString stringWithFormat:
                              @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",[bus.TuiSongDic objectForKey:@"loadurl"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2]];
#else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[bus.TuiSongDic objectForKey:@"loadurl"]]]];
#endif
        }
    }
}

#pragma mark -

- (void)networkDidSetup:(NSNotification *)notification {
    MyLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    MyLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    MyLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    MyLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    MyLog(@"%@",[NSString stringWithFormat:@"收到消息\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content]);
    [dateFormatter release];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    MyLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSString*str =  [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    if ([str rangeOfString:@"wcfHomeIndex"].location!=NSNotFound)
//    {
//        
//        MainVC* mainVC = [[MainVC alloc] init];
//        self.window.rootViewController = mainVC;
//    }
    
    if (([str rangeOfString:@"wb568898243"].location!=NSNotFound)||([str rangeOfString:@"wx77c3392f8f7c9fdf"].location!=NSNotFound)||([str rangeOfString:@"QQ41d2c848"].location!=NSNotFound)) {
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
    //    NSURL *url1=[NSURL URLWithString:[[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
    //    NSString*str =  [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSURL *url1 = [NSURL URLWithString:str];
    NSString *host = url.host;
    NSString *query = url.query;
    NSString *scheme = url.scheme;
    
    NSLog(@"host = %@",host);
    NSLog(@"query = %@",query);
    NSLog(@"scheme = %@",scheme);
    NSLog(@"%@",sourceApplication);
    
    NSMutableDictionary *paramsDict = nil;
    if ([str rangeOfString:@"wcfmallshareproduct"].location!=NSNotFound)
    {
        paramsDict = [NSMutableDictionary dictionary];
        NSString *decodeQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSRange shareRange = [decodeQuery rangeOfString:@"shareurl"];
        if (shareRange.location != NSNotFound &&shareRange.length != 0)
        {
            NSString *urlStr = [decodeQuery substringFromIndex:shareRange.location+shareRange.length+1];
            NSRange returnRange = [urlStr rangeOfString:@"return"];
            if (returnRange.location != NSNotFound &&returnRange.length!=0)
            {
                [paramsDict setObject:[urlStr substringFromIndex:returnRange.location+returnRange.length+1] forKey:@"return"];
                NSString *shareUrl =[decodeQuery substringWithRange:NSMakeRange(shareRange.location+shareRange.length+1,returnRange.location-1)];
                [paramsDict setObject:shareUrl forKey:@"shareurl"];
                NSLog(@"%@",shareUrl);
            }
            decodeQuery = [decodeQuery substringToIndex:shareRange.location-1];
        }
        
        NSArray *queryParams = [decodeQuery componentsSeparatedByString:@"&"];
        for (NSString *param in queryParams)
        {
            NSArray *paramElement = [param componentsSeparatedByString:@"="];
            [paramsDict setObject:paramElement[1] forKey:paramElement[0]];
        }
        NSLog(@"name = %@",paramsDict[@"name"]);
        NSLog(@"img = %@",paramsDict[@"img"]);
        NSLog(@"oldprice = %@",paramsDict[@"oldprice"]);
        NSLog(@"saleprice = %@",paramsDict[@"saleprice"]);
        NSLog(@"shareurl =%@",paramsDict[@"shareurl"]);
        NSLog(@"charges =%@",paramsDict[@"charges"]);
        NSLog(@"return =%@",paramsDict[@"return"]);
        NSLog(@"desc =%@",paramsDict[@"desc"]);
        NSLog(@"userid =%@",paramsDict[@"userid"]);
        NSLog(@"典里是%@",paramsDict);
        NSLog(@"showtype = %@",paramsDict[@"showtype"]);
        
        NSString *showType =paramsDict[@"showtype"];
        if ([showType isEqualToString:@"2"]) {
            ContractVC *ContVC = [[ContractVC alloc]init];
            ContVC.myDic = paramsDict;
            self.window.rootViewController = ContVC;
        }
        
        else{
            [ProDuctShareManager shareInstance].productShareDta = paramsDict;
            NSLog(@"哈哈%@",[ProDuctShareManager shareInstance].productShareDta);
            self.window.rootViewController = [[ProductShareVC alloc]init];
        }
    }
    
    else if ([str rangeOfString:@"wcfqk2015"].location!=NSNotFound) {
        
        paramsDict = [NSMutableDictionary dictionary];
        NSString *decodeQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSRange returnRange = [decodeQuery rangeOfString:@"return"];
        if (returnRange.location != NSNotFound &&returnRange.length != 0)
        {
            NSString *returnUrl =  [decodeQuery substringFromIndex:returnRange.location+returnRange.length+1];
            [paramsDict setObject:returnUrl forKey:@"return"];
            decodeQuery = [decodeQuery substringToIndex:returnRange.location-1];
        }
        
        NSArray *queryParams = [decodeQuery componentsSeparatedByString:@"&"];
        for (NSString *param in queryParams)
        {
            NSArray *paramElement = [param componentsSeparatedByString:@"="];
            [paramsDict setObject:paramElement[1] forKey:paramElement[0]];
        }
        
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                             initWithIdentifier:@"UUID"
                                             accessGroup:nil];
        NSString *strUUID = [keychainItem objectForKey:(id)kSecAttrAccount];
        if ([strUUID isEqualToString:@""])
        {
            
            strUUID = [ComponentsFactory getUUID];
            [keychainItem setObject:strUUID forKey:(id)kSecAttrAccount];
            
        }
        NSString *UUID;
        UUID = strUUID;
        [paramsDict setObject:UUID forKey:@"UUID"];
        NSLog(@"session_id =%@",paramsDict[@"session_id"]);
        NSLog(@"return =%@",paramsDict[@"return"]);
        NSLog(@"UUID =%@",paramsDict[@"UUID"]);
        
        
        [keychainItem release];
        
        
        QiankaLogin *qkLogin =[[QiankaLogin alloc]init];
        qkLogin.myDic = paramsDict;
        qkLogin.authKey = strUUID;
        qkLogin.pass_Url = str;
        [ProDuctShareManager shareInstance].authKey = strUUID;
        qkLogin.returnUrl =paramsDict[@"return"];
        self.window.rootViewController = qkLogin;
    }
    
    
    if ([str rangeOfString:@"wcfmallshareapp"].location!=NSNotFound)
    {
        paramsDict = [NSMutableDictionary dictionary];
        NSString *decodeQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange shareImgRange = [decodeQuery rangeOfString:@"shareimg"];
        NSRange returnRange1 = [decodeQuery rangeOfString:@"return"];
        if (shareImgRange.location != NSNotFound) {
            NSString *urlStr1 =[decodeQuery substringWithRange:NSMakeRange(shareImgRange.location,returnRange1.location-1-shareImgRange.location)];
            NSLog(@"%@",urlStr1);
            NSArray *queryParam = [urlStr1 componentsSeparatedByString:@"&"];
            for (NSString *param in queryParam)
            {
                NSArray *paramElement = [param componentsSeparatedByString:@"="];
                [paramsDict setObject:paramElement[1] forKey:paramElement[0]];
            }
        }
        
        
        
        NSRange shareRange = [decodeQuery rangeOfString:@"shareurl"];
        if (shareRange.location != NSNotFound &&shareRange.length != 0)
        {
            NSString *urlStr = [decodeQuery substringFromIndex:shareRange.location+shareRange.length+1];
            NSRange shareimgRange = [urlStr rangeOfString:@"shareimg"];
            NSRange returnRange = [urlStr rangeOfString:@"return"];
            if (shareimgRange.location != NSNotFound &&returnRange.length!=0)
            {
                [paramsDict setObject:[urlStr substringFromIndex:returnRange.location+returnRange.length+1] forKey:@"return"];
                NSString *shareUrl =[decodeQuery substringWithRange:NSMakeRange(shareRange.location+shareRange.length+1,shareimgRange.location-1)];
                [paramsDict setObject:shareUrl forKey:@"shareurl"];
                NSLog(@"粉丝分享URl是%@",shareUrl);
            }
            decodeQuery = [decodeQuery substringToIndex:shareRange.location-1];
        }
        
        NSArray *queryParams = [decodeQuery componentsSeparatedByString:@"&"];
        for (NSString *param in queryParams)
        {
            NSArray *paramElement = [param componentsSeparatedByString:@"="];
            [paramsDict setObject:paramElement[1] forKey:paramElement[0]];
        }
        NSLog(@"fans = %@",paramsDict[@"fans"]);
        NSLog(@"fansmoney = %@",paramsDict[@"fansmoney"]);
        NSLog(@"subfans = %@",paramsDict[@"subfans"]);
        NSLog(@"subfansmoney = %@",paramsDict[@"subfansmoney"]);
        NSLog(@"total =%@",paramsDict[@"total"]);
        NSLog(@"code =%@",paramsDict[@"code"]);
        NSLog(@"return =%@",paramsDict[@"return"]);
        NSLog(@"shareurl =%@",paramsDict[@"shareurl"]);
        NSLog(@"shareimg =%@",paramsDict[@"shareimg"]);
        NSLog(@"sharecontent =%@",paramsDict[@"sharecontent"]);
        NSLog(@"fanspercent =%@",paramsDict[@"fanspercent"]);
        NSLog(@"subfanspercent =%@",paramsDict[@"subfanspercent"]);
        
        
        NSLog(@"典里是%@",paramsDict);
        //        [ProDuctShareManager shareInstance].productShareDta = paramsDict;
        //        NSLog(@"哈哈%@",[ProDuctShareManager shareInstance].productShareDta);
        FansVC *fansVC = [[FansVC alloc]init];
        fansVC.params = paramsDict;
        self.window.rootViewController = fansVC;
    }
  
    
    //    else if ([str rangeOfString:@"heyuelist"].location!=NSNotFound)
    //    {
    //        paramsDict = [NSMutableDictionary dictionary];
    //        NSString *decodeQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //        NSRange shareRange = [decodeQuery rangeOfString:@"shareurl"];
    //        if (shareRange.location != NSNotFound &&shareRange.length != 0)
    //        {
    //            NSString *urlStr = [decodeQuery substringFromIndex:shareRange.location+shareRange.length+1];
    //            NSRange returnRange = [urlStr rangeOfString:@"return"];
    //            if (returnRange.location != NSNotFound &&returnRange.length!=0)
    //            {
    //                [paramsDict setObject:[urlStr substringFromIndex:returnRange.location+returnRange.length+1] forKey:@"return"];
    //                NSString *shareUrl =[decodeQuery substringWithRange:NSMakeRange(shareRange.location+shareRange.length+1,returnRange.location-1)];
    //                [paramsDict setObject:shareUrl forKey:@"shareurl"];
    //                NSLog(@"%@",shareUrl);
    //            }
    //            decodeQuery = [decodeQuery substringToIndex:shareRange.location-1];
    //        }
    //
    //        NSArray *queryParams = [decodeQuery componentsSeparatedByString:@"&"];
    //        for (NSString *param in queryParams)
    //        {
    //            NSArray *paramElement = [param componentsSeparatedByString:@"="];
    //            [paramsDict setObject:paramElement[1] forKey:paramElement[0]];
    //        }
    //        ContractVC *ContVC = [[ContractVC alloc]init];
    //        ContVC.myDic = paramsDict;
    //        self.window.rootViewController = ContVC;
    //    }
    return YES;
}


@end

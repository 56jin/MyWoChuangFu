//
//  AppDelegate.h
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-10.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildNavigationController.h"
#import "ChildTabBarController.h"
#import <CoreLocation/CoreLocation.h>

@class TopVC;
@class MainVC;
@class CommitVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,CLLocationManagerDelegate>{
    MainVC *topV;
    ChildNavigationController *navigationVC;
    ChildTabBarController *tabBarVC;
    
    CLLocationManager *locationManager; //定位器
    CLGeocoder *geocoder;     // 反向地理解析
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) BOOL isLogin;  //判断是否已登录
@property (nonatomic,assign) BOOL isSeleat;  //判断是否在精选页面跳转登录页面
@property (nonatomic,assign) NSInteger selectInteger;  //判断是否在精选页面跳转登录页面
@property (nonatomic,assign) BOOL isFailToLogin;  //判断是否在登录过时

@property (nonatomic,assign) BOOL isShare;  //判断是否在分享

+(AppDelegate*)shareMyApplication;
//屏幕高度
+ (CGFloat)sharePhoneHeight;
//屏幕宽度
+ (CGFloat)sharePhoneWidth;
//手机自带工具栏高度
+ (CGFloat)sharePhoneBarHeight;
//屏幕高度除去手机工具栏高度
+ (CGFloat)sharePhoneContentHeight;

- (void)initTabBar;  //初始化tabbar控制器


@end

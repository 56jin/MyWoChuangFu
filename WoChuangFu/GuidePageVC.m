//
//  GuidePageVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-2-10.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "GuidePageVC.h"
#import "MainVC.h"
#import "NewMainSearchVC.h"
#import "MyWocfVC.h"
#import "SettingVC.h"

@interface GuidePageVC ()

@end

@implementation GuidePageVC

- (void)loadView
{
    UIView *bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = bgView;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMainView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initMainView
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight])];
    scroll.pagingEnabled = YES;
    for (int i = 1;i<6;i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*[AppDelegate sharePhoneWidth],0,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight])];
        imageView.userInteractionEnabled = YES;
        if([UIScreen mainScreen].bounds.size.height == 568){
            NSString *pathStr = [NSString stringWithFormat:@"GuidePage%d@2x",i];
            NSString *path = [[NSBundle mainBundle] pathForResource:pathStr ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            imageView.image = image;
        }else{
            NSString *pathStr = [NSString stringWithFormat:@"GuidePage4s_%d@2x",i];
            NSString *path = [[NSBundle mainBundle] pathForResource:pathStr ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            imageView.image = image;
        }
        [scroll addSubview:imageView];
        
        if (i==5) {
            UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //立即分享
            beginBtn.center = CGPointMake(imageView.frame.size.width / 2,imageView.frame.size.height * 0.86);
            beginBtn.bounds = (CGRect){CGPointZero,{120,44}};//设置大小
            [beginBtn addTarget:self action:@selector(begin) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:beginBtn];
        }
    }
    scroll.contentSize = CGSizeMake([AppDelegate sharePhoneWidth]*5,0);
    [self.view addSubview:scroll];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)begin
{
    [[AppDelegate shareMyApplication] initTabBar];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)initTabBar
{
    ChildTabBarController *tabBarVC = [[ChildTabBarController alloc] init];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version>=5.0&&version<7.0){
        tabBarVC.tabBar.tintColor=[ComponentsFactory createColorByHex:@"#353333"];//tabber背景的颜色
    }else if(version>=7.0){
        [tabBarVC.tabBar setTintColor:[UIColor orangeColor]];//tabber下面选择图标的颜色
    }
    
    self.view.window.rootViewController = tabBarVC;
    //search
    NewMainSearchVC* searchVC = [[NewMainSearchVC alloc] init];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索"
                                                         image:[UIImage imageNamed:@"icon_navbar_search.png"]
                                                           tag:0];
    ChildNavigationController* searchNC = [[ChildNavigationController alloc] initWithRootViewController:searchVC];
    //main
    MainVC* mainVC = [[MainVC alloc] init];
    mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商城"
                                                       image:[UIImage imageNamed:@"icon_navbar_home.png"]
                                                         tag:0];
    ChildNavigationController* mainNC = [[ChildNavigationController alloc]initWithRootViewController:mainVC];
    //my wocf
    MyWocfVC* myWocfVC = [[MyWocfVC alloc] init];
    myWocfVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"登陆"
                                                         image:[UIImage imageNamed:@"icon_navbar_Diamond.png"]
                                                           tag:0];
    ChildNavigationController* myWocfNC = [[ChildNavigationController alloc]initWithRootViewController:myWocfVC];
    //system set
    SettingVC* setVC = [[SettingVC alloc] init];
    setVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                      image:[UIImage imageNamed:@"icon_navbar_set.png"]
                                                        tag:0];
    ChildNavigationController* systemSetNC = [[ChildNavigationController alloc]initWithRootViewController:setVC];
    
    NSArray* ncArr = [[NSArray alloc] initWithObjects:mainNC,searchNC,myWocfNC,systemSetNC,nil];

    for(int i=0;i<ncArr.count;i++){
        ((ChildNavigationController*)[ncArr objectAtIndex:i]).navigationBar.tintColor = [ComponentsFactory createColorByHex:@"#F6F6F6"];
    }
    tabBarVC.viewControllers = ncArr;
#ifdef __IPHONE_7_0
    tabBarVC.tabBar.barTintColor = [ComponentsFactory createColorByHex:@"#2b2c2d"];
#else
    tabBarVC.tabBar.barStyle = UIBarStyleBlack;
#endif
    tabBarVC.selectedIndex = 0;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

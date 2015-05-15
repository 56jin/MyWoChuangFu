//
//  MyWocfVC.m
//  WoChuangFu
//
//  Created by duwl on 12/27/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "MyWocfVC.h"
#import "UserInfoView.h"
#import "WealthView.h"
#import "SideBar.h"
#import "TitleBar.h"
#import "UserInfoView.h"
#import "LoginView.h"
//#import "RegdistVC.h"
#import "RegisterVC.h"
#import "MyPrivilegeView.h"
#import "GetBackPassWordVC.h"
#include "UrlParser.h"
#import "LoginSuccessView.h"

@interface MyWocfVC ()<TitleBarDelegate,SideBarDelegate,LoginViewDelegate>
{
    WealthView             *wealthView;              //我的财富界面
    SideBar                *sideBar;                 //侧滑栏
    UserInfoView           *userInfoView;            //用户信息界面
    LoginView              *loginView;               //登录界面
    MyPrivilegeView        *myPrivilegeView;         //我的特权
    UIView                 *wuLiaoView;              //申请物料
    CGFloat                currentTranslate;         //当前偏移
    BOOL                   _sideBarShowing;          //侧滑栏显示标志
    int                    ContentOffset;            //侧滑栏偏移量
    int                    ContentMinOffset;         //最小偏移量
    float                  MoveAnimationDuration;    //动画时间
    UIView                 *mainView;                //主界面
    UIScrollView           *contentView;             //主容器界面
    TitleBar               *titleBar;                //标题栏
    UIPanGestureRecognizer *panGes;                  //滑动手势
    UIView                 *shadeView;               //阴影视图
    LoginSuccessView       *loginSuccessView;        //登录成功后的视图
}

@end

@implementation MyWocfVC

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor blackColor];
    [self layoutV];
}

- (void)layoutV
{
    //主容器视图
    mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:mainView];
    
    //导航栏
    titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:middle_position];
    titleBar.target = self;
    [titleBar setLeftWithImage:@"btn_navbar_n" HighLightImage:@"btn_navbar_p"];
    [titleBar setLeftIsHiden:YES];
    if (IOS7)
        titleBar.frame = CGRectMake(0, 20, PHONE_WIDTH, 44);
    [mainView addSubview:titleBar];
    
    //视图容器视图
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,TITLE_BAR_HEIGHT+[[UIScreen mainScreen] applicationFrame].origin.y, PHONE_WIDTH,PHONE_HEIGHT-TITLE_BAR_HEIGHT-[[UIScreen mainScreen] applicationFrame].origin.y-49)];
    contentView.scrollEnabled = NO;
    contentView.backgroundColor = [ComponentsFactory createColorByHex:@"#efeff4"];
    contentView.contentSize = CGSizeMake(PHONE_WIDTH * 5, 0);
    contentView.bounces = NO;
    contentView.pagingEnabled = YES;
    [mainView addSubview:contentView];
    
    shadeView = [[UIView alloc] init];
    shadeView.backgroundColor = [UIColor blackColor];
    shadeView.frame = contentView.frame;
    [mainView addSubview:shadeView];
    shadeView.alpha = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    currentTranslate = 0;
    _sideBarShowing = NO;
    ContentOffset = 260;
    ContentMinOffset = 150;
    MoveAnimationDuration = 0.3;
    
    //判断是否登录
    /*
     *界面分布
     *0.我的信息
     *1.我的财富
     *2.申请物料
     *3.我的特权
     *4.登陆界面
     */
    bussineDataService *bus = [bussineDataService sharedDataService];
    
    //如果已经登录
    if (bus.HasLogIn == YES)
    {
        //step1.设置sideBar用户信息
        NSString *customName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        sideBar.customName = customName;
        
        //step2.加载用户信息界面
        [self showUserInfoView];
    }
    else
    {
        //step1.加载加载登录界面
        [self showLoginView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    bussineDataService *bus = [bussineDataService sharedDataService];
    if (bus.HasLogIn == NO)
    {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        if (userName != nil && ![userName isEqualToString:@""])
        {
            loginView.NameTextField.text = userName;
        }
        NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"PassWord"];
        if (passWord != nil && ![passWord isEqualToString:@""])
        {
            loginView.PassTextField.text = passWord;
        }
    }
    //隐藏侧滑栏
    if (_sideBarShowing)
    {
        [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
    }
}

#pragma mark - TitleBarDelegate
-(void)backAction
{
    bussineDataService *bus = [bussineDataService sharedDataService];
    
    if (bus.HasLogIn)
    {
        if (_sideBarShowing)
        {
            [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
        }
        else
        {
            [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
        }
    }
}
#pragma mark - LoginViewDelegate
//跳转到用户注册界面
- (void)didClickedRegister
{
//    RegdistVC *regdistVC = [[RegdistVC alloc] init];
//    regdistVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:regdistVC animated:YES];
    RegisterVC *regdistVC = [[RegisterVC alloc] init];
    regdistVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:regdistVC animated:YES];
}

- (void)didClickedGetBackPassWord
{
    GetBackPassWordVC *getpassVC = [[GetBackPassWordVC alloc] init];
    getpassVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:getpassVC animated:YES];
}

- (void)loginSuccess:(NSArray *)menus
{
    //step1.添加侧边栏
    if (sideBar == nil)
    {
        //侧滑栏
        sideBar = [[SideBar alloc] initWithFrame:CGRectMake(0,20,260,PHONE_HEIGHT-20)];
        sideBar.delegate = self;
        [self.view insertSubview:sideBar belowSubview:mainView];
    }
    //step2.设置菜单数据源
    sideBar.dataSources = menus;
    sideBar.customName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    
    [titleBar setLeftIsHiden:NO];
    
    //step3.显示个人信息界面
    [self showUserInfoView];
    
    //step4.添加手势
    if (panGes == nil)
    {
        panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    }
    [self.view addGestureRecognizer:panGes];
    //step4.显示侧滑栏
    [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
}

- (void)loginSuccessReture:(NSString *)loginString {
    
    self.navigationController.navigationBar.hidden = YES;
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 45;
    if (loginSuccessView == nil){
        loginSuccessView = [[LoginSuccessView alloc]initWithFrame:frame];
        loginSuccessView.urlLogin = loginString;
        [loginSuccessView builtView];
        [self.view addSubview:loginSuccessView];
        
        [loginSuccessView returnText:^(NSString *showText) {
            loginSuccessView.seachButton.userInteractionEnabled=YES;
            [loginSuccessView.seachButton StopWave];
            
            [UrlParser gotoNewVCWithUrl:showText VC: self];

        }];
        
       
        return;
    }
    
    if (loginSuccessView) {
        [UrlParser gotoNewVCWithUrl:loginString VC: self];

    }
    
}

#pragma mark - SideBarDelegate
//用户已经退出
- (void)userDidLogout
{
    //step1.隐藏侧滑栏
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
    
    //step2.移除侧滑手势
    [self.view removeGestureRecognizer:panGes];
    
    //step3.跳转到登陆界面
    [self showLoginView];
    
    //step4.隐藏侧滑栏显示按钮
    [titleBar setLeftIsHiden:YES];
}

#pragma mark - SideBarDelegate
//侧滑菜单选中调用
- (void)sideBar:(SideBar *)sideBar didSelectAtIndex:(NSInteger)index
{
    /*
     *界面分布
     *0.我的信息
     *1.我的财富
     *2.申请物料
     *3.我的特权
     *4.登陆界面
     */
    switch (index)
    {
            //我的信息
        case 0:
        {
            bussineDataService *bus = [bussineDataService sharedDataService];
            if (bus.HasLogIn == YES)
            {
                [self showUserInfoView];
            }
            else
            {
                [self ShowProgressHUDwithMessage:@"请先登录！"];
                [self showLoginView];
            }
            [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
        }
            break;
            //我的财富
        case 1:
        {
            bussineDataService *bus = [bussineDataService sharedDataService];
            if (bus.HasLogIn == YES)
            {
                [self showWealthView];
            }
            else
            {
                [self ShowProgressHUDwithMessage:@"请先登录！"];
                [self showLoginView];
            }
            [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
        }
            break;
            //申请物料
        case 2:
        {
            
            [self moveAnimationWithDirection:SideBarShowDirectionNone duration:0];
            self.tabBarController.selectedIndex = 0;
            
//            bussineDataService *bus = [bussineDataService sharedDataService];
//            if (bus.HasLogIn == YES)
//            {
//                if (wuLiaoView == nil)
//                {
//                    wuLiaoView = [[UIView alloc] initWithFrame:CGRectMake(PHONE_WIDTH*2,0,PHONE_WIDTH,PHONE_HEIGHT - 64)];
//                    
//                    UIImage *image = [UIImage imageNamed:@"toBeContinued"];
//                    CGSize imageSize = image.size;
//                    UIImageView *imgView = [[UIImageView alloc] init];
//                    CGPoint origin = CGPointMake((wuLiaoView.frame.size.width-imageSize.width)/2.0,(wuLiaoView.frame.size.height-imageSize.height-48)/2.0);
//                    imgView.frame = (CGRect){origin,imageSize};
//                    imgView.image = image;
//                    [wuLiaoView addSubview:imgView];
//                    [contentView addSubview:wuLiaoView];
//                }
//                //申请物料
//                titleBar.title = @"申请物料";
//                [contentView setContentOffset:CGPointMake(PHONE_WIDTH*2,0) animated:NO];
//            }
//            else
//            {
//                [self ShowProgressHUDwithMessage:@"请先登录！"];
//                [self showLoginView];
//            }
//            [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
        }
            break;
            //我的特权
        case 3:
        {
            bussineDataService *bus = [bussineDataService sharedDataService];
            if (bus.HasLogIn == YES)
            {
                //我的特权
                [self showPrivilegeView];
            }
            else
            {
                [self ShowProgressHUDwithMessage:@"请先登录！"];
                [self showLoginView];
            }
            [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
        }
            break;
        default:
            break;
    }
}

//显示用户信息视图
- (void)showUserInfoView
{
    if (userInfoView == nil)
    {
        userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0,0,PHONE_WIDTH,PHONE_HEIGHT - 64)];
        [contentView addSubview:userInfoView];
    }
    [userInfoView loadUserInfo];
    titleBar.title = @"我的信息";
    [contentView setContentOffset:CGPointMake(0,0) animated:NO];
}
//显示个人财富视图
- (void)showWealthView
{
    //我的财富
    if (wealthView == nil)
    {
        wealthView = [[WealthView alloc] initWithFrame:CGRectMake(PHONE_WIDTH, 0, PHONE_WIDTH,PHONE_HEIGHT - 64)];
        [contentView addSubview:wealthView];
    }
    [wealthView loadWealthInfo];
    titleBar.title = @"我的财富";
    [contentView setContentOffset:CGPointMake(PHONE_WIDTH,0) animated:NO];
}

//显示我的特权视图
- (void)showPrivilegeView
{
    if (myPrivilegeView == nil)
    {
        myPrivilegeView = [[MyPrivilegeView alloc] initWithFrame:CGRectMake(PHONE_WIDTH*3,0,PHONE_WIDTH,PHONE_HEIGHT - 64)];
        [contentView addSubview:myPrivilegeView];
    }
    titleBar.title = @"我的特权";
    [contentView setContentOffset:CGPointMake(PHONE_WIDTH*3,0) animated:NO];
}
//显示登录视图
- (void)showLoginView
{
    if (loginView == nil)
    {
        loginView = [[LoginView alloc] initWithFrame:CGRectMake(PHONE_WIDTH*4,0,PHONE_WIDTH,PHONE_HEIGHT - 64)];
        loginView.delegate = self;
        [contentView addSubview:loginView];
    }
    titleBar.title = @"沃创富用户登录";
    [contentView setContentOffset:CGPointMake(PHONE_WIDTH*4,0) animated:NO];
}

#pragma mark - 拖动手势
-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat translation = [gestureRecognizer translationInView:self.view].x;
        
        if(translation+currentTranslate > 0&&translation+currentTranslate<260.0)
        {
            mainView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        
            self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
            shadeView.alpha = (translation+currentTranslate)/260.0 *0.85;
        }
	}
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
		currentTranslate = mainView.transform.tx;
        if (!_sideBarShowing)
        {//左边
            if (currentTranslate<=ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }
            else if(currentTranslate>ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }
        else//全屏
        {
            if (currentTranslate>=ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
            else if(currentTranslate<ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }
        }
	}
}

//滑动中的动画
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                mainView.transform  = CGAffineTransformMakeTranslation(0, 0);
                self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, 0);
                self.tabBarController.tabBar.userInteractionEnabled = YES;
                shadeView.alpha = 0;
                contentView.userInteractionEnabled = YES;
            }
                break;
            case SideBarShowDirectionRight:
            {
                mainView.transform  = CGAffineTransformMakeTranslation(260, 0);
                self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(260, 0);
                shadeView.alpha = 0.85;
                contentView.userInteractionEnabled = NO;
                self.tabBarController.tabBar.userInteractionEnabled = NO;
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        if (direction == SideBarShowDirectionNone)
        {
            _sideBarShowing = NO;
        }
        else
        {
            _sideBarShowing = YES;
        }
        currentTranslate =mainView.transform.tx;
	};
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end

//
//  MainVC.m
//  WoChuangFu
//
//  Created by duwl on 12/8/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "MainVC.h"
#import "NewMainSearchVC.h"
#import "UrlParser.h"


@interface MainVC ()<HttpBackDelegate,UIGestureRecognizerDelegate> {
    UIView *ImageView;
}

@end

@implementation MainVC

@synthesize titleBar;
@synthesize mainView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MAIN_PAGE_URL_PARSE object:nil];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    CGRect ScF=[UIScreen mainScreen].bounds;
//    ScF.size.height -= 45;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[UIColor blackColor];//[ComponentsFactory createColorByHex:@"#F8F8F8"];
    self.view = BackV;
    [BackV release];
    self.navigationController.navigationBarHidden=YES;
    [self layoutView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainPageItemClick:) name:MAIN_PAGE_URL_PARSE object:nil];
    [self checkVersion];
}

- (void)mainPageItemClick:(NSNotification*)vc
{
    if(vc != nil){
        UIViewController *viewController = [vc object];
//        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)layoutView
{
//    //1,布局titleBar
//    TitleBar* bar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:middle_position];
//    bar.frame = CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
//    self.titleBar = bar;
//    [bar setTitle:@"沃创富"];
//    [bar setLeftIsHiden:YES];
//    [bar release];
//    [self.view addSubview:self.titleBar];
    
    //1,布局titleBar
    UIView* bar = [[UIView alloc] init];
    bar.frame = CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
    bar.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:bar];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logo.center = CGPointMake(25,22);
    [bar addSubview:logo];
    
    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(45,0,60,44)];
    appName.text = @"沃创富";
    [appName setFont:[UIFont boldSystemFontOfSize:16]];
    [appName setTextColor:[UIColor whiteColor]];
    [bar addSubview:appName];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.frame = CGRectMake(100,7,210,30);
    [searchBtn addTarget:self action:@selector(gotoSearch) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:searchBtn];

    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
    searchIcon.center = CGPointMake(15,15);
    [searchBtn addSubview:searchIcon];
    
    [appName release];
    [logo release];
    [searchBtn release];
    [bar release];
    [searchIcon release];
    
    
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
    [dateformatter release];
    if([locationString integerValue] < 20150616 || [locationString integerValue] > 20150630) {
        
        MainView* view = [[MainView alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y+TITLE_BAR_HEIGHT,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight]-[[UIScreen mainScreen] applicationFrame].origin.y-TITLE_BAR_HEIGHT-TAB_BAR_HEIGHT )];
        self.mainView = view;
        [self.view addSubview:self.mainView];
        [view release];
        return;
    }
    
    
    MainView* view = [[MainView alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y+TITLE_BAR_HEIGHT,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight]-[[UIScreen mainScreen] applicationFrame].origin.y-TITLE_BAR_HEIGHT-TAB_BAR_HEIGHT - 60)];
    self.mainView = view;
    [self.view addSubview:self.mainView];
    [view release];
    
    ImageView  = [[UIView alloc]initWithFrame:CGRectMake(0, MainHeight - 60 - 50, MainWidth, 62)];
    [ImageView setBackgroundColor:[UIColor whiteColor]];
//    [ImageView setImage:[UIImage imageNamed:@""]];

    
    UIImageView *Image  = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, MainWidth, 59)];
//    [Image setBackgroundColor:[UIColor redColor]];
    [Image setImage:[UIImage imageNamed:@"618image.png"]];
    [ImageView addSubview:Image];
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    
    [ImageView addGestureRecognizer:singleRecognizer];
    [singleRecognizer release];
    
//    // 双击的 Recognizer
//    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
//    doubleRecognizer.numberOfTapsRequired = 2; // 双击
//    //关键语句，给self.view添加一个手势监测；
//    [ImageView addGestureRecognizer:doubleRecognizer];
//    
//    // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
//    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    
//    [doubleRecognizer release];
    
    [self.view addSubview:ImageView];
    
    [Image release];
    
    UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureOrderBtn setBackgroundColor:[UIColor clearColor]];
    [sureOrderBtn setFrame:(CGRect){MainWidth - 52.5,MainHeight - 60 - 50 + 7,50,44}];
//    [sureOrderBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [sureOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [sureOrderBtn setImage:[UIImage imageNamed:@"imagebtn.png"] forState:UIControlStateNormal];
//    [sureOrderBtn.layer setMasksToBounds:YES];
//    [sureOrderBtn.layer setCornerRadius:sureOrderBtn.frame.size.width  / 2];
//    sureOrderBtn.layer.borderWidth = 2;
//    sureOrderBtn.layer.borderColor = [[UIColor colorWithRed:161/255.0 green:47/255.0 blue:47/255.0 alpha:1] CGColor];
//    [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:20 weight:20]];
    [sureOrderBtn addTarget:self action:@selector(sureOrderEven:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureOrderBtn];
    
   
}


-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
     NSLog(@"\n\nwowooooooooooooooooooooooooo\n");
    [UrlParser gotoNewVCWithUrl:@"http://o2o.gx10010.com/zt/ad618/site/index"];
}

-(void)DoubleTap:(UITapGestureRecognizer*)recognizer
{
    //处理双击操作
     NSLog(@"\n\nwowooooooooooooooooooooooooo222222222\n");
}

- (void)sureOrderEven:(UIButton *)sender {
    NSInteger tag = sender.tag;
    tag ++;
    float Durationtime = 0.2;
    [UIView beginAnimations:@"alt" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:Durationtime];
    CGRect frame = self.mainView.allScrollView.frame;
    if (tag == 1) { //关闭
        sender.tag = 1;
        [ImageView setFrame:CGRectMake(MainWidth,MainHeight - 60 - 50, MainWidth, 62)];
        
        
        frame.size.height += 60;
       
        


    }
    if (tag == 2) {// 打开
        sender.tag = 0;
        tag = 0;
        [ImageView setFrame:CGRectMake(0,MainHeight - 60 - 50, MainWidth, 62)];
        frame.size.height -= 60;
    }
    
   
     self.mainView.allScrollView.frame = frame;
    
    [UIView commitAnimations];

}

- (void)gotoSearch
{
//    [self.tabBarController setSelectedIndex:1];
    
     NewMainSearchVC* searchVC = [[NewMainSearchVC alloc] init];
//    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)checkVersion
{
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService updateVersion:nil];
}
- (BOOL)userLogin
{
    bussineDataService *bus=[bussineDataService sharedDataService];
    bus.target=self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"UserName"];
    NSString *passWord = [userDefaults objectForKey:@"PassWord"];
    NSString *userId = [userDefaults objectForKey:@"userId"];
    NSString *userType = [userDefaults objectForKey:@"userType"];
    
    if (userName == nil ||passWord == nil||userId==nil||userType==nil)
    {
        return false;
    }
    else
    {
        NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                           passWord,@"passWd",
                           userName,@"userCode",
                           userType,@"type",
                           nil];
        [bus login:dic];
        [dic release];
        return YES;
    }
}
//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if([[VersionUpdataMessage getBizCode] isEqualToString:bizCode])
    {
        if([@"7777" isEqualToString:errCode])
        {
            //可选升级
            bussineDataService *bus=[bussineDataService sharedDataService];
            [self showAlertViewTitle:@"有新版本发布，是否升级？"
                             message:[bus.rspInfo objectForKey:@"remark"]==[NSNull null]?@"":[bus.rspInfo objectForKey:@"remark"]
                            delegate:self
                                 tag:10106
                   cancelButtonTitle:@"取消"
                   otherButtonTitles:@"确定", nil];
        }
        if ([self userLogin]== false)
        {
            [self.mainView sendMainUIRequest];
        }
    }
    if ([[LoginMessage getBizCode] isEqualToString:bizCode])
    {
        [self.mainView sendMainUIRequest];
    }
}
- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    if ([[VersionUpdataMessage getBizCode] isEqualToString:bizCode])
    {
        if ([self userLogin]== false)
        {
            [self.mainView sendMainUIRequest];
        }
    }
    else if([[LoginMessage getBizCode] isEqualToString:bizCode])
    {
        [self.mainView sendMainUIRequest];
    }
}

#pragma mark -
#pragma mark AlertView
-(void)showAlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles,...
{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    id arg;
    va_list argList;
    if(nil != otherButtonTitles){
        va_start(argList, otherButtonTitles);
        while ((arg = va_arg(argList,id))) {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    alert.tag = tag;
    for(int i = 0; i < [argsArray count]; i++){
        [alert addButtonWithTitle:[argsArray objectAtIndex:i]];
    }
    [alert show];
    [alert release];
    
    [argsArray release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10106){
        if([buttonTitle isEqualToString:@"确定"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
             NSLog(@"更新地址 %@",bus.updateUrl);
            NSURL* url = [NSURL URLWithString:bus.updateUrl];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
                exit(0);
            }
        }
    }
}

@end

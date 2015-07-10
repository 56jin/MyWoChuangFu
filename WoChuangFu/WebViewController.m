//
//  JiGouWebViewControler.m
//  WoChuangFu
//
//  Created by 陈 贵邦 on 15-5-27.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "WebViewController.h"
#import "TitleBar.h"
#import "3Des.h"
#import <BLEIDCardReaderItem/BLEIDCardReaderItem.h>
#import "GDataXMLNode.h"
#import "ZSYPopListView.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface WebViewController()<TitleBarDelegate,UIWebViewDelegate,ZSYPopListViewDelegate,CBCentralManagerDelegate,BR_Callback>{
//     CBCentralManager *manager;
     BleTool *bletool;//bleTool对象
     ZSYPopListView *zsy;
    NSDictionary *blootDic;  //当前选择的蓝牙设备信息
    BOOL isReadAgin;
    BOOL isRead;
}

@end

@implementation WebViewController
@synthesize URL = URL ;
@synthesize webView;
- (void)viewDidLoad {
    
    
    
    
    
    
    
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    webView.delegate = self;
    
    //    webView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:webView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    [UIApplication sharedApplication].statusBarHidden=NO;
    //    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"简易下单";
    titleBar.frame = CGRectMake(0,20, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    titleBar.target = self;
    if ([AppDelegate shareMyApplication].isSeleat == YES) {
        //        NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
        
        //        NSLog(@"%@",sessionid);
        
        //        URL = [NSString stringWithFormat:@"%@/mallwcf/goods?flag=1&sessionid=%@",service_IPqq,sessionid];
//        URL = [NSString stringWithFormat:@"%@/userSettingwcf/toJoinOrg",service_IPqq];
//        
//        URL = @"http://133.0.191.9:15613/showProSimDet.do";
//        URL = @"http://10.37.239.43:8080/emall/showProSimDetForApp.do?server_type=0&developId=gxlt10016";
//        URL = @"http://221.7.252.48:15613/showProSimDetForApp.do?server_type=0&developId=gxlt10016";
//       
         URL = [NSString stringWithFormat:@"%@showProSimDetForApp.do?server_type=0&developId=gxlt10016",service_IP];
        //去掉左右滚动条
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        //去掉左右滚动条
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        [AppDelegate shareMyApplication].isSeleat = NO;
        NSURL* url = [NSURL URLWithString:URL];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];//加载
        return;
    }
    if (URL) {
        return;
    }
    
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    
    NSLog(@"  !!!%@",sessionid);
    
    //    URL = [NSString stringWithFormat:@"%@/mallwcf/goods?flag=1&sessionid=%@",service_IPqq,sessionid];
    
//    URL = [NSString stringWithFormat:@"%@/userSettingwcf/toJoinOrg",service_IPqq];
//    
//    URL = @"http://133.0.191.9:15613/showProSimDet.do";
//    
//    URL = @"http://10.37.239.43:8080/emall/showProSimDetForApp.do?server_type=0&developId=gxlt10016";
//    
//    URL = @"http://221.7.252.48:15613/showProSimDetForApp.do?server_type=0&developId=gxlt10016";
//    
    
    URL = [NSString stringWithFormat:@"%@showProSimDetForApp.do?server_type=0&developId=gxlt10016",service_IP];
    
    
    
    
    //去掉左右滚动条
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    //去掉左右滚动条
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
    NSURL* url = [NSURL URLWithString:URL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
    bletool =[[BleTool alloc]init:self];
//    [self performSelector:@selector(afertBtn) withObject:nil afterDelay:0.5];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 响应web按钮
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([request.URL.relativeString hasSuffix:@"=a"] || [request.URL.relativeString hasSuffix:@"=b"] ) {
//        UIViewController *view = [[[UIViewController alloc]init]autorelease];
//        [[self navigationController] pushViewController:view animated:YES];
//        [self fillWebView:@"张三" CardId:@"452012354687654633541"];
        
        [self getIdCradBtnEvent];
        
        return NO;
    }
    return YES;
}

#pragma mark 设置web信息姓名及身份证号码
-(void)fillWebView:(NSString*)name CardId:(NSString*)cardId{
    
//    NSString *_name = [NSString stringWithFormat:@"\"%@\"",name];
    NSString *function = [NSString stringWithFormat:@"refreshWebView(\"%@\",\"%@\")",name,cardId];
    [webView stringByEvaluatingJavaScriptFromString:function];
}
-(void)backAction {
    if (isRead) {
        //断开连接
        [bletool disconnectBt];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}



//选择哪个店铺类型
- (void)sureDoneWith:(NSDictionary *)resion{
    
    
    if (zsy) {
        [zsy dissViewClose];
        zsy = nil;
        zsy.delegate = nil;
    }
    
    NSLog(@"获取设备信息%@",resion);
    
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    blootDic = resion ;
    [bletool connectBt:[resion valueForKey:@"uuid"]];
    
    
    
    if (isReadAgin == YES) {
        //        [self getIdCradBtnEvent];
        //         [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        [self performSelector:@selector(getIdCradBtnEvent) withObject:nil afterDelay:0.5];
    }
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString * message = nil;
    switch (central.state) {
        case 0:
            message = @"初始化中，请稍后……";
            break;
        case 1:
            message = @"设备不支持状态，过会请重试……";
            break;
        case 2:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 3:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 4:
            message = @"尚未打开蓝牙，请在设置中打开……";
            break;
        case 5:
            message = @"蓝牙已经成功开启，稍后……";
            break;
        default:
            break;
    }
    
    [self ShowProgressHUDwithMessage:message];
    
}

- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.5];
}

- (void)getIdCradBtnEvent {
    [self.view endEditing:YES];
    
    isReadAgin = NO;
    if (!isRead) {
        isReadAgin = YES;
        [self afertBtn]; // 先连接设备
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    
    
    NSDictionary *result=[bletool readIDCardS];//读出来的加密数据 其中baseInfo是加密后的数据，需要用设备对应的key解密。
    
    
    //处理xml字符串，因为返回的xml字符没有根节点，所以此处加上一个根节点，便于GDataXmlNode取xml值
    NSString *resultstr = [result valueForKey:@"baseInfo"];
    NSLog(@"获取身份证信息：---- %@",resultstr);
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if(resultstr == nil || [resultstr isEqualToString:@""]){
        
        [self performSelector:@selector(getShowFail) withObject:nil afterDelay:0.5];
        
        return;
        
    }else{
    
        GDataXMLDocument *xmlroot=[[GDataXMLDocument alloc] initWithXMLString:resultstr options:0 error:nil];
        GDataXMLElement *xmlelement= [xmlroot rootElement];
        NSArray *xmlarray= [xmlelement children];
        NSMutableDictionary *xmldictionary=[NSMutableDictionary dictionary];
        for(GDataXMLElement *childElement in xmlarray){
            NSString *childName= [childElement name];
            NSString *childValue= [childElement stringValue];
            [xmldictionary setValue:childValue forKey:childName];
        }
        
        [xmldictionary valueForKey:@""];
        //        NSString *sexCode= [self SexJudge:[xmldictionary valueForKey:@"sexCode"]];  //性别
        //        NSString *nationCode=[self NationJugde:[xmldictionary valueForKey:@"nationCode"]];  // 民族
        NSString *name = [xmldictionary valueForKey:@"name"];
        NSString *cardid = [xmldictionary valueForKey:@"idNum"];
//        idCardAddress.text = [xmldictionary valueForKey:@"address"];
        [self fillWebView:name CardId:cardid];
    }
}


- (void)getShowFail {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"读取身份证信息失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新读取", nil];
    alert.tag = 101010;
    [alert show];
    [alert release];
}


- (void)afertBtn {
    
    
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    //搜索蓝牙设备
    NSMutableArray *devarry = [[NSMutableArray alloc]init];
    NSArray *arry = [bletool ScanDeiceList:2.0f];
    [devarry addObjectsFromArray:arry];
    if (devarry && devarry != nil && devarry.count > 0) {
        NSLog(@"设备信息 %@",devarry);
        
        for (NSDictionary *dic in arry) {
            if ( dic.count <= 0 || [dic allKeys].count <= 0) {
                NSLog(@"移除信息 ");
                [devarry removeObject:dic];
            }
        }
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];

        if(devarry.count <= 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您附近没有找到蓝牙读卡器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新搜索", nil];
            alert.tag = 10108;
            [alert show];
            [alert release];
            
        }
        else {
            zsy = [[ZSYPopListView alloc]initWitZSYPopFrame:CGRectMake(0, 0, 200, devarry.count  * 55 + 50) WithNSArray:devarry WithString:@"选择蓝牙读卡器类型"];
            zsy.isTitle = NO;
            zsy.delegate = self;
        }
        
        
        
        
    }else {
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您附近没有找到蓝牙读卡器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新搜索", nil];
        alert.tag = 10108;
        [alert show];
        [alert release];
        
    }
    
    [devarry release];
    
    
}

#pragma  mark -bletool 's delegate
-(void)BR_connectResult:(BOOL)isconnected{
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if(isconnected){  //链接成功
        NSLog(@"\n\n  读取代理1");
        isRead = YES;
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器成功"];
//        [BlootLabel setText:[NSString stringWithFormat:@"您当前连接蓝牙设备: %@",blootDic[@"name"] ]];
        
    }
    else{
        //链接失败
        NSLog(@"\n\n  读取代理2");
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器失败"];
        
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10101 || alertView.tag == 288 )
    {
        
        if([buttonTitle isEqualToString:@"重试"] || [buttonTitle isEqualToString:@"马上返档"]){
//            [self sureFangDang];
        }
    }
    
    if(alertView.tag==10108)
    {
        if([buttonTitle isEqualToString:@"重新搜索"]){
            //            [self afertBtn];
            [self performSelector:@selector(afertBtn) withObject:nil afterDelay:0.5];
        }
    }
    
    if(alertView.tag==101010)
    {
        if([buttonTitle isEqualToString:@"重新读取"]){
            
            [self performSelector:@selector(getIdCradBtnEvent) withObject:nil afterDelay:1];
        }
    }
    
    
    
}

-(void)dealloc{
    [super dealloc];
    [bletool release];
    blootDic = nil;
    
}

@end

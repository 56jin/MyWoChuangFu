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
#import "ShowWebVC.h"


@interface WebViewController()<TitleBarDelegate,UIWebViewDelegate,ZSYPopListViewDelegate,CBCentralManagerDelegate,BR_Callback>{
//     CBCentralManager *manager;
//     BleTool *bletool;//bleTool对象
     ZSYPopListView *zsy;
    NSDictionary *blootDic;  //当前选择的蓝牙设备信息
    BOOL isReadAgin;
    BOOL isRead;
    BleTool *tools;
    
    BOOL failStat;
}

@end

@implementation WebViewController
@synthesize URL = URL ;
@synthesize webView;

- (void)loadView
{
    [super loadView];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    tools = [[BleTool alloc]init:self];

    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, MainHeight-44)];
    webView.delegate = self;
    webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:webView];
       
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.navigationController.navigationBarHidden = YES;
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"简易下单";
    titleBar.frame = CGRectMake(0,20, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    titleBar.target = self;
    
    if ([AppDelegate shareMyApplication].isSeleat == YES) {
        
        [self initWithRequestWeb];
        return;
    }
    
//    if (URL) {
//        return;
//    }
    
//    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
//    
//    NSLog(@"  !!!%@",sessionid);
//    URL = [NSString stringWithFormat:@"%@showProSimDetForApp.do?server_type=0&developId=gxlt10016",service_IP];
//    NSLog(@"加载地址：%@",URL);
//    
//    
//    
//    
//    //去掉左右滚动条
//    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
//    //去掉左右滚动条
//    self.webView.scrollView.showsVerticalScrollIndicator = NO;
//    
//    NSURL* url = [NSURL URLWithString:URL];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//    [self.webView loadRequest:request];//加载
    
    [self initWithRequestWeb];
}

- (void)initWithRequestWeb {
    
    URL = [NSString stringWithFormat:@"%@showProSimDetForApp.do?server_type=0&developId=gxlt10016",service_IP];
    //去掉左右滚动条
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    //去掉左右滚动条
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [AppDelegate shareMyApplication].isSeleat = NO;
    
    NSString *UrlStr= [service_url stringByReplacingOccurrencesOfString:@"json" withString:@"appweb"];
    NSURL *url = nil;
    NSString *body = nil;
    url = [NSURL URLWithString:[UrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
    if (sessionId == nil)
    {
        sessionId = @"";
    }
    
    body = [NSString stringWithFormat:@"sessionId=%@&destUrl=%@",sessionId,[self encodeURL:URL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [webView loadRequest: request];
    [request release];
    

}

- (NSString*)encodeURL:(NSString *)string
{
    //CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`")
    NSString *newString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)string, NULL,CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8);
    if (newString) {
        return newString;
    }
    return @"";
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
    

    NSURL *url = [request URL];
    NSString*str =  [url absoluteString];
    



    if ([request.URL.relativeString hasSuffix:@"=a"] || [request.URL.relativeString hasSuffix:@"=b"] ) {
        [self getMessage];
        
        return NO;
    }
    if ([str rangeOfString:@"emallcardorder/completion.do"].location!=NSNotFound){
        ShowWebVC *webVC = [[ShowWebVC alloc] init];
        webVC.urlStr = [NSString stringWithFormat:@"%@",str];//@"showProSimDetForApp.do?server_type=0&developId=gxlt10016";
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        
        
        return NO;
    }
//=======
//    if ([str rangeOfString:@"emallcardorder/completion.do"].location!=NSNotFound){
//        ShowWebVC *webVC = [[ShowWebVC alloc] init];
//        webVC.urlStr = [NSString stringWithFormat:@"%@",str];//@"showProSimDetForApp.do?server_type=0&developId=gxlt10016";
//        webVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:webVC animated:YES];
//
//        
//        return NO;
//    }
//>>>>>>> .r51303
    return YES;
}

-(void)getMessage{
   
       //搜索蓝牙设备
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    NSMutableArray *devarry = [[NSMutableArray alloc]init];
    NSArray *arry = [tools ScanDeiceList:2.0f];
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
             [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
            [self ShowProgressHUDwithMessage:@"搜索不到蓝牙,请重试"];
            
        }
        else {
            zsy = [[ZSYPopListView alloc]initWitZSYPopFrame:CGRectMake(0, 0, 200, devarry.count  * 55 + 50) WithNSArray:devarry WithString:@"选择蓝牙读卡器类型"];
            zsy.isTitle = NO;
            zsy.delegate = self;
        }
    }else{
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        [self ShowProgressHUDwithMessage:@"搜索不到蓝牙,请重试"];
    }
    [devarry release];
}






#pragma mark 设置web信息姓名及身份证号码
-(void)fillWebView:(NSString*)name CardId:(NSString*)cardId{
    
//    NSString *_name = [NSString stringWithFormat:@"\"%@\"",name];
    NSString *function = [NSString stringWithFormat:@"refreshWebView(\"%@\",\"%@\")",name,cardId];
    [webView stringByEvaluatingJavaScriptFromString:function];
    
     [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
}
-(void)backAction {
    if (isRead) {
        //断开连接
        [tools disconnectBt];
        [tools release];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -选择连接的蓝牙
- (void)sureDoneWith:(NSDictionary *)resion{
    
    
    if (zsy) {
        [zsy dissViewClose];
        zsy = nil;
        zsy.delegate = nil;
    }
    [tools connectBt:[resion valueForKey:@"uuid"]];
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

#pragma  mark - 蓝牙连接代理
-(void)BR_connectResult:(BOOL)isconnected{
//    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if(isconnected){  //链接成功
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器成功"];
        [self readCard];
        
    }
    else if(failStat == YES){
        failStat = NO;
    }else{
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器失败,请重试"];
    }
    
    
}
#pragma mark 读取身份证信息
-(void)readCard{
    
    
    NSDictionary *result=[tools readIDCardS];//读出来的加密数据 其中baseInfo是加密后的数据，需要用设备对应的key解密。
    
    
    //处理xml字符串，因为返回的xml字符没有根节点，所以此处加上一个根节点，便于GDataXmlNode取xml值
    NSString *resultstr = [result valueForKey:@"baseInfo"];
    NSLog(@"获取身份证信息：---- %@",resultstr);
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if(resultstr == nil || [resultstr isEqualToString:@""]){
                [tools disconnectBt];
                [NSThread sleepForTimeInterval:1];
                [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
                [self ShowProgressHUDwithMessage:@"读取身份证信息失败，请重试"];
        
                failStat = YES;
        //        [result release];
        
        //        tools = nil;
                return;
        
        
        return;
        
    }else{
        failStat = YES;
        [tools disconnectBt];
        [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
        [NSThread sleepForTimeInterval:1];
  
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
          NSString *name = [xmldictionary valueForKey:@"name"];
            NSString *cardid = [xmldictionary valueForKey:@"idNum"];
          [self fillWebView:name CardId:cardid];
        
     
      [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    }
    

    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
//   [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
};
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
};
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
      [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
      [self ShowProgressHUDwithMessage:@"加载出错"];
};


-(void)dealloc{
    [super dealloc];
    blootDic = nil;
    [tools release];
    
}

@end

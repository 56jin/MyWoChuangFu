//
//  ShowWebVC.m
//  WoChuangFu
//
//  Created by duwl on 12/12/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "ShowWebVC.h"
#import "UrlParser.h"
#import "GTMBase64_My.h"
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "WoSchoolViewController.h"

@interface ShowWebVC ()

@end

@implementation ShowWebVC
@synthesize urlStr;
@synthesize titleStr;
@synthesize titleBar;
@synthesize postData;
@synthesize isPayment;

- (void)dealloc
{
    if(urlStr != nil){
        [urlStr release];
    }
    if(titleStr != nil){
        [titleStr release];
    }
    if(titleBar != nil){
        [titleBar release];
    }
    if(postData != nil){
        [postData release];
    }
    [super dealloc];
}

-(void)loadView
{
    [super loadView];
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[UIColor blackColor];//[ComponentsFactory createColorByHex:@"#F8F8F8"];
    self.view = BackV;
    [BackV release];
    self.navigationController.navigationBarHidden=YES;
}

-(void)backAction
{
    if (self.isLogin) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)homeAction
{
    if (self.isLogin) {
        return;
    }
    if (self.isShow) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initTitleBar
{
    
  
    
    TitleBar* title = [[TitleBar alloc] initWithFramShowHome:self.isLogin ? NO : YES ShowSearch:NO TitlePos: self.isLogin ? middle_position : left_position];
    [title setLeftIsHiden: self.isLogin ? YES : NO];
    if (IOS7){
        title.frame = CGRectMake(0, 20, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
    }
    if(self.titleStr !=nil && self.titleStr.length >0){
        [title setTitle:self.titleStr];
    } else {
        [title setTitle:@"沃创富"];
    }
    title.target = self;
    self.titleBar = title;
    [title release];
    [self.view addSubview:self.titleBar];
    
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

- (NSString*)processPaymentUrl:(NSString*)payUrl
{
    NSLog(@"before processPaymentUrl:%@",payUrl);
    NSMutableString* retUrl = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    //1,按？分隔
    NSArray* allArr = [payUrl componentsSeparatedByString:@"?"];
    if(allArr.count >=2){
        [retUrl appendString:allArr[0]];
        [retUrl appendString:@"?"];
        
        NSArray* allParams = [allArr[1] componentsSeparatedByString:@"&"];
        for(int i=0;i<allParams.count;i++){
            NSArray* oneParam = [allParams[i] componentsSeparatedByString:@"="];
            if(oneParam.count>=2){
                [retUrl appendString:oneParam[0]];
                [retUrl appendString:@"="];
                
                //对＝号左边的参数值进行转码
                [retUrl appendString:[self encodeURL:[oneParam[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                
                [retUrl appendString:@"&"];
            }
        }
    }
    
    MyLog(@"after processPaymentUrl:%@",retUrl);
    return retUrl;
}

- (void)initContentView
{
    CGFloat heiht = [AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-SYSTEM_BAR_HEIGHT;
    if (self.isLogin) {
        [self.view setFrame:CGRectMake(0, 0, [AppDelegate sharePhoneWidth], [AppDelegate sharePhoneHeight] )];
        heiht += 45;
    }
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT+SYSTEM_BAR_HEIGHT, [AppDelegate sharePhoneWidth], heiht)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.frame = CGRectMake(webView.center.x,webView.center.y,0,0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    indicator.frame = CGRectMake(keyWindow.center.x,keyWindow.center.y,0,0);
    
    [webView addSubview:indicator];
    [indicator release];
    
    NSString *UrlStr= [service_url stringByReplacingOccurrencesOfString:@"json" withString:@"appweb"];
    NSURL *url = nil;
    NSString *body = nil;
    if(self.isPayment){//如果支付界面，要进行转码
        url = [NSURL URLWithString:[self processPaymentUrl:self.urlStr]];
    } else {
        url = [NSURL URLWithString:[UrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if(self.postData == nil){
            NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
            if (sessionId == nil)
            {
                sessionId = @"";
            }
            
             body = [NSString stringWithFormat:@"sessionId=%@&destUrl=%@",sessionId,[self encodeURL:self.urlStr]];
//             body = [NSString stringWithFormat:@"&destUrl=%@",[self encodeURL:self.urlStr]];
            
            
            if ([self.urlStr rangeOfString:@"school"].location != NSNotFound
                || [self.urlStr rangeOfString:@"jhllb"].location != NSNotFound
                ) {
                 sessionId = @"";  //临时加
                NSLog(@"这个字符串中有a");
                 body = [NSString stringWithFormat:@"destUrl=%@",[self encodeURL:self.urlStr]];
                
            }
        } else {
            //            [GTMBase64_My stringByEncodingData:[[self.urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]]
            body = self.postData;
        }
    }
    
    NSLog(@"\n\n 请求地址  %@   ---- %@  \n\n",url,[self encodeURL:self.urlStr]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    if(self.isPayment){
        [request setHTTPMethod: @"GET"];
    } else {
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    }
    //    if ([urlStr rangeOfString:@"phoneFee"].location!=NSNotFound)
    //    {
    //        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    //    }else
    //    {
    //        [webView loadRequest: request];
    //    }
    [webView loadRequest: request];
    [request release];
    //    [UrlStr release];
    [self.view addSubview:webView];
    [webView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FIRST = 0;
    [self initTitleBar];
    [self initContentView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [indicator stopAnimating];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSString*str =  [url absoluteString];
    
    
    
//    if ([request.URL.relativeString hasSuffix:@"=a"] || [request.URL.relativeString hasSuffix:@"=b"] ) {
//        [self getMessage];
//        
//        return NO;
//    }
//
    
    
    if ([str rangeOfString:@"wcfsproduct"].location!=NSNotFound)
    {
        NSString *query = url.query;
        NSMutableDictionary * paramsDict = [NSMutableDictionary dictionary];
        NSString *decodeQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange shareRange = [decodeQuery rangeOfString:@"shareurl"];
        if (shareRange.location != NSNotFound &&shareRange.length != 0)
        {
            NSString *shareUrl =  [decodeQuery substringFromIndex:shareRange.location+shareRange.length+1];
            [paramsDict setObject:shareUrl forKey:@"shareurl"];
            decodeQuery = [decodeQuery substringToIndex:shareRange.location-1];
        }
        NSArray *queryParams = [decodeQuery componentsSeparatedByString:@"&"];
        for (NSString *param in queryParams)
        {
            NSArray *paramElement = [param componentsSeparatedByString:@"="];
            [paramsDict setObject:paramElement[1] forKey:paramElement[0]];
        }
//        NSLog(@"img = %@",paramsDict[@"img"]);
//        NSLog(@"name = %@",paramsDict[@"name"]);
//        NSString*str =  [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        if ([str rangeOfString:@"wcfsproduct"].location!=NSNotFound)
//        {
//            NSString *query = url.query;
//            NSMutableDictionary * paramsDict = [NSMutableDictionary dictionary];
//            NSString *decodeQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSRange shareRange = [decodeQuery rangeOfString:@"shareurl"];
//            if (shareRange.location != NSNotFound &&shareRange.length != 0)
//            {
//                NSString *shareUrl =  [decodeQuery substringFromIndex:shareRange.location+shareRange.length+1];
//                [paramsDict setObject:shareUrl forKey:@"shareurl"];
//                decodeQuery = [decodeQuery substringToIndex:shareRange.location-1];
//            }
//            NSArray *queryParams = [decodeQuery componentsSeparatedByString:@"&"];
//            for (NSString *param in queryParams)
//            {
//                NSArray *paramElement = [param componentsSeparatedByString:@"="];
//                [paramsDict setObject:paramElement[1] forKey:paramElement[0]];
//            }
////            NSLog(@"img = %@",paramsDict[@"img"]);
////            NSLog(@"name = %@",paramsDict[@"name"]);
//        }
        id<ISSContent> publishContent = [ShareSDK content:paramsDict[@"name"] defaultContent:nil image:[ShareSDK pngImageWithImage:[UIImage  imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:paramsDict[@"img"]]]]] title:@"沃创富分享挣钱" url:paramsDict[@"shareurl"] description:paramsDict[@"name"] mediaType:SSPublishContentMediaTypeNews];
        //2.调用分享菜单分享
        NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSMS,ShareTypeQQ,ShareTypeQQSpace,ShareTypeTencentWeibo,ShareTypeSinaWeibo,nil];
        [ShareSDK showShareActionSheet:nil shareList:shareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            //如果分享成功
            if (state == SSResponseStateSuccess) {
//                NSLog(@"分享成功");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            //如果分享失败
            if (state == SSResponseStateFail) {
//                NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[error errorDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }];
    }
    
    
//    NSLog(@"连接地址   --------- %@",str);
    
    if ([str rangeOfString:@"menuname=woschool"].location!=NSNotFound){
        WoSchoolViewController * WoSchoolView = [[WoSchoolViewController alloc]init];
        WoSchoolView.hidesBottomBarWhenPushed = YES;
        [WoSchoolView setIsCG:@"2"];
        [self.navigationController pushViewController:WoSchoolView animated:YES];
        
        return NO;
    }
    if(FIRST==0){
        FIRST=1;
        return YES;
    }else{
        if(self.isPayment){
            return  YES;
        } else {
            if ([self isProductDetail:url])
            {
                [UrlParser gotoNewVCWithUrl:[url absoluteString]];
                return NO;
            }
            return YES;
        }
    }
}

- (BOOL)isProductDetail:(NSURL *)url
{
    if (url == nil)
    {
        return NO;
    }
    NSMutableArray *urlCom = [[NSMutableArray alloc] initWithArray:[url pathComponents]];
    NSMutableArray *paramsArr=[[NSMutableArray alloc] initWithArray:[[url query] componentsSeparatedByString:@"&"]];
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] init];
    if([urlCom count] >2)
    {
        if([[urlCom objectAtIndex:[urlCom count]-2] isEqualToString:@"emallorder"]||[[urlCom objectAtIndex:[urlCom count]-2] isEqualToString:@"emallcardorder"])
        {
            if([[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"choiceTreaty.do"]||
               [[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"choiceTreatyDetail.do"]||
               [[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"choicebroadBandDetail.do"]||
               [[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"numbCardDetail.do"]){
                BOOL isDetail = NO;
                for(int i=0;i<paramsArr.count;i++)
                {
                    if([[paramsArr objectAtIndex:i] rangeOfString:@"productId="].length > 0){
                        MyLog(@"productId: %@", [paramsArr objectAtIndex:i]);
                        isDetail = YES;
                    }
                    NSArray* keyV = [[paramsArr objectAtIndex:i] componentsSeparatedByString:@"="];
                    if(keyV.count >1)
                    {
                        [paramsDic setObject:[keyV objectAtIndex:1] forKey:[keyV objectAtIndex:0]];
                    }
                }
                if(isDetail)
                {//详情界面
                    if (![paramsDic[@"productId"] isEqualToString:@"10056"]&&
                        ![paramsDic[@"productId"] isEqualToString:@"30090"]&&
                        ![paramsDic[@"productId"] isEqualToString:@"30010"]&&
                        ![paramsDic[@"productId"] isEqualToString:@"30070"])
                    {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}



@end

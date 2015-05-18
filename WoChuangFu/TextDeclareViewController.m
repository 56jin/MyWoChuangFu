//
//  TextDeclareViewController.m
//  Neighbor
//
//  Created by 1 on 10/17/14.
//  Copyright (c) 2014 ice. All rights reserved.
//

#import "TextDeclareViewController.h"
#import "TitleBar.h"


@interface TextDeclareViewController ()<TitleBarDelegate> {
    
}

@end

@implementation TextDeclareViewController

@synthesize URL = URL;
@synthesize IDString = IDString;
@synthesize shengHuo = shengHuo;
@synthesize isHuDong = isHuDong;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)initTitleBar
{
    TitleBar* title = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:middle_position];
    [title setLeftIsHiden:YES];
    if (IOS7){
        title.frame = CGRectMake(0, 20, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
    }
//    if(self.titleStr !=nil && self.titleStr.length >0){
//        [title setTitle:self.titleStr];
//    } else {
//        [title setTitle:@"沃创富"];
//    }
    [title setTitle:@"沃创富"];
    title.target = self;
   
   
    [self.view addSubview:title];
    [title release];
    
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [AppDelegate shareMyApplication].isSeleat = YES;
    [self.tabBarController setSelectedIndex:2];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleBlackOpaque;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden=NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    
    self.navigationController.navigationBarHidden = YES;
    if ([AppDelegate shareMyApplication].isLogin == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上登录", nil];
        [alert show];
        
    }
    else{
        [AppDelegate shareMyApplication].isSeleat = NO; //已登录
        if (URL) {
            return;
        }
       
        NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
        URL = [NSString stringWithFormat:@"%@/mallwcf/goods?sessionid=%@",service_IPqq,sessionid];
        //去掉左右滚动条
        self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
        //去掉左右滚动条
        self.myWebView.scrollView.showsVerticalScrollIndicator = NO;
        
        NSURL* url = [NSURL URLWithString:URL];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.myWebView loadRequest:request];//加载
        

            
    }

}



- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self initTitleBar];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    self.navigationController.navigationBarHidden = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//
//    if(isHuDong){
//        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:URL]];
//        [self.myWebView loadRequest:request];
//        DLog(@"########%@",IDString);
//         self.title = IDString;
//    }
//    else{
//        [self requestData];
//    }
    
    
//    [self.myWebView loadHTMLString:@" <div class=\"tpc_content\"><div id=\"read_tpc\" class=\"f14 mb10\">□ 记者 马叶星&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <div align=\"center\"><span id=\"att_4824\" class=\"f12\"><span style=\"DISPLAY: inline-block\" id=\"td_att4824\"><img style=\"MAX-WIDTH: 700px; MAX-HEIGHT: 700px\" title=\"点击查看原图\" border=\"0\" src=\"http://www.wjyanghu.com/Public/Upload/article/remote_1305/5_6_3adde894b156966.jpg?69\" alt=\"\" /><\/span><\/span><div style=\"DISPLAY: none\" id=\"menu_att4824\" class=\"pw_menu\"><div style=\"BORDER-BOTTOM: #ffffff 1px solid; BORDER-LEFT: #ffffff 1px solid; PADDING-BOTTOM: 5px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; BACKGROUND: #f3f9fb; BORDER-TOP: #ffffff 1px solid; BORDER-RIGHT: #ffffff 1px solid; PADDING-TOP: 5px\"><p><span class=\"mr10\">图片:3.jpg<\/span><\/p><\/div><\/div><\/div><div align=\"center\"><span id=\"att_4823\" class=\"f12\"><span style=\"DISPLAY: inline-block\" id=\"td_att4823\"><img style=\"MAX-WIDTH: 700px; MAX-HEIGHT: 700px\" title=\"点击查看原图\" border=\"0\" src=\"http://www.wjyanghu.com/Public/Upload/article/remote_1305/5_6_019bf5ccb26235a.jpg?112\" alt=\"\" /><\/span><\/span><div style=\"DISPLAY: none\" id=\"menu_att4823\" class=\"pw_menu\"><div style=\"BORDER-BOTTOM: #ffffff 1px solid; BORDER-LEFT: #ffffff 1px solid; PADDING-BOTTOM: 5px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; BACKGROUND: #f3f9fb; BORDER-TOP: #ffffff 1px solid; BORDER-RIGHT: #ffffff 1px solid; PADDING-TOP: 5px\"><p><span class=\"mr10\">图片:4.jpg<\/span><\/p><\/div><\/div><\/div><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 本报讯 4月2日，全球排名第一的骨科制造商美国史赛克集团正式入驻创生控股有限公司。这是我区\u201c以民引外\u201d招商模式的新探索，标志着又一家世界500强企业落户武进。此举得到了市委、市政府的高度重视，市委书记阎立专程会见了美国史赛克集团总裁、首席执行官Kevin Lobo一行。<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 史赛克创立于1941年，去年销售额达87亿美元。作为全球医疗技术领域的领导者，史赛克向全球提供多样化的创新医疗技术，包括重建植入物、医疗及手术设备、神经技术及脊柱产品。公司连续11年被世界著名杂志《财富》评为\u201c全球最受尊敬企业\u201d之一。<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 创生控股创建于1986年，是我国最悠久的骨科植入物制造企业之一，经过20多年的发展，公司已拥有代理商600多家，授权医院近4000家。无论是生产规模、市场份额，还是销售业绩，创生在中国骨科行业都位居第一，已成为中国最大的骨科产品制造商。<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 一个是骨科行业的中国第一，一个是业内的世界第一，双方在2005年就产生了交集。当年，创生控股与史赛克共同合作生产OEM骨科产品，成为史赛克的中国第一家认证供应商。经过7年多的合作，双方建立了良好的信任基础。为了进一步扩大市场，拓展品牌影响力，双方开始洽谈合作事宜。经过深入交流，最终，美国史赛克公司(Stryker)决定收购创生控股100\\%股权，收购价每股7.5港元，包括创生控股股东钱福卿所持有的61.72\\%股权，总收购额达59亿港元。<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;据悉，作为中国驰名商标、医疗器械行业的民族品牌，史赛克收购创生后，仍将保留创生原有的产品、品牌、市场，包括600多家代理商、近4000家终端客户。<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\u201c创生和史赛克强强联合，犹如给创生未来的发展插上了翅膀。\u201d市委书记阎立在会见时表示，史赛克是国际顶级企业，创生是医疗器械行业的民族品牌，强强联合将在中国医疗器械行业中占据重要的竞争优势，为在全球实现更快增长构筑了一个更高的平台，必将推动常州生物医药产业大发展。\u201c希望史赛克集团加快把尖端技术、优秀企业文化和先进企业制度引入常州，推动民族品牌走向世界。\u201d<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\u201c史赛克集团收购创生，是武进开放型经济发展的又一里程碑。\u201d区委书记、武进国家高新区党工委书记周斌在参加会见时明确表示，将秉承\u201c投资无忧、服务最优\u201d的理念，提供更大支持，创造更好条件，营造更优环境，为史赛克集团在武进发展提供优质高效的服务。<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 市、区领导蔡骏、方国强、臧建中、凌光耀、薛建忠出席活动。<br /><\/div><\/div>" baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)requestData
//{
//    if (nil == AFN) {
//        
////        NSString *URL = [NSString stringWithFormat:@"http://58.216.149.132:10090/?module=%7BappId:%27wxwj%27,id:%27queryWJNewsid%27,param:%7Bid:%22%22%7D%7D"];
////        NSMutableString *URL = [NSMutableString stringWithString:@"http://58.216.149.132:10090/?module=%7BappId:%27wxwj%27,id:%27queryWJNewsid%27,param:%7Bid:%22"];
////        [URL appendString:@"10057"];
////        [URL appendString:@"%22%7D%7D"];
////         NSLog(@"id  ----- %@    --- %@",IDString,URL);
//        
//        
////        NSString *URL = [NSString stringWithFormat:@"%@%@%@",@"http://58.216.149.132:10090/?module=%7BappId:%27wxwj%27,id:%27queryWJNewsid%27,param:%7Bid:%22",IDString,@"%22%7D%7D"];
//        DLog(@"加载地址   -- %@",URL);
//
//        AFN = [AFNecService new];
//        AFN.delegate = self;
//        [AFN AFNecServiceWithRequest:nil WithHUD:@"正在加载..." WithURL: URL];
//    }
//    
//   
//}

//#pragma AFNdelegate  mothle
//- (void)requstSuccess:(NSMutableDictionary *)requestDic{
//    
//    DLog(@"GCD 加载数据 \n\n  %@ ",requestDic);
//    AFN.delegate = nil;
//    AFN = nil;
//    
//     BOOL requst = (BOOL) [requestDic objectForKey:@"success"];
//    
//    if (requst) {
//        
//       
//        
//        NSString *string = [[requestDic objectForKey:@"data"] objectForKey:IDString ? @"message":@"content"];
//        string = [string stringByReplacingOccurrencesOfString:@"[" withString:@"<"];
//        string = [string stringByReplacingOccurrencesOfString:@"]" withString:@">"];
//        
//        if(IDString){
//            
//            [self filterHTML:string];
//            
//            
//            
//            [self.myWebView loadHTMLString:string baseURL:nil];
//            self.title = IDString;
//        }else{
//            
//            string = [string stringByReplacingOccurrencesOfString:@"/Public/Upload/" withString:@"http://www.wjyanghu.com/Public/Upload/"];
//            DLog(@"带图片地址：%@",string);
//            [self filterHTML:string];
//            [self.myWebView loadHTMLString:string baseURL:nil];
//            self.title = shengHuo ? shengHuo : [[requestDic objectForKey:@"data"] objectForKey:@"title"];
//        }
//        
//    }
//    else{
//        
//        [SVProgressHUD show];
//        [SVProgressHUD showErrorWithStatus:@"服务器返回数据为空"];
//        
//    }
//
//
//    
//    
//}
//
//- (void)requstFailed:(NSMutableDictionary *)requestDic{
//    DLog(@"GCD 加载数据失败 \n\n   ");
//    AFN.delegate = nil;
//    AFN = nil;
//    
//    //    dispatch_async(dispatch_get_main_queue(), ^{
//    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络链接失败，请检测网络设置" delegate:self cancelButtonTitle:Nil otherButtonTitles:@"OK", nil];
//    [alert show];
//    
//}


//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    
////    if(isHuDong){
////        return;
////    }
//    // finished loading, hide the activity indicator in the status bar
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'"];
//    
//    //字体大小
//    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '350%'"];
//    //字体颜色
//    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
//    //页面背景色
////    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='black'"];
//
//}


-(NSString *)filterHTML:(NSString *)html
{
//    两种方法
//    NSRange range;
//    NSString *string = html;
//    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
//        string=[string stringByReplacingCharactersInRange:range withString:@""];
//    }
//    NSLog(@"Un block string : %@",string);
    
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
//    NSString * regEx = @"<([^>]*)>";
//    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    
//    DLog(@"解析HTML格式数据后：%@",html);
    return html;
}

@end

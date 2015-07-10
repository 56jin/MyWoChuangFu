//
//  JiGouWebViewControler.m
//  WoChuangFu
//
//  Created by 陈 贵邦 on 15-5-27.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "JiGouWebViewControler.h"
#import "TitleBar.h"
@interface JiGouWebViewControler ()<TitleBarDelegate>

@end

@implementation JiGouWebViewControler
@synthesize URL = URL ;
@synthesize webView;
- (void)viewDidLoad {
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
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
    titleBar.title = @"加入机构";
    titleBar.frame = CGRectMake(0,20, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    titleBar.target = self;
    if ([AppDelegate shareMyApplication].isSeleat == YES) {
//        NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
        
        //        NSLog(@"%@",sessionid);
        
//        URL = [NSString stringWithFormat:@"%@/mallwcf/goods?flag=1&sessionid=%@",service_IPqq,sessionid];
            URL = [NSString stringWithFormat:@"%@/userSettingwcf/toJoinOrg",service_IPqq];

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
    
     URL = [NSString stringWithFormat:@"%@/userSettingwcf/toJoinOrg",service_IPqq];
    //去掉左右滚动条
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    //去掉左右滚动条
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
    NSURL* url = [NSURL URLWithString:URL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载

    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

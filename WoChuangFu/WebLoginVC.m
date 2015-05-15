//
//  WebLoginVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/11/13.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "WebLoginVC.h"

@interface WebLoginVC ()

@end

@implementation WebLoginVC


@synthesize Url;

- (void)dealloc
{
    [self.Url release];
    [super dealloc];
}

-(void)loadView
{
    [super loadView];
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[ComponentsFactory createColorByHex:@"#F4F4F4"];
    self.view = BackV;
    [BackV release];
    self.title=@"沃创富";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 8, 28, 28);
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"back-on.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    [self LayoutV];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)LayoutV
{
    UIWebView *viewWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height-44)];
    viewWeb.scalesPageToFit = YES;
    viewWeb.delegate=self;
    
  //  NSURL* url = [NSURL URLWithString:[self.Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   // NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wcf.gx10010.com/user/userpage/"]];
    [viewWeb loadRequest:request];
    [self.view addSubview: viewWeb];
    [viewWeb release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"hideHeader()"];
    //    [MBProgressHUD hideAllHUDsForView:[AppDelegate shareMyApplication].window animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    [MBProgressHUD hideAllHUDsForView:[AppDelegate shareMyApplication].window animated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

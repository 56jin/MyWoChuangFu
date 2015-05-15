//
//  webVC.m
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-17.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "webVC.h"

@interface webVC ()

@end

@implementation webVC

@synthesize Url;
@synthesize TStr;
@synthesize webType;

- (id)initwithStr:(NSString *)Str title:(NSString *)TitleStr withType:(NSString *)type{
    if (self = [super init])
    {
        self.Url=Str;
        self.TStr=TitleStr;
        self.webType=type;
    }
    return self;
}

- (void)loadView
{
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[ComponentsFactory createColorByHex:@"#F8F8F8"];
    self.view = BackV;
    [BackV release];
    self.title=self.TStr;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *leftButtonForSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButtonForSearch.frame =  CGRectMake(0, 8, 28, 28);
    [leftButtonForSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButtonForSearch setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButtonForSearch setBackgroundImage:[UIImage imageNamed:@"back-on.png"] forState:UIControlStateHighlighted];
    [leftButtonForSearch addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonForSearch] autorelease];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 8, 28, 28);
    [btn setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"home-on.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    viewWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height-44)];
    viewWeb.scalesPageToFit = YES;
    viewWeb.delegate=self;
//    NSLog(@"%@",self.Url);
    if([self.Url hasSuffix:@"="]){
        self.Url=[NSString stringWithFormat:@"%@%@",self.Url,[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]];
    }
//    NSLog(@"%@",self.Url);
    
    NSURL* url = [NSURL URLWithString:[self.Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [viewWeb loadRequest:request];
    [self.view addSubview: viewWeb];

}

-(void)back
{
    if([self.webType isEqualToString:@"0"]){
        if(viewWeb.canGoBack){
            [viewWeb goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if(viewWeb.canGoBack){
            [viewWeb goBack];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

-(void)backHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.Url=nil;
    self.TStr=nil;
    self.webType=nil;
    [viewWeb release];
    [super dealloc];
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
    NSURL *url = [request URL];
    
    NSLog(@"%@",url);
    return YES;
}

@end

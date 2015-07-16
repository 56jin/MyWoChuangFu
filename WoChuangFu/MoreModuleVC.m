//
//  MoreModuleVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-25.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "MoreModuleVC.h"
#import "TitleBar.h"
#import "ModulesManager.h"
#import "FileHelpers.h"
#import "UrlParser.h"
#import "WoSchoolViewController.h"
#define TITLEBAR_HEIGHT 44
#define MAINCONTENTVIEW_TAG 2000
#define MAIN_CONTENT_VIEW_OFFSET_Y ([[UIScreen mainScreen] applicationFrame].origin.y + TITLEBAR_HEIGHT)

@interface MoreModuleVC ()<TitleBarDelegate,UIWebViewDelegate>

@end

@implementation MoreModuleVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitleBar];
    [self initMainContentView];
    [self addItem];
}

- (void)loadView
{
    UIView *bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor blackColor];
    self.view = bgView;
    
    
}

- (void)initTitleBar
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:middle_position];
    titleBar.frame = CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
    titleBar.target = self;
    titleBar.title= @"更多";
    [self.view addSubview:titleBar];
}

- (void)initMainContentView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                             MAIN_CONTENT_VIEW_OFFSET_Y,
                                                                             [AppDelegate sharePhoneWidth],
                                                                             [AppDelegate sharePhoneHeight]-MAIN_CONTENT_VIEW_OFFSET_Y
                                                                              )];
    scrollView.tag = MAINCONTENTVIEW_TAG;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
}

- (void)addItem
{
    ModulesManager *manager = [ModulesManager shareManager];
    NSArray *modules = manager.modulesList;
    if (modules != nil && [modules count] != 0)
    {
        int itemCount = [modules count];
        float itemWidth = [AppDelegate sharePhoneWidth]/4.0f;
        float itemHeight = 95.0f;
        UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:MAINCONTENTVIEW_TAG];
        for (int i = 0; i<itemCount; i++)
        {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((i%4)*itemWidth,(i/4)*itemHeight,itemWidth,itemHeight)];
            bgView.layer.borderWidth = 0.5;
            bgView.layer.borderColor = [[ComponentsFactory createColorByHex:@"#eeeeee"]CGColor];
            bgView.backgroundColor = [UIColor clearColor];
            [scroll addSubview:bgView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.frame.size.width-35)/2,25,35,35)];
            NSString* strURL = [[modules objectAtIndex:i] objectForKey:@"imgUrl"];
            [bgView addSubview:imageView];
            if (hasCachedImage([NSURL URLWithString:strURL]))
            {
                UIImage *image = [UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:strURL])];
                imageView.image = image;
            }
            else
            {
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strURL,@"url",nil];
                [ComponentsFactory dispatch_process_with_thread:^{
                    UIImage* ima = [self LoadImage:dic];
                    return ima;
                } result:^(UIImage *ima){
                    imageView.image = ima;
                }];
            }
            UILabel* name = [[UILabel alloc] init];
            name.frame = CGRectMake(0,imageView.frame.origin.y+imageView.frame.size.height+5,bgView.frame.size.width,20);
#ifdef __IPHONE_6_0
            [name setTextAlignment:NSTextAlignmentCenter];
#else
            [name setTextAlignment:UITextAlignmentCenter];
#endif
            [name setFont:[UIFont boldSystemFontOfSize:14.0]];
            name.backgroundColor = [UIColor whiteColor];
            name.textColor = [ComponentsFactory createColorByHex:@"#666666"];
            name.text = [[modules objectAtIndex:i] objectForKey:@"name"];
            [bgView addSubview:name];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.text = [[modules objectAtIndex:i] objectForKey:@"clickUrl"];
            button.frame =bgView.bounds;
            [bgView addSubview:button];
        }
        int rowCount = (itemCount%4==0)?itemCount/4:(itemCount/4+1);
        scroll.contentSize = CGSizeMake([AppDelegate sharePhoneWidth],rowCount*itemHeight);
    }
}

- (void)btnClicked:(UIButton *)sender
{
    UIButton* clickBtn = (UIButton*)sender;
    NSString* clickUrl = clickBtn.titleLabel.text;
    if(clickUrl != nil && clickUrl.length >0)
    {
        [UrlParser gotoNewVCWithUrl:clickUrl VC:self];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"读取url失败！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(UIImage *)LoadImage:(NSDictionary*)aDic{
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"url"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];

    [fileManager createFileAtPath:pathForURL(aURL) contents:data attributes:nil];

    return image;
}




-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSString*str =  [url absoluteString];
    if ([str rangeOfString:@"menuname=woschool"].location!=NSNotFound){
        WoSchoolViewController * WoSchoolView = [[WoSchoolViewController alloc]init];
        WoSchoolView.hidesBottomBarWhenPushed = YES;
        [WoSchoolView setIsCG:@"2"];
        [self.navigationController pushViewController:WoSchoolView animated:YES];
        
        return NO;
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}



#pragma mark
#pragma mark - TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

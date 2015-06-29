//
//  SendOrderVC.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/10.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SendOrderVC.h"
#import "TitleBar.h"
#import "SendOrderView.h"
#import "PhotoCertIDVC.h"
#import "ShowOpenUserFlowVC.h"

@interface SendOrderVC ()<TitleBarDelegate,SendOrderViewDelegate>

@end

@implementation SendOrderVC

- (void)dealloc
{
    [super dealloc];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    self.view = rootView;
    [rootView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO
                                                     ShowSearch:NO
                                                       TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"派单开户";
    titleBar.target = self;
    titleBar.frame = CGRectMake(0,20, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    [titleBar release];
    
    SendOrderView *sendOrderView = [[SendOrderView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT+20, self.view.frame.size.width, self.view.frame.size.height-TITLE_BAR_HEIGHT-20)];
    sendOrderView.delegate = self;
    sendOrderView.backgroundColor = [ComponentsFactory createColorByHex:@"#F0F0F0"];
    [self.view addSubview:sendOrderView];
    [sendOrderView release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - SendOrderViewDelegate
- (void)didGoToPhotoView:(NSDictionary *)data
{
    PhotoCertIDVC *idVC = [[PhotoCertIDVC alloc] init];
    idVC.orderInfo = data;
    [self.navigationController pushViewController:idVC animated:YES];
    [idVC release];
}

- (void)didGoToFlowVC:(NSDictionary *)flowData
{
    ShowOpenUserFlowVC *VC = [[ShowOpenUserFlowVC alloc] init];
    VC.orderDic = flowData;
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
}

@end

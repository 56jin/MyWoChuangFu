//
//  WoSchoolViewController.m
//  WoChuangFu
//
//  Created by 陈亦海 on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "WoSchoolViewController.h"
#import "RFSegmentView.h"
#import "TitleBar.h"

@interface WoSchoolViewController ()<RFSegmentViewDelegate,TitleBarDelegate> {
    UITableView *myTabView;
    UIView *oldView;  //老宽带用户
    UIScrollView *myScrollView; //新宽带用户页面
    UIView *allView;
}

@end

@implementation WoSchoolViewController

-(void)loadView {
    [super loadView];
//    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (allView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,20, self.view.frame.size.width,self.view.frame.size.height)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        allView = view;
        [self.view addSubview:allView];
        [view release];
    }

   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"沃校园办理";
    titleBar.frame = CGRectMake(0,0, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [allView addSubview:titleBar];
    titleBar.target = self;
    [titleBar release];

    
    
    RFSegmentView* segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(40, 40, 240, 60) items:@[@"新装宽带用户",@"老宽带用户"]];
    segmentView.tintColor = [ComponentsFactory createColorByHex:@"#ff7e0c"];
    segmentView.delegate = self;
    [allView addSubview:segmentView];
    [segmentView release];
    
    [self initWithNewView]; //新装宽带用户页面
    [self initWithOldView]; //老宽带用户页面
    // Do any additional setup after loading the view.
}

#pragma mark-    新装宽带用户页面
- (void)initWithNewView {
    
}
#pragma mark-    老宽带用户页面
- (void)initWithOldView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [super dealloc];
    
}

#pragma mark - RFSegmentViewDelegate 分段选择
- (void)segmentViewSelectIndex:(NSInteger)index
{
    NSLog(@"current index is %d",index);
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

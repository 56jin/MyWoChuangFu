//
//  ScanCodeController.m
//  WoChuangFu
//
//  Created by 陈贵邦 on 15/7/6.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ScanCodeController.h"
#import "TitleBar.h"
#import <CoreBluetooth/CoreBluetooth.h>
//#import "BlueToothDCAdapter.h"

#import "3Des.h"
#import <BLEIDCardReaderItem/BLEIDCardReaderItem.h>
#import "GDataXMLNode.h"
#import "ZSYPopListView.h"
#import "ReadBlueTool.h"

@interface ScanCodeController ()<TitleBarDelegate>{
    UIView *mainView;
    BleTool *bletool;
    ReadBlueTool *read ;
}

@end

@implementation ScanCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.tag = 1000;
    [self.view addSubview:mainView];
    [self inittitleBar];
    // Do any additional setup after loading the view.
    
//    read = [[ReadBlueTool alloc]init];
//    
// 
//    
//    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 20, 20)];
//    btn.backgroundColor = [UIColor blackColor];
//    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:btn];
//    
//    
//    
//    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(200, 300, 20, 20)];
//    btn2.backgroundColor = [UIColor blackColor];
//    [btn2 addTarget:self action:@selector(btn2) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn2];
    
    
    UIImageView *codeView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"code2.png"]];
    
    codeView.frame = CGRectMake(0, 0, self.view.frame.size.width-50, mainView.frame.size.height-140);
    codeView.center = CGPointMake(mainView.center.x, mainView.center.y-50);
    
    
    codeView.layer.cornerRadius  = 10;
    codeView.layer.shadowColor   = [UIColor blackColor].CGColor;
    codeView.layer.shadowOffset  = CGSizeMake(0, 5);
    codeView.layer.shadowOpacity = 0.5f;
    codeView.layer.shadowRadius  = 10.0f;
    
    
    [mainView addSubview:codeView];
    
}

-(void)btn{
    [read searchBlueTool:^(NSMutableArray *searchResultArr) {
        NSLog(@"收到的蓝牙%@",searchResultArr);
        
    }];
}

-(void)btn2{
    [read getMessage:^(NSDictionary *dic) {
        NSLog(@"读到的信息%@",dic);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)inittitleBar{
    self.navigationController.navigationBarHidden = YES;
    TitleBar *titleBar = [[TitleBar alloc]initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    CGRect tmpFrame = titleBar.frame;
    tmpFrame.origin.y = 20;
    titleBar.frame = tmpFrame;
    titleBar.target = self;
    titleBar.title = @"广西联通官方微信";
    [self.view addSubview:titleBar];
    [titleBar release];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

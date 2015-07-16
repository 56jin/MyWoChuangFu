//
//  ScanCodeController.m
//  WoChuangFu
//
//  Created by 陈贵邦 on 15/7/6.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) 

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)




#import "ScanCodeController.h"
#import "TitleBar.h"
#import <CoreBluetooth/CoreBluetooth.h>
//#import "BlueToothDCAdapter.h"

#import "3Des.h"
#import <BLEIDCardReaderItem/BLEIDCardReaderItem.h>
#import "GDataXMLNode.h"
#import "ZSYPopListView.h"
#import "ReadBlueTool.h"
#import "CoreTextView.h"

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
    
    
    UIImageView *codeView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ewm.jpg"]];
    
    codeView.frame = CGRectMake(0, 0, self.view.frame.size.width-150, 260);//260
    
    
    codeView.center = CGPointMake(mainView.center.x, [[UIScreen mainScreen] bounds].size.height < 500.000000 ?mainView.center.y-100:mainView.center.y-150);
    
    NSLog(@"aaaa    %f",[[UIScreen mainScreen] bounds].size.height);
    NSLog(@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]);

    
//    codeView.layer.cornerRadius  = 10;
//    codeView.layer.shadowColor   = [UIColor blackColor].CGColor;
//    codeView.layer.shadowOffset  = CGSizeMake(0, 5);
//    codeView.layer.shadowOpacity = 0.5f;
//    codeView.layer.shadowRadius  = 10.0f;

    
    CoreTextView *tv = [[CoreTextView alloc]initWithFrame:CGRectMake(0, codeView.frame.origin.y+codeView.frame.size.height+10, codeView.frame.size.width+100, 150)];
    tv.backgroundColor = [UIColor clearColor];
    CGPoint tvcent = tv.center;
    tvcent.x = self.view.frame.size.width/2;
    tv.center = tvcent;
//    NSString *str =@"扫码关注\"广西联通\"官网微信,回复”绑定“，按提示完成电子协议认证，即可广西联通赠送的奖励噢！\n注：根据您办理套餐的不同，奖励的内容也不同。奖品为300M区内流量或10元话费。";
//    tv.text = str;
//    
//
//    tv.font = [UIFont boldSystemFontOfSize:15];
//    tv.textColor = [UIColor grayColor];
//    tv.userInteractionEnabled = NO;

      UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, codeView.frame.origin.y+codeView.frame.size.height+5, codeView.frame.size.width+100, 5)];
    [line setImage:[UIImage imageNamed:@"linec.png"]];
    CGPoint linecent = line.center;
    linecent.x = self.view.frame.size.width/2;
    line.center = linecent;
    
    
    UILabel *jingxin = [[UILabel alloc]initWithFrame:CGRectMake(0, codeView.frame.size.height - 30  , codeView.frame.size.width, 30)];
    jingxin.backgroundColor = [UIColor whiteColor];
    [codeView addSubview:jingxin];
    jingxin.text =  @"扫码认证电子协议";
    jingxin.textAlignment = NSTextAlignmentCenter;
    jingxin.textColor = [UIColor grayColor];
    jingxin.font = [UIFont boldSystemFontOfSize:20];
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    [mainView addSubview:line];
    [mainView addSubview:tv];
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

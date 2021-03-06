//
//  SeachedTermVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/15.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//
#import "UIImage+LXX.h"
#import "SeachedTermVC.h"
#import "CommonMacro.h"
#import "SearchOrderVC.h"
#import "TitleBar.h"
#define MyTextFieldHeight 44



@interface SeachedTermVC ()<UITextFieldDelegate,TitleBarDelegate>

@end

@implementation SeachedTermVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self layoutSubView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    [_orderCode resignFirstResponder];
    [_receiverPhoneNum resignFirstResponder];
    [_certNum resignFirstResponder];
}

-(void)layoutSubView
{
    UIView *textbg = [[UIView alloc]initWithFrame:CGRectMake(0,10, SCREEN_WIDTH, MyTextFieldHeight*3+74)];
    [self.view addSubview:textbg];
    
    textbg.backgroundColor = [UIColor clearColor];
    if (IOS7) {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    } else {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        
    }
    
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:left_position];
    titleBar.title = @"订单查询";
    [titleBar setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    //self.navigationController.view.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
    //    [self.navigationController.view addSubview:titleBar];
    [self.view addSubview:titleBar];
    titleBar.target = self;
    
    
    
    //    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 0.5)];
    //    line1.backgroundColor = [UIColor grayColor];
    //    [textbg addSubview:line1];
    
    UIView *orderCode1= [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, MyTextFieldHeight)];
    _orderCode = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, MyTextFieldHeight)];
    _orderCode.delegate = self;
    _orderCode.placeholder = @"订单号";
    _orderCode.returnKeyType = UIReturnKeyDone;
    _orderCode.backgroundColor = [UIColor whiteColor];
    orderCode1.backgroundColor = [UIColor whiteColor];
    [orderCode1 addSubview:_orderCode];
    
    
    
    UIView *receiverPhoneNum1= [[UIView alloc]initWithFrame:CGRectMake(0, MyTextFieldHeight+10+0.5, SCREEN_WIDTH, MyTextFieldHeight)];
    _receiverPhoneNum = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, MyTextFieldHeight)];
    _receiverPhoneNum.delegate = self;
    _receiverPhoneNum.placeholder = @"收件人手机号码";
    _receiverPhoneNum.returnKeyType = UIReturnKeyDone;
    _receiverPhoneNum.backgroundColor = [UIColor whiteColor];
    receiverPhoneNum1.backgroundColor = [UIColor whiteColor];
    [receiverPhoneNum1 addSubview:_receiverPhoneNum];
    
    
    UIView *certNum3= [[UIView alloc]initWithFrame:CGRectMake(0, MyTextFieldHeight*2+10+1, SCREEN_WIDTH, MyTextFieldHeight)];
    _certNum = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, MyTextFieldHeight)];
    _certNum.delegate = self;
    _certNum.backgroundColor = [UIColor whiteColor];
    _certNum.placeholder = @"入网证件号码";
    _certNum.returnKeyType = UIReturnKeyDone;
    certNum3.backgroundColor = [UIColor whiteColor];
    [certNum3 addSubview:_certNum];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view1.backgroundColor = UIColorWithRGBA(240, 239, 245, 1);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60-64, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH-60, 33)];
    
    UIImage* image = [UIImage resizedImage:@"btn_alter_bg_p"];
    //image = [image stretchableImageWithLeftCapWidth:19 topCapHeight:19];
    [searchBtn setBackgroundImage:image forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchedClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
    
    [self.view addSubview:view1];
    
    [view1 addSubview:certNum3];
    [view1 addSubview:receiverPhoneNum1];
    [view1 addSubview:orderCode1];
    
    [view1 addSubview:view];
    self.view.backgroundColor =[UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //resign keyboard
    [_orderCode resignFirstResponder];
    [_receiverPhoneNum resignFirstResponder];
    [_certNum resignFirstResponder];
    return NO;
}

/**
 按钮点击事件，用来处理按钮点击后的事情。
 此例中用来发送代理，并跳到下个视图
 */
-(void)searchedClicked:(id)sender
{
    if ([_orderCode.text isEqualToString: @""]&&[_certNum.text isEqualToString: @""]&&[_receiverPhoneNum.text isEqualToString: @""]) {
        
        [self ShowProgressHUDwithMessage:@"请输入搜索条件！"];
    }
    else
    {
        SearchOrderVC *se=[[SearchOrderVC alloc] init];
        se.orderCode = self.orderCode.text;
        se.certNum = self.certNum.text;
        se.receiverPhoneNum = self.receiverPhoneNum.text;
        [self.navigationController pushViewController:se animated:YES];
    }
}

#pragma mark - HUD
- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

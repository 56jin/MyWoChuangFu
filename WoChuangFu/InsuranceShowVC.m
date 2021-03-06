//
//  InsuranceShowVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/29.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "InsuranceShowVC.h"
#import "TitleBar.h"
#import "CommonMacro.h"

@interface InsuranceShowVC ()<TitleBarDelegate,HttpBackDelegate>

@property(nonatomic,strong)NSString *orderCode;
@property(nonatomic,strong)UILabel *odNum;
@property (nonatomic,strong)NSDictionary *SendDic;
@end

@implementation InsuranceShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutV];
    
    bussineDataService *bus = [bussineDataService  sharedDataService];
    bus.target = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _userName,@"custName",
                                 _userPhoneNum,@"receiverPhoneNum",
                                 _certNum,@"custCertNum",
                                 _phoneType,@"phoneBrand",
                                 _phoneName,@"phoneModel",
                                 _imeiNub,@"phoneImeiNum",nil];
    [bus creatInsurance:dict];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutV
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:middle_position];
    titleBar.title = @"下单完成";
    [titleBar setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [self.view addSubview:titleBar];
    titleBar.target = self;
    
    UIView *showOrderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UILabel * creatSuc = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-80, 50)];
    creatSuc.text = @"恭喜您下单成功";
    creatSuc.textColor = [UIColor orangeColor];
    
    UILabel *od = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, 70, 30)];
    od.text = @"订单号:";
    od.textColor = [UIColor blackColor];
    
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgview.backgroundColor = UIColorWithRGBA(208, 208, 208, 1);
    showOrderV.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:bgview];
    [bgview addSubview:showOrderV];
    [showOrderV addSubview:creatSuc];
    [showOrderV addSubview:od];
 
}

-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if([[ChoosePackageMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){

    bussineDataService *bus=[bussineDataService sharedDataService];
    _orderCode = bus.rspInfo[@"orderCode"];
    MyLog(@"ordercode的值是%@",_orderCode);
    
    _odNum = [[UILabel alloc]initWithFrame:CGRectMake(100, 115, SCREEN_WIDTH-110, 30)];
    _odNum.text = _orderCode;
    _odNum.textColor = [UIColor orangeColor];
    [self.view addSubview:_odNum];
        }else{
            
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"获取数据异常！";
            }
            if(nil == msg){
                msg = @"获取数据异常！";
            }
            [self showSimpleAlertView:msg];
        }
    }

    }


-(void)requestFailed:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ChoosePackageMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"获取数据失败！";
        }
        if(nil == msg){
            msg = @"获取数据失败！";
        }
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10101
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"重试",nil];
        
    }
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10101){
        if([buttonTitle isEqualToString:@"重试"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [bus creatInsurance:self.SendDic];
        }
    }
}

#pragma mark -
#pragma mark AlertView
-(void)showAlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles,...
{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    id arg;
    va_list argList;
    if(nil != otherButtonTitles){
        va_start(argList, otherButtonTitles);
        while ((arg = va_arg(argList,id))) {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    alert.tag = tag;
    for(int i = 0; i < [argsArray count]; i++){
        [alert addButtonWithTitle:[argsArray objectAtIndex:i]];
    }
    [alert show];
}

-(void)showSimpleAlertView:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
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

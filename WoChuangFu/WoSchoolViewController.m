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
#import "SchoolViewTable.h"
#import <CoreBluetooth/CoreBluetooth.h>
//#import "BlueToothDCAdapter.h"

#import "3Des.h"
#import <BLEIDCardReaderItem/BLEIDCardReaderItem.h>
//#import "ToastView.h"
#import "GDataXMLNode.h"
//#import "MLTableAlert.h"
#import "UIWindow+YUBottomPoper.h"
#import "AddressComBox.h"
#import "ShowWebVC.h"
#import "ZSYPopListView.h"
//#define MainHeight  [[UIScreen mainScreen] bounds].size.height
//#define MainWidth   [[UIScreen mainScreen] bounds].size.width

@interface WoSchoolViewController ()<RFSegmentViewDelegate,TitleBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,HttpBackDelegate,CBCentralManagerDelegate,BR_Callback,UITextFieldDelegate,AddressComBoxDelegate,ZSYPopListViewDelegate,UIAlertViewDelegate> {
    UITableView *myTabView;
    UIView *oldView;  //老宽带用户
    UIScrollView *myScrollView; //新宽带用户页面
    UIView *allView;
    NSMutableArray *tableArray;  //table数据
    NSInteger selectInteger; //记住当前页面是老用户还是新用户  0代表新  1代表老
    
    //    SimCardReader *rwcard; //读身份证号
    CBCentralManager *manager;
//    BlueToothDCAdapter *adapter;
    
//    NSMutableArray *devarry; //存储ble列表蓝牙
    BleTool *bletool;//bleTool对象
    
    BOOL isRead;
    BOOL isReadAgin;
    ZSYPopListView *zsy;
    UILabel *devLabel;  // 显示当前连接的蓝牙设备名称
    NSDictionary *blootDic;  //当前选择的蓝牙设备信息
    BOOL IsKeyBoardHide; //监听键盘
    NSInteger mark;
    NSArray* areaData;
    NSArray *jiedaoData;
    NSString *cityCode;
    NSString *addrCode;
    NSString *resAreaCode;    //地市的resAreaCode
    NSString *addressString;  //街道地址
    NSString *pkgId;          //校验成功标示
    
    NSDictionary *selectDic;   //选中套餐信息
    NSDictionary *iPhoneNumDic;  //校验手机号码类型信息
    NSString *rhPackegeCode;    //获取cf0046返回结果然后上传到cf0026接口
    NSString *codeMSM;  //验证短信成功标示
    NSDictionary *taoCanDic;  //选择套餐信息
    NSInteger flagInteger;   //flagInteger = 0 验证码校验 flagInteger = 1 阅读器校验
    
    BOOL isHuoDong;
    
    
    
    NSString  *myProductId;
    NSString *skuID;
}
@property(nonatomic,retain)NSArray* areaData;
@property(nonatomic,retain)NSArray* jiedaoData;
@property(nonatomic,retain)NSMutableArray* packages;
//@property(nonatomic,retain) SchoolViewTable *schoolviewtable;

@end

@implementation WoSchoolViewController
@synthesize alert;
@synthesize areaData;
@synthesize jiedaoData;
@synthesize params;
@synthesize isChangGui;
//@synthesize schoolviewtable;
@synthesize packages;


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString * message = nil;
    switch (central.state) {
        case 0:
            message = @"初始化中，请稍后……";
            break;
        case 1:
            message = @"设备不支持状态，过会请重试……";
            break;
        case 2:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 3:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 4:
            message = @"尚未打开蓝牙，请在设置中打开……";
            break;
        case 5:
            message = @"蓝牙已经成功开启，稍后……";
            break;
        default:
            break;
    }
    [self ShowProgressHUDwithMessage:message];
}
- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.5];
}

- (void)ShowAlertMyView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

#pragma 请求成功
-(void)requestDidFinished:(NSDictionary *)info{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    NSLog(@"请求吗=========%@",bizCode);
    
    
    
    switch (mark) {
            
            
        case 0:
            if([bizCode isEqualToString:[ChooseAreaMessage getBizCode]]){
                if([oKCode isEqualToString:errCode]){
                    bussineDataService* buss = [bussineDataService sharedDataService];
                    self.areaData = [buss.rspInfo objectForKey:@"areas"];
                    
                    
                    NSLog(@"请求地市信息：%@",buss.rspInfo);
                    
                    
//                    NSLog(@"%@",[[areaData objectAtIndex:2] objectForKey:@"areaName"]);
                    if(self.areaData != nil){
//                        [((UITableView*)[self.view viewWithTag:TABLE_VIEW_TAG]) reloadData];
                    }
                } else {
                    if(nil == msg || [info objectForKey:@"MSG"] == [NSNull null]){
                        msg = @"获取区域数据失败！";
                    }
//                    [self showSimpleAlertView:msg];
                }
            }
            break;
        case 1:
            if([[IndentifyMessage getBizCode] isEqualToString:bizCode])
            {
                
                bussineDataService *bus=[bussineDataService sharedDataService];
                NSLog(@"IndentifyMessage归档信息 ：%@",bus.rspInfo);
                
                NSLog(@"----------- ：%@",[bus.rspInfo objectForKey:@"respCode"]);
                
                if ([bus.rspInfo objectForKey:@"productId"] != [NSNull null]) {
                    
                    if (!myProductId) {
                        myProductId = [bus.rspInfo objectForKey:@"productId"];
                    }
                    
                    
                }
                else {
                    if (!myProductId) {
                         myProductId = @"30670";
                    }
                   
                }
                if ([bus.rspInfo objectForKey:@"skuId"] != [NSNull null]) {
                    
                    if (!skuID) {
                        skuID = [bus.rspInfo objectForKey:@"productId"];
                    }
                    
                    
                }
                
                
                if([[bus.rspInfo objectForKey:@"respCode"] isEqualToString:@"1"])
                {
                    NSLog(@"请求成功信息%@",info);
                    [self getIndentify];
                    
                }
                else
                {
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:bus.rspInfo[@"respDesc"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }

            }
            
            
            
            break;
        case 2:
            if([[GetIndentifyCodeMessage getBizCode] isEqualToString:bizCode])
            {
                bussineDataService *bus=[bussineDataService sharedDataService];
                NSLog(@"验证码信息 ：%@",bus.rspInfo);
                
                NSLog(@"----------- ：%@",[bus.rspInfo objectForKey:@"respCode"]);
                
                if ([bus.rspInfo objectForKey:@"productId"] != [NSNull null]) {
                    
                    if (!myProductId) {
                        myProductId = [bus.rspInfo objectForKey:@"productId"];
                    }
                    
                    
                }
                else {
                    if (!myProductId) {
                        myProductId = @"30670";
                    }
                    
                }
                if ([bus.rspInfo objectForKey:@"skuId"] != [NSNull null]) {
                    
                    if (!skuID) {
                        skuID = [bus.rspInfo objectForKey:@"productId"];
                    }
                    
                    
                }
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:bus.rspInfo[@"respDesc"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }  
            break;
        case 3:
            if([[ComfirmIndentifyMessage getBizCode] isEqualToString:bizCode])
            {
                bussineDataService *bus=[bussineDataService sharedDataService];
                NSLog(@"验证验证码信息 ：%@",bus.rspInfo);
                if([bus.rspInfo[@"respCode"] integerValue] == 1){
                    codeMSM = @"YES";
                }
                
                
                if ([bus.rspInfo objectForKey:@"productId"] != [NSNull null]) {
                    
                    if (!myProductId) {
                        myProductId = [bus.rspInfo objectForKey:@"productId"];
                    }
                    
                    
                }
                else {
                    if (!myProductId) {
                        myProductId = @"30670";
                    }
                    
                }


                if ([bus.rspInfo objectForKey:@"skuId"] != [NSNull null]) {
                    
                    if (!skuID) {
                        skuID = [bus.rspInfo objectForKey:@"productId"];
                    }
                    
                    
                }
                
               
//                if ([myProductId length]==0) {
//                                    }
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:bus.rspInfo[@"respDesc"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 5:
            if([[filterAddressMessage getBizCode] isEqualToString:bizCode])
            {
           
                bussineDataService* buss = [bussineDataService sharedDataService];
                NSLog(@"~~~~~~~~~~~~返回信息%@",buss.rspInfo);

                if ([buss.rspInfo objectForKey:@"addrs"] == nil || [buss.rspInfo objectForKey:@"addrs"] == NULL || (NSNull *)[buss.rspInfo objectForKey:@"addrs"] == [NSNull null]) {
                    [self ShowAlertMyView:@"暂无查询到您输入的地址"];
                    return;
                }
                
                
                
                self.jiedaoData = [buss.rspInfo objectForKey:@"addrs"];
                
                
                NSLog(@"\n\n 街道信息  %@",buss.rspInfo);
                
                SchoolViewTable *schoolviewtable = [[SchoolViewTable alloc]init];
                    schoolviewtable.areArr = jiedaoData;
                    
                    schoolviewtable.handler = ^(NSDictionary *dict){
                        
                         NSLog(@"选择街道信息%@",dict);
                        
                        UITableViewCell *cell2 = (UITableViewCell*) [myTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        UITextField *jiedao = (UITextField*)[cell2 viewWithTag:100];
                        
                        addressString = [dict objectForKey:@"areaName"];
                        jiedao.text = addressString;
                        addrCode = [dict objectForKey:@"areaCode"];
                        
                        
                        
                        
                    };
              
                [self.navigationController pushViewController:schoolviewtable animated:YES];
                
                
                
                
            }
            break;
            
        case 6:
            if([[FilterAddressPackageMessage getBizCode] isEqualToString:bizCode])
            {
//                
                bussineDataService* buss = [bussineDataService sharedDataService];
                packages = [[buss.rspInfo objectForKey:@"broadbandPackage"] objectForKey:@"broadBandPkg"]
                ;
                taoCanDic = [buss.rspInfo objectForKey:@"broadbandPackage"];
                NSLog(@"\n\n  选择套餐信息   %@",buss.rspInfo);
                NSMutableArray *packageArr = [NSMutableArray array];
                for(NSDictionary *dict in packages){
                   
                    
                     NSString *packDesc = [dict objectForKey:@"packDesc"];
                     NSString *packCode = [dict objectForKey:@"packCode"];
                     NSString *packCost = [dict objectForKey:@"packCost"];
                    
                    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:packCode,@"packCode",packCost,@"packCost",packDesc,@"areaName", nil];
                    [packageArr addObject:dict2];
                }
                
                
                SchoolViewTable *schoolviewtable2 = [[SchoolViewTable alloc]init];
                schoolviewtable2.areArr = (NSArray*)packageArr ;
                schoolviewtable2.handler = ^(NSDictionary *dict){
                    
                     NSLog(@"选择套餐信息%@",dict);
                    
                    UITableViewCell *cell2 = (UITableViewCell*) [myTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    UITextField *taocan = (UITextField*)[cell2 viewWithTag:100];
                    taocan.text = [dict objectForKey:@"areaName"];
                    
                    selectDic = [NSDictionary dictionaryWithDictionary:dict];
                    if (iPhoneNumDic && dict) {
                        //调cf0046接口
                        mark = 8;
                        NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
                        [sendDic setValue:dict[@"packCode"] forKey:@"netEssPkgId"];
                        [sendDic setValue:iPhoneNumDic[@"svcNumProperty"][@"net_type"] forKey:@"net_type"];
                        [sendDic setValue:iPhoneNumDic[@"svcNumProperty"][@"product"] forKey:@"phoneEssPkgId"];
                        [sendDic setValue:@"woRh" forKey:@"woRhflag"];
                        [sendDic setValue:@"2" forKey:@"userType"];  //宽带用户类型   1:老号码+老宽带  2:老号码+新宽带
                        
                        NSLog(@"参数：%@",sendDic);
                        
                        bussineDataService *buss=[bussineDataService sharedDataService];
                        buss.target = self;
                        [buss getRHKDInfo:sendDic];
                    }
                   

                    
                    
                };
                [self.navigationController pushViewController:schoolviewtable2 animated:YES];
                
            }
            break;
            
        case 7:
            if([[GetIndentifyCodeMessage getBizCode] isEqualToString:bizCode])
            {
                bussineDataService* bus = [bussineDataService sharedDataService];
                iPhoneNumDic = [NSDictionary dictionaryWithDictionary:bus.rspInfo];
                NSLog(@"\n\n  校验手机号信息   %@    ---  %@",bus.rspInfo,iPhoneNumDic);
                pkgId = bus.rspInfo[@"svcNumProperty"][@"product"];
                if ([bus.rspInfo objectForKey:@"productId"] != [NSNull null]) {
                    
                    if (!myProductId) {
                        myProductId = [bus.rspInfo objectForKey:@"productId"];
                    }
                    
                    
                }
                else {
                    if (!myProductId) {
                        myProductId = @"30670";
                    }
                    
                }
                if ([bus.rspInfo objectForKey:@"skuId"] != [NSNull null]) {
                    
                    if (!skuID) {
                        skuID = [bus.rspInfo objectForKey:@"productId"];
                    }
                    
                    
                }

                

            }
            
            
            break;
        case 8:
            if([[GetRHKDcodeMessage getBizCode] isEqualToString:bizCode])
            {
                bussineDataService* buss = [bussineDataService sharedDataService];
                
                NSLog(@"\n\n  获取融合宽带信息   %@",buss.rspInfo);
                NSString *respCode = buss.rspInfo[@"respCode"];
                if ([respCode integerValue] == 1) {
                    //正确
                    rhPackegeCode = buss.rspInfo[@"rhPackegeCode"];
                }
                else {
                    [self ShowAlertMyView:buss.rspInfo[@"respDesc"]];
                }

              
                
            }
            
            
            break;

            
            
        case 10:
            if([[OpenNetworkUserMessage getBizCode] isEqualToString:bizCode])
            {
                //
                bussineDataService* buss = [bussineDataService sharedDataService];
               
                ;
                NSLog(@"\n\n  校验结果   %@",buss.rspInfo);
                NSString *respCode = buss.rspInfo[@"respCode"];
                if ([respCode integerValue] == 1) {
                    //正确
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定马上下单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上下单", nil];
                    alertView.tag = 288;
                    [alertView show];
                   
//                    [self sureBuyOrder];
                }
                else {
                    [self ShowAlertMyView:buss.rspInfo[@"respDesc"]];
                }
               
                
            }
            break;
        case 11:
            if([[CreateOrderMessage getBizCode] isEqualToString:bizCode])
            {
                //
                bussineDataService* buss = [bussineDataService sharedDataService];
                
                ;
                NSLog(@"\n\n  下单结果   %@",buss.rspInfo);
                
                ShowWebVC *gotoVC = [[ShowWebVC alloc] init] ;
                gotoVC.isShow = @"YES";
                gotoVC.urlStr = [NSString stringWithFormat:@"%@emallcardorder/completion.do?payType=2&orderCode=%@&orderTitle=宽带融合业务&woRhflag=woRh",service_IP,buss.rspInfo[@"orderCode"]];
                [self.navigationController pushViewController:gotoVC animated:YES];

                
                
            }
            break;


            
            
        default:
            break;
    }
    
    
    //调用该就扣
    

    
//    //获取验证码
//    if([[ComfirmIndentifyMessage getBizCode] isEqualToString:bizCode])
//    {
//        bussineDataService *bus=[bussineDataService sharedDataService];
//        NSLog(@"校验结果++++++++++++++ ：%@",bus.rspInfo);
//    }
 
    
}

#pragma 请求失败
-(void)requestFailed:(NSDictionary *)info{
    NSLog(@"请求失败 \n  ..............................  \n %@",info);
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    switch (mark) {
            
            
        case 0:
            if([bizCode isEqualToString:[ChooseAreaMessage getBizCode]]){
                NSLog(@"获取地市失败");
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

            }
            break;
        case 1:
            if([[IndentifyMessage getBizCode] isEqualToString:bizCode])
            {
                
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

            }
            
            
            
            break;
        case 2:
            if([[GetIndentifyCodeMessage getBizCode] isEqualToString:bizCode])
            {
                
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

            }
            
            
            break;
        case 3:
            if([[ComfirmIndentifyMessage getBizCode] isEqualToString:bizCode])
            {
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

            }
            break;
        case 5:
            if([[filterAddressMessage getBizCode] isEqualToString:bizCode])
            {
                
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

                
                
            }
            break;
            
        case 6:
            if([[FilterAddressPackageMessage getBizCode] isEqualToString:bizCode])
            {
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

            }
            break;
            
        case 7:
            if([[GetIndentifyCodeMessage getBizCode] isEqualToString:bizCode])
            {
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

            }
            
            
            break;
        case 8:
            if([[GetRHKDcodeMessage getBizCode] isEqualToString:bizCode])
            {
                
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

                
            }
            
            
            break;
            
            
            
        case 10:
            if([[OpenNetworkUserMessage getBizCode] isEqualToString:bizCode])
            {
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

            }
            break;
        case 11:
            if([[CreateOrderMessage getBizCode] isEqualToString:bizCode])
            {
                                
                if(msg == nil || msg.length <= 0){
                    msg = @"获取数据失败!";
                    [self ShowProgressHUDwithMessage:msg];
                }else {
                    [self ShowProgressHUDwithMessage:msg];
                    
                }

            }
            break;
            
            
            
            
        default:
            break;
    }

    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag == 288 )
    {
        
        if([buttonTitle isEqualToString:@"马上下单"]){
            [self sureBuyOrder];

        }
    }
    
}


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
    }
}


#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    IsKeyBoardHide=NO;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    IsKeyBoardHide=YES;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
//    adapter = [[BlueToothDCAdapter alloc] init];
     bletool =[[BleTool alloc]init:self]; //bletool初始化
    selectInteger = 0;
    flagInteger = 0;
    tableArray = [NSMutableArray array];
    [tableArray addObject:@"地市"];
    [tableArray addObject:@"街道"];
    [tableArray addObject:@"套餐"];
    
//    schoolviewtable = [[SchoolViewTable alloc]init];
    
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"沃校园办理";
    titleBar.frame = CGRectMake(0,0, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [allView addSubview:titleBar];
    titleBar.target = self;
   
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
//    RFSegmentView* segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(40, 40, 240, 60) items:@[@"新装宽带用户",@"老宽带用户"]];
//    segmentView.tintColor = [ComponentsFactory createColorByHex:@"#ff7e0c"];
//    segmentView.delegate = self;
//    [allView addSubview:segmentView];
    
    if([isChangGui isEqualToString:@"2"]) {
        
        UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeBtn.frame = CGRectMake(0, 40, self.view.frame.size.width, 60);
        CGPoint tmpPoint =  modeBtn.center;
        tmpPoint.x = self.view.center.x;
        [modeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        modeBtn.center = tmpPoint;
        [modeBtn setTitle:@"验证码校验" forState:UIControlStateNormal];
        [modeBtn addTarget:self action:@selector(chooseComfirmMode) forControlEvents:UIControlEventTouchUpInside];
        modeBtn.tag = 5004;
        [allView addSubview:modeBtn];
    }
    
    
    
    UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureOrderBtn setBackgroundColor:[UIColor orangeColor]];
    [sureOrderBtn setFrame:(CGRect){10,MainHeight - 70,MainWidth - 20,44}];
    [sureOrderBtn setTitle:@"确认下单" forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
     sureOrderBtn.tag = 3000;
    [sureOrderBtn.layer setMasksToBounds:YES];
    [sureOrderBtn.layer setCornerRadius:4.0];
    [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [sureOrderBtn addTarget:self action:@selector(sureOrderEven:) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:sureOrderBtn];
    [self initWithNewView]; //新装宽带用户页面
    [self initWithOldView]; //老宽带用户页面
    // Do any additional setup after loading the view.
    
    [self sendRequestData];
}

#pragma mark-    新装宽带用户页面
- (void)initWithNewView {
    
    CGFloat allHeight = 0;
    
    myScrollView = [[UIScrollView alloc]initWithFrame:(CGRect){0,[isChangGui integerValue] == 2 ? 90 : 70,MainWidth ,MainHeight - 170}];
    [myScrollView setBackgroundColor:[UIColor clearColor]];
    // 隐藏水平滚动条
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    // 用来记录scrollview滚动的位置
    //    scrollView.contentOffset = ;
    
    // 去掉弹簧效果
    myScrollView.bounces = NO;
    // 增加额外的滚动区域（逆时针，上、左、下、右）
    // top  left  bottom  right
    myScrollView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    
    
    
    if ([isChangGui isEqualToString:@"1"]) {
        UIView *newView = [self viewWith:1 andString:nil];
        [myScrollView addSubview:newView];
        allHeight += CGRectGetHeight(newView.frame);
    }else if([isChangGui isEqualToString:@"2"]){

        //常规验证码校验
        UIView *newView = [self viewWith:2 andString:nil];
        
        //常规阅读器校验
        
        CGRect tmpframe = newView.frame;
        tmpframe.size.height = tmpframe.size.height/2;
        
        UIView *newView2 = [[UIView alloc]initWithFrame:tmpframe];
        newView2.backgroundColor = [UIColor whiteColor];
        
        UILabel *numName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 45, 40)];
        numName.text = @"号码";
        
        [newView2 addSubview:numName];
        
        UITextField *numFiled = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, 250, 40)];
        numFiled.delegate = self;
        numFiled.placeholder = @"请输入手机号";
        numFiled.font = [UIFont systemFontOfSize:15.0f];
        numFiled.returnKeyType = UIReturnKeyDone;
        numFiled.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
        numFiled.tag = 8003;
        [newView2 addSubview:numFiled];
        
        newView.tag = 8000;
        newView2.tag = 8001;
        newView2.hidden = YES;
        
        [myScrollView addSubview:newView];
        [myScrollView addSubview:newView2];
        allHeight += CGRectGetHeight(newView.frame);
        
       
    }
    
    
   

    myTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, allHeight + 20, [UIScreen mainScreen].bounds.size.width, 44*3) style:UITableViewStylePlain ];
    myTabView.delegate = self;
    myTabView.dataSource = self;
    myTabView.bounces= NO;
    myTabView.tag = 9000;
    [myScrollView addSubview:myTabView];
    allHeight += 50 * 3 + 10;
    
    if ([isChangGui integerValue] == 2) {
        UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureOrderBtn setBackgroundColor:[UIColor orangeColor]];
        [sureOrderBtn setFrame:(CGRect){10,allHeight-50 ,MainWidth - 20,44}];
        [sureOrderBtn setTitle:@"身份证识别" forState:UIControlStateNormal];
        [sureOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        sureOrderBtn.tag = 2000;
        [sureOrderBtn.layer setMasksToBounds:YES];
        [sureOrderBtn.layer setCornerRadius:4.0];
        [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [sureOrderBtn addTarget:self action:@selector(sureOrderEven:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:sureOrderBtn];
        [sureOrderBtn setHidden:YES];
        
        
        devLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, allHeight-80, MainWidth-10, 40)];
        devLabel.text = @"您当前暂无连接蓝牙设备，请打开蓝牙";
        [devLabel setFont:[UIFont fontWithName:nil size:13]];
        devLabel.textColor = [self colorWithHexString:@"#b6b6b6"];
        devLabel.tag = 3320;
        [devLabel setHidden:YES];
        
        [myScrollView addSubview:devLabel];
        
        UILabel *devmessage= [[UILabel alloc]initWithFrame:CGRectMake(10, allHeight-10, MainWidth-10, 40)];
        devmessage.text  = @"获取身份证信息前，请将身份证原件放置在阅读器上";
        [devmessage setFont:[UIFont fontWithName:nil size:13]];
        devmessage.textColor = [self colorWithHexString:@"#b6b6b6"];
        [devmessage setHidden:YES];
        devmessage.tag = 3321;
        [myScrollView addSubview:devmessage];
        
        
        
//        allHeight += 44;

    }
    allHeight += 10;
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, allHeight, MainWidth, 300)];
//    view3.backgroundColor = [UIColor blueColor];
    view3.tag = 7011;
    
    int tmp = allHeight;
    allHeight=0;
    
    for (int i = 0 ; i < 3; i++) {
        
        allHeight += 10;
        
        UIView *SFview = [[UIView alloc]init];
        SFview.backgroundColor = [UIColor whiteColor];
        [SFview.layer setMasksToBounds:YES];
        [SFview.layer setCornerRadius:4.0];
        [SFview.layer setBorderWidth:1.0f];
        [SFview.layer setBorderColor:[[UIColor groupTableViewBackgroundColor] CGColor]];
        [SFview setFrame:(CGRect){10,allHeight,MainWidth - 20,50}];
         allHeight += 50;
        
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        [label setTextColor:[self colorWithHexString:@"#363636"]];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = i == 0 ? @"姓名" : i == 1 ? @"身份证" : @"地址";
        [label setFrame:(CGRect){10,0,50,50}];
        [SFview addSubview:label];
        
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectZero];
        text.delegate = self;
       
        text.placeholder = i == 0 ? @"机主姓名" : i == 1 ? @"机主身份证号" :@"详细地址(在报装地址基础上加)";
        
//        if ([isChangGui integerValue] == 2) {
//            text.userInteractionEnabled = i == 2 ? YES : NO;
//        }
        
        
        text.font = [UIFont systemFontOfSize:15.0f];
        text.tag = 4000 + i ;
        [text setBorderStyle:UITextBorderStyleNone];
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;
        text.returnKeyType = UIReturnKeyDone;
        text.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        text.keyboardType = i == 1 ? UIKeyboardTypeNumbersAndPunctuation : UIKeyboardTypeDefault;
        [text setFrame:(CGRect){70,0,MainWidth - 100 ,50}];
//        text.adjustsFontSizeToFitWidth = YES;
        [SFview addSubview:text];
        
        [view3 addSubview:SFview];
        
        
        
    }
    allHeight = tmp;
    
    allHeight += 30;
    
//    myScrollView.frame = CGRectMake(0, 100, MainWidth, allHeight);
    
    [myScrollView addSubview:view3];
    myScrollView.contentSize = CGSizeMake(MainWidth, allHeight+250);
    [allView addSubview:myScrollView];
    
    
}
#pragma mark-    老宽带用户页面
- (void)initWithOldView {
    oldView = [[UIView alloc]init];
    oldView.backgroundColor = [UIColor clearColor];
    [oldView setFrame:(CGRect){0,95,MainWidth ,MainHeight - 180}];
    
    UIView *newView = [self viewWith:3 andString:nil];
    [oldView addSubview:newView];
    
    UIView *SFview = [[UIView alloc]init];
    SFview.backgroundColor = [UIColor whiteColor];
    [SFview.layer setMasksToBounds:YES];
    [SFview.layer setCornerRadius:4.0];
    [SFview.layer setBorderWidth:1.0f];
    [SFview.layer setBorderColor:[[UIColor groupTableViewBackgroundColor] CGColor]];
    [SFview setFrame:(CGRect){0,CGRectGetHeight(newView.frame) + 30,MainWidth - 0,60}];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.text = @"套餐";
    [label setFrame:(CGRect){10,0,50,60}];
    [SFview addSubview:label];
    
    UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureOrderBtn setBackgroundColor:[UIColor clearColor]];
    [sureOrderBtn setFrame:(CGRect){10,8 ,MainWidth - 20,44}];
    [sureOrderBtn setTitle:@"请选择套餐" forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    sureOrderBtn.tag = 6000;
    [sureOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(MainWidth - 220), 0, 0)];
//    [sureOrderBtn.layer setMasksToBounds:YES];
//    [sureOrderBtn.layer setCornerRadius:4.0];
    [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:16 ]];
    [sureOrderBtn addTarget:self action:@selector(sureOrderEven:) forControlEvents:UIControlEventTouchUpInside];
    
    [SFview addSubview:sureOrderBtn];

    
    
    
    [oldView addSubview:SFview];
    
    [allView addSubview:oldView];
    oldView.hidden = YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIView *)viewWith:(NSInteger)integer andString:(NSString *)string {
    //手机验证码页面
    UIView *NumView = [[UIView alloc]initWithFrame:(CGRect){0,0,MainWidth,50 * integer}];
    [NumView setBackgroundColor:[UIColor whiteColor]];
    
    
    for (int i = 0; i < integer; i++) {
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectZero];
        text.delegate = self;
        if (integer == 3) {
            text.placeholder = i == 0 ? @"宽带设备号" : i == 1 ? @"请输入手机号" :@"请输入短信验证码";
        }
        else if (integer == 2) {
            text.placeholder = i == 0 ? @"请输入手机号" : @"请输入短信验证码";
        }
        else if (integer == 1){
            text.placeholder = @"请输入手机号";
            
        }
        
        text.font = [UIFont systemFontOfSize:15.0f];
        text.tag = 1000 + i + integer * 100;
        [text setBorderStyle:UITextBorderStyleNone];
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;
        text.returnKeyType = UIReturnKeyDone;
        text.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [text setFrame:(CGRect){10,50 * i,MainWidth - 100 ,50}];
        [NumView addSubview:text];
        
        if ([isChangGui isEqualToString:@"1"] && integer == 1) {
            continue;
        }
        
        if (i == 0 || i == 2) {
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [label setFrame:(CGRect){0, i == 0 ? 49 : 109,MainWidth,1}];
            [NumView addSubview:label];
            
        }
        
        if(i == 0 && integer == 3) {
            continue;
        }
        
      
        
        UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureOrderBtn setBackgroundColor: (i == 0 && integer ==2) || (i == 1 && integer == 3)  ? [UIColor orangeColor] :[UIColor orangeColor]];
        [sureOrderBtn setFrame:(CGRect){MainWidth - 110,50 *i + 5,100,40}];
        [sureOrderBtn setTitle:(i == 0 && integer ==2) || (i == 1 && integer == 3) ? @"获取验证码" : @"确定" forState:UIControlStateNormal];
        
        [sureOrderBtn setTitleColor: (i == 0 && integer ==2) || (i == 1 && integer == 3)  ? [UIColor whiteColor] : [UIColor whiteColor] forState:UIControlStateNormal];
        [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        sureOrderBtn.tag = 1000 + i + integer * 200;
        [sureOrderBtn.layer setMasksToBounds:YES];
        [sureOrderBtn.layer setCornerRadius:4.0];
        
        
        if ( i == 1 && integer == 3 ) {
            [sureOrderBtn.layer setBorderWidth:1.0f];
             [sureOrderBtn.layer setBorderColor:[[UIColor groupTableViewBackgroundColor] CGColor]];
        }
       
        [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [sureOrderBtn addTarget:self action:@selector(sureOrGetCodeEven:) forControlEvents:UIControlEventTouchUpInside];
        [NumView addSubview:sureOrderBtn];
        
        NumView.tag = 1520;//常规
    }
   
    return NumView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:self];
   

    myTabView.delegate = nil;
    myTabView.dataSource = nil;
    myTabView = nil;
    myScrollView = nil;
    allView = nil;
    oldView = nil;
//    schoolviewtable = nil;
    
    
}

#pragma mark 地市  套餐 点击事件
-(void)labelSelect:(id)sender{
    UIButton *lb = (UIButton*)sender;
    
    
    
    if (lb.tag == 9000) {
        [self selectarea];
            }
}

-(void)selectarea{
    SchoolViewTable *schoolviewtable = [[SchoolViewTable alloc]init];
    schoolviewtable.areArr = areaData;
    schoolviewtable.handler = ^(NSDictionary *dict){
        
        UIButton *btn = (UIButton*)[self.view viewWithTag:9000];
        [btn setTitle:[dict objectForKey:@"result"] forState:UIControlStateNormal];
        cityCode = [dict objectForKey:@"cityCode"];
        NSLog(@"%@",[dict objectForKey:@"result"]);
        
    };
    [self.navigationController pushViewController:schoolviewtable animated:YES];

}



#pragma mark 请求地市
-(void)sendRequestData
{
    
    mark = 0;
    bussineDataService* buss = [bussineDataService sharedDataService];
    buss.target = self;
    
    self.params= [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"",@"title_str",
                                [NSNull null],@"request_data",nil];
    NSDictionary* requestDic = [self.params objectForKey:@"request_data"];
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjectsAndKeys:self.params,@"params",nil];
    if(requestDic == nil || (NSObject*)requestDic == [NSNull null]){
        requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                       paramsDict,@"expand",
                       @"",@"provinceCode",
                       @"",@"cityCode",
                       @"6",@"version",
                       @"",@"countryCode",nil];
    }
    [buss chooseArea:requestDic];
    
}



#pragma mark - 确定1401 与 获取验证码1400
- (void)sureOrGetCodeEven:(id)sender {
    [self.view endEditing:YES];
    UIButton *btn = (UIButton*)sender;
       if (btn.tag == 1400) {
           [self getIdentifyingCode];
    }
    else if(btn.tag == 1401){
        [self comfirmIdentify];
    }else{
        
    }
}

#pragma mark - 确定下单3000 与 身份证识别 2000  6000 是选择套餐
- (void)sureOrderEven:(id)sender {
    [self.view endEditing:YES];
    
    UIButton *btn = (UIButton*)sender;
    if (btn.tag ==2000) {
        [self getUserIDCardInfo];
    }
    else if (btn.tag == 3000){
        [self orderComfirm];
    }
}

#pragma mark - RFSegmentViewDelegate 分段选择
- (void)segmentViewSelectIndex:(NSInteger)index
{
    
    UIButton *btn =  (UIButton*)[self.view viewWithTag:5004];
    [self.view endEditing:YES];
   selectInteger = index;
    NSLog(@"current index is %ld",(long)index);
    switch (index) {
        case 0:
            [btn setHidden:NO];
            myScrollView.hidden = NO;
            oldView.hidden = YES;
            break;
            
        case 1:
            [btn setHidden:YES];
            myScrollView.hidden = YES;
            oldView.hidden = NO;
            break;
            
        default:
            break;
    }
}

#pragma mark - RFSegmentViewDelegate 分段选择

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellStr = @"CellWithIdentifier";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
    if(Cell == nil){
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStr];
        Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.backgroundColor=[UIColor whiteColor];
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 35)];
        lb.backgroundColor = [UIColor clearColor];
        [lb setTextColor:[self colorWithHexString:@"#363636"]];
        lb.tag = 100;
        lb.font = [UIFont systemFontOfSize:15];
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, 200, 35)];
        //        lb.backgroundColor = [UIColor yellowColor];
      
        
        tf.textColor = [UIColor darkTextColor];
        tf.tag = 100;
        tf.font = [UIFont systemFontOfSize:15];
        tf.delegate = self;
        
        AddressComBox *combox = [[AddressComBox alloc] initWithFrame:CGRectMake(50, 5, 260, 35)];
        combox.delegate = self;
        combox.dataSources = self.cardOrderKeyValuelist;
//        combox.layer.borderWidth = 1;
//        combox.layer.borderColor = [[ComponentsFactory createColorByHex:@"#eeeeee"] CGColor];
//        combox.backgroundColor = [UIColor whiteColor];
        
        if (indexPath.row==0) {
//            [Cell addSubview:combox];
             [Cell addSubview:tf];
            [tf setEnabled:NO];
        }
        
        else if (indexPath.row==1) {
            [Cell addSubview:tf];
        }else if(indexPath.row == 2){
             [Cell addSubview:tf];
            [tf setEnabled:NO];
        }
       
    }
    
    
  
    
//    [tableArray addObject:@"地市   请选择地市"];
//    [tableArray addObject:@"街道   请输入小区/街道名称"];
//    [tableArray addObject:@"套餐   请选择套餐"];
    Cell.textLabel.text = tableArray[indexPath.row];
    Cell.textLabel.font = [UIFont systemFontOfSize:15];
    
   UITextField *lb = (UITextField*) [Cell viewWithTag:100];
    
    lb.placeholder = indexPath.row == 0 ? @"请选择地市" : indexPath.row  == 1 ? @"请输入小区/街道名称" :@"请选择套餐";
    return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *numStr = nil;
    if (flagInteger == 0) {
        UITextField *numText = (UITextField *)[myScrollView viewWithTag:  (1000 + [isChangGui integerValue] * 100 ) ];
        numStr = numText.text;
    }else if (flagInteger == 1) {
        UITextField *numText = (UITextField *)[myScrollView viewWithTag:8003];
        numStr = numText.text;
    }
    
    if ([numStr length] <= 0 || numStr == nil || [numStr isEqualToString:@""]) {
        [self ShowAlertMyView:@"请先输入完整手机号码"];
        return;
    }

    if ([numStr length] > 0 && [numStr length] < 11) {
        [self ShowAlertMyView:@"请先输入完整手机号码"];
        return;
    }
    
    
    [self.view endEditing:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0 ) {
        
        SchoolViewTable *schoolviewtable = [[SchoolViewTable alloc]init];
        schoolviewtable.areArr = areaData;
        schoolviewtable.handler = ^(NSDictionary *dict){
            
            NSLog(@"选择地市信息%@",dict);
            
            cityCode = [dict objectForKey:@"areaCode"];
            resAreaCode = [dict objectForKey:@"resAreaCode"];
            UILabel *lb = (UILabel*) [cell viewWithTag:100];
            lb.text = [dict objectForKey:@"areaName"];
        };
        [self.navigationController pushViewController:schoolviewtable animated:YES];
    }else if(indexPath.row == 1){

    }else if(indexPath.row == 2){
        
      
        [self packageRequest];

    }
}

-(void)backAction {
    if (isRead) {
        //断开连接
        [bletool disconnectBt];
        
    }

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - textField 代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
   
    
//    if(textField.tag ==100){
//        UITableViewCell *cell = (UITableViewCell*) [myTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        UITextField *dishitf = (UITextField*)[cell viewWithTag:100];
//        if ([dishitf.text length]==0) {
//            [self ShowProgressHUDwithMessage:@"请选择地市"];
//        }
//        else{
//            
//        }
//        
//    }
    if (textField.tag == 4002 || textField.tag == 4000 || textField.tag == 4001) {
        float Durationtime = 0.5;
        [UIView beginAnimations:@"alt" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:Durationtime];
        
        if([UIScreen mainScreen].bounds.size.height>=568){
            
            [self.view setFrame:CGRectMake(0, -245, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
            
        }else{
            
            [self.view setFrame:CGRectMake(0, -245, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        }
        [UIView commitAnimations];

    }
    
    else if (textField.tag == 1302) {
        
        float Durationtime = 0.5;
        [UIView beginAnimations:@"alt" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:Durationtime];
        
        if([UIScreen mainScreen].bounds.size.height>=568){
            
            [self.view setFrame:CGRectMake(0, -45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
            
        }else{
            
            [self.view setFrame:CGRectMake(0, -45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        }
        [UIView commitAnimations];

        
    }else if(textField.tag == 9001){
    //街道填写
        
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( textField.tag == 4002 || textField.tag == 4000 || textField.tag == 4001 || textField.tag == 1302) {
        
        if(IsKeyBoardHide){
            float Durationtime = 0.3;
            [UIView beginAnimations:@"alt" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:Durationtime];
            
            [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            [UIView commitAnimations];
        }
       
    }
    
    if ( textField.tag == 1100 || textField.tag == 1200 || textField.tag ==  8003){
        
        if ([textField.text length] < 11) {
            [self ShowAlertMyView:@"请输入完整手机号"];
            return;
        }
        
        mark = 7;
        bussineDataService *buss=[bussineDataService sharedDataService];
        buss.target = self;
        NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 textField.text,@"svcNum",
                                
                                 @"1",@"methodType",
                                 nil];
        //发送校验身份证与手机号是否一致
        [buss identifyManeger:SendDic];
        
    }
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ( textField.tag == 1100 || textField.tag == 1200 || textField.tag ==  8003){
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length >= 11 ){
           textField.text = [toBeString substringToIndex:11];
          [textField resignFirstResponder];
            return NO;
            
        }
       
        return YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    
    
    
    if (textField.tag == 100) {
        
        UITableViewCell *cell2 = (UITableViewCell*) [myTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UITextField *dishitf = (UITextField*)[cell2 viewWithTag:100];

        
        
        if ([dishitf.text length] ==0) {
            [self ShowProgressHUDwithMessage:@"请先选择地市"];
        }
        else if ([textField.text length]<2) {
            [self ShowProgressHUDwithMessage:@"请输入至少两个字符"];
        }
        else{
            [self adrrFiterRequest];
        }
        
        
        
    }
   
    
    
    
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)getUserIDCardInfo{
//    [self.view endEditing:YES];
    
    [self getIdCradBtnEvent];
}

//搜索蓝牙设备
- (void)searchBlueTooth{
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    //搜索蓝牙设备
    NSMutableArray *devarry = [[NSMutableArray alloc]init];
    NSArray *arry = [bletool ScanDeiceList:2.0f];
    [devarry addObjectsFromArray:arry];
    if (devarry && devarry != nil && devarry.count > 0) {
        NSLog(@"设备信息 %@",devarry);
        
        for (NSDictionary *dic in arry) {
            if ( dic.count <= 0 || [dic allKeys].count <= 0) {
                [devarry removeObject:dic];
            }
        }
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        
        if(devarry.count <= 0){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您附近没有找到蓝牙读卡器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新搜索", nil];
            alertView.tag = 10108;
            [alertView show];
            
        }else {
            zsy = [[ZSYPopListView alloc]initWitZSYPopFrame:CGRectMake(0, 0, 200, devarry.count  * 55 + 50) WithNSArray:devarry WithString:@"选择蓝牙读卡器类型"];
            zsy.isTitle = NO;
            zsy.delegate = self;
        }

        
        
        
        
    }else {
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您附近没有找到蓝牙读卡器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新搜索", nil];
        alertView.tag = 10108;
        [alertView show];
        
        
    }
    
    
   
    
}

#pragma mark - 选择验证方式
-(void)chooseComfirmMode{
    UIButton *btn = (UIButton*)[self.view viewWithTag:5004];
    [self.view.window  showPopWithButtonTitles:@[@"验证码校验",@"身份证阅读器校验"] styles:@[YUDefaultStyle,YUDefaultStyle,YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        switch (index) {
            case 0:
                
                if ([btn.titleLabel.text isEqualToString:@"身份证阅读器校验"]) {
                      [btn setTitle:@"验证码校验" forState:UIControlStateNormal];
                    [self chooseIdentifyMode:0];
                }
                break;
            case 1:
                
                if ([btn.titleLabel.text isEqualToString:@"验证码校验"]) {
                    [btn setTitle:@"身份证阅读器校验" forState:UIControlStateNormal];
                    [self chooseIdentifyMode:1];
                }
                break;
            default:
                break;
        }
        
    }];

}

#pragma  mark -bletool 's delegate
-(void)BR_connectResult:(BOOL)isconnected{
     [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if(isconnected){
        NSLog(@"\n\n  读取代理1");
        isRead = YES;
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器成功"];
    
        [devLabel setText:[NSString stringWithFormat:@"您当前连接蓝牙设备: %@",blootDic[@"name"] ]];

    }else{
        //链接失败
        NSLog(@"\n\n  读取代理2");
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器失败"];

    }
}

//选择哪个店铺类型
- (void)sureDoneWith:(NSDictionary *)resion{
    
    
    if (zsy) {
        [zsy dissViewClose];
        zsy = nil;
        zsy.delegate = nil;
    }
    
    NSLog(@"获取设备信息%@",resion);
    
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    blootDic = resion ;
    [bletool connectBt:[resion valueForKey:@"uuid"]];
    
    
    
    if (isReadAgin == YES) {
        //        [self getIdCradBtnEvent];
        //         [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        [self performSelector:@selector(getIdCradBtnEvent) withObject:nil afterDelay:0.5];
    }
    
    
    
    
}

- (void)getIdCradBtnEvent {
    [self.view endEditing:YES];
    
    isReadAgin = NO;
    if (!isRead) {
        isReadAgin = YES;
        [self searchBlueTooth]; // 先连接设备
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    
    
    NSDictionary *result=[bletool readIDCardS];//读出来的加密数据 其中baseInfo是加密后的数据，需要用设备对应的key解密。
    
    
    //处理xml字符串，因为返回的xml字符没有根节点，所以此处加上一个根节点，便于GDataXmlNode取xml值
    NSString *resultstr = [result valueForKey:@"baseInfo"];
    NSLog(@"获取身份证信息：---- %@",resultstr);
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if(resultstr == nil || [resultstr isEqualToString:@""]){
        
        [self performSelector:@selector(getShowFail) withObject:nil afterDelay:0.5];
        
        return;
        
    }else{
        
        
        
        
        //        GDataXMLNode 使用方法如下 ，需要在项目中引入GDataXMLNode.h   并且在项目的build setting中的Header Search Paths中添加搜索路径： /usr/include/libxml2
        GDataXMLDocument *xmlroot=[[GDataXMLDocument alloc] initWithXMLString:resultstr options:0 error:nil];
        GDataXMLElement *xmlelement= [xmlroot rootElement];
        NSArray *xmlarray= [xmlelement children];
        NSMutableDictionary *xmldictionary=[NSMutableDictionary dictionary];
        for(GDataXMLElement *childElement in xmlarray){
            NSString *childName= [childElement name];
            NSString *childValue= [childElement stringValue];
            [xmldictionary setValue:childValue forKey:childName];
        }
        
        [xmldictionary valueForKey:@""];
        //        NSString *sexCode= [self SexJudge:[xmldictionary valueForKey:@"sexCode"]];  //性别
        //        NSString *nationCode=[self NationJugde:[xmldictionary valueForKey:@"nationCode"]];  // 民族
        
        UITextField *IDcarText = (UITextField *)[myScrollView viewWithTag:4001 ];
        UITextField *nameText = (UITextField *)[myScrollView viewWithTag:4000 ];
        nameText.text = [xmldictionary valueForKey:@"name"];
        IDcarText.text = [xmldictionary valueForKey:@"idNum"];
       
        
    }
    
    
    
    
//    //    相片解码 start
//    NSData *_decodedImageData=[result objectForKey:@"picBitmap"];
//    if(_decodedImageData!=nil){
//        NSDictionary *imgdecodeDict=[bletool DecodePicFunc:_decodedImageData];
//        NSString *errcode= [imgdecodeDict objectForKey:@"errCode"];
//        
//        if([errcode isEqualToString:@"-1"]){
//            
//            [self ShowProgressHUDwithMessage:@"解码图片失败"];
//            return;
//            
//            
//        }else if([errcode isEqualToString:@"0"]){
//            NSData *imgdecodeData=[imgdecodeDict objectForKey:@"DecPicData"];
//            
//            UIImage *image = [UIImage imageWithData:imgdecodeData];
//            
//            
//            CGSize origImageSize= [image size];
//            CGRect newRect;
//            newRect.origin= CGPointZero;
//            //拉伸到多大
//            newRect.size.width= photoImageView.frame.size.width *2;
//            newRect.size.height= photoImageView.frame.size.height*2;
//            //缩放倍数
//            float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
//            UIGraphicsBeginImageContext(newRect.size);
//            CGRect projectRect;
//            projectRect.size.width =ratio * origImageSize.width;
//            projectRect.size.height=ratio * origImageSize.height;
//            projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
//            projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
//            [image drawInRect:projectRect];
//            UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
//            //压缩比例
//            NSData *smallData=UIImageJPEGRepresentation(small, 1);
//            UIGraphicsEndImageContext();
//            
//            if (smallData) {
//                photoImageView.image  = [UIImage imageWithData:smallData];
//            }
//            
//            
//            
//        }
//        
//    }else{
//        
//        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        //        hud.mode = MBProgressHUDModeText;
//        //        hud.labelText = @"解码图片失败";
//        //        hud.dimBackground = NO;
//        //        hud.removeFromSuperViewOnHide = YES;
//        //        [hud hide:YES afterDelay:2];
//        [self ShowProgressHUDwithMessage:@"解码图片失败"];
//        
//        return;
//        
//    }
//    //    相片解码 end
    
}

- (void)getShowFail {
    [self ShowAlertMyView:@"读取身份证信息失败"];
}


#pragma mark - 确认下单
-(void)orderComfirm{
    
    switch ([isChangGui integerValue]) {
        case 1: //集中促销期
        {
            switch (selectInteger) {
                case 0:  //新带宽
                    
                    [self sureOpenUserIphoneNum];  //先校验再下单
                    
                    
                    break;
                case 1:  //旧用户带宽
                    
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
        case 2:  //常规促销期
        {
            switch (selectInteger) {
                case 0:  //新带宽
                    
                    if (flagInteger == 0) {
                        //先验证手机验证码再校验下单
                        if (!codeMSM || codeMSM == nil) {
                            [self ShowAlertMyView:@"请先验证手机收到的验证码"];
                            return;
                        }

                    }
                    [self sureOpenUserIphoneNum];  //先校验再下单
                    
                    break;
                case 1:  //旧用户带宽
                    
                    break;
                    
                default:
                    break;
            }
        }

            
            break;
            
        default:
            break;
    }
    
    
//    NSLog(@"确认下单");
//    bussineDataService *buss=[bussineDataService sharedDataService];
//    buss.target = self;
//    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
//    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                             session,@"sessionId",
//                             
//                             nil];
//    //发送确认下单请求
//    [buss schoolOrderComfirm:SendDic];
    
}

#pragma mark - 校验手机号码与身份证 mark = 10
- (void)sureOpenUserIphoneNum {
    NSString *numStr = nil;
    if (flagInteger == 0) {
        UITextField *numText = (UITextField *)[myScrollView viewWithTag:  (1000 + [isChangGui integerValue] * 100 ) ];
        numStr = numText.text;
    }else if (flagInteger == 1) {
        UITextField *numText = (UITextField *)[myScrollView viewWithTag:8003];
        numStr = numText.text;
    }
    
    UITextField *IDcarText = (UITextField *)[myScrollView viewWithTag:4001 ];
    if ([numStr length] <= 0 || [numStr isEqualToString:@""]) {
        [self ShowAlertMyView:@"请先输入手机号码"];
        return;
    }
    if ([IDcarText.text length] <= 0 || [IDcarText.text isEqualToString:@""]) {
        [self ShowAlertMyView:@"请先输入身份证号码"];
        return;
    }
    
    mark = 10;
    bussineDataService *buss=[bussineDataService sharedDataService];
    buss.target = self;
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             numStr,@"svcNum",
                             IDcarText.text,@"cDCardId",
                             @"4",@"methodType",
                             nil];
    //发送校验身份证与手机号是否一致
    [buss sureSFZandIphoneNum:SendDic];

    
}


#pragma mark - 确定下单接口 mark = 11
- (void)sureBuyOrder {
    switch ([isChangGui integerValue]) {
        case 1: //集中促销期
        {
            switch (selectInteger) {
                case 0:  //新带宽
                {
                    
                    UITextField *numText = (UITextField *)[myScrollView viewWithTag:1100 ];
                    UITextField *IDcarText = (UITextField *)[myScrollView viewWithTag:4001 ];
                    UITextField *nameText = (UITextField *)[myScrollView viewWithTag:4000 ];
                    UITextField *addressText = (UITextField *)[myScrollView viewWithTag:4002 ];
                    if ([numText.text length] <= 0 || [numText.text isEqualToString:@""]) {
                        [self ShowAlertMyView:@"请先输入手机号码"];
                        return;
                    }
                    if ([IDcarText.text length] <= 0 || [IDcarText.text isEqualToString:@""]) {
                        [self ShowAlertMyView:@"请先输入身份证号码"];
                        return;
                    }
                    if ([nameText.text length] <= 0 || [nameText.text isEqualToString:@""]) {
                        [self ShowAlertMyView:@"请先输入您的姓名"];
                        return;
                    }
                    if ([addressText.text length] <= 0 || [addressText.text isEqualToString:@""]) {
                        [self ShowAlertMyView:@"请先输入您的报装地址"];
                        return;
                    }


                    
                    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
                    
                    NSMutableDictionary *addrInfo = [NSMutableDictionary dictionary];
                    [addrInfo setValue:@"" forKey:@"countryId"];
                    [addrInfo setValue:@"com.ailk.app.mapp.model.req.CF0026Request$AddrInfo" forKey:@"@class"];
                    [addrInfo setValue:resAreaCode forKey:@"cityId"];  //地市的resAreaCode
                    [addrInfo setValue:[NSString stringWithFormat:@"%@%@",addressString,addressText.text] forKey:@"address"];
                    [addrInfo setValue:@"" forKey:@"countryName"];
                    [addrInfo setValue:numText.text forKey:@"phoneNum"];
                    [addrInfo setValue:[NSString stringWithFormat:@"%@%@",addressString,addressText.text] forKey:@"cityName"];  //两个地址一样拼接上选择的街道地址
                    
                    [sendDic setValue:addrInfo forKey:@"addrInfo"];
                    
                    NSMutableDictionary *expand = [NSMutableDictionary dictionary];
                    
                    NSMutableDictionary *broadbrand = [NSMutableDictionary dictionary];
                    [broadbrand setValue:taoCanDic[@"bssProductId"] forKey:@"bssproduct_Id"];
                    [broadbrand setValue:taoCanDic[@"alTypeId"] forKey:@"aLType_Id"];
                    [broadbrand setValue:@"1" forKey:@"bssBandFlag"];
                    [broadbrand setValue:addrCode forKey:@"bssAddr_Id"];  //街道地址的areaCode
                    [broadbrand setValue:taoCanDic[@"usertypeId"] forKey:@"usertype_Id"];
                    [broadbrand setValue:rhPackegeCode forKey:@"rhPackegeCode"];
                    [broadbrand setValue:@"2" forKey:@"isNewUser"];
                    [broadbrand setValue:selectDic[@"packCode"] forKey:@"essPkgId"];
                    
                    [expand setValue:broadbrand forKey:@"broadbrand"];
                    
                    [sendDic setValue:expand forKey:@"expand"];
                    
                    NSMutableDictionary *payInfo = [NSMutableDictionary dictionary];
                    [payInfo setValue:@"1" forKey:@"payWay"];
                    [payInfo setValue:NULL forKey:@"expand"];
                    [payInfo setValue:@"com.ailk.app.mapp.model.req.CF0026Request$PayInfo" forKey:@"@class"];
                    [payInfo setValue:@"2" forKey:@"payType"];
                    
                    [sendDic setValue:payInfo forKey:@"payInfo"];
                    [sendDic setValue:@"com.ailk.app.mapp.model.req.CF0026Request" forKey:@"@class"];
                   
                    
                    NSMutableDictionary *productInfo = [NSMutableDictionary dictionary];
                    [productInfo setValue:@"" forKey:@"modeCode"];
                    [productInfo setValue:@"" forKey:@"invoiceInfo"];
                    [productInfo setValue:@"" forKey:@"fileId"];
                    [productInfo setValue:NULL forKey:@"cardNum"];
                    [productInfo setValue:NULL forKey:@"custType"];
                    [productInfo setValue:IDcarText.text forKey:@"certNum"];  //身份证号
                    [productInfo setValue:nameText.text forKey:@"certName"]; //名字
                    [productInfo setValue:@"" forKey:@"remark"];
                    
                    [productInfo setValue:@"1018" forKey:@"moduleId"];
                    [productInfo setValue:skuID forKey:@"skuId"];//40126
                    [productInfo setValue:NULL forKey:@"period"];
                    [productInfo setValue:@"com.ailk.app.mapp.model.req.CF0026Request$ProductInfo" forKey:@"@class"];
                    [productInfo setValue:pkgId forKey:@"pkgId"]; //校验成功返回
                    [productInfo setValue:myProductId forKey:@"productId"];   //这个值怎么来的
                    [productInfo setValue:NULL forKey:@"woYibaoFlag"];
                    [productInfo setValue:NULL forKey:@"seckillFlag"];

                    
                    [sendDic setValue:productInfo forKey:@"productInfo"];
                    
                    
                    
                    
                    mark = 11;
                    bussineDataService *buss=[bussineDataService sharedDataService];
                    buss.target = self;
                    [buss createOrder:sendDic];
                    
                    
                }
        
                    break;
                case 1:  //旧用户带宽
                    
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
        case 2:  //常规促销期
        {
            switch (selectInteger) {
                case 0:  //新带宽
                {
                    NSString *numStr = nil;
                    
                    switch (flagInteger) {
                        case 0:
                        {
                            UITextField *numText = (UITextField *)[myScrollView viewWithTag:1200 ];
                            numStr = numText.text;
                        }
                            break;
                        case 1:
                        {
                            UITextField *numText = (UITextField *)[myScrollView viewWithTag:8003 ];
                             numStr = numText.text;
                        }
                            break;

                            
                        default:
                            break;
                    }
                    
                    UITextField *IDcarText = (UITextField *)[myScrollView viewWithTag:4001 ];
                    UITextField *nameText = (UITextField *)[myScrollView viewWithTag:4000 ];
                    UITextField *addressText = (UITextField *)[myScrollView viewWithTag:4002 ];
                    
                    if ([numStr length] <= 0 || [numStr isEqualToString:@""]) {
                        [self ShowAlertMyView:@"请先输入手机号码"];
                        return;
                    }
                    if ([IDcarText.text length] <= 0 || [IDcarText.text isEqualToString:@""]) {
                        [self ShowAlertMyView:@"请先输入身份证号码"];
                        return;
                    }
                    if ([nameText.text length] <= 0 || [nameText.text isEqualToString:@""]) {
                        [self ShowAlertMyView:@"请先输入您的姓名"];
                        return;
                    }
                    if ([addressText.text length] <= 0 || [addressText.text isEqualToString:@""]) {
                        [self ShowAlertMyView:@"请先输入您的报装地址"];
                        return;
                    }
                    
                    
                    
                    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
                    
                    NSMutableDictionary *addrInfo = [NSMutableDictionary dictionary];
                    [addrInfo setValue:@"" forKey:@"countryId"];
                    [addrInfo setValue:@"com.ailk.app.mapp.model.req.CF0026Request$AddrInfo" forKey:@"@class"];
                    [addrInfo setValue:resAreaCode forKey:@"cityId"];  //地市的resAreaCode
                    [addrInfo setValue:[NSString stringWithFormat:@"%@%@",addressString,addressText.text] forKey:@"address"];
                    [addrInfo setValue:@"" forKey:@"countryName"];
                    [addrInfo setValue:numStr forKey:@"phoneNum"];
                    [addrInfo setValue:[NSString stringWithFormat:@"%@%@",addressString,addressText.text] forKey:@"cityName"];  //两个地址一样拼接上选择的街道地址
                    
                    [sendDic setValue:addrInfo forKey:@"addrInfo"];
                    
                    NSMutableDictionary *expand = [NSMutableDictionary dictionary];
                    
                    NSMutableDictionary *broadbrand = [NSMutableDictionary dictionary];
                    [broadbrand setValue:taoCanDic[@"bssProductId"] forKey:@"bssproduct_Id"];
                    [broadbrand setValue:taoCanDic[@"alTypeId"] forKey:@"aLType_Id"];
                    [broadbrand setValue:@"1" forKey:@"bssBandFlag"];
                    [broadbrand setValue:addrCode forKey:@"bssAddr_Id"];  //街道地址的areaCode
                    [broadbrand setValue:taoCanDic[@"usertypeId"] forKey:@"usertype_Id"];
                    [broadbrand setValue:rhPackegeCode forKey:@"rhPackegeCode"];
                    [broadbrand setValue:@"2" forKey:@"isNewUser"];
                    [broadbrand setValue:selectDic[@"packCode"] forKey:@"essPkgId"];
                    
                    [expand setValue:broadbrand forKey:@"broadbrand"];
                    
                    [sendDic setValue:expand forKey:@"expand"];
                    
                    NSMutableDictionary *payInfo = [NSMutableDictionary dictionary];
                    [payInfo setValue:@"1" forKey:@"payWay"];
                    [payInfo setValue:NULL forKey:@"expand"];
                    [payInfo setValue:@"com.ailk.app.mapp.model.req.CF0026Request$PayInfo" forKey:@"@class"];
                    [payInfo setValue:@"2" forKey:@"payType"];
                    
                    [sendDic setValue:payInfo forKey:@"payInfo"];
                    [sendDic setValue:@"com.ailk.app.mapp.model.req.CF0026Request" forKey:@"@class"];
                    
                    
                    NSMutableDictionary *productInfo = [NSMutableDictionary dictionary];
                    [productInfo setValue:@"" forKey:@"modeCode"];
                    [productInfo setValue:@"" forKey:@"invoiceInfo"];
                    [productInfo setValue:@"" forKey:@"fileId"];
                    [productInfo setValue:NULL forKey:@"cardNum"];
                    [productInfo setValue:NULL forKey:@"custType"];
                    [productInfo setValue:IDcarText.text forKey:@"certNum"];  //身份证号
                    [productInfo setValue:nameText.text forKey:@"certName"]; //名字
                    [productInfo setValue:@"" forKey:@"remark"];
                    
                    [productInfo setValue:@"1018" forKey:@"moduleId"];
                    [productInfo setValue:skuID forKey:@"skuId"];
                    [productInfo setValue:NULL forKey:@"period"];
                    [productInfo setValue:@"com.ailk.app.mapp.model.req.CF0026Request$ProductInfo" forKey:@"@class"];
                    [productInfo setValue:pkgId forKey:@"pkgId"]; //校验成功返回
                    [productInfo setValue:myProductId forKey:@"productId"];   //这个值怎么来的
                    [productInfo setValue:NULL forKey:@"woYibaoFlag"];
                    [productInfo setValue:NULL forKey:@"seckillFlag"];
                    
                    
                    [sendDic setValue:productInfo forKey:@"productInfo"];
                    
                    
                    
                    
                    mark = 11;
                    bussineDataService *buss=[bussineDataService sharedDataService];
                    buss.target = self;
                    [buss createOrder:sendDic];
                }
                    break;
                    
                case 1:  //旧用户带宽
                    
                    break;
                    
                default:
                    break;
            }
        }
            
            
            break;
            
        default:
            break;
    }
}


#pragma mark - 地址过滤请求 mark = 5
-(void)adrrFiterRequest{
    
    UITableViewCell *cell2 = (UITableViewCell*) [myTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *dishitf = (UITextField*)[cell2 viewWithTag:100];
    NSString * dishi = dishitf.text;
  
    UITableViewCell *cell = (UITableViewCell*) [myTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *jiedaotf = (UITextField*)[cell viewWithTag:100];
    NSString * jiedao = jiedaotf.text;
    mark = 5;
    bussineDataService *buss=[bussineDataService sharedDataService];
    buss.target = self;
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             session,@"sessionId",
                             jiedao,@"addrInfo",
                             dishi ,@"city",
                             @"10",@"maxRows",
                             @"woRh",@"woRhflag",
                             nil];
    
    [buss filterAddress:SendDic];
}

#pragma mark - 套餐选择请求 mark 6
-(void)packageRequest{
//    UITableViewCell *cell2 = (UITableViewCell*) [myTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UITextField *dishitf = (UITextField*)[cell2 viewWithTag:100];
//    NSString * dishi = dishitf.text;
//    
//    UITableViewCell *cell = (UITableViewCell*) [myTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    UITextField *jiedaotf = (UITextField*)[cell viewWithTag:100];
//    NSString * jiedao = jiedaotf.text;
    
    if (!cityCode) {
        [self ShowAlertMyView:@"请先选择地市"];
        return;
    }
    if (!addrCode) {
        [self ShowAlertMyView:@"请先输入小区/街道名称"];
        return;
    }

    
    mark = 6;
    bussineDataService *buss=[bussineDataService sharedDataService];
    buss.target = self;
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             session,@"sessionId",
                             addrCode,@"addrId",
                             cityCode ,@"cityCode",
                             @"7",@"version",
                             @"1018",@"moduleId",
                              @"woRh",@"woRhflag",
                             nil];
   
    [buss filterAddressPackage:SendDic];
    
    
}


#pragma mark 获取验证码 1400
-(void)getIdentifyingCode{
    [self isOrNotNum];
}
#pragma mark - 判断联通号码

-(void)isOrNotNum{
    UITextField *phonenum = (UITextField*)[self.view viewWithTag:1200];
    NSString *phonenumstr = phonenum.text;
    if(!phonenumstr || phonenumstr == nil) {
        [self ShowAlertMyView:@"请先输入手机号码"];
        return;
    }

    //     NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    
    bussineDataService *buss = [bussineDataService sharedDataService];
    buss.target = self;
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             //                             session,@"sessionId",
                             phonenumstr,@"svcNum",
                             @"1",@"methodType",
                             nil];
    mark = 1;
    [buss identifyManeger:SendDic];

}
#pragma mark - 获取验证码
-(void)getIndentify{
    UITextField *phonenum = (UITextField*)[self.view viewWithTag:1200];
    NSString *phonenumstr = phonenum.text;
    //     NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    if(!phonenumstr || phonenumstr == nil) {
        [self ShowAlertMyView:@"请先输入手机号码"];
        return;
    }

    bussineDataService *buss = [bussineDataService sharedDataService];
    buss.target = self;
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             //                             session,@"sessionId",
                             phonenumstr,@"svcNum",
                             @"2",@"methodType",
                             nil];
    mark = 2;
    [buss getIndentifyCode:SendDic];
}


#pragma 验证码确定 1401
-(void)comfirmIdentify{
    UITextField *phonenum = (UITextField*)[self.view viewWithTag:1200];
    NSString *phonenumstr = phonenum.text;
    UITextField *identify = (UITextField*)[self.view viewWithTag:1201];
    NSString *identifyStr = identify.text;
    if(!phonenumstr || phonenumstr == nil) {
        [self ShowAlertMyView:@"请先输入手机号码"];
        return;
    }
    if([identify.text length] <= 0 || identify.text == nil) {
        [self ShowAlertMyView:@"请输入您手机收到的验证码"];
        return;
    }
    
    bussineDataService *buss = [bussineDataService sharedDataService];
    buss.target = self;
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             //                             session,@"sessionId",
                             phonenumstr,@"svcNum",
                             identifyStr,@"yzCode",
                             @"3",@"methodType",
                             nil];
    mark = 3;
    [buss comfirmIndentifyCode:SendDic];
    
    
}


#pragma mark 地址选择代理
- (void)addressComBox:(AddressComBox *)comBoxView didSelectAtIndex:(NSInteger)index withData:(NSDictionary *)data
{
//    self.resAreaCode = data[@"resAreaCode"];
//    [self.addressRequest setObject:data[@"areaName"] forKey:@"city"];
//    [self.packageRequest setObject:data[@"areaCode"] forKey:@"cityCode"];
}

#pragma mark - 设置常规 促销 标示
-(void)setIsCG:(NSString *)misChangGui{
    self.isChangGui  = misChangGui;
}


#pragma mark - 校验方式显示  flag = 0 验证码校验 flag = 1 阅读器校验
-(void)chooseIdentifyMode:(int)flag{
    UIView *yanzhengma = (UIView*)[self.view viewWithTag:8000];
    UIView *yueduqi = (UIView*)[self.view viewWithTag:8001];
    UITableView *tbView = (UITableView*)[self.view viewWithTag:9000];
    CGRect tmpFrame = tbView.frame;
    UIButton *IdRead = (UIButton*)[self.view viewWithTag:2000];
    
    UIView *bottomVew =(UIView*) [self.view viewWithTag:7011];
    CGRect bottomVewtmpFrame = bottomVew.frame;
    
    UILabel *dev = (UILabel*)[self.view viewWithTag:3320];
    UILabel *devmessage = (UILabel*)[self.view viewWithTag:3321];
    
    UITextField *jizhuName = (UITextField*)[self.view viewWithTag:4000];
    UITextField *jizhuID = (UITextField*)[self.view viewWithTag:4001];
    UITextField *jizhuAddr = (UITextField*)[self.view viewWithTag:4002];
    flagInteger = flag;
    if (flag ==0) {
        [yanzhengma setHidden:NO];
        [yueduqi setHidden:YES];
        tmpFrame.origin.y = tmpFrame.origin.y + 65;
        tbView.frame = tmpFrame;
        [IdRead setHidden:YES];
        bottomVewtmpFrame.origin.y -= 5;
        bottomVew.frame = bottomVewtmpFrame;
        [dev setHidden:YES];
        [devmessage setHidden:YES];
        
        [jizhuAddr setUserInteractionEnabled:YES];
        [jizhuID setUserInteractionEnabled:YES];
        [jizhuName setUserInteractionEnabled:YES];
        
        
    }else if (flag == 1)
    {
        
        [yanzhengma setHidden:YES];
        [yueduqi setHidden:NO];
        tmpFrame.origin.y = tmpFrame.origin.y - 65;
        tbView.frame = tmpFrame;
        [IdRead setHidden:NO];
        
        bottomVewtmpFrame.origin.y += 5;
        bottomVew.frame = bottomVewtmpFrame;
        [dev setHidden:NO];
        [devmessage setHidden:NO];
        
        [jizhuAddr setUserInteractionEnabled:YES];
        [jizhuID setUserInteractionEnabled:NO];
        [jizhuName setUserInteractionEnabled:NO];
        
//        [self searchBlueTooth];
        
    }else{
        
    }
    
}


-(UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end



/*
 
 常规期：
 
 
 阅读器校验:
    8003 请输入手机号码
 
 
 验证码校验：
    1200 请输入手机号码
    1201 请输入短信验证码
 */



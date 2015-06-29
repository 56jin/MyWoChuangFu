//
//  PhotoCertIDVC.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/15.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "PhotoCertIDVC.h"
#import "PhotoCertIDView.h"
#import "TitleBar.h"
#import <BLEIDCardReaderItem/BleTool.h>
#import "BLEDeviceListView.h"
#import "GDataXMLNode.h"
#import "bussineDataService.h"
#import "MBProgressHUD.h"

#define ALTER_SHOW_DISCONNECT_TAG       102

#define SMS_PHONE_CENTER                @"13010591500"

@interface PhotoCertIDVC ()<TitleBarDelegate,
                            BLEDeviceListViewDelegate,
                            UIAlertViewDelegate,
                            HttpBackDelegate>
{
    BleTool *adapter;
    PhotoCertIDView *photoView;
    BLEDeviceListView *deviceView;
    UIButton *scanBtn;
    
    BOOL isSearch;
    
    NSDictionary *idInfo;
    
    NSString *iccidStr;
}
@property (nonatomic ,retain)PhotoCertIDView *photoView;
@property (nonatomic ,retain)BleTool *adapter;
@property (nonatomic ,retain)BLEDeviceListView *deviceView;
@property (nonatomic ,retain)UIButton *scanBtn;
@property (nonatomic ,retain)NSDictionary *idInfo;
@property (nonatomic ,retain)NSString *iccidStr;
@end

@implementation PhotoCertIDVC
@synthesize adapter;
@synthesize photoView;
@synthesize deviceView;
@synthesize scanBtn;
@synthesize idInfo;
@synthesize orderInfo;
@synthesize iccidStr;

- (void)dealloc
{
    if (orderInfo != nil) {
        [orderInfo release];
    }
    if (idInfo != nil) {
        [idInfo release];
    }
    if (iccidStr != nil) {
        [iccidStr release];
    }
    [adapter release];
    [photoView release];
    [deviceView release];
    [scanBtn release];
    
    [super dealloc];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    self.view = rootView;
    [rootView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO
                                                     ShowSearch:NO
                                                       TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"蓝牙读取信息";
    titleBar.target = self;
    titleBar.frame = CGRectMake(0,20, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    [titleBar release];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+TITLE_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView release];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(self.view.frame.size.width - 60, (TITLE_BAR_HEIGHT-32)/2.0f, 50, 32);
    commitBtn.backgroundColor = [UIColor clearColor];
    [commitBtn addTarget:self
                  action:@selector(commitClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBar addSubview:commitBtn];
    
    
    //布局视图
    CGFloat width = self.view.frame.size.width;
    UIButton *scanCertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanCertBtn.frame = CGRectMake((width - 150)/2.0f, TITLE_BAR_HEIGHT+50, 150, 40);
    scanCertBtn.backgroundColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    [scanCertBtn setTitle:@"搜索蓝牙设备" forState:UIControlStateNormal];
    [scanCertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanCertBtn addTarget:self
                    action:@selector(scan:)
          forControlEvents:UIControlEventTouchUpInside];
    scanCertBtn.layer.cornerRadius = 5;
    scanCertBtn.layer.borderWidth = 1;
    scanCertBtn.layer.borderColor = [[ComponentsFactory createColorByHex:@"#F96C00"] CGColor];
    self.scanBtn = scanCertBtn;
    [self.view addSubview:scanCertBtn];

    isSearch = YES;
    
    
    PhotoCertIDView *idView = [[PhotoCertIDView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT+120, self.view.frame.size.width, self.view.frame.size.height)];
    idView.hidden = YES;
    self.photoView = idView;
    idView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:idView];
    [idView release];
    
    BLEDeviceListView *listView = [[BLEDeviceListView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT+120, self.view.frame.size.width, self.view.frame.size.height)];
    listView.delegate = self;
    listView.hidden = NO;
    listView.backgroundColor = [UIColor clearColor];
    self.deviceView =  listView;
    [self.view addSubview:listView];
    [listView release];
    
    
    
    BleTool *dcAdapter = [[BleTool alloc] init:self];
    self.adapter = dcAdapter;
    [dcAdapter release];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - BLE 操作
- (NSDictionary *)readCertIDInfo
{
    NSDictionary *result = [self.adapter readIDCardS];
    NSMutableDictionary *itemDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    if (result != nil && [result count] > 0) {
        NSString *resultstr = [result valueForKey:@"baseInfo"];
        GDataXMLDocument *xmlroot=[[GDataXMLDocument alloc] initWithXMLString:resultstr options:0 error:nil];
        GDataXMLElement *xmlelement= [xmlroot rootElement];
        NSArray *xmlarray= [xmlelement children];
        NSMutableDictionary *xmldictionary=[NSMutableDictionary dictionary];
        for(GDataXMLElement *childElement in xmlarray){
            NSString *childName= [childElement name];
            NSString *childValue= [childElement stringValue];
            [xmldictionary setValue:childValue forKey:childName];
        }
        
        [itemDic setObject:[xmldictionary valueForKey:@"address"] forKey:@"address"];
        [itemDic setObject:[xmldictionary valueForKey:@"name"] forKey:@"name"];
        [itemDic setObject:[xmldictionary valueForKey:@"idNum"] forKey:@"idNum"];
        
        [xmlroot release];
    }
    
    return itemDic;
}

- (NSString *)readICCID
{
    NSDictionary *kaikaDict= [self.adapter KaiKa];
    NSMutableString *iccidString = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    if(kaikaDict!=nil){
        NSString *errcode=[kaikaDict objectForKey:@"errCode"];
        if([errcode isEqualToString:@"-1"]){
            NSString *errDesc=[kaikaDict objectForKey:@"errDesc"];
            NSLog(@"%@",errDesc);
        }else{
            NSData *kaikaData=[kaikaDict objectForKey:@"kaikaData"];
            NSString *kaikastr=[[NSString alloc] initWithData:kaikaData encoding:NSUTF8StringEncoding];
            [iccidString appendString:kaikastr];
            [kaikastr release];
        }
    }
    return iccidString;
}

- (BOOL)writeCard:(NSString *)imsiString
{
    //检查卡的类型 0表示2G   1表示3G
    //errCode:1成功 -1 失败
    //isBlank:0 白卡 1非白卡
    BOOL isWriteCardOK = YES;
    [self showHUDWithMSG:@"正在检查卡的类型......"];
    NSDictionary *checkSimBlankDict= [self.adapter CheckSIMisBlank:0];
    if([[checkSimBlankDict valueForKey:@"errCode"] isEqualToString:@"1"]){
        if ([[checkSimBlankDict valueForKey:@"isBlank"] isEqualToString:@"0"]) {
            NSData *imsi2gdata=[checkSimBlankDict objectForKey:@"IMSI2G"];
            NSString *imsi2gStr= [[NSString alloc]initWithData:imsi2gdata encoding:NSUTF8StringEncoding];
            NSLog(@"imsi2gstr===%@",imsi2gStr);
            NSData *imsi2g = [imsiString dataUsingEncoding:NSUTF8StringEncoding];
            [self showHUDWithMSG:@"正在写入IMSI中......"];
//            NSInteger result = [self.adapter WriteSIMCardwithIMSI1:imsi2g
//                                                          andIMSI2:nil];
//            if(result==1){
//                [self showHUDWithMSG:@"正在写入短信中心号......"];
//                result = [self.adapter WriteMsgCenter:SMS_PHONE_CENTER
//                                      withNumberIndex:(Byte)0x01];
//                if (result == 1) {
//                    isWriteCardOK = YES;
//                }else{
//                    isWriteCardOK = NO;
//                }
//            }else{
//                isWriteCardOK = NO;
//            }
            
        }
    }
    
    return isWriteCardOK;
}

- (void)handleBLERequest:(NSInteger)requestValue
{
    NSString *msg = nil;
    switch (requestValue) {
        case 2:
        {
            msg = @"卡未插入";
        }
            break;
        case 3:
        {
             msg = @"不识别的sim卡";
        }
            break;
        case 4:
        {
             msg = @"卡插入但还未初始化";
        }
            break;
        default:
            break;
    }
}

#pragma mark
#pragma mark - UIAction
- (void)scan:(id)sender
{
    if (isSearch) {
        NSArray *deviceList = [self.adapter ScanDeiceList:2.0f];
        if (deviceList != nil && [deviceList count] > 0) {
            self.deviceView.hidden = NO;
            self.photoView.hidden = YES;
            [self.view bringSubviewToFront:self.deviceView];
            
            [self.deviceView reloadViewData:deviceList];
        }else{
            UIAlertView  *alter = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"没有搜索到蓝牙设备"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
            [alter show];
            [alter release];
        }
    }else{
        //读取身份证信息
        self.idInfo = [self readCertIDInfo];
        if (self.idInfo != nil && [self.idInfo count] > 0) {
            [self.photoView reloadViewDataID:[self.idInfo objectForKey:@"idNum"]
                                        Name:[self.idInfo objectForKey:@"name"]
                                     Address:[self.idInfo objectForKey:@"address"]];
        }
        
    }
}


#pragma mark
#pragma mark - TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - BLEDeviceListViewDelegate
- (void)bleDeviceDidSelectbLE:(NSString *)uuid
{
    [self.adapter connectBt:uuid];
}

#pragma mark
#pragma mark - bletool 's delegate
-(void)BR_connectResult:(BOOL)isconnected
{
    if(isconnected){
        self.deviceView.hidden = YES;
        self.photoView.hidden = NO;
        [self.view bringSubviewToFront:self.photoView];
        [self.scanBtn setTitle:@"获取身份证信息"
                      forState:UIControlStateNormal];
        isSearch = NO;
    }else{
        UIAlertView  *alter = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"设备已断开,是否重新搜索设备进行链接?"
                                                        delegate:self
                                               cancelButtonTitle:@"不进行搜索"
                                               otherButtonTitles:@"重新搜索", nil];
        alter.tag = ALTER_SHOW_DISCONNECT_TAG;
        [alter show];
        [alter release];
    }
}

#pragma mark
#pragma mark - UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (ALTER_SHOW_DISCONNECT_TAG == alertView.tag) {
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            self.deviceView.hidden = NO;
            [self.deviceView reloadViewData:nil];
            self.photoView.hidden = YES;
            [self.view bringSubviewToFront:self.photoView];
            [self.scanBtn setTitle:@"搜索蓝牙设备"
                          forState:UIControlStateNormal];
            isSearch = YES;
        }
    }
}

#pragma mark
#pragma mark - MBProgressHUD 操作
- (void)showHUDWithMSG:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
}
- (void)hideCurrentHUD
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

#pragma mark
#pragma mark - UIAction
- (void)commitClicked:(id)sender
{
    [self showHUDWithMSG:@"正在读取SIM卡号......"];
    NSString *iccidString = [self readICCID];
    [self hideCurrentHUD];
    if (iccidString != nil && ![iccidString isEqualToString:@""]) {
        self.iccidStr = iccidString;
        [self showHUDWithMSG:@"正在提交信息....."];
        [self sendCommitOpenUserMessage];
    }
    
}

#pragma mark
#pragma mark - Send HttpMessage
- (void)sendCommitOpenUserMessage
{
    NSDictionary *requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [self.orderInfo objectForKey:@"orderCode"],@"orderCode",
                                self.iccidStr,@"ICCID",
                                [self.idInfo objectForKey:@"name"],@"custName",
                                [self.idInfo objectForKey:@"idNum"],@"custNo",
                                [self.idInfo objectForKey:@"address"],@"custAddr",nil];
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService commitOpenUser:requestDic];
    [requestDic release];
}

- (void)sendSuessOpneUserMessage:(BOOL)isOk
{
    NSString *status = nil;
    if (isOk) {
        status = @"0";
    }else{
        status = @"1";
    }
    NSDictionary *requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                self.iccidStr,@"iccid",
                                status,@"status",nil];
    
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService suessCommitOpenUser:requestDic];
    [requestDic release];
}


#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errorCode = [info objectForKey:@"errorCode"];
    if ([bizCode isEqualToString:[CommitOpenUserMessage getBizCode]]) {
        [self hideCurrentHUD];
        if ([errorCode isEqualToString:@"0000"]) {
            bussineDataService *bussineService = [bussineDataService sharedDataService];
            NSDictionary *rspInfo = bussineService.rspInfo;
            NSString *respCode = [rspInfo objectForKey:@"respCode"];
            NSString *respDesc = [rspInfo objectForKey:@"respDesc"];
            
//            返回0成功，进行写卡;
//            返回1不成功，不写卡，不调44接口;
//            返回2表示已开户写卡，调44接口提交资料
            
//            if ([respCode isEqualToString:@"0"]) {
                NSString *imsi = [rspInfo objectForKey:@"imsi"];
                BOOL isWriteCard = [self writeCard:imsi];
                [self showHUDWithMSG:@"正在开户中......"];
                [self sendSuessOpneUserMessage:isWriteCard];
//            }else if ([respCode isEqualToString:@"1"]) {
//                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:respDesc
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//                [alter show];
//                [alter release];
//            }else if([respCode isEqualToString:@"2"]) {
//                [self showHUDWithMSG:@"正在开户中......"];
//                [self sendSuessOpneUserMessage:YES];
//            }
            
        }
    }else if ([bizCode isEqualToString:[SueccOpenUserMessage getBizCode]]) {
        [self hideCurrentHUD];
        if ([errorCode isEqualToString:@"0000"]) {
            bussineDataService *bussineService = [bussineDataService sharedDataService];
            NSDictionary *rspInfo = bussineService.rspInfo;
            NSString *respCode = [rspInfo objectForKey:@"respCode"];
            NSString *respDesc = [rspInfo objectForKey:@"respDesc"];
            if ([respCode isEqualToString:@"0"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"开卡成功"
                                                                message:respDesc
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alter show];
                [alter release];
            }else{
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"开卡失败"
                                                                message:respDesc
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alter show];
                [alter release];
            }
        }
    }
    
}

- (void)requestFailed:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* MSG = [info objectForKey:@"MSG"];
    if ([bizCode isEqualToString:[CommitOpenUserMessage getBizCode]]) {
        [self hideCurrentHUD];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:MSG
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alter show];
        [alter release];
    }else if ([bizCode isEqualToString:[SueccOpenUserMessage getBizCode]]) {
        [self hideCurrentHUD];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:MSG
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alter show];
        [alter release];
    }
}

@end

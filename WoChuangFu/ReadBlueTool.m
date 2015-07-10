//
//  ReadBlueTool.m
//  WoChuangFu
//
//  Created by 陈贵邦 on 15/7/7.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ReadBlueTool.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <BLEIDCardReaderItem/BLEIDCardReaderItem.h>
#import "ZSYPopListView.h"
#import "GDataXMLNode.h"
@interface  ReadBlueTool()<BR_Callback,CBCentralManagerDelegate,ZSYPopListViewDelegate>{
    BleTool *bletool;
    NSMutableArray *deviceArr;
    ZSYPopListView *zsy;
}
@end

@implementation ReadBlueTool
@synthesize iDcardMessageBlock,resutlOrSearchBlock,connectToBlueToolsBlock;

-(instancetype)init
{
    self = [super init];
    if (self) {
        bletool = [[BleTool alloc]init:self];
        deviceArr = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)searchBlueTool :(ResutlOrSearchBlock)searchResultBlock{
//    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    //搜索蓝牙设备
    NSMutableArray *devarry = [[NSMutableArray alloc]init];
    
    NSArray *arry  = nil;
    int count = 0;
    
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    while ([arry count]==0&&count<4) {
       arry = [bletool ScanDeiceList:2.0f];
        count++;
    }
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    [deviceArr addObjectsFromArray:arry];
    [devarry addObjectsFromArray:arry];
    if (devarry && devarry != nil && devarry.count > 0) {
        NSLog(@"设备信息 %@",devarry);
        
        for (NSDictionary *dic in arry) {
            if ( dic.count <= 0 || [dic allKeys].count <= 0) {
                NSLog(@"移除信息 ");
                [devarry removeObject:dic];
            }
        }
        if(devarry.count <= 0){
            searchResultBlock(nil);
        }
        else {
//            searchResultBlock(devarry);
            zsy = [[ZSYPopListView alloc]initWitZSYPopFrame:CGRectMake(0, 0, 200, devarry.count  * 55 + 50) WithNSArray:devarry WithString:@"选择蓝牙读卡器类型"];
            zsy.isTitle = NO;
            zsy.delegate = self;
        }
    }else {
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您附近没有找到蓝牙读卡器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新搜索", nil];
        alert.tag = 10108;
        [alert show];
        [alert release];
    }
    
    [devarry release];

    
    
}

-(void)connectToBlueTool:(ConnectToBlueToolsBlock)connectResultBlock index:(int)index{
    NSDictionary *dict = [deviceArr objectAtIndex:index];
    [bletool connectBt:[dict valueForKey:@"uuid"]];
    
}


#pragma mark - 蓝牙连接结果代理
-(void)BR_connectResult:(BOOL)isconnected{
//    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if(isconnected){  //链接成功
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器成功"];
    }
    else{
        //链接失败
        NSLog(@"\n\n  读取代理2");
//        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器失败"];
        
    }
}

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
    NSLog(@"%@",message);
    
}

-(void)getMessage:(MessageBlock)messageBlock{
    NSDictionary *result= nil;//读出来的加密数据 其中baseInfo是加密后的数据，需要用设备对应的key解密。
    
    int flag = 0;
    while ([result count]==0&&flag<4) {
       result =[bletool readIDCardS];
        flag++;
    }
    
    
    
    //处理xml字符串，因为返回的xml字符没有根节点，所以此处加上一个根节点，便于GDataXmlNode取xml值
    NSString *resultstr = [result valueForKey:@"baseInfo"];
    NSLog(@"获取身份证信息：---- %@",resultstr);
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if(resultstr == nil || [resultstr isEqualToString:@""]){
        
        //获取失败
//        [self performSelector:@selector(getShowFail) withObject:nil afterDelay:0.5];
        [self ShowProgressHUDwithMessage:@"获取身份证信息失败,请重新获取"];
        
        return;
    }else{
        
        
        
        
    //GDataXMLNode 使用方法如下 ，需要在项目中引入GDataXMLNode.h   并且在项目的build setting中的Header Search Paths中添加搜索路径： /usr/include/libxml2
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
//        nameLabel.text = [xmldictionary valueForKey:@"name"];
//        idCardLabel.text = [xmldictionary valueForKey:@"idNum"];
//        idCardAddress.text = [xmldictionary valueForKey:@"address"];
        messageBlock(xmldictionary);
        NSLog(@"000000000%@",[xmldictionary valueForKey:@"name"]);
    }
    
    
}

-(void)sureDoneWith:(NSDictionary *)resion{
    if (zsy) {
        [zsy dissViewClose];
        zsy = nil;
        zsy.delegate = nil;
    }
    
//    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    [bletool connectBt:[resion valueForKey:@"uuid"]];
    
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

@end

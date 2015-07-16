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
    BleTool *tools;
    
    BOOL failStat;
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

}

-(void)connectToBlueTool:(ConnectToBlueToolsBlock)connectResultBlock index:(int)index{
    NSDictionary *dict = [deviceArr objectAtIndex:index];
    [bletool connectBt:[dict valueForKey:@"uuid"]];
    
}


#pragma  mark - 蓝牙连接代理
-(void)BR_connectResult:(BOOL)isconnected{
    //    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if(isconnected){  //链接成功
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器成功"];
        [self readCard];
        
    }
    else if(failStat == YES){
        failStat = NO;
        //        [self ShowProgressHUDwithMessage:@"身份证读取失败,请重试"];
    }else{
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器失败,请重试"];
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




-(void)getMessage{
    //搜索蓝牙设备
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    //    [tools ScanDeiceList:2.0];
    //     NSMutableArray *arry = [tools ScanDeiceList:4.0f];
    
    //    arry = [NSArray arrayWithObjects:@"测试1", @"测试2",@"测试3",nil];
    
    
    
    
    NSMutableArray *devarry = [[NSMutableArray alloc]init];
    NSArray *arry = [tools ScanDeiceList:2.0f];
    [devarry addObjectsFromArray:arry];
    if (devarry && devarry != nil && devarry.count > 0) {
        NSLog(@"设备信息 %@",devarry);
        
        for (NSDictionary *dic in arry) {
            if ( dic.count <= 0 || [dic allKeys].count <= 0) {
                NSLog(@"移除信息 ");
                [devarry removeObject:dic];
            }
        }
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        
        if(devarry.count <= 0){
            [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
            [self ShowProgressHUDwithMessage:@"搜索不到蓝牙,请重试"];
            
        }
        else {
            zsy = [[ZSYPopListView alloc]initWitZSYPopFrame:CGRectMake(0, 0, 200, devarry.count  * 55 + 50) WithNSArray:devarry WithString:@"选择蓝牙读卡器类型"];
            zsy.isTitle = NO;
            zsy.delegate = self;
        }
    }else{
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        [self ShowProgressHUDwithMessage:@"搜索不到蓝牙,请重试"];    }
    [devarry release];
}

#pragma mark 读取身份证信息
-(void)readCard{
    
    
    NSDictionary *result=[tools readIDCardS];//读出来的加密数据 其中baseInfo是加密后的数据，需要用设备对应的key解密。
    
    
    //处理xml字符串，因为返回的xml字符没有根节点，所以此处加上一个根节点，便于GDataXmlNode取xml值
    NSString *resultstr = [result valueForKey:@"baseInfo"];
    NSLog(@"获取身份证信息：---- %@",resultstr);
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if(resultstr == nil || [resultstr isEqualToString:@""]){
        [tools disconnectBt];
        [NSThread sleepForTimeInterval:1];
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        [self ShowProgressHUDwithMessage:@"读取身份证信息失败，请重试"];
        failStat = YES;
        return;
    }else{
        failStat = YES;
        [tools disconnectBt];
        [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
        [NSThread sleepForTimeInterval:1];
        
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
        NSString *name = [xmldictionary valueForKey:@"name"];
        NSString *cardid = [xmldictionary valueForKey:@"idNum"];
//        [self fillWebView:name CardId:cardid];
        
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    }
    
    
    
}



@end

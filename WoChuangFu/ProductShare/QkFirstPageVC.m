//
//  QkFirstPageVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 15/1/17.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "QkFirstPageVC.h"
#import "CommonMacro.h"
#import "KeychainItemWrapper.h"
#import "BMWaveButton.h"

@interface QkFirstPageVC ()<HttpBackDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) BMWaveButton *seachButton;


@end

@implementation QkFirstPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    _appVersion = [infoDic objectForKey:@"CFBundleVersion"];
//    bussineDataService *bus = [bussineDataService  sharedDataService];
//    bus.target = self;
//    [bus updateVersion:nil];
    [self layout];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]
                                         initWithIdentifier:@"UUID"
                                         accessGroup:nil];
    NSString *strUUID = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    if ([strUUID isEqualToString:@""])
    {
        
        strUUID = [ComponentsFactory getUUID];
        [keychainItem setObject:strUUID forKey:(__bridge id)kSecAttrAccount];
        
    }
    _authKey = strUUID;
    
//    bussineDataService *bus = [bussineDataService  sharedDataService];
//    bus.target = self;
//    
//    //NSDictionary *dic2 = [NSDictionary dictionaryWithObject:_myDic forKey:@"params"];
//    
//    if (_pushDic!=nil&&_ifFirst ==YES ) {
//        NSDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                             _pushDic,@"expand",
//                             _authKey == nil?@"":strUUID,@"authKey",
//                             @"",@"sessionId",
//                             _appVersion,@"version",
//                             @"",@"sign",
//                             @"ios",@"clientKey",nil];
//        
//        [bus qiankaLogin:dic];
//    }
//
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layout{
    self.view.backgroundColor = UIColorWithRGBA(240, 112, 33, 1);

//    _seachButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT/2-30, 60, 60)];
    //image = [image stretchableImageWithLeftCapWidth:19 topCapHeight:19];
     self.seachButton = [[BMWaveButton alloc] initWithType:BMWaveButtonDefault Image:@"logo_key_safari2"];
//    [_seachButton setBackgroundImage:[UIImage imageNamed:@"safari_azul"] forState:UIControlStateNormal];
    [self.seachButton setTitle:nil forState:UIControlStateNormal];
    [self.seachButton addTarget:self action:@selector(searchedClicked) forControlEvents:UIControlEventTouchUpInside];
   

    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-50, 200, 40)];
    lable.text = @"钥匙已激活，请返回创富宝";
    lable.font = [UIFont systemFontOfSize:15];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.seachButton];
    [self.view addSubview:lable];
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-30, 200, 40)];
    lable1.text = @"请勿删除“创富宝钥匙”以保证正常使用";
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.backgroundColor = [UIColor clearColor];
    lable1.font = [UIFont systemFontOfSize:10];
    lable1.textColor = [ComponentsFactory createColorByHex:@"#fec08a"];
//    lable1.textColor = [UIColor whiteColor];
    [self.view addSubview:lable1];
    
    UIImageView *chuangimg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT-150, 120 , 32)];
    chuangimg.image = [UIImage imageNamed:@"logo_key_wocf"];
    [self.view addSubview:chuangimg];
    
    UIImageView *chuowo = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+40, SCREEN_HEIGHT/2-150, 50 , 40)];
    chuowo.image = [UIImage imageNamed:@"chuowo"];
    [self.view addSubview:chuowo];
    
    UIImageView *textImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-112, SCREEN_HEIGHT-110, 225 , 35)];
    textImg.image = [UIImage imageNamed:@"txt_key_coryright"];
    [self.view addSubview:textImg];
    
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT-70, 100, 40)];
    lable2.text = [NSString stringWithFormat:@"版本号：%@",_appVersion];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.font = [UIFont systemFontOfSize:10];
    lable2.textColor = [UIColor blackColor];
    lable2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lable2];
}

-(void)searchedClicked

{
//    _seachButton.userInteractionEnabled=NO;
    [self.seachButton StartWave];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://10.37.238.199:8080/"]];
    
    [self.seachButton StopWave];
//    bussineDataService *bus = [bussineDataService  sharedDataService];
//    bus.target = self;
//    NSLog( @"hahah%@",_authKey);
////    NSDictionary *dic2 = [NSDictionary dictionaryWithObject:_myDic forKey:@"params"];
//    
//    _requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 [NSNull null],@"expand",
////                                  _myDic,@"params",
//                                 _authKey == nil?@"":_authKey,@"authKey",
//                                 @"",@"sessionId",
//                                 _appVersion,@"version",
//                                 @"",@"sign",
//                                 @"ios",@"clientKey",nil];
//    
//      [bus qiankaLogin:_requestDic];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:login_IP]];
}


-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
//    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    
//    if([[VersionUpdataMessage getBizCode] isEqualToString:bizCode])
//    {    }

    
    [_seachButton StopWave];
    if([[QianKaLoginMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            self.alias = bus.rspInfo[@"expand"][@"alias"];
            [APService setTags:[NSSet setWithObjects:nil] alias: self.alias callbackSelector:nil target:nil];
            
            _seachButton.userInteractionEnabled=YES;
            _loadUrl = bus.rspInfo[@"loadUrl"];
            
//  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"weixin://"]];
//            NSURL*url=[NSURL URLWithString:@"prefs:root=Safari"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_loadUrl]];
            // self.detailsDict = [NSMutableDictionary dictionaryWithCapacity:self.detailsList.count];
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
    _seachButton.userInteractionEnabled=YES;
    [_seachButton StopWave];
     NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    _upDateUrl = msg;
    NSLog(@"%@",_upDateUrl);
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[QianKaLoginMessage getBizCode] isEqualToString:bizCode]){
        
        
        if([@"7777" isEqualToString:errCode])
        {
            [self showAlertViewTitle:@"有新版本发布，是否升级？"
                             message:@""
                            delegate:self
                                 tag:10116
                   cancelButtonTitle:nil
                   otherButtonTitles:@"确定", nil];
            
            
        }

        else{ if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"登陆失败！";
        }
        if(nil == msg){
            msg = @"登陆失败！";
        }
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10101
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"确定",nil];
        }
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


#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if(alertView.tag==10101){
        if([buttonTitle isEqualToString:@"重试"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [bus qiankaLogin:_myDic];
        }
}
    
    if (alertView.tag==10116) {
        if ([buttonTitle isEqualToString:@"确定"]) {
            NSLog(@"%@",_upDateUrl);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_upDateUrl]];
            exit(0);
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

@end

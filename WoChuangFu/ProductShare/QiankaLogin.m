//
//  QiankaLogin.m
//  WoChuangFu
//
//  Created by 郑渊文 on 15/1/17.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "QiankaLogin.h"
#import "CommonMacro.h"
#import "QkFirstPageVC.h"

@interface QiankaLogin ()<HttpBackDelegate,UIAlertViewDelegate>
@property(nonatomic,copy)NSString *ifLogin;

@end

@implementation QiankaLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    _ifLogin = @"登录中";
    [self layout];
    NSLog(@"哈哈哈哈%@",_myDic);
    

    NSLog(@"_pass_Url的值是%@",_pass_Url);
    NSLog( @"hahah%@",_authKey);
    if ([_pass_Url rangeOfString:@"wcfqk2015"].location!=NSNotFound) {
        
        bussineDataService *bus = [bussineDataService  sharedDataService];
        bus.target = self;
        NSDictionary *dic2 = [NSDictionary dictionaryWithObject:_myDic forKey:@"params"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     dic2,@"expand",
                                     //                                  _myDic,@"params",
                                     _authKey == nil?@"":_authKey,@"authKey",
                                     //                                 @"",@"sessionId",
                                     appVersion,@"version",
                                     @"",@"sign",nil];
        
        [bus qiankaLogin:dict];
    }
    
    if ([_pass_Url rangeOfString:@"wcfqk2015"].location==NSNotFound) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_returnUrl]];
        
     }

    

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layout
{
    self.view.backgroundColor = UIColorWithRGBA(39, 130, 190, 1);
    UILabel *loginStr = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT/2, 80, 40)];;
    loginStr.text = _ifLogin;
    loginStr.textAlignment = NSTextAlignmentCenter;
    loginStr.textColor = [UIColor whiteColor];
    loginStr.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:loginStr];
    
}


-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[QianKaLoginMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
           
           bussineDataService *bus=[bussineDataService sharedDataService];
            self.alias_Login = bus.rspInfo[@"expand"][@"alias"];
            NSLog(@"数字是%@",_alias_Login);
            [APService setTags:[NSSet setWithObjects:nil] alias:self.alias_Login callbackSelector:nil target:nil];
            
             QkFirstPageVC *firstPage = [[QkFirstPageVC alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = firstPage;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_returnUrl]];
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
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    _upDateUrl = msg;
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
                   cancelButtonTitle:nil
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

//
//  FansVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 15/1/14.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "FansVC.h"
#import "CommonMacro.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSContent.h>
#import "TitleBar.h"
#import "ProDuctShareManager.h"
#import "KeychainItemWrapper.h"
#import "QkFirstPageVC.h"
#define CellHeight 44
#define SHAREHEIGHT 50
#define SHAREBUTTONSIZE 70
#define SHAREBUTTONSIZE4 65

@interface FansVC ()<TitleBarDelegate,UIScrollViewDelegate,HttpBackDelegate>
@property(nonatomic,strong)UITableView *mytable;
@property(nonatomic,strong)NSArray     *shareArray;
@property(nonatomic,strong)  UIView       *headerView;
@property(nonatomic,copy)  NSDictionary       *myDic;
@end

@implementation FansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"值是%@",_params[@"sharetitle"]);
    
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
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layout
{
    
    
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:middle_position];
    titleBar.title = @"分享";
    [titleBar setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    //self.navigationController.view.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
    //    [self.navigationController.view addSubview:titleBar];
    [self.view addSubview:titleBar];
    titleBar.target = self;
    
    
    UIScrollView *bgView= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIView *productView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 100)];
    bgView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+50);
    bgView.scrollEnabled = YES;
    bgView.delegate = self;
    
    [self.view addSubview:bgView];
    productView.backgroundColor = [UIColor whiteColor];
    bgView.backgroundColor = UIColorWithRGBA(30, 139, 190, 1);
    self.view.backgroundColor = [UIColor blackColor];
    

    UIImageView *chageImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-125, 30, 250, 180)];
    chageImgView.image = [UIImage imageNamed:@"fsxf"];
    [bgView addSubview:chageImgView];
    
    UILabel *idlable = [[UILabel alloc]initWithFrame:CGRectMake(40, 108, 170, 15)];
//    idlable.backgroundColor = [UIColor redColor];
    idlable.text = [NSString stringWithFormat:@"ID:%@",_params[@"fuserId"]];
    idlable.textColor = [ComponentsFactory createColorByHex:@"#348fa2"];
    idlable.textAlignment =NSTextAlignmentCenter;
    [chageImgView addSubview:idlable];
    
    
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250+30, SCREEN_WIDTH, 250)];
    shareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shareView];
    
    UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-28, 15, 35, 12)];
//                               (SCREEN_WIDTH/2-75, 20, 150, 50)];
    shareImage.image = [UIImage imageNamed:@"share"];
    [shareView addSubview:shareImage];
    
    
    UIButton *WXbutton = [[UIButton alloc]initWithFrame:CGRectMake(20, SHAREHEIGHT, SHAREBUTTONSIZE,SHAREBUTTONSIZE)];
    [WXbutton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [WXbutton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    WXbutton.tag = 1;
    [shareView addSubview:WXbutton];
    
    UIButton *WBbutton = [[UIButton alloc]initWithFrame:CGRectMake(120, SHAREHEIGHT, SHAREBUTTONSIZE, SHAREBUTTONSIZE)];
    [WBbutton setImage:[UIImage imageNamed:@"pyq"] forState:UIControlStateNormal];
    [WBbutton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    WBbutton.tag = 2;
    [shareView addSubview:WBbutton];
    
    
    UIButton *FriendButton = [[UIButton alloc]initWithFrame:CGRectMake(220, SHAREHEIGHT, SHAREBUTTONSIZE, SHAREBUTTONSIZE)];
    [FriendButton setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
    [FriendButton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    FriendButton.tag = 3;
    [shareView addSubview:FriendButton];
    
    UIButton *storeButton = [[UIButton alloc]initWithFrame:CGRectMake(20, SHAREHEIGHT+SHAREBUTTONSIZE, SHAREBUTTONSIZE, SHAREBUTTONSIZE)];
    [storeButton setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [storeButton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    storeButton.tag = 4;
    [shareView addSubview:storeButton];
    
    UIButton *QQButton = [[UIButton alloc]initWithFrame:CGRectMake(120, SHAREHEIGHT+SHAREBUTTONSIZE, SHAREBUTTONSIZE, SHAREBUTTONSIZE)];
    [QQButton setImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
    [QQButton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    QQButton.tag = 5;
    [shareView addSubview:QQButton];
    
    
    UIButton *QQspaceButton = [[UIButton alloc]initWithFrame:CGRectMake(220, SHAREHEIGHT+SHAREBUTTONSIZE, SHAREBUTTONSIZE, SHAREBUTTONSIZE)];
    [QQspaceButton setImage:[UIImage imageNamed:@"qqkj.png"] forState:UIControlStateNormal];
    [QQspaceButton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    QQspaceButton.tag = 6;
    [shareView addSubview:QQspaceButton];
    
    if (SCREEN_HEIGHT<560) {
        shareView.frame = CGRectMake(0, SCREEN_HEIGHT-200+30, SCREEN_WIDTH, 200);
        WXbutton.frame = CGRectMake(20, SHAREHEIGHT-20, SHAREBUTTONSIZE4,SHAREBUTTONSIZE4);
        WBbutton.frame = CGRectMake(120, SHAREHEIGHT-20, SHAREBUTTONSIZE4,SHAREBUTTONSIZE4);
        FriendButton.frame = CGRectMake(220, SHAREHEIGHT-20, SHAREBUTTONSIZE4,SHAREBUTTONSIZE4);
        storeButton.frame = CGRectMake(20, SHAREHEIGHT+40, SHAREBUTTONSIZE4,SHAREBUTTONSIZE4);
        QQButton.frame = CGRectMake(120, SHAREHEIGHT+40, SHAREBUTTONSIZE4,SHAREBUTTONSIZE4);
        QQspaceButton.frame = CGRectMake(220, SHAREHEIGHT+40, SHAREBUTTONSIZE4,SHAREBUTTONSIZE4);
    }
    
}





-(void)shareClicked:(UIButton *)sender
{
    ShareType type = 0;
    switch (sender.tag) {
        case 1:
            type = ShareTypeWeixiSession;
            break;
        case 2:
            type = ShareTypeWeixiTimeline
            ;
            break;
        case 3:
            type = ShareTypeWeixiFav;
            break;
        case 4:
            type = ShareTypeSinaWeibo;
            break;
        case 5:
            type = ShareTypeQQ;
            break;
        case 6:
            type = ShareTypeQQSpace;
            break;
        default:
            break;
    }
    
    //1.定制分享的内容
//    NSString* path = [[NSBundle mainBundle]pathForResource:@"ShareSDK" ofType:@"jpg"];
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",_params[@"sharecontent"]] defaultContent:[NSString stringWithFormat:@"%@,%@",_params[@"name"],_params[@"desc"]] image:[ShareSDK imageWithUrl:[NSString stringWithFormat:@"%@",_params[@"shareimg"]]] title:_params[@"sharetitle"] url:_params[@"shareurl"] description:_params[@"sharecontent"] mediaType:SSPublishContentMediaTypeNews];
    //2.分享
    [ShareSDK showShareViewWithType:type container:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            
                        NSLog(@"分享成功");
            bussineDataService *bus = [bussineDataService  sharedDataService];
            bus.target = self;
            
            NSString *userId = _params[@"userid"];
            NSString *wcfProductId = _params[@"wcfProductId"];
            NSString *sharePlat = [NSString stringWithFormat:@"%d",sender.tag];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         //                                         @"expand",@"expand",
                                         userId,@"useId",
                                         _authKey,@"authKey",
                                         @"ios",@"clientKey",
                                         wcfProductId,@"productId",
                                         @"1",@"sharedStatus",
                                         sharePlat,@"sharePlat",
                                         nil];
            
            [bus qiankaShare:dict];
            _myDic = dict;
//  NSString *str = [NSString stringWithFormat:@"wcfPlatform=%d&wcfProductId=%@&wcfUserid=%@&wcfFlag=0",sender.tag,_params[@"wcfProductId"],_params[@"fuserId"]];
//            NSString *urlStr=[NSString stringWithFormat:@"http://133.0.191.179:19211/route/document/joinType?%@",str];
//            
//            NSLog(@"url的地址是%@",urlStr);
//            
//            NSURL *url=[NSURL URLWithString:urlStr];
//            
//            NSURLRequest *request=[NSURLRequest requestWithURL:url];
//            
//            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];

//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
        }
        //如果分享失败
        if (state == SSResponseStateFail) {
            
            
//            _myDic = dict;

            NSString *str = [NSString stringWithFormat:@"wcfPlatform=%d&wcfProductId=%@&wcfUserid=%@&wcfFlag=0",sender.tag,_params[@"wcfProductId"],_params[@"userid"]];
            NSString *urlStr=[NSString stringWithFormat:@"http://133.0.191.179:19211/route/document/joinType?%@",str];
    
//            NSLog(@"url的地址是%@",urlStr);
//            
//            NSURL *url=[NSURL URLWithString:urlStr];
//
//            NSURLRequest *request=[NSURLRequest requestWithURL:url];
//            
//            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
            
            
            bussineDataService *bus = [bussineDataService  sharedDataService];
            bus.target = self;
            
            NSString *userId = _params[@"userid"];
             NSString *wcfProductId = _params[@"wcfProductId"];
            NSString *sharePlat = [NSString stringWithFormat:@"%d",sender.tag];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                         @"expand",@"expand",
                                         userId,@"useId",
                                         _authKey,@"authKey",
                                         @"ios",@"clientKey",
                                         wcfProductId,@"productId",
                                         @"0",@"sharedStatus",
                                         sharePlat,@"sharePlat",
                                         nil];
            
            [bus qiankaShare:dict];
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"分享失败，请看日记错误描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
        }
    }];
    
}


-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ShareMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
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
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ShareMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"回调失败！";
        }
        if(nil == msg){
            msg = @"回调失败！";
        }
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10101
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"重试",nil];
        
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
            [bus qiankaShare:_myDic];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_params[@"return"]]];
    QkFirstPageVC *firstPage = [[QkFirstPageVC alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = firstPage;
//    exit(0);
}
@end

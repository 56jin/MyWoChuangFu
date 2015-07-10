//
//  ContractVC.m
//  WcfQianKa
//
//  Created by 郑渊文 on 15/1/23.
//  Copyright (c) 2015年 asiainfo. All rights reserved.
//

#import "ContractVC.h"
#import "TitleBar.h"
#import "CommonMacro.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSContent.h>
#import "JSONKit.h"
#import "QkFirstPageVC.h"
#import "KeychainItemWrapper.h"

#define COLLECTIONWIDTH  (SCREEN_WIDTH-20)/6
#define SHAREHEIGHT 50
#define SHAREBUTTONSIZE 70
#define SHAREBUTTONSIZE4 65

@interface ContractVC ()<TitleBarDelegate,UIScrollViewDelegate,HttpBackDelegate>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *oldPrice;
@property(nonatomic,copy)NSString *saleprice;
@property(nonatomic,copy)NSString *shareUrl;
@property(nonatomic,copy)NSString *charges;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *myImage;
@property(nonatomic,copy)NSString *returnUrl;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSArray *shareData;
@property(nonatomic,copy)NSString *heyueList;
@property(nonatomic,copy)NSArray *moneyData;

@end


@implementation ContractVC



- (void)viewDidLoad {
    [super viewDidLoad];
    _name = _myDic[@"name"];
    _oldPrice = _myDic[@"oldprice"];
    _saleprice = _myDic[@"saleprice"];
    _charges = _myDic[@"charges"];
    _desc = _myDic[@"desc"];
    _myImage = _myDic[@"img"];
    _shareUrl = _myDic[@"shareurl"];
    _returnUrl = _myDic[@"return"];
    _userID =_myDic[@"userid"];
    _heyueList = _myDic[@"heyuelist"];
    
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

    NSString *json2 =_heyueList;
    NSLog(@"json2:%@", json2);
    _moneyData = [json2 objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSLog(@"data的值是%@",_moneyData);
    
    NSLog(@"上面的数字为%@",[_moneyData[0] allKeys]);
    
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
//    bgView.backgroundColor = UIColorWithRGBA(30, 139, 190, 1);
    bgView.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    
    
    
    UIScrollView *sco = [[UIScrollView alloc]initWithFrame:CGRectMake(60, 70, SCREEN_WIDTH-40, 156)];
    sco.delegate = self;
    
    sco.showsHorizontalScrollIndicator = NO;
    [bgView addSubview:sco];
    
    
    
    int count1= _moneyData.count;
    if (count1<5||count1==5) {
        float  cellWidth = (SCREEN_WIDTH-COLLECTIONWIDTH-20)/_moneyData.count;
        
        UIView *moneyBackGround = [[UIView alloc]initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-20, 170)];
//        moneyBackGround.backgroundColor = [UIColor whiteColor];
        moneyBackGround.layer.borderColor = [UIColor clearColor].CGColor;
        [moneyBackGround.layer setCornerRadius:10];
        moneyBackGround.layer.borderWidth = 1;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:moneyBackGround.bounds];
        
        moneyBackGround.layer.masksToBounds = YES;
        
        moneyBackGround.layer.shadowColor = [UIColor blackColor].CGColor;
        
        moneyBackGround.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        
        moneyBackGround.layer.shadowOpacity = 0.5f;
        
        moneyBackGround.layer.shadowPath = shadowPath.CGPath;
//        moneyBackGround.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
        [bgView addSubview:moneyBackGround];
        
        UILabel *idlable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 50)];
//        idlable.layer.borderColor = [UIColor whiteColor].CGColor;
//        idlable.layer.borderWidth = 1.0;
        idlable.backgroundColor = [ComponentsFactory createColorByHex:@"#2badeb"];
//        idlable.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
        idlable.font = [UIFont systemFontOfSize:17];
        idlable.text = [NSString stringWithFormat:@"ID:%@",_myDic[@"userid"]];
        idlable.textAlignment = NSTextAlignmentCenter;
        idlable.textColor = [UIColor whiteColor];
        [moneyBackGround addSubview:idlable];
        
//        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 1, 120)];
//        line2.backgroundColor = [UIColor whiteColor];
//        [moneyBackGround addSubview:line2];
//        
//        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH-20, 1)];
//        line3.backgroundColor = [UIColor whiteColor];
//        [moneyBackGround addSubview:line3];
//        
//        UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-1, 50, 1, 120)];
//        line5.backgroundColor = [UIColor whiteColor];
//        [moneyBackGround addSubview:line5];
//        
//        
//        UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH-20, 1)];
//        line4.backgroundColor = [UIColor whiteColor];
//        [moneyBackGround addSubview:line4];
        
        
        
        UILabel *taocan =[[UILabel alloc]initWithFrame:CGRectMake(0, 50, COLLECTIONWIDTH+1, 62)];
        taocan.text = @"套餐";
        taocan.font = [UIFont systemFontOfSize:17];
        //    taocan.textColor = [ComponentsFactory createColorByHex:@"#666666"];
        taocan.textColor = [UIColor whiteColor];
        taocan.textAlignment = NSTextAlignmentCenter;
        taocan.backgroundColor = [ComponentsFactory createColorByHex:@"#1a9fde"];
//        taocan.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
        [moneyBackGround addSubview:taocan];
        
        
        UILabel *fanli =[[UILabel alloc]initWithFrame:CGRectMake(0, 110, COLLECTIONWIDTH+1, 60)];
        fanli.font = [UIFont systemFontOfSize:17];
        fanli.backgroundColor = [ComponentsFactory createColorByHex:@"#1a9fde"];
//        fanli.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
        fanli.text = @"返利";
        //    fanli.textColor = [ComponentsFactory createColorByHex:@"#666666"];
        fanli.textColor = [UIColor whiteColor];
        fanli.textAlignment = NSTextAlignmentCenter;
        [moneyBackGround addSubview:fanli];
        
        
        
        
        
        
        for(int i = 0;i< count1;i++){
            
            UIView * collectionView = [[UIView alloc]initWithFrame:CGRectMake((count1-1)*cellWidth+1+COLLECTIONWIDTH, 50, cellWidth, 120)];
            collectionView.backgroundColor = [UIColor clearColor];
//            collectionView.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);

//            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(i*cellWidth+COLLECTIONWIDTH-1, 50, 1, 120)];
//            line2.backgroundColor = [UIColor whiteColor];
            
            UILabel *taocanLable = [[UILabel alloc]initWithFrame:CGRectMake(i*cellWidth+1+COLLECTIONWIDTH, 50, cellWidth, 60)];
            if (i%2==0) {
                taocanLable.backgroundColor = [ComponentsFactory createColorByHex:@"#1794cf"];
//                taocanLable.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
            }
            else{
                taocanLable.backgroundColor = [ComponentsFactory createColorByHex:@"#1a9fde"];
//                taocanLable.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
            }
            if (i>_moneyData.count) {
                taocanLable.text = @"";
            }
            
            else{
                taocanLable.text =[NSString stringWithFormat:@"%@",[_moneyData[i] allKeys][0]];
            }
            taocanLable.textColor = [UIColor whiteColor];
            taocanLable.textAlignment = NSTextAlignmentCenter;
            [moneyBackGround addSubview:taocanLable];
            
            UILabel *fanxianLable = [[UILabel alloc]initWithFrame:CGRectMake(i*cellWidth+1+COLLECTIONWIDTH, 110, cellWidth, 60)];
            if (i%2==0) {
                fanxianLable.backgroundColor = [ComponentsFactory createColorByHex:@"#1794cf"];
//                 fanxianLable.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
            }
            else{
                fanxianLable.backgroundColor = [ComponentsFactory createColorByHex:@"#1a9fde"];
//                 fanxianLable.backgroundColor = UIColorWithRGBA(255, 126, 12, 1);
            }
            if (i>_moneyData.count) {
                fanxianLable.text = @"";
            }
            else{
                fanxianLable.text =[NSString stringWithFormat:@"%@",[_moneyData[i] allValues][0]];
            }
            fanxianLable.textColor = [UIColor whiteColor];
            fanxianLable.textAlignment = NSTextAlignmentCenter;
            [moneyBackGround addSubview:fanxianLable];
            
            
            [moneyBackGround addSubview:collectionView];
//            [moneyBackGround addSubview:line2];
        }
    }
    
    
    else if (_moneyData.count>5){
        
        UILabel *idLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 20, 100, 40)];
        idLable.text = [NSString stringWithFormat:@"ID:%@",_userID];
        idLable.textAlignment = NSTextAlignmentCenter;
        idLable.font = [UIFont systemFontOfSize:16];
        idLable.textColor = [UIColor whiteColor];
        [bgView addSubview:idLable];
        
        UIImageView *idimage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50-20, 25, 30, 30)];
        idimage.image = [UIImage imageNamed:@"share_icon_ID"];
        [bgView addSubview:idimage];
        
        
        UIView *lineGe = [[UIView alloc]initWithFrame:CGRectMake(10, 55, SCREEN_WIDTH-20, 1)];
        lineGe.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:lineGe];
        
        int datacount =_moneyData.count;
        if (datacount<5) {
            datacount = 5;
        }
        
        
        for(int i = 1;i< datacount+1;i++){
            
            
            
            sco.contentSize = CGSizeMake(COLLECTIONWIDTH*(i+1)+10, 150) ;
            
            UIView * collectionView = [[UIView alloc]initWithFrame:CGRectMake((i-1)*COLLECTIONWIDTH+1, 0, COLLECTIONWIDTH, 150)];
            collectionView.backgroundColor = [UIColor clearColor];
            
            
            UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(1, 60, 1, 90)];
            line2.image = [UIImage imageNamed:@"line_s"];
            
            UIImageView *moneyImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 70, 20, 20)];
            moneyImg.image = [UIImage imageNamed:@"share_money_symbol"];
            [collectionView addSubview:moneyImg];
            
            UIImageView *moneyImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 110, 20, 20)];
            moneyImg2.image = [UIImage imageNamed:@"share_money_symbol"];
            [collectionView addSubview:moneyImg2];
            
            
            
            
            UILabel *taocanLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 65, 30, 30)];
            
            if (i>_moneyData.count) {
                taocanLable.text = @"";
            }
            else{
                taocanLable.text =[NSString stringWithFormat:@"%@",[_moneyData[i-1] allKeys][0]];
            }
            taocanLable.font = [UIFont systemFontOfSize:14];
            taocanLable.textColor = [UIColor whiteColor];
            [collectionView addSubview:taocanLable];
            
            UILabel *fanxianLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 105, 30, 30)];
            if (i>_moneyData.count) {
                fanxianLable.text = @"";
            }
            else{
                fanxianLable.text =[NSString stringWithFormat:@"%@",[_moneyData[i-1] allValues][0]];
            }
            fanxianLable.font = [UIFont systemFontOfSize:14];
            fanxianLable.textColor = [UIColor whiteColor];
            [collectionView addSubview:fanxianLable];
            
            UIImageView *numberImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
            numberImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"share_%d",i]];
            [collectionView addSubview:numberImg];
            [collectionView addSubview:line2];
            [sco addSubview:collectionView];
            
            UILabel *taocan =[[UILabel alloc]initWithFrame:CGRectMake(10, 100, COLLECTIONWIDTH, 100)];
            taocan.text = @"套餐";
            //    taocan.textColor = [ComponentsFactory createColorByHex:@"#666666"];
            taocan.textColor = [UIColor whiteColor];
            [bgView addSubview:taocan];
            
            UILabel *fanli =[[UILabel alloc]initWithFrame:CGRectMake(10, 140, COLLECTIONWIDTH, 100)];
            fanli.text = @"返利";
            //    fanli.textColor = [ComponentsFactory createColorByHex:@"#666666"];
            fanli.textColor = [UIColor whiteColor];
            [bgView addSubview:fanli];
        }
        
    }
    
    
    UILabel *tipsLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, SCREEN_WIDTH-20, 40)];
    tipsLable.text = [NSString stringWithFormat:@"*%@",_myDic[@"tips"]];
    tipsLable.textColor = [UIColor whiteColor];
    tipsLable.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:tipsLable];
    
    
    
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250+30, SCREEN_WIDTH, 250)];
    shareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shareView];
    
    UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-26, 15, 35, 12)];
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
    
    
    UILabel *lable2 =[[UILabel alloc]initWithFrame:CGRectMake(80, 30, 80, 40)];
    lable2.text = [NSString stringWithFormat:@"原价：%@",_oldPrice];
    lable2.font = [UIFont systemFontOfSize:13];
    lable2.textColor = [UIColor grayColor];
    
    UILabel *lable3 =[[UILabel alloc]initWithFrame:CGRectMake(160, 30, 90, 40)];
    lable3.text = [NSString stringWithFormat:@"折扣价：%@",_saleprice];;
    lable3.font = [UIFont systemFontOfSize:13];
    lable3.textColor = [UIColor grayColor];
    
    
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
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@,%@",_myDic[@"name"],_myDic[@"desc"]] defaultContent:[NSString stringWithFormat:@"%@,%@",_myDic[@"name"],_myDic[@"desc"]] image:[ShareSDK imageWithUrl:[NSString stringWithFormat:@"%@",_myDic[@"img"]]] title:[NSString stringWithFormat:@"%@",_myDic[@"name"]] url:_shareUrl description:_desc mediaType:SSPublishContentMediaTypeNews];
    //2.分享
    [ShareSDK showShareViewWithType:type container:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            
            
            bussineDataService *bus = [bussineDataService  sharedDataService];
            bus.target = self;
            
            NSString *userId = _myDic[@"userid"];
            NSString *wcfProductId = _myDic[@"wcfProductId"];
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
            
//            [bus qiankaShare:dict];

            
            NSLog(@"分享成功");
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
        }
        //如果分享失败
        if (state == SSResponseStateFail) {
            
            
            bussineDataService *bus = [bussineDataService  sharedDataService];
            bus.target = self;
            
            NSString *userId = _myDic[@"userid"];
            NSString *wcfProductId = _myDic[@"wcfProductId"];
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
//    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
//    if([[ShareMessage getBizCode] isEqualToString:bizCode]){
//        if([oKCode isEqualToString:errCode]){
//            // self.detailsDict = [NSMutableDictionary dictionaryWithCapacity:self.detailsList.count];
//        }else{
//            
//        }
//    }
    
    
}

-(void)backAction
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_returnUrl]];
//    QkFirstPageVC *firstPage = [[QkFirstPageVC alloc]init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = firstPage;
//    exit(0);
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
//
//  ProductShareVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 15/1/15.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ProductShareVC.h"
#import "TitleBar.h"
#import "CommonMacro.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSContent.h>
#import "ProDuctShareManager.h"
#import "FileHelpers.h"
#import "ComponentsFactory.h"
#import "QkFirstPageVC.h"
#import "KeychainItemWrapper.h"

#define  CellHeight 44
#define SHAREBUTTONSIZE 70
#define SHAREBUTTONSIZE4 65
#define SHAREHEIGHT 50

@interface ProductShareVC ()<TitleBarDelegate,UIScrollViewDelegate,HttpBackDelegate>
{
     UITableView *_tableView;
}

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


@end

@implementation ProductShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _myDic = [[NSDictionary alloc]init];
    NSDictionary *dic =[ProDuctShareManager shareInstance].productShareDta;
    NSLog(@"%@", [ProDuctShareManager shareInstance].productShareDta);
    _myDic = dic;
    _name = _myDic[@"name"];
    _oldPrice = _myDic[@"oldprice"];
    _saleprice = _myDic[@"saleprice"];
    _charges = _myDic[@"charges"];
    _desc = _myDic[@"desc"];
    _myImage = _myDic[@"img"];
    _shareUrl = _myDic[@"shareurl"];
    _returnUrl = _myDic[@"return"];
    _userID = _myDic[@"userid"];
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
    bgView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+50);
    bgView.scrollEnabled = YES;
    bgView.delegate = self;
    UIView *productView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 100)];
    [self.view addSubview:bgView];
    productView.backgroundColor = [UIColor whiteColor];
    bgView.backgroundColor = UIColorWithRGBA(35, 139, 190, 1);
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = UIColorWithRGBA(240, 239, 245, 1);
    
    UIView *grounView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 20, 150, 150)];
    [grounView.layer setCornerRadius:CGRectGetHeight([grounView bounds]) / 2];
    grounView.layer.masksToBounds = YES;
    grounView.layer.borderWidth = 5;
    grounView.backgroundColor = [UIColor whiteColor];
    grounView.layer.borderColor = [UIColorWithRGBA(240, 239, 245, 1) CGColor];
    
    
    UIImageView *chageImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 30, 200, 150)];
    chageImgView.image = [UIImage imageNamed:@"xf"];
    [bgView addSubview:chageImgView];
    
    
    UILabel *idLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 190, 100, 50)];
    idLable.text = [NSString stringWithFormat:@"ID:%@",_userID];
    idLable.textAlignment = NSTextAlignmentCenter;
    idLable.font = [UIFont systemFontOfSize:20];
    idLable.textColor = [UIColor whiteColor];
    [bgView addSubview:idLable];
    
    
//   UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 100, 100)];
//    imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_myImage]]];
//    [grounView addSubview:imgView];

//    
//    if (hasCachedImage([NSURL URLWithString:_myImage])) {
//        imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_myImage]]];
//
//           // grounView.layer.contents = (id)[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_myImage]]]CGImage];
////               [grounView.layer setNeedsDisplay];
//    }else{
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_myImage,@"url",grounView,@"imageView",nil];
//        [ComponentsFactory dispatch_process_with_thread:^{
//            UIImage* ima = [self LoadImage:dic];
//            return ima;
//        } result:^(UIImage *ima){
//            //                imageV.image = ima;
//             imgView.image = (id)[ima CGImage];
////                    [grounView.layer setNeedsDisplay];
//        }];
//    }

//    [bgView addSubview:lineView];
//   [bgView addSubview:grounView];
    
//    UIImageView *lableView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+50, 30, 65, 65)];
//    lableView.image = [UIImage imageNamed:@"money"];
//    [bgView addSubview:lableView];
    
    
    
    UILabel *lable5 = [[UILabel alloc]initWithFrame:CGRectMake(50,40, 100, 70)];
    lable5.textAlignment = NSTextAlignmentCenter;
    lable5.text =_charges;
    lable5.font = [UIFont systemFontOfSize:45];
    lable5.textColor = UIColorWithRGBA(242, 118, 56, 1);
    [chageImgView addSubview:lable5];
    
    
//    UILabel *lable1 =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-150, 170, 300, 70)];
//    lable1.textAlignment = NSTextAlignmentCenter;
//    lable1.text = _name;
//    lable1.font = [UIFont systemFontOfSize:17];
//    lable1.numberOfLines = 0;
//    [bgView addSubview:lable1];
//    
//    UILabel *lable4 =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-150, 200, 300, 80)];
//    lable4.text = _desc;
//    lable4.textAlignment = NSTextAlignmentCenter;
//    lable4.font = [UIFont systemFontOfSize:15];
//    lable4.textColor = [UIColor redColor];
//    lable4.numberOfLines = 0;
//    [bgView addSubview:lable4];
    
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
-(UIImage *)LoadImage:(NSDictionary*)aDic
{
    UIView* view = [aDic objectForKey:@"imageView"];
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"url"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil)
    {
        return nil;
    }
    CGSize origImageSize= [image size];
    CGRect newRect;
    newRect.origin= CGPointZero;
    //拉伸到多大
    newRect.size.width=sqrtf(view.frame.size.width*view.frame.size.width/2);
    newRect.size.height=sqrtf(view.frame.size.height*view.frame.size.height/2);
    //缩放倍数
    float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    UIGraphicsBeginImageContext(newRect.size);
    CGRect projectRect;
    projectRect.size.width =ratio * origImageSize.width;
    projectRect.size.height=ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
    [image drawInRect:projectRect];
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    //压缩比例
    NSData *smallData=UIImageJPEGRepresentation(small, 1);
    if (smallData)
    {
        [fileManager createFileAtPath:pathForURL(aURL) contents:smallData attributes:nil];
    }
    UIGraphicsEndImageContext();
    return small;
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
            type = ShareTypeSMS;
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
            
            [bus qiankaShare:dict];

            
            NSLog(@"%d",type);
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

             NSLog(@"%d",type);
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"分享失败，请看日记错误描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
        }
    }];
    //3.没了，就是这么简单
}

-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    //    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ShareMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            // self.detailsDict = [NSMutableDictionary dictionaryWithCapacity:self.detailsList.count];
        }else{
            
        }
    }
    
    
}

-(void)backAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_returnUrl]];
    QkFirstPageVC *firstPage = [[QkFirstPageVC alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = firstPage;
}
@end

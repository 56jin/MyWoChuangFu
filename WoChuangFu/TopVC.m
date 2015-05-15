//
//  TopVC.m
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-15.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "TopVC.h"
#import "FileHelpers.h"
#import "webVC.h"
//#import <ShareSDK/ShareSDK.h>

#define ImaTag  202
#define StrTag  203

@interface TopVC ()

@end

@implementation TopVC

@synthesize FirNav;

- (void)viewWillAppear:(BOOL)animated
{
    [NdUncaughtExceptionHandler setDefaultHandler];
}

-(void)loadView
{
    [super loadView];
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[UIColor grayColor];//[ComponentsFactory createColorByHex:@"#F8F8F8"];
    self.view = BackV;
    [BackV release];
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LayOutTab];
    [self LayOutView];
    // Do any additional setup after loading the view.
}

-(void)LayOutTab
{
    UIImageView *BackImg=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-85, 0, 85, [UIScreen mainScreen].bounds.size.height-20)];
    if(IOS7){
        BackImg.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-85, 0, 85, [UIScreen mainScreen].bounds.size.height);
    }
    BackImg.image=[UIImage imageNamed:@"biejin.png"];
    BackImg.userInteractionEnabled=YES;
    [self.view addSubview:BackImg];
    [BackImg release];
    
    Firtab = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-85, 0, 85, [UIScreen mainScreen].bounds.size.height-20)];
    if(IOS7){
        Firtab.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-85, 0, 85, [UIScreen mainScreen].bounds.size.height);
    }
    Firtab.delegate=self;
    Firtab.dataSource=self;
    Firtab.backgroundColor=[UIColor clearColor];
    Firtab.separatorColor=[UIColor clearColor];
    [self.view addSubview:Firtab];
    
    TabArr = [[NSMutableArray alloc] initWithCapacity:0];
}

-(void)LayOutView
{
    FirV=[[FirstVC alloc] init];
    FirV.delegate=self;
    FirV.tabDelegate=self;
    FirNav=[[UINavigationController alloc] initWithRootViewController:FirV];
    [FirNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor whiteColor],UITextAttributeTextColor,[UIFont boldSystemFontOfSize:20], UITextAttributeFont,nil]];
    [FirNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"top.png"] forBarMetrics:UIBarMetricsDefault];
//    if(IOS7)
//        FirNav.navigationBar.barTintColor=[ComponentsFactory createColorByHex:@"#FD931C"];
////        FirNav.navigationBar.backgroundColor = [UIColor orangeColor];
//    else
//        FirNav.navigationBar.tintColor = [ComponentsFactory createColorByHex:@"#FD931C"];//[UIColor orangeColor];
    
    UIImageView *yinyinV=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 13.5, [UIScreen mainScreen].bounds.size.height-20)];
    yinyinV.image=[UIImage imageNamed:@"yinyin.png"];
    if(IOS7){
        yinyinV.frame=CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 13.5, [UIScreen mainScreen].bounds.size.height);
    }
    [FirNav.view addSubview:yinyinV];
    [yinyinV release];
    [self.view addSubview:FirNav.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [FirNav release];
    [FirV release];
    [Firtab release];
    [TabArr release];
    [super dealloc];
}

#pragma mark FirstDelegate
-(void)ShowList
{
    float Durationtime = 0.5;
    [UIView beginAnimations:@"alt" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:Durationtime];
    if(FirNav.view.frame.origin.x==-85){
        FirNav.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FirNav.view.frame.size.height);
        FirV.view.userInteractionEnabled=YES;
    }else{
        FirNav.view.frame=CGRectMake(-85, 0, [UIScreen mainScreen].bounds.size.width, FirNav.view.frame.size.height);
        FirV.view.userInteractionEnabled=NO;
    }
    [UIView commitAnimations];
}

#pragma mark FirstDelegat
-(void)SetTab:(NSMutableArray *)Arr
{
    [TabArr removeAllObjects];
    [TabArr setArray:Arr];
    [Firtab reloadData];
}

#pragma mark tableDelegate&TableDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TabArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstr=@"cellstr";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellstr];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstr] autorelease];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIImageView *ima=[[UIImageView alloc] initWithFrame:CGRectMake(23.75, 26, 37.5, 38)];
        ima.userInteractionEnabled=YES;
        ima.tag=ImaTag;
        [cell addSubview:ima];
        [ima release];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 64, 85, 20)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:13];
        lab.textColor=[UIColor whiteColor];
        lab.backgroundColor=[UIColor clearColor];
        lab.tag=StrTag;
        [cell addSubview:lab];
        [lab release];
    }
    UILabel *StrLab=(UILabel *)[cell viewWithTag:StrTag];
    UIImageView *imaV=(UIImageView *)[cell viewWithTag:ImaTag];
    imaV.image=[UIImage imageNamed:[[TabArr objectAtIndex:indexPath.row] objectForKey:@"ImageName"]];
    StrLab.text=[[TabArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if (hasCachedImage([NSURL URLWithString:[[TabArr objectAtIndex:indexPath.row] objectForKey:@"ptPath"]])) {
        imaV.image=[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:[[TabArr objectAtIndex:indexPath.row] objectForKey:@"ptPath"]])];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:cell,@"cell1",indexPath,@"indexPath1",[NSString stringWithFormat:@"%d",ImaTag],@"Tag",[[TabArr objectAtIndex:indexPath.row] objectForKey:@"ptPath"],@"Url",nil];
            [NSThread detachNewThreadSelector:@selector(LoadImage:) toTarget:self withObject:dic];
            [dic release];
        });
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon"  ofType:@"png"];
    
/*    //定义菜单分享列表
//    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeTwitter, ShareTypeFacebook, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeRenren, ShareTypeKaixin, ShareTypeSohuWeibo, ShareType163Weibo, nil];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
//    //定制人人网信息
//    [publishContent addRenRenUnitWithName:NSLocalizedString(@"TEXT_HELLO_RENREN", @"Hello 人人网")
//                              description:INHERIT_VALUE
//                                      url:INHERIT_VALUE
//                                  message:INHERIT_VALUE
//                                    image:INHERIT_VALUE
//                                  caption:nil];
//    
//    //定制QQ空间信息
//    [publishContent addQQSpaceUnitWithTitle:NSLocalizedString(@"TEXT_HELLO_QZONE", @"Hello QQ空间")
//                                        url:INHERIT_VALUE
//                                       site:nil
//                                    fromUrl:nil
//                                    comment:INHERIT_VALUE
//                                    summary:INHERIT_VALUE
//                                      image:INHERIT_VALUE
//                                       type:INHERIT_VALUE
//                                    playUrl:nil
//                                       nswb:nil];
//    
//    //定制微信好友信息
//    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//                                         content:INHERIT_VALUE
//                                           title:NSLocalizedString(@"TEXT_HELLO_WECHAT_SESSION", @"Hello 微信好友!")
//                                             url:INHERIT_VALUE
//                                      thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                           image:INHERIT_VALUE
//                                    musicFileUrl:nil
//                                         extInfo:nil
//                                        fileData:nil
//                                    emoticonData:nil];
//    
//    //定制微信朋友圈信息
//    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
//                                          content:INHERIT_VALUE
//                                            title:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
//                                              url:@"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D"
//                                       thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                            image:INHERIT_VALUE
//                                     musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
//                                          extInfo:nil
//                                         fileData:nil
//                                     emoticonData:nil];
//    
//    //定制微信收藏信息
//    [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
//                                     content:INHERIT_VALUE
//                                       title:NSLocalizedString(@"TEXT_HELLO_WECHAT_FAV", @"Hello 微信收藏!")
//                                         url:INHERIT_VALUE
//                                  thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                       image:INHERIT_VALUE
//                                musicFileUrl:nil
//                                     extInfo:nil
//                                    fileData:nil
//                                emoticonData:nil];
//    
//    //定制QQ分享信息
//    [publishContent addQQUnitWithType:INHERIT_VALUE
//                              content:INHERIT_VALUE
//                                title:@"Hello QQ!"
//                                  url:INHERIT_VALUE
//                                image:INHERIT_VALUE];
//    
//    //定制邮件信息
//    [publishContent addMailUnitWithSubject:@"Hello Mail"
//                                   content:INHERIT_VALUE
//                                    isHTML:[NSNumber numberWithBool:YES]
//                               attachments:INHERIT_VALUE
//                                        to:nil
//                                        cc:nil
//                                       bcc:nil];
//    
//    //定制短信信息
//    [publishContent addSMSUnitWithContent:@"Hello SMS"];
//    
//    
//    //定制易信好友信息
//    [publishContent addYiXinSessionUnitWithType:INHERIT_VALUE
//                                        content:INHERIT_VALUE
//                                          title:INHERIT_VALUE
//                                            url:INHERIT_VALUE
//                                     thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                          image:INHERIT_VALUE
//                                   musicFileUrl:INHERIT_VALUE
//                                        extInfo:INHERIT_VALUE
//                                       fileData:INHERIT_VALUE];
//    
//    //定义易信朋友圈信息
//    [publishContent addYiXinTimelineUnitWithType:INHERIT_VALUE
//                                         content:INHERIT_VALUE
//                                           title:INHERIT_VALUE
//                                             url:INHERIT_VALUE
//                                      thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                           image:INHERIT_VALUE
//                                    musicFileUrl:INHERIT_VALUE
//                                         extInfo:INHERIT_VALUE
//                                        fileData:INHERIT_VALUE];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];*/


//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(go:) userInfo:indexPath repeats:NO];
    [self ShowList];
    if([[TabArr objectAtIndex:indexPath.row] objectForKey:@"clickUrl"]==[NSNull null]){
//        UIAlertView *ar=[[UIAlertView alloc] initWithTitle:@"提示:" message:@"当前暂无点击事件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [ar show];
//        [ar release];
    }else{
//        webVC *web=[[[webVC alloc] initwithStr:[[TabArr objectAtIndex:indexPath.row] objectForKey:@"clickUrl"] title:[[TabArr objectAtIndex:indexPath.row] objectForKey:@"name"]] autorelease];
//        [FirNav pushViewController:web animated:YES];
    }
}

//-(void)go:(id)sender{
//    NSTimer *time=(id)sender;
//    NSIndexPath *inx=(NSIndexPath *)time.userInfo;
//    [self ShowList];
//    if([[TabArr objectAtIndex:inx.row] objectForKey:@"clickUrl"]==[NSNull null]){
//        UIAlertView *ar=[[UIAlertView alloc] initWithTitle:@"提示:" message:@"当前暂无点击事件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [ar show];
//        [ar release];
//    }else{
//        webVC *web=[[[webVC alloc] initwithStr:[[TabArr objectAtIndex:inx.row] objectForKey:@"clickUrl"] title:[[TabArr objectAtIndex:inx.row] objectForKey:@"name"]] autorelease];
//        [FirNav pushViewController:web animated:YES];
//    }
//}

-(void)LoadImage:(NSDictionary*)aDic{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UITableViewCell *ImgCell=[aDic objectForKey:@"cell1"];
    NSIndexPath *Ind=[aDic objectForKey:@"indexPath1"];
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"Url"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil) {
        return;
    }
    
    CGSize origImageSize= [image size];
    
    CGRect newRect;
    newRect.origin= CGPointZero;
    //拉伸到多大
    newRect.size.width=37.5*2;//56*2;
    newRect.size.height=38*2;//56*2;
    
    
    //缩放倍数
    float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    
    //    NSLog(@"%f",ratio);
    UIGraphicsBeginImageContext(newRect.size);
    
    
    CGRect projectRect;
    projectRect.size.width =ratio * origImageSize.width;
    projectRect.size.height=ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
    
    [image drawInRect:projectRect];
    
    
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    
    NSData *smallData=UIImagePNGRepresentation(small);
    if (smallData) {
        [fileManager createFileAtPath:pathForURL(aURL) contents:smallData attributes:nil];
    }
    
    //    [imgDic setObject:small forKey:[[listArr objectAtIndex:Ind.row] objectForKey:@"pic"]];
    if (ImgCell!=nil) {
        [(UIImageView *)[[Firtab cellForRowAtIndexPath:Ind] viewWithTag:[[aDic objectForKey:@"Tag"] intValue]] setImage:small];
    }
    
    UIGraphicsEndImageContext();
    [pool release];
    
}

@end

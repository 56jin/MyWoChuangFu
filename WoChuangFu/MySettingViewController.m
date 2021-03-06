//
//  MySettingViewController.m
//  WoChuangFu
//
//  Created by 陈亦海 on 15/6/3.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "MySettingViewController.h"

#import "TitleBar.h"
#import "CommonMacro.h"
#import "FileHelpers.h"
#import "MessageCenterVC.h"
#import "JiGouWebViewControler.h"

@interface MySettingViewController ()<UITableViewDataSource,UITableViewDelegate,TitleBarDelegate,HttpBackDelegate>

@property(nonatomic,strong)UITableView *myTable;

@property(nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MySettingViewController

@synthesize dataSource = dataSource;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor blackColor];
    [self layoutV];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;;
    // Do any additional setup after loading the view.
}

-(void)layoutV
{
  
    dataSource = [NSMutableArray arrayWithObjects:@"消息中心",@"系统更新", @"清除缓存",@"加入机构",nil];//@"加入机构",
//    dataSource = [NSMutableArray array];
//    [dataSource addObject:@"消息中心"];
//    [dataSource addObject:@"系统更新"];
//    [dataSource addObject:@"清除缓存"];
//    [dataSource addObject:@"加入机构"];
  
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome: NO  ShowSearch: NO  TitlePos:0];
  
    [titleBar setLeftIsHiden: NO ];
    titleBar.title =  @"设置" ;
    titleBar.frame = CGRectMake(0,[UIScreen mainScreen].applicationFrame.origin.y, SCREEN_WIDTH,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    titleBar.target = self;
    
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].applicationFrame.origin.y+TITLE_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-[UIScreen mainScreen].applicationFrame.origin.y-TITLE_BAR_HEIGHT)];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    _myTable.backgroundColor = [ComponentsFactory createColorByHex:@"#efeff4"];
    _myTable.showsVerticalScrollIndicator = NO;
    _myTable.scrollEnabled = NO;
    _myTable.backgroundColor = UIColorWithRGBA(240, 239, 245, 1);
    [self.view addSubview:_myTable];
    _myTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    _myTable.tableFooterView = [[UIView alloc] init];
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction {
   
}

#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCell = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = dataSource[indexPath.row];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"   ---- %d",indexPath.row);
    
    NSInteger row = indexPath.row;
    
    if (row == 1)
    {
        [self updataVersion];
    }
    else if (row == 0)
    {
        MessageCenterVC *messageCenter = [[MessageCenterVC alloc] init];
        messageCenter.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageCenter animated:YES];
    }
    else if (row == 2)
    {
        UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.tag=2324;
        [aler show];
    }
    else if (row == 3){
        
        //        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"加入机构" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        [aler setAlertViewStyle:UIAlertViewStylePlainTextInput];
        //        [aler textFieldAtIndex:0].placeholder = @"请输入机构代码";
        //        aler.tag = 2377;
        //        [aler show];
        
        if ([AppDelegate shareMyApplication].isLogin == NO) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上登录", nil];
            alert.tag = 20015;
            [alert show];
            
            return;
        }
        
        
        
        JiGouWebViewControler *jigou = [[JiGouWebViewControler alloc]init];
        jigou.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jigou animated:YES];
        
        
    }
    else if (row == 4)
    {
        
        bussineDataService *buss=[bussineDataService sharedDataService];
        buss.target=self;
        NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
        
        NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 session,@"sessionId",
                                 nil];
        [buss isRootPush:SendDic];
        
        //        RealNameCarViewController *realName = [[RealNameCarViewController alloc]initWithNibName:@"RealNameCarViewController" bundle:nil];
        //        realName.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:realName animated:YES];
        
    }
    else
        [self ShowProgressHUDwithMessage:@"敬请期待"];
}



- (void)updataVersion
{
    bussineDataService *bus=[bussineDataService sharedDataService];
    bus.target=self;
    [bus updateVersion:nil];
}
- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark -
#pragma mark HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[VersionUpdataMessage getBizCode] isEqualToString:bizCode])
    {
        if([@"7777" isEqualToString:errCode])
        {
            //可选升级
            bussineDataService *bus=[bussineDataService sharedDataService];
            [self showAlertViewTitle:@"有新版本发布，是否升级？"
                             message:[bus.rspInfo objectForKey:@"remark"]==[NSNull null]?@"":[bus.rspInfo objectForKey:@"remark"]
                            delegate:self
                                 tag:10106
                   cancelButtonTitle:@"取消"
                   otherButtonTitles:@"确定", nil];
        }
        else
        {
            [self ShowProgressHUDwithMessage:@"当前已是最新版本"];
        }
    }
    
    if([[RealNameYesOrNoMessage getBizCode] isEqualToString:bizCode])
    {
        
        bussineDataService *bus=[bussineDataService sharedDataService];
        NSLog(@"是否有权限 ：%@",bus.rspInfo);
        if([@"7777" isEqualToString:errCode])
        {
            
            
            
        }
        else
        {
            
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10106)
    {
        if([buttonTitle isEqualToString:@"确定"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            NSLog(@"更新地址 %@",bus.updateUrl);
            NSURL* url = [NSURL URLWithString:bus.updateUrl];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
                exit(0);
            }
        }
    }
    else if(alertView.tag == 2324)
    {
        if([buttonTitle isEqualToString:@"确定"])
        {
            [[NSFileManager defaultManager] removeItemAtPath:pathInCacheDirectory(@"com.xmly") error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:pathInCacheDirectory(@"com.xmly") withIntermediateDirectories:YES attributes:nil error:nil];
            [self ShowProgressHUDwithMessage:@"已清除缓存"];
        }
    }
    else if(alertView.tag == 2377)
    {
        if([buttonTitle isEqualToString:@"确定"])
        {
            //得到输入框
            NSString *beiZhu = [alertView textFieldAtIndex:0].text;
            //        NSLog(@"备注：%@",beiZhu);
            if (beiZhu.length != 0 || ![beiZhu isEqualToString:@""]) {
                [self ShowProgressHUDwithMessage:@"已加入机构"];
            }
            else {
                [self ShowProgressHUDwithMessage:@"请先输入机构代码"];
            }
            
            
        }
    }
    
    else if(alertView.tag == 20015)
    {
        
        [AppDelegate shareMyApplication].selectInteger = 3;
        
        [AppDelegate shareMyApplication].isSeleat = YES;
        [self.tabBarController setSelectedIndex:2];
        
        
    }
    
    
    
}

- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[VersionUpdataMessage getBizCode] isEqualToString:bizCode]){
        if(msg == nil || msg.length <= 0){
            msg = @"获取数据失败!";
            [self ShowProgressHUDwithMessage:msg];
        }else {
            [self ShowProgressHUDwithMessage:msg];
            
        }
    }
    
    if([[RealNameYesOrNoMessage getBizCode] isEqualToString:bizCode]){
        if(msg == nil || msg.length <= 0){
            msg = @"获取数据失败!";
            [self ShowProgressHUDwithMessage:msg];
        }else {
            [self ShowProgressHUDwithMessage:msg];
            
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


@end

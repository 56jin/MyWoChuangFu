//
//  SettingVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "SettingVC.h"
#import "TitleBar.h"
#import "CommonMacro.h"
#import "FileHelpers.h"
#import "MessageCenterVC.h"
#import "JiGouWebViewControler.h"
#import "WoSchoolViewController.h"
#import "RealnameVC.h"
//#import "MySettingViewController.h"
#import "SendOrderVC.h"


@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate,TitleBarDelegate,HttpBackDelegate>
{
    NSString *TabStr;
}
@property(nonatomic,strong)UITableView *myTable;

@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation SettingVC



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_myTable reloadData];
}

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
    
    
    if ([self.isYesOrNo isEqualToString:@"YES"]) {
        _dataSource = [NSMutableArray arrayWithObjects:@"消息中心",@"系统更新", @"清除缓存",@"加入机构",nil];//@"加入机构",
    }
    else {
        _dataSource = [NSMutableArray arrayWithObjects:@"实名返档",@"沃校园办理",@"派单开户",nil]; //@"沃校园办理",@"派单开户",
    }
//    else {
//        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rightBtn setBackgroundColor:[UIColor clearColor]];
//        [rightBtn setFrame: (CGRect){280,5,40,44}];
//        [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [rightBtn setTitle:@"设置" forState:UIControlStateNormal];
//        [rightBtn addTarget:self action:@selector(rightBtnEven) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//        [self.navigationController.navigationItem setRightBarButtonItem:right];
//    }
    
   
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:self.isYesOrNo ? NO : YES ShowSearch: NO  TitlePos:0];
    [titleBar setRightImage: self.isYesOrNo ? @"btn_navbar_home_n":@"icon_navbar_set"];
    [titleBar setLeftIsHiden:self.isYesOrNo ? NO : YES];
    titleBar.title = self.isYesOrNo ? @"设置" : @"工具";
    titleBar.frame = CGRectMake(0,[UIScreen mainScreen].applicationFrame.origin.y, SCREEN_WIDTH,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    titleBar.target = self;
    
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].applicationFrame.origin.y+TITLE_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-[UIScreen mainScreen].applicationFrame.origin.y-TITLE_BAR_HEIGHT- (self.isYesOrNo ? 0 : 49))];
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
    
//    MySettingViewController *setVC = [[MySettingViewController alloc]init];
     SettingVC *setVC = [[SettingVC alloc]init];
    setVC.isYesOrNo = @"YES";
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
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
    cell.textLabel.text = _dataSource[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MainWidth, 60)];
    footView.backgroundColor = [UIColor clearColor];
    
    if (self.isYesOrNo && [self.isYesOrNo isEqualToString:@"YES"]) {
        
        UIButton *realBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 300, 44)];
        realBtn.backgroundColor = [UIColor orangeColor];
        NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
        
        [realBtn setTitle:session ? @"退出登录" : @"请登录" forState:UIControlStateNormal];
        //    [realBtn setImage:[UIImage imageNamed:@"fandang.png"] forState:UIControlStateNormal];
        [realBtn.layer setMasksToBounds:YES];
        [realBtn.layer setCornerRadius:4];
        [realBtn addTarget:self action:@selector(LogoutEven) forControlEvents:UIControlEventTouchUpInside];
        //    realBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 5);
        [realBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [realBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [footView addSubview:realBtn];
    }
   
    return footView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TabStr = _dataSource[indexPath.row];
    
    if ([_dataSource[indexPath.row] isEqualToString:@"系统更新"])
    {
        [self updataVersion];
    }
    else if ([_dataSource[indexPath.row] isEqualToString:@"消息中心"])
    {
        MessageCenterVC *messageCenter = [[MessageCenterVC alloc] init];
        messageCenter.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageCenter animated:YES];
    }
    else if ([_dataSource[indexPath.row] isEqualToString:@"清除缓存"])
    {
        UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aler.tag=2324;
        [aler show];
    }
    else if ([_dataSource[indexPath.row] isEqualToString:@"加入机构"]){
        
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
    else if ([_dataSource[indexPath.row] isEqualToString:@"实名返档"])
    {
        
        [self isRootGuidang];
       
    }
    else if ([_dataSource[indexPath.row] isEqualToString:@"沃校园办理"])
    {
        
        [self isRootGuidang];
        
    }
    else if ([_dataSource[indexPath.row] isEqualToString:@"派单开户"])
    {
        
//        [self isRootGuidang];
        bussineDataService *buss=[bussineDataService sharedDataService];
        buss.target=self;
        NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
        
        NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 session,@"sessionId",
                                 @"openAccount",@"menuName",
                                 nil];
        [buss isRootPush:SendDic];

        
    }

    else
        [self ShowProgressHUDwithMessage:@"敬请期待"];
}

- (void)LogoutEven {
    
     NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    if(!session) {
        [self.tabBarController setSelectedIndex:2];
        return;
   
    }
    
    bussineDataService *buss=[bussineDataService sharedDataServicee];
    buss.target=self;
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             session,@"sessionId",
                             nil];
    [buss usrtLogout:SendDic];
}


- (void)isRootGuidang {
    bussineDataService *buss=[bussineDataService sharedDataService];
    buss.target=self;
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             session,@"sessionId",
                             @"realNameReturn",@"menuName",
                             nil];
    [buss isRootPush:SendDic];

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
    [hud hide:YES afterDelay:2];
}

#pragma mark -
#pragma mark HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
     NSString* oKCode = @"0000";
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
        if([bus.rspInfo[@"respCode"] integerValue] == 0)
        {
           
 
            if ( [TabStr isEqualToString:@"沃校园办理"]) {
               WoSchoolViewController * WoSchoolView = [[WoSchoolViewController alloc]init];
                WoSchoolView.hidesBottomBarWhenPushed = YES;
                NSString *isChangGui = [NSString stringWithFormat:@"%@",bus.rspInfo[@"marketingMethods"]];
                [WoSchoolView setIsCG:isChangGui];
                


                [self.navigationController pushViewController:WoSchoolView animated:YES];
            }
            else if( [TabStr isEqualToString:@"实名返档"]) {

                RealnameVC *realName = [[RealnameVC alloc]init];
                realName.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:realName animated:YES];
                
            }
            else if( [TabStr isEqualToString:@"派单开户"]) {
                
                SendOrderVC *sendOrderVC = [[SendOrderVC alloc] init];
                sendOrderVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sendOrderVC animated:YES];
                
            }

            
        }
        else
        {
            [self ShowProgressHUDwithMessage:@"对不起，您暂无权限查看"];
        }
    }
    
    if([[UserLogoutMessage getBizCode] isEqualToString:bizCode]){
        NSString *msg = nil;
        if([oKCode isEqualToString:errCode]){
            
            bussineDataService *bus=[bussineDataService sharedDataServicee];
            
            NSLog(@"bus,rspInfo是%@",bus.rspInfo);
            [self userLogout];
            
        }else{
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"退出异常！";
            }
            if(nil == msg){
                msg = @"退出异常！";
            }
            [self showSimpleAlertView:msg];
        }
    }


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

- (void)userLogout {
    
   
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.tabBarController.selectedIndex == 2) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
     [self.tabBarController setSelectedIndex:2];
    
        
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
    
    else if(alertView.tag == 10101)
    {
        
        if([buttonTitle isEqualToString:@"重试"]){
            [self isRootGuidang];
        }
        
        
    }
    else if(alertView.tag == 10108)
    {
        
        if([buttonTitle isEqualToString:@"重试"]){
            [self LogoutEven];
        }
        
        
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
//            [self ShowProgressHUDwithMessage:msg];
        }
//        else {
//            [self ShowProgressHUDwithMessage:msg];
//
//        }
//        [self showAlertViewTitle:@"提示"
//                         message:msg
//                        delegate:self
//                             tag:10101
//               cancelButtonTitle:@"取消"
//               otherButtonTitles:@"重试",nil];
        
        
        NSLog(@"\n\n\n\n   chaoshi  :  %@  \n\n\n",msg);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 10101;
        [alert show];
    

        
    }
    
    if([[UserLogoutMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"退出失败！";
        }
        if(nil == msg){
            msg = @"退出失败！";
        }
        
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10108
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"重试",nil];
        

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

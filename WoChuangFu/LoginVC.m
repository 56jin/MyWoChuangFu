//
//  LoginVC.m
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-10.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "LoginVC.h"
#import "RegdistVC.h"
#import "CommonMacro.h"

#define LOGIN_TYPE_PERSON 100
#define LOGIN_TYPE_COMPANY 101

@interface LoginVC ()

@property(nonatomic,retain)NSDictionary *SendDic;

@end

@implementation LoginVC
@synthesize titleBar;
@synthesize SendDic;

-(void)loadView
{
    [super loadView];
    [self LayoutV];
    [self initTitleBar];
//    CGRect ScF=[UIScreen mainScreen].bounds;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 8, 28, 28);
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"back-on.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];

}

- (void)initTitleBar
{
    TitleBar* title = [[TitleBar alloc] initWithFram:CGRectMake(0, 20, SCREEN_WIDTH, 44) ShowHome:YES ShowSearch:NO TitlePos:left_position];
    [title setLeftIsHiden:NO];
    [title setTitle:@"提交订单"];
    title.target = self;
    self.titleBar = title;
    [title release];
    [self.view addSubview:self.titleBar];
    
}
-(void)LayoutV
{
    
    UIView *BackV=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    BackV.backgroundColor=[ComponentsFactory createColorByHex:@"#F4F4F4"];
    [self.view addSubview:BackV];
    self.view.backgroundColor = [UIColor blackColor];
    [BackV release];
    
    UIImageView *LogoImg=[[UIImageView alloc] initWithFrame:CGRectMake(117.5, 20, 83.5, 22)];
    LogoImg.image=[UIImage imageNamed:@"logo.png"];
    [BackV addSubview:LogoImg];
    [LogoImg release];
    
    UIImageView *biaoyuImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 55, 320, 11.5)];
    biaoyuImg.image=[UIImage imageNamed:@"biaoyu.png"];
    [BackV addSubview:biaoyuImg];
    [biaoyuImg release];
    
    UIImageView *beijinImg=[[UIImageView alloc] initWithFrame:CGRectMake(24.5, 78+10, 271, 168.5)];
    beijinImg.image=[UIImage imageNamed:@"beijin.png"];
    beijinImg.userInteractionEnabled=YES;
    [BackV addSubview:beijinImg];
    
    float offset_y = 15.0;
    UILabel *zhanghuLab=[ComponentsFactory labelWithFrame:CGRectMake(0, 30+offset_y, 69, 30.5) text:@"账户:" textColor:[ComponentsFactory createColorByHex:@"#f96c00"] font:[UIFont systemFontOfSize:14] tag:0 hasShadow:NO];
    zhanghuLab.textAlignment=NSTextAlignmentRight;
    [beijinImg addSubview:zhanghuLab];
    
    NameTextField=[[UITextField alloc] initWithFrame:CGRectMake(73, 30+offset_y, 168, 30.5)];
    NameTextField.background=[UIImage imageNamed:@"shuru.png"];
    NameTextField.textAlignment=UITextAlignmentLeft;
    NameTextField.delegate=self;
    NameTextField.font=[UIFont systemFontOfSize:14];
    NameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    NameTextField.placeholder=@"请输入用户名";
    NameTextField.returnKeyType=UIReturnKeyDefault;
    NameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [beijinImg addSubview:NameTextField];
    
    UILabel *mimaLab=[ComponentsFactory labelWithFrame:CGRectMake(0, 80+offset_y, 69, 30.5) text:@"密码:" textColor:[ComponentsFactory createColorByHex:@"#f96c00"] font:[UIFont systemFontOfSize:14] tag:0 hasShadow:NO];
    mimaLab.textAlignment=NSTextAlignmentRight;
    [beijinImg addSubview:mimaLab];
    
    PassTextField=[[UITextField alloc] initWithFrame:CGRectMake(73, 80+offset_y, 168, 30.5)];
    PassTextField.background=[UIImage imageNamed:@"shuru.png"];
    PassTextField.textAlignment=UITextAlignmentLeft;
    PassTextField.secureTextEntry = YES;
    PassTextField.delegate=self;
    PassTextField.font=[UIFont systemFontOfSize:14];
    PassTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    PassTextField.placeholder=@"请输入密码";
    PassTextField.returnKeyType=UIReturnKeyDefault;
    PassTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [beijinImg addSubview:PassTextField];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]!=nil){
        NameTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PassWord"]!=nil){
        PassTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"PassWord"];
    }
    
    //登录类型
    loginType = 1;
    float min_offset = 5.0;
    UIButton *personBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.frame=CGRectMake((320-92*2)/2, 83, 92, 32);
    [personBtn setBackgroundImage:[UIImage imageNamed:@"login_type_sheet_a.png"] forState:UIControlStateNormal];
    personBtn.tag = LOGIN_TYPE_PERSON;
    [personBtn setTitle:@"个人账户" forState:UIControlStateNormal];
    [personBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    personBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [personBtn addTarget:self action:@selector(changeLoginType:) forControlEvents:UIControlEventTouchUpInside];
    [BackV addSubview:personBtn];
    UIButton *companyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    companyBtn.frame=CGRectMake((320-92*2)/2 +min_offset +92, 83, 92, 32);
    [companyBtn setBackgroundImage:[UIImage imageNamed:@"login_type_sheet.png"] forState:UIControlStateNormal];
    companyBtn.tag = LOGIN_TYPE_COMPANY;
    [companyBtn setTitle:@"企业账户" forState:UIControlStateNormal];
    [companyBtn setTitleColor:[ComponentsFactory createColorByHex:@"#545454"]  forState:UIControlStateNormal];
    companyBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [companyBtn addTarget:self action:@selector(changeLoginType:) forControlEvents:UIControlEventTouchUpInside];
    [BackV addSubview:companyBtn];
    
    UIButton *LogInBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    LogInBtn.frame=CGRectMake(48.5, 78+168.5+30, 223, 31);
    [LogInBtn setBackgroundImage:[UIImage imageNamed:@"Anniu.png"] forState:UIControlStateNormal];
    [LogInBtn setBackgroundImage:[UIImage imageNamed:@"Anniu-on.png"] forState:UIControlStateHighlighted];
    [LogInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [LogInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LogInBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [LogInBtn addTarget:self action:@selector(Log) forControlEvents:UIControlEventTouchUpInside];
    [BackV addSubview:LogInBtn];
    [beijinImg release];
    
    UILabel *regdistLable=[ComponentsFactory labelWithFrame:CGRectMake(90, 78+168.5+30+31+15, 80, 20) text:@"还没有账号？" textColor:[ComponentsFactory createColorByHex:@"#9c9c9c"] font:[UIFont systemFontOfSize:13] tag:0 hasShadow:NO];
    mimaLab.textAlignment=NSTextAlignmentRight;
    [BackV addSubview:regdistLable];

    UIButton *regdistBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    regdistBtn.frame=CGRectMake(170, 78+168.5+30+31+15, 150, 20);
    regdistBtn.backgroundColor = [UIColor clearColor];
    [regdistBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [regdistBtn setTitleColor:[ComponentsFactory createColorByHex:@"#f96c00"] forState:UIControlStateNormal];
    regdistBtn.titleLabel.font=[UIFont systemFontOfSize:13];
//    regdistBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    regdistBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [regdistBtn addTarget:self action:@selector(gotoRegdistVC) forControlEvents:UIControlEventTouchUpInside];
    [BackV addSubview:regdistBtn];
}

-(void)gotoRegdistVC
{
    RegdistVC *regdistVC = [[RegdistVC alloc] init];
//    if(loginType == 1){
//        regdistVC.Url = @"http://o2o.gx10010.com/reg/?type=gr&over=1";
//    } else {
//        regdistVC.Url = @"http://o2o.gx10010.com/reg/?type=jg&over=1";
//    }
    [self.navigationController pushViewController:regdistVC animated:YES];
    [regdistVC release];
}

-(void)Log
{
    [NameTextField resignFirstResponder];
    [PassTextField resignFirstResponder];
    if([NameTextField.text length]==0){
        [self showSimpleAlertView:@"请输入账户"];
    }else if([PassTextField.text length]==0){
        [self showSimpleAlertView:@"请输入密码"];
    }else{
        bussineDataService *bus=[bussineDataService sharedDataService];
        
        bus.target=self;
        NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                           PassTextField.text,@"passWd",
                           NameTextField.text,@"userCode",
                           loginType==1? @"1":@"2",@"type",
                           nil];
        self.SendDic=dic;
        [bus login:dic];
        [dic release];
    }
}

-(void)changeLoginType:(id)sender
{
    UIView *actionView = (UIView*)sender;
    UIButton* personBtn = (UIButton*)[self.view viewWithTag:LOGIN_TYPE_PERSON];
    UIButton* companyBtn = (UIButton*)[self.view viewWithTag:LOGIN_TYPE_COMPANY];
    if(actionView.tag == LOGIN_TYPE_PERSON){
        loginType = 1;
        [personBtn setBackgroundImage:[UIImage imageNamed:@"login_type_sheet_a.png"] forState:UIControlStateNormal];
        [personBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [companyBtn setBackgroundImage:[UIImage imageNamed:@"login_type_sheet.png"] forState:UIControlStateNormal];
        [companyBtn setTitleColor:[ComponentsFactory createColorByHex:@"#545454"] forState:UIControlStateNormal];
    } else{// if(actionView.tag == LOGIN_TYPE_COMPANY){
        loginType = 2;
        [personBtn setBackgroundImage:[UIImage imageNamed:@"login_type_sheet.png"] forState:UIControlStateNormal];
        [personBtn setTitleColor:[ComponentsFactory createColorByHex:@"#545454"] forState:UIControlStateNormal];
        [companyBtn setBackgroundImage:[UIImage imageNamed:@"login_type_sheet_a.png"] forState:UIControlStateNormal];
        [companyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.SendDic=nil;
    [NameTextField release];
    [PassTextField release];
    [titleBar release];
    [super dealloc];
    
}

#pragma mark -
#pragma mark HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
//    MyLog(@"%@",info);
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[LoginMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            
            NSMutableString *nameStr=[NSMutableString stringWithFormat:@"%@",NameTextField.text];
            [APService setTags:[NSSet setWithObjects:nil] alias:[NSString stringWithFormat:@"%@",[nameStr stringByReplacingOccurrencesOfString:@"@" withString:@""]] callbackSelector:nil target:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:NameTextField.text forKey:@"UserName"];
            [[NSUserDefaults standardUserDefaults] setObject:PassTextField.text forKey:@"PassWord"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if([bus.rspInfo objectForKey:@"adminUrl"]==[NSNull null]){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                bus.HasLogIn=YES;
                webVC *web=[[[webVC alloc] initwithStr:[bus.rspInfo objectForKey:@"adminUrl"] title:@"沃创富" withType:@"1"] autorelease];
                [self.navigationController pushViewController:web animated:YES];
            }
        }else{
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"登录异常！";
            }
            if(nil == msg){
                msg = @"登录异常！";
            }
            [self showSimpleAlertView:msg];
        }
    }
}

- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[LoginMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
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
               otherButtonTitles:@"重试",nil];
        
    }
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10101){
        if([buttonTitle isEqualToString:@"重试"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [bus login:self.SendDic];
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
    [alert release];
    
    [argsArray release];
}

-(void)showSimpleAlertView:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
   
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    //    [self showSimpleAlertView:[NSString stringWithFormat:@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias]];
    MyLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

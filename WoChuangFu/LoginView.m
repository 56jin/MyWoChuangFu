//
//  LoginView.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/31.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "LoginView.h"
#import "UIImage+LXX.h"
#import "QkFirstPageVC.h"
#import "UrlParser.h"

#define TOP_VIEW_HEIGHT 100
#define INPUT_VIEW_HEIGHT 100
#define BUTTON_HEIGHT  44
#define MARGIN 20

@implementation LoginView

@synthesize SendDic;
@synthesize NameTextField;
@synthesize PassTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllFirstResponder)];
        [self addGestureRecognizer:tapGestureRecognizer];
       [self LayoutV];
       [self login];  //取消自动登录
    }
    return self;
}

- (void)login
{
    bussineDataService *buss=[bussineDataService sharedDataServicee];
    buss.target=self;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"PassWord"];
    if (userName !=nil && passWord != nil&&![userName isEqualToString:@""]&&![passWord isEqualToString:@""]) {
        NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                           passWord,@"passWd",
                           userName,@"userCode",
                           nil];
        [buss qiankaLogin:dic];
    }
}
-(void)LayoutV
{
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,TOP_VIEW_HEIGHT)];
    topView.contentMode = UIViewContentModeCenter;
    topView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
//    [self addSubview:topView];
    
    UIImageView *DottedLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_login_xline"]];
    DottedLine.frame = CGRectMake(30,15,250, 44);
//    [topView addSubview:DottedLine];
    
    UIImageView *banner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,TOP_VIEW_HEIGHT)];
//    banner.backgroundColor = [UIColor redColor];
    banner.image = [UIImage imageNamed:@"banner.jpg"];
    banner.center = CGPointMake(topView.frame.size.width/2,topView.frame.size.height/2);
    [self addSubview:banner];
    
    UIView *inputBgView = [[UIView alloc] initWithFrame:CGRectMake(0,TOP_VIEW_HEIGHT+5,self.frame.size.width,INPUT_VIEW_HEIGHT)];
    [inputBgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:inputBgView];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(50,50, self.frame.size.width,1)];
    separatorLine.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [inputBgView addSubview:separatorLine];
    
    NameTextField = [[UITextField alloc] initWithFrame:CGRectMake(55,10,200, 33)];
    NameTextField.placeholder = @"手机号码/QQ/邮箱";
    NameTextField.delegate = self;
    NameTextField.returnKeyType = UIReturnKeyDone;
    [inputBgView addSubview:NameTextField];
    
    PassTextField = [[UITextField alloc] initWithFrame:CGRectMake(55,60,200,33)];
    PassTextField.secureTextEntry =YES;
    PassTextField.placeholder = @"请输入密码";
    PassTextField.delegate = self;
    PassTextField.returnKeyType = UIReturnKeyDone;
    PassTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputBgView addSubview:PassTextField];
    
    UIImageView *userNameIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_account"]];
    userNameIcon.contentMode = UIViewContentModeCenter;
    userNameIcon.frame =  CGRectMake(0,0,50,50);
    UIImageView *passWordIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_password"]];
    passWordIcon.contentMode = UIViewContentModeCenter;
    passWordIcon.frame =  CGRectMake(0,50,50,50);
    
    [inputBgView addSubview:userNameIcon];
    [inputBgView addSubview:passWordIcon];
    
//    UIButton *passWordSwitch = [[UIButton alloc] initWithFrame:CGRectMake(250,50,50,50)];
//    [passWordSwitch setImage:[UIImage imageNamed:@"btn_login_eye_p"] forState:UIControlStateNormal];
//    [passWordSwitch setImage:[UIImage imageNamed:@"btn_login_eye.png"] forState:UIControlStateSelected];
//    [passWordSwitch addTarget:self action:@selector(changeSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
//
//    [inputBgView addSubview:passWordSwitch];
    
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(10,TOP_VIEW_HEIGHT+INPUT_VIEW_HEIGHT+MARGIN,self.frame.size.width-20,44);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = [ComponentsFactory createColorByHex:@"#ff6600"];
    [loginBtn setBackgroundImage:[UIImage resizedImage:@"bnt_content_primary_n"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];

    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake(40,TOP_VIEW_HEIGHT+INPUT_VIEW_HEIGHT+BUTTON_HEIGHT+30,90,44);
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [registerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(gotoRegdistVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(160,TOP_VIEW_HEIGHT+INPUT_VIEW_HEIGHT+BUTTON_HEIGHT+45,1,14)];
    separator.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separator];
    
    UIButton *getBackPassWordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    getBackPassWordBtn.frame=CGRectMake(190,TOP_VIEW_HEIGHT+INPUT_VIEW_HEIGHT+BUTTON_HEIGHT+30,90,44);
    [getBackPassWordBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [getBackPassWordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [getBackPassWordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [getBackPassWordBtn addTarget:self action:@selector(getBackPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:getBackPassWordBtn];
}

- (void)changeSecureTextEntry:(UIButton *)mySwitch
{
    mySwitch.selected = !mySwitch.selected;
    PassTextField.secureTextEntry = !mySwitch.selected;
}
- (void)resignAllFirstResponder
{
    [NameTextField resignFirstResponder];
    [PassTextField resignFirstResponder];
}

-(void)login:(UIButton *)sender
{
    if([NameTextField.text length]==0){
        [self showSimpleAlertView:@"请输入账户"];
        [NameTextField becomeFirstResponder];
    }else if([PassTextField.text length]==0){
        [self showSimpleAlertView:@"请输入密码"];
        [PassTextField becomeFirstResponder];
    }else{
        [self resignAllFirstResponder];
        bussineDataService *buss=[bussineDataService sharedDataServicee];
        buss.target=self;
        NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                           PassTextField.text,@"passWd",
                           NameTextField.text,@"userCode",
                           nil];
        [buss qiankaLogin:dic];
    }
}

-(void)gotoRegdistVC
{
    if ([self.delegate respondsToSelector:@selector(didClickedRegister)]){
        [self.delegate didClickedRegister];
    }
}
-(void)getBackPassWord
{
    if ([self.delegate respondsToSelector:@selector(didClickedGetBackPassWord)]){
        [self.delegate didClickedGetBackPassWord];
    }
}

#pragma mark -
#pragma mark HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
    MyLog(@"登录返回信息 \n\n\n %@ \n\n\n",info);
    
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[QianKaLoginMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataServicee];
            
            NSMutableString *nameStr=[NSMutableString stringWithFormat:@"%@",NameTextField.text];
            [APService setTags:[NSSet setWithObjects:nil] alias:[NSString stringWithFormat:@"%@",[nameStr stringByReplacingOccurrencesOfString:@"@" withString:@""]] callbackSelector:nil target:nil];
         NSLog(@"bus,rspInfo是%@",bus.rspInfo);
            NSString *userId = bus.rspInfo[@"userId"];
            
            MyLog(@"\n\n\n\n\nuserId id %@\n\n\n\n\n",userId);
            NSString *userCode = bus.rspInfo[@"userCode"];
            _loadUrl= bus.rspInfo[@"loadUrl"];
            NSString *qq = bus.rspInfo[@"qq"];
            NSString *sessionid = bus.rspInfo[@"sessionId"];;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:sessionid forKey:@"sessionid"];
            [user setObject:qq forKey:@"qq"];
            NSLog(@"returnUrl的值是%@",_loadUrl);
           

            if (![PassTextField.text isEqualToString:@""]&&PassTextField.text != nil) {
                [[NSUserDefaults standardUserDefaults] setObject:PassTextField.text forKey:@"PassWord"];
            }
            if (![NameTextField.text isEqualToString:@""]&&NameTextField.text != nil) {
                [[NSUserDefaults standardUserDefaults] setObject:NameTextField.text forKey:@"UserName"];
            }
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
//            [[NSUserDefaults standardUserDefaults] setObject:userType forKey:@"userType"];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            NSArray *menus = bus.rspInfo[@"menus"];

            bus.HasLogIn=YES;
            
//            QkFirstPageVC *firstPage = [[QkFirstPageVC alloc]init];
            
//            [UIApplication sharedApplication].keyWindow.rootViewController = firstPage;
//            [self addSubview:firstPage.view];
            
//            [self removeFromSuperview];
            
            
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_loadUrl]];   //旧的跳转Safari浏览器
            
             
            [AppDelegate shareMyApplication].isLogin = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessReture:)]) {
                [self.delegate loginSuccessReture:_loadUrl];
            }
            
//            if ([self.delegate respondsToSelector:@selector(loginSuccess:)])
//            {
//                [self.delegate loginSuccess:menus];
//            }

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
    
    if([[QianKaLoginMessage getBizCode] isEqualToString:bizCode]){
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
//    [alert release];
//    
//    [argsArray release];
}

-(void)showSimpleAlertView:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
//    [alert release];
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


@end

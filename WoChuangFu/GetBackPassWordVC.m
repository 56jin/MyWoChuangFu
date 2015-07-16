//
//  GetBackPassWordVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-28.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "GetBackPassWordVC.h"
#import "TitleBar.h"
#import "UIImage+LXX.h"
#import "CommonMacro.h"
#define TOP_VIEW_HEIGHT 100
#define PHONE_NUMBER_TAG 6000
#define CHECK_NUMBER_TAG 6001
#define NEW_PASSWORD_TAG 6002

@interface GetBackPassWordVC ()<TitleBarDelegate,UITextFieldDelegate,HttpBackDelegate>

@property(nonatomic,strong) NSMutableDictionary *getBackPassWordDict;

@end

@implementation GetBackPassWordVC

- (NSMutableDictionary *)getBackPassWordDict
{
    if (_getBackPassWordDict == nil) {
        _getBackPassWordDict = [NSMutableDictionary dictionary];
    }
    return _getBackPassWordDict;
}

#pragma mark
#pragma mark - 初始化视图
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor blackColor];
    [self initTitleBar];
    [self initMainView];
}

- (void)initTitleBar
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    titleBar.frame = CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y,[AppDelegate sharePhoneWidth],44);
    titleBar.title = @"找回密码";
    titleBar.target = self;
    [self.view addSubview:titleBar];
}

- (void)initMainView
{
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y+TITLE_BAR_HEIGHT,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-[[UIScreen mainScreen] applicationFrame].origin.y)];
    mainView.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
    mainView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self.view addSubview:mainView];
    
    
    UIImageView *banner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,TOP_VIEW_HEIGHT)];
    //    banner.backgroundColor = [UIColor redColor];
    banner.image = [UIImage imageNamed:@"banner.jpg"];
    banner.center = CGPointMake(banner.frame.size.width/2,banner.frame.size.height/2);
    [mainView addSubview:banner];
    
    //手机号
    UIView *phoneBgView = [[UIView alloc] initWithFrame:CGRectMake(0,10+TOP_VIEW_HEIGHT,[AppDelegate sharePhoneWidth],50)];
    phoneBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:phoneBgView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,30)];
    phoneLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    phoneLabel.text = @"手机号:";
    [phoneBgView addSubview:phoneLabel];
    
    UITextField *phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(80,10,160,30)];
    phoneNum.placeholder = @"请输入手机号码";
    phoneNum.delegate = self;
    phoneNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneNum.returnKeyType = UIReturnKeyDone;
    phoneNum.tag = PHONE_NUMBER_TAG;
    [phoneBgView addSubview:phoneNum];
    
    UIButton *sendCheckNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCheckNumBtn.frame = CGRectMake(phoneBgView.frame.size.width-85,(50-28)/2, 80,28);
    [sendCheckNumBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendCheckNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sendCheckNumBtn setBackgroundImage:[UIImage resizedImage:@"btn_login_yzm"] forState:UIControlStateNormal];
    [sendCheckNumBtn setBackgroundImage:[UIImage resizedImage:@"btn_login_yzm_p"] forState:UIControlStateHighlighted];
    [sendCheckNumBtn addTarget:self action:@selector(sendCheckNumberRequest:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBgView addSubview:sendCheckNumBtn];
    
    UIView *checkNumBgView = [[UIView alloc] initWithFrame:CGRectMake(0,61+TOP_VIEW_HEIGHT,[AppDelegate sharePhoneWidth],50)];
    checkNumBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:checkNumBgView];
    
    UILabel *checkNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,30)];
    checkNumLabel.text = @"验证码:";
    checkNumLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    [checkNumBgView addSubview:checkNumLabel];
    
    UITextField *checkNum = [[UITextField alloc] initWithFrame:CGRectMake(80,10,200,30)];
    checkNum.delegate = self;
    checkNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    checkNum.placeholder = @"请输入验证码";
    checkNum.returnKeyType = UIReturnKeyDone;
    checkNum.tag = CHECK_NUMBER_TAG;
    [checkNumBgView addSubview:checkNum];
    
    UIView *newPassWordBgView = [[UIView alloc] initWithFrame:CGRectMake(0,135+TOP_VIEW_HEIGHT,[AppDelegate sharePhoneWidth],50)];
    newPassWordBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:newPassWordBgView];
    UILabel *newPassWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,30)];
    newPassWordLabel.text = @"新密码:";
    newPassWordLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    [newPassWordBgView addSubview:newPassWordLabel];
    
    UITextField *newPassWord = [[UITextField alloc] initWithFrame:CGRectMake(80,10,180,30)];
    newPassWord.delegate = self;
    newPassWord.placeholder = @"请输入新密码";
    newPassWord.secureTextEntry = YES;
    newPassWord.tag = NEW_PASSWORD_TAG;
    newPassWord.returnKeyType = UIReturnKeyDone;
    newPassWord.clearButtonMode  = UITextFieldViewModeWhileEditing;
    [newPassWordBgView addSubview:newPassWord];
    
//    UIButton *passWordSwitch = [[UIButton alloc] initWithFrame:CGRectMake(260,0,50,50)];
//    [passWordSwitch setImage:[UIImage imageNamed:@"btn_login_eye_p"] forState:UIControlStateNormal];
//    [passWordSwitch setImage:[UIImage imageNamed:@"btn_login_eye.png"] forState:UIControlStateSelected];
//    [passWordSwitch addTarget:self action:@selector(changeSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
//    [newPassWordBgView addSubview:passWordSwitch];
    
    UIButton *getBackPassWordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [getBackPassWordBtn setBackgroundImage:[UIImage resizedImage:@"bnt_content_primary_n"] forState:UIControlStateNormal];
    getBackPassWordBtn.frame=CGRectMake(10,200+TOP_VIEW_HEIGHT,[AppDelegate sharePhoneWidth]-20,44);
    [getBackPassWordBtn setTitle:@"提交" forState:UIControlStateNormal];
    [getBackPassWordBtn addTarget:self action:@selector(getBackPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:getBackPassWordBtn];
    
}
- (void)changeSecureTextEntry:(UIButton *)mySwitch
{
    mySwitch.selected = !mySwitch.selected;
    UITextField *newPwd = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    newPwd.secureTextEntry = !mySwitch.selected;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加单击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllFirstResponder)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark - ButtonAction
- (void)getBackPassWord:(UIButton *)sender
{
    [self resignAllFirstResponder];
    if ([self inputCheck]) {
        [self sendGetBackPwdRequest];
    }
}

#pragma mark
#pragma mark - 网络请求

- (void)sendGetBackPwdRequest
{
    if ([self.getBackPassWordDict objectForKey:@"serverPhone"]==nil||[self.getBackPassWordDict objectForKey:@"serverCode"]==nil){
        [self ShowProgressHUDwithMessage:@"请先获取手机验证码"];
    }else
    {
        UITextField *phoneNumber = (UITextField *)[self.view viewWithTag:PHONE_NUMBER_TAG];
        UITextField *checkNumber = (UITextField *)[self.view viewWithTag:CHECK_NUMBER_TAG];
        UITextField *newPassWord = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
        bussineDataService *bus=[bussineDataService sharedDataService];
        bus.target=self;
        [self.getBackPassWordDict setObject:phoneNumber.text forKey:@"phoneNumber"];
        [self.getBackPassWordDict setObject:checkNumber.text forKey:@"identifyCode"];
        [self.getBackPassWordDict setObject:newPassWord.text forKey:@"passWord"];
        [bus getBackPwd:self.getBackPassWordDict];
    }
}

-(void)sendCheckNumberRequest:(UIButton *)sender
{
    UITextField *phoneNumber = (UITextField *)[self.view viewWithTag:PHONE_NUMBER_TAG];
    if(phoneNumber.text.length!=11) {
        [self ShowProgressHUDwithMessage:@"请输入11位手机号码！"];
    }
    else{
        [phoneNumber resignFirstResponder];
        [sender setBackgroundImage:[UIImage resizedImage:@"btn_login_yzm_lose"] forState:UIControlStateNormal];
        [sender setTitleColor:[ComponentsFactory createColorByHex:@"#666666"] forState:UIControlStateNormal];
        bussineDataService *bus=[bussineDataService sharedDataService];
        bus.target=self;
        NSDictionary *checkNumberRequestDict= [NSDictionary dictionaryWithObjectsAndKeys:
                                               phoneNumber.text,@"phoneNumber",
                                               @"1",@"requestType",nil];
        
        [bus checkNum:checkNumberRequestDict];
        
        __block int timeout=59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [sender setBackgroundImage:[UIImage resizedImage:@"btn_login_yzm"] forState:UIControlStateNormal];
                    [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                    sender.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sender setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                    sender.userInteractionEnabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}
#pragma mark 输入检测
- (BOOL)inputCheck
{
    UITextField *phoneNumber = (UITextField *)[self.view viewWithTag:PHONE_NUMBER_TAG];
    UITextField *checkNumber = (UITextField *)[self.view viewWithTag:CHECK_NUMBER_TAG];
    UITextField *newPassWord = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    if ([phoneNumber.text isEqualToString:@""]) {
        [self ShowProgressHUDwithMessage:@"手机号码不能为空！"];
        [phoneNumber becomeFirstResponder];
        return NO;
    }else if(phoneNumber.text.length != 11){
        [self ShowProgressHUDwithMessage:@"请输入11位手机号码！"];
        [phoneNumber becomeFirstResponder];
        return NO;
    }else if ([checkNumber.text isEqualToString:@""]) {
        [checkNumber becomeFirstResponder];
        [self ShowProgressHUDwithMessage:@"验证码不能为空！"];
        return NO;
    }else if ([newPassWord.text isEqualToString:@""]) {
        [newPassWord becomeFirstResponder];
        [self ShowProgressHUDwithMessage:@"新密码不能为空！"];
        return NO;
    }else{
        return YES;
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

- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark 取消键盘
-(void)resignAllFirstResponder
{
    UITextField *phoneNumber = (UITextField *)[self.view viewWithTag:PHONE_NUMBER_TAG];
    [phoneNumber resignFirstResponder];
    UITextField *checkNumber = (UITextField *)[self.view viewWithTag:CHECK_NUMBER_TAG];
    [checkNumber resignFirstResponder];
    UITextField *newPassWord = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    [newPassWord resignFirstResponder];
}

#pragma mark
#pragma mark - TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - HttpBackDelegete
-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[CheckNumMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            
            if (bus.rspInfo[@"phoneNumber"] != [NSNull null]) {
                [self.getBackPassWordDict setObject:bus.rspInfo[@"phoneNumber"] forKey:@"serverPhone"];
            }
            if (bus.rspInfo[@"phoneCode"] != [NSNull null]) {
                [self.getBackPassWordDict setObject:bus.rspInfo[@"phoneCode"] forKey:@"serverCode"];
            }
        }else{
            
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"获取数据异常！";
            }
            if(nil == msg){
                msg = @"获取数据异常！";
            }
            [self ShowProgressHUDwithMessage:msg];
        }
    }else if ([[GetBackPwdMessage getBizCode] isEqualToString:bizCode]){
        if ([oKCode isEqualToString:errCode]) {
            msg = @"修改密码成功!";
            [self ShowProgressHUDwithMessage:@"修改密码成功！"];
            [self backAction];
        }else{
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"修改密码失败！";
            }
            if(nil == msg){
                msg = @"修改密码失败！";
            }
            [self ShowProgressHUDwithMessage:msg];
        }
    }
}

-(void)requestFailed:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if([[CheckNumMessage getBizCode] isEqualToString:bizCode])
    {
        if([info objectForKey:@"MSG"] == [NSNull null]||nil == msg)
        {
            msg = @"获取失败请重新获取验证码！";
        }
        [self ShowProgressHUDwithMessage:msg];
    }else{
        
        [self ShowProgressHUDwithMessage:msg];
    }
}



@end

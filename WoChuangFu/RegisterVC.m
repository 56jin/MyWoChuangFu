//
//  RegisterVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-28.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "RegisterVC.h"
#import "TitleBar.h"
#import "UIImage+LXX.h"
#import "CommonMacro.h"
#define TOP_VIEW_HEIGHT 100
#define BG_HEIGHT 50

#define PHONE_NUMBER_TAG 8000
#define CHECK_NUMBER_TAG 8001
#define PASS_WORD_TAG    8002
#define DEVELOPER_TAG    8003
#define SURE_PASS_WORD_TAG    8004

@interface RegisterVC ()<TitleBarDelegate,UITextFieldDelegate,HttpBackDelegate>

@property(nonatomic,strong) NSMutableDictionary *registerDict;

@end

@implementation RegisterVC

- (NSMutableDictionary *)registerDict
{
    if (_registerDict == nil) {
        _registerDict = [NSMutableDictionary dictionary];
        [_registerDict setObject:@"1" forKey:@"userType"];
    }
    return _registerDict;
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
    titleBar.title = @"沃创富用户注册";
    titleBar.target = self;
    [self.view addSubview:titleBar];
}

- (void)initMainView
{
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y+TITLE_BAR_HEIGHT,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-[[UIScreen mainScreen] applicationFrame].origin.y)];
    mainView.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
    mainView.showsVerticalScrollIndicator = NO;
    mainView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self.view addSubview:mainView];
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[AppDelegate sharePhoneWidth],TOP_VIEW_HEIGHT)];
    topView.contentMode = UIViewContentModeCenter;
    topView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [mainView addSubview:topView];
    
    UIImageView *DottedLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_login_xline"]];
    DottedLine.frame = CGRectMake(30,15,250, 44);
    [topView addSubview:DottedLine];
    
    UIImageView *banner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,TOP_VIEW_HEIGHT)];
    //    banner.backgroundColor = [UIColor redColor];
    banner.image = [UIImage imageNamed:@"banner.jpg"];
    banner.center = CGPointMake(topView.frame.size.width/2,topView.frame.size.height/2);
    [mainView addSubview:banner];
    
    //手机号
    UIView *phoneBgView = [[UIView alloc] initWithFrame:CGRectMake(0,TOP_VIEW_HEIGHT,[AppDelegate sharePhoneWidth],BG_HEIGHT)];
    phoneBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:phoneBgView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,30)];
    phoneLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    phoneLabel.text = @"手机号";
    [phoneBgView addSubview:phoneLabel];
    
    UITextField *phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(90,10,160,30)];
    phoneNum.placeholder = @"请输入手机号码";
    phoneNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneNum.delegate = self;
    phoneNum.returnKeyType = UIReturnKeyDone;
    phoneNum.tag = PHONE_NUMBER_TAG;
    [phoneBgView addSubview:phoneNum];
    
    UIButton *sendCheckNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCheckNumBtn.frame = CGRectMake(phoneBgView.frame.size.width-85,(BG_HEIGHT-28)/2, 80,28);
    [sendCheckNumBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendCheckNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sendCheckNumBtn setBackgroundImage:[UIImage resizedImage:@"btn_login_yzm"] forState:UIControlStateNormal];
    [sendCheckNumBtn setBackgroundImage:[UIImage resizedImage:@"btn_login_yzm_p"] forState:UIControlStateHighlighted];
    [sendCheckNumBtn addTarget:self action:@selector(sendCheckNumberRequest:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBgView addSubview:sendCheckNumBtn];
    
    UIView *checkNumBgView = [[UIView alloc] initWithFrame:CGRectMake(0,TOP_VIEW_HEIGHT+BG_HEIGHT+1,[AppDelegate sharePhoneWidth],50)];
    checkNumBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:checkNumBgView];
    
    UILabel *checkNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,30)];
    checkNumLabel.text = @"验证码";
    checkNumLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    [checkNumBgView addSubview:checkNumLabel];
    
    UITextField *checkNum = [[UITextField alloc] initWithFrame:CGRectMake(90,10,200,30)];
    checkNum.delegate = self;
    checkNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    checkNum.placeholder = @"请输入验证码";
    checkNum.returnKeyType = UIReturnKeyDone;
    checkNum.tag = CHECK_NUMBER_TAG;
    [checkNumBgView addSubview:checkNum];
    
    UIView *passWordBgView = [[UIView alloc] initWithFrame:CGRectMake(0,TOP_VIEW_HEIGHT+BG_HEIGHT*2+2,[AppDelegate sharePhoneWidth],50)];
    passWordBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:passWordBgView];
    UILabel *passWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,30)];
    passWordLabel.text = @"密 \t 码";
    passWordLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    [passWordBgView addSubview:passWordLabel];
    
    UITextField *passWord = [[UITextField alloc] initWithFrame:CGRectMake(90,10,160,30)];
    passWord.delegate = self;
    passWord.secureTextEntry = YES;
    passWord.placeholder = @"请输入密码";
    passWord.tag = PASS_WORD_TAG;
    passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWord.returnKeyType = UIReturnKeyDone;
    [passWordBgView addSubview:passWord];
    
    UIView *surePassWordBgView = [[UIView alloc] initWithFrame:CGRectMake(0,TOP_VIEW_HEIGHT+BG_HEIGHT*3+4,[AppDelegate sharePhoneWidth],50)];
    surePassWordBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:surePassWordBgView];
    UILabel *surePassWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,30)];
    surePassWordLabel.text = @"确认密码";
    surePassWordLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    [surePassWordBgView addSubview:surePassWordLabel];
    
    UITextField *surePassWord = [[UITextField alloc] initWithFrame:CGRectMake(90,10,160,30)];
    surePassWord.delegate = self;
    surePassWord.secureTextEntry = YES;
    surePassWord.placeholder = @"再次输入密码";
    surePassWord.tag = SURE_PASS_WORD_TAG;
    surePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    surePassWord.returnKeyType = UIReturnKeyDone;
    [surePassWordBgView addSubview:surePassWord];
    
    
//    UIButton *passWordSwitch = [[UIButton alloc] initWithFrame:CGRectMake(260,0,50,50)];
//    [passWordSwitch setImage:[UIImage imageNamed:@"btn_login_eye_p"] forState:UIControlStateNormal];
//    [passWordSwitch setImage:[UIImage imageNamed:@"btn_login_eye.png"] forState:UIControlStateSelected];
//    [passWordSwitch addTarget:self action:@selector(changeSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
//    [passWordBgView addSubview:passWordSwitch];
    
    UIView *developerBgView = [[UIView alloc] initWithFrame:CGRectMake(0,TOP_VIEW_HEIGHT+BG_HEIGHT*4+15,[AppDelegate sharePhoneWidth],50)];
    developerBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:developerBgView];
    UILabel *developerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,70,30)];
    developerLabel.text = @"推荐人:";
    developerLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    [developerBgView addSubview:developerLabel];
    
    UITextField *developer = [[UITextField alloc] initWithFrame:CGRectMake(90,10,240,30)];
    developer.delegate = self;
    developer.placeholder = @"请输入推荐人沃创富账号(选填)";
    developer.adjustsFontSizeToFitWidth = YES;
    developer.tag = DEVELOPER_TAG;
    developer.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    developer.returnKeyType = UIReturnKeyDone;
    [developerBgView addSubview:developer];
    
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setBackgroundImage:[UIImage resizedImage:@"bnt_content_primary_n"] forState:UIControlStateNormal];
    registerBtn.frame=CGRectMake(10,TOP_VIEW_HEIGHT+BG_HEIGHT*5+30,[AppDelegate sharePhoneWidth]-20,44);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClicked) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:registerBtn];
    
}
- (void)changeSecureTextEntry:(UIButton *)mySwitch
{
    mySwitch.selected = !mySwitch.selected;
    UITextField *newPwd = (UITextField *)[self.view viewWithTag:PASS_WORD_TAG];
    newPwd.secureTextEntry = !mySwitch.selected;
}

#pragma mark
#pragma mark - 网络请求
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
                                               @"0",@"requestType",
                                               phoneNumber.text,@"phoneNumber",nil];
        
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
-(void)sendRegisterRequest
{
    if ([self.registerDict objectForKey:@"serverPhone"]==nil||[self.registerDict objectForKey:@"serverCode"]==nil) {
        [self ShowProgressHUDwithMessage:@"请先获取手机验证码"];
    }else
    {
        UITextField *phoneNumber = (UITextField *)[self.view viewWithTag:PHONE_NUMBER_TAG];
        UITextField *checkNumber = (UITextField *)[self.view viewWithTag:CHECK_NUMBER_TAG];
        UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TAG];
        UITextField *developer = (UITextField *)[self.view viewWithTag:DEVELOPER_TAG];
        UITextField *surePassWord = (UITextField *)[self.view viewWithTag:SURE_PASS_WORD_TAG];
        if ([surePassWord.text isEqualToString:passWord.text]) {
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [self.registerDict setObject:phoneNumber.text forKey:@"phoneNumber"];
            [self.registerDict setObject:checkNumber.text forKey:@"identifyCode"];
            [self.registerDict setObject:passWord.text forKey:@"passWord"];
            if (developer.text != nil &&![developer.text isEqualToString:@""]) {
                [self.registerDict setObject:developer.text forKey:@"recommendCode"];
            }else{
                [self.registerDict setObject:[NSNull null] forKey:@"recommendCode"];
            }
            
            [bus regist:self.registerDict];

        }else
        {
            [self ShowProgressHUDwithMessage:@"两次密码输入有误！"];
        }
    }
}

#pragma mark
#pragma mark - 按钮事件
-(void)registerClicked
{
    [self resignAllFirstResponder];
    if ([self dataCheck]) {
        [self sendRegisterRequest];
    }
}

#pragma mark 取消键盘
-(void)resignAllFirstResponder
{
    UITextField *phoneNumber = (UITextField *)[self.view viewWithTag:PHONE_NUMBER_TAG];
    [phoneNumber resignFirstResponder];
    UITextField *checkNumber = (UITextField *)[self.view viewWithTag:CHECK_NUMBER_TAG];
    [checkNumber resignFirstResponder];
    UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TAG];
    [passWord resignFirstResponder];
    UITextField *developer = (UITextField *)[self.view viewWithTag:DEVELOPER_TAG];
    [developer resignFirstResponder];
}

#pragma mark - 数据检查
- (BOOL)dataCheck
{
    UITextField *phoneNumber = (UITextField *)[self.view viewWithTag:PHONE_NUMBER_TAG];
    UITextField *checkNumber = (UITextField *)[self.view viewWithTag:CHECK_NUMBER_TAG];
    UITextField *passWord = (UITextField *)[self.view viewWithTag:PASS_WORD_TAG];
    
    if ([phoneNumber.text isEqualToString:@""]) {
        [self ShowProgressHUDwithMessage:@"手机号码不能为空！"];
        [phoneNumber becomeFirstResponder];
        return NO;
    }else if(phoneNumber.text.length != 11){
        [self ShowProgressHUDwithMessage:@"请输入11位手机号码！"];
        [phoneNumber becomeFirstResponder];
        return NO;
    }else if ([checkNumber.text isEqualToString:@""]){
        [self ShowProgressHUDwithMessage:@"验证码不能为空！"];
        [checkNumber becomeFirstResponder];
        return NO;
    }else if ([passWord.text isEqualToString:@""]){
        [passWord becomeFirstResponder];
        [self ShowProgressHUDwithMessage:@"密码不能为空！"];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark-
- (void)viewDidLoad
{
    [super viewDidLoad];
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
                [self.registerDict setObject:bus.rspInfo[@"phoneNumber"] forKey:@"serverPhone"];
            }
            if (bus.rspInfo[@"phoneCode"] != [NSNull null]) {
                [self.registerDict setObject:bus.rspInfo[@"phoneCode"] forKey:@"serverCode"];
            }
        }else{
            
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"获取数据异常！";
            }
            if(nil == msg){
                msg = @"获取数据异常！";
            }
            [self showSimpleAlertView:msg];
        }
    }else if([[registerMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            [self ShowProgressHUDwithMessage:@"恭喜您注册成功！"];
            UITextField *phoneNumber = (UITextField *)[self.view viewWithTag:PHONE_NUMBER_TAG];
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber.text forKey:@"UserName"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
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
    
    if([[registerMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]&&nil == msg)
        {
            msg = @"注册失败！";
        }
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10101
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"重试",nil];
    }else if([[CheckNumMessage getBizCode] isEqualToString:bizCode])
    {
        if([info objectForKey:@"MSG"] == [NSNull null]||nil == msg)
        {
            msg = @"获取失败请重新获取验证码！";
        }
        [self ShowProgressHUDwithMessage:msg];
    }
}

#pragma mark -
#pragma mark AlertView

- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}
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

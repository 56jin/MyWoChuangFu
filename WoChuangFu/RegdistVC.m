//
//  RegdistVC.m
//  WoChuangFu
//
//  Created by duwl on 11/6/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "RegdistVC.h"
#import "TitleBar.h"
#import "CommonMacro.h"
#import "UIImage+LXX.h"
#import "MyWocfVC.h"
#import "RFPasswordStrength.h"


#define MyTextFieldHeight 49

@interface RegdistVC ()<TitleBarDelegate,UITextFieldDelegate,UIScrollViewDelegate,HttpBackDelegate>

@property (strong, nonatomic)  UILabel *displayPasswordStrength;
@property(nonatomic,strong) UIButton *checkBtn;
@property (nonatomic,strong) NSMutableDictionary *phoneRequ;           //请求参数字典
@property (nonatomic,strong) NSMutableDictionary *registRequ;           //请求参数字典

@property (nonatomic,strong) NSString *phoneNumber;           //
@property (nonatomic,strong) NSString *checkCode;           //

@property (nonatomic,strong) NSString *passWord;           //
@property (nonatomic,strong) NSString *recommendCode;

@property(nonatomic,strong)UITextField  *phoneNum;        //手机号
@property(nonatomic,strong)UITextField  *checkNum;  //短信验证码
@property(nonatomic,strong)UITextField  *secreatNum; //创建密码
@property(nonatomic,strong)UITextField  *sureSecreatNum;//确认密码
@property(nonatomic,strong)UITextField  *people;

@end

@implementation RegdistVC
@synthesize checkBtn;


-(void)loadView
{
    [super loadView];
    [self LayoutV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    [_phoneNum resignFirstResponder];
    [_checkNum resignFirstResponder];
    [_sureSecreatNum resignFirstResponder];
    [_secreatNum resignFirstResponder];
    [_phoneNum resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //resign keyboard
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)LayoutV
{
    
    TitleBar *titleBar = [[TitleBar alloc]initWithFram:CGRectMake(0, 20, SCREEN_WIDTH, 44) ShowHome:NO ShowSearch:NO TitlePos:left_position];
    titleBar.target = self;
    titleBar.title = @"用户注册";
    [self.view addSubview:titleBar];
    
    UIScrollView *bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    [bgView setContentSize:CGSizeMake(0, SCREEN_HEIGHT+20)];
    [bgView setShowsVerticalScrollIndicator:NO];
    [bgView setBounces:YES];
    bgView.delegate = self;
    [self.view addSubview:bgView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-120, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH-60, 33)];
    
    UIImage* image = [UIImage resizedImage:@"btn_alter_bg_p"];
    [searchBtn setBackgroundImage:image forState:UIControlStateNormal];
    [searchBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(registClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
    [bgView addSubview:view];
    
    
    UIView *numView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, MyTextFieldHeight)];
    numView.backgroundColor = [UIColor whiteColor];

    _phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, MyTextFieldHeight-20)];
    _phoneNum.delegate = self;
    _phoneNum.placeholder = @"请输入手机号码";
    _phoneNum.backgroundColor = [UIColor whiteColor];
    _phoneNum.layer.cornerRadius = 5.0;
    [numView addSubview:_phoneNum];
    
    
  
    checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 24+MyTextFieldHeight+5, SCREEN_WIDTH/2-30, MyTextFieldHeight-20)];
//   [checkBtn setBackgroundImage:image forState:UIControlStateNormal];
    [checkBtn setTitle:@"免费获取短信验证码" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkClicked) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    checkBtn.backgroundColor = [UIColor orangeColor];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _displayPasswordStrength = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 24+MyTextFieldHeight+5, SCREEN_WIDTH/2-30, MyTextFieldHeight-20)];
    //   [checkBtn setBackgroundImage:image forState:UIControlStateNormal];
    //    strength.backgroundColor = [UIColor redColor];
    [bgView addSubview:_displayPasswordStrength];
    _displayPasswordStrength.textAlignment = NSTextAlignmentCenter;

      UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, MyTextFieldHeight*2+21, SCREEN_WIDTH, MyTextFieldHeight)];
    messageView.backgroundColor = [UIColor whiteColor];
    _checkNum = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, MyTextFieldHeight-20)];
    _checkNum.delegate = self;
    _checkNum.placeholder = @"短信验证码";
    _checkNum.font = [UIFont systemFontOfSize:16];
    _checkNum.backgroundColor = [UIColor whiteColor];
    _checkNum.layer.cornerRadius = 5.0;
    [messageView addSubview:_checkNum];
    
    
   UIView *secreatView= [[UIView alloc]initWithFrame:CGRectMake(0, MyTextFieldHeight*3+21+1, SCREEN_WIDTH, MyTextFieldHeight)];
    secreatView.backgroundColor = [UIColor whiteColor];
    _secreatNum = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, MyTextFieldHeight-20)];
    [_secreatNum addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    _secreatNum.delegate = self;
    _secreatNum.backgroundColor = [UIColor whiteColor];
    _secreatNum.placeholder = @"创建密码";
    _secreatNum.layer.cornerRadius = 5.0;
    _secreatNum.secureTextEntry = true;
    [secreatView addSubview:_secreatNum];
    
    
    UIView *sureSecreatNum = [[UIView alloc]initWithFrame:CGRectMake(0, MyTextFieldHeight*4+21+2, SCREEN_WIDTH, MyTextFieldHeight)];
    sureSecreatNum.backgroundColor = [UIColor whiteColor];
    _sureSecreatNum = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, MyTextFieldHeight-20)];
    _sureSecreatNum.delegate = self;
    _sureSecreatNum.backgroundColor = [UIColor whiteColor];
    _sureSecreatNum.placeholder = @"确认密码";
    _sureSecreatNum.layer.cornerRadius = 5.0;
    _sureSecreatNum.secureTextEntry = true;
    [sureSecreatNum addSubview:_sureSecreatNum];
    
    UIView *peopleView = [[UIView alloc]initWithFrame:CGRectMake(0, MyTextFieldHeight*5+21+3, SCREEN_WIDTH, MyTextFieldHeight)];
    peopleView.backgroundColor = [UIColor whiteColor];
    _people = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, MyTextFieldHeight-20)];
    _people.delegate = self;
    _people.backgroundColor = [UIColor whiteColor];
    _people.placeholder = @"推荐人";
    _people.layer.cornerRadius = 5.0;
    [peopleView addSubview:_people];
    
     bgView.backgroundColor = UIColorWithRGBA(240, 239, 245, 1);
    [bgView addSubview:secreatView];
    [bgView addSubview:messageView];
    [bgView addSubview:numView];
    [bgView addSubview:sureSecreatNum];
    [bgView addSubview:peopleView];
    [bgView addSubview:checkBtn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registClicked
{
    NSString *phoneNum =_phoneNum.text;
    NSString *checkNum = _checkNum.text;
    NSString *passWord = _secreatNum.text;
    
    if ([phoneNum isEqualToString:@""]) {
        
        [self ShowProgressHUDwithMessage:@"请输入手机号码！"];
        return;
    }else if([checkNum isEqualToString:@""]){
        
        [self ShowProgressHUDwithMessage:@"请输入验证码！"];
        
        
    }else if([passWord isEqualToString:@""]){
        
        [self ShowProgressHUDwithMessage:@"请输入密码！"];
      
    }else if(passWord.length< 3 || passWord.length > 20){
        
        [self ShowProgressHUDwithMessage:@"密码6-20位之间"];
     
    }else if([_sureSecreatNum.text isEqualToString:@""]){
        
        [self ShowProgressHUDwithMessage:@"请输入确认密码！"];
       
    }else if([_sureSecreatNum.text isEqualToString:_secreatNum.text]==false){
        
        [self ShowProgressHUDwithMessage:@"确认密码输入有误！"];
      
    }else if(_phoneNum.text.length!=11){
        
        [self ShowProgressHUDwithMessage:@"请输入有效的手机号！"];
     
    }else if(_phoneNum.text.length!=11){
        
        [self ShowProgressHUDwithMessage:@"请输入有效的手机号！"];
      
    }else if ([_phoneNumber isEqualToString:phoneNum]&&[_checkCode isEqualToString:checkNum]) {
        bussineDataService *bus=[bussineDataService sharedDataService];
        bus.target=self;
        _registRequ = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       _phoneNum.text,@"phoneNumber",
                       _checkNum.text,@"identifyCode",
                       _secreatNum.text,@"passWord",
                       @"1",@"userType",
                       _people.text,@"recommendCode",nil];
        
        [bus regist:_registRequ];
        
        
    }else{
        [self ShowProgressHUDwithMessage:@"输入的手机验证码无效！"];
    }
}


-(void)checkClicked
{
    if(_phoneNum.text.length!=11) {
        
        [self ShowProgressHUDwithMessage:@"请输入11位手机号码！"];
    }
    else{
    bussineDataService *bus=[bussineDataService sharedDataService];
    bus.target=self;
    _phoneRequ = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    _phoneNum.text,@"phoneNumber",nil];
                   
    [bus checkNum:_phoneRequ];

    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
        
                [checkBtn setTitle:@"免费获取短信验证码" forState:UIControlStateNormal];
                checkBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [checkBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                checkBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    }
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 数据接收

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
            _phoneNumber = bus.rspInfo[@"phoneNumber"];
            _checkCode = bus.rspInfo[@"phoneCode"];
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
            
            [[NSUserDefaults standardUserDefaults] setObject:_phoneNum.text forKey:@"UserName"];
            
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
        if([info objectForKey:@"MSG"] == [NSNull null]&&nil == msg)
        {
            msg = @"获取失败请重新获取验证码！";
        }
        [self ShowProgressHUDwithMessage:msg];
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
            [bus regist:_registRequ];
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
- (void)textChanged:(UITextField *)sender {
    
    //Use class method to get Password Strength
    int passwordStrength = [RFPasswordStrength checkPasswordStrengthWithPassword:self.secreatNum.text];
    
    //Change Label
    if (passwordStrength == 0) {
        self.displayPasswordStrength.backgroundColor = [UIColor greenColor];
        self.displayPasswordStrength.text = @"密码强度：高";
    } else if (passwordStrength == 1) {
        self.displayPasswordStrength.backgroundColor = [UIColor colorWithRed:(229/255.0) green:(226/255.0) blue:(3/255.0) alpha:1];
        self.displayPasswordStrength.text = @"密码强度：中";
    } else if (passwordStrength == 2) {
        self.displayPasswordStrength.backgroundColor = [UIColor redColor];
        self.displayPasswordStrength.text = @"密码强度：弱";
    }
    
}

@end

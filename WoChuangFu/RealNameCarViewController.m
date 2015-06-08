//
//  RealNameCarViewController.m
//  WoChuangFu
//
//  Created by 陈亦海 on 15/6/2.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "RealNameCarViewController.h"
#import "TitleBar.h"
#import "ReaderDelegate.h"

#import "RWSimCard.h"
#import "IDCardInfo.h"
#import "IDCardReader.h"
#import "SimCardReader.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface RealNameCarViewController ()<TitleBarDelegate,ReaderDelegate,HttpBackDelegate,CBCentralManagerDelegate> {
    SimCardReader *rwcard; //读身份证号
    CBCentralManager *manager;
}

@end

@implementation RealNameCarViewController


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleBlackOpaque;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden=NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    
    self.navigationController.navigationBarHidden = YES;
   
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString * message = nil;
    switch (central.state) {
        case 0:
            message = @"初始化中，请稍后……";
            break;
        case 1:
            message = @"设备不支持状态，过会请重试……";
            break;
        case 2:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 3:
            message = @"设备未授权状态，过会请重试……";
            break;
        case 4:
            message = @"尚未打开蓝牙，请在设置中打开……";
            break;
        case 5:
            message = @"蓝牙已经成功开启，稍后……";
            break;
        default:
            break;
    }
    
    [self ShowProgressHUDwithMessage:message];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    [UIApplication sharedApplication].statusBarHidden=NO;
    //    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"实名返档";
    titleBar.frame = CGRectMake(0,20, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    titleBar.target = self;
    
    self.SFZbutton.layer.masksToBounds = YES;
    self.SFZbutton.layer.cornerRadius = 4.0f;
 
    
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 4.0f;
    
    self.beiZhuTextView.layer.masksToBounds = YES;
    self.beiZhuTextView.layer.borderWidth = 1.5f;
    self.beiZhuTextView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];

    [self performSelector:@selector(afertBtn) withObject:nil afterDelay:1.0];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)afertBtn {
    
    rwcard=[[SimCardReader alloc]init];
    
    [rwcard setReaderDelegate:self];
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_NumTextField release];
    [_SFZbutton release];
    [_nameLabel release];
    [_NumCarLabel release];
    [_addressLabel release];
    [_beiZhuTextView release];
    [_TopimageView release];
    [_sureBtn release];
    [rwcard release];
    [manager release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNumTextField:nil];
    [self setSFZbutton:nil];
    [self setNameLabel:nil];
    [self setNumCarLabel:nil];
    [self setAddressLabel:nil];
    [self setBeiZhuTextView:nil];
    [self setTopimageView:nil];
    [self setSureBtn:nil];
    rwcard = nil;
    manager = nil;
    [super viewDidUnload];
}
- (IBAction)SureEven:(id)sender {
    [self.view endEditing:YES];
    if ([_NumTextField.text length] <= 0) {
        [self ShowProgressHUDwithMessage:@"请先输入返档号码"];
        return;
    }
    if ([_nameLabel.text isEqualToString:@""] || [_nameLabel.text length] <= 0 || [_NumCarLabel.text isEqualToString:@""] || [_NumCarLabel.text length] <= 0 || [_addressLabel.text isEqualToString:@""] || [_addressLabel.text length] <= 0) {
        [self ShowProgressHUDwithMessage:@"请先将身份证放置读卡器上读取信息"];
        return;
    }
    if ([_beiZhuTextView.text isEqualToString:@""] || [_beiZhuTextView.text length] <= 0) {
        [self ShowProgressHUDwithMessage:@"请先输入备注信息"];
        return;
    }
    
    [self sureFangDang];
}

- (void)sureFangDang {
    bussineDataService *buss=[bussineDataService sharedDataService];
    buss.target=self;
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             session,@"sessionId",
                             _NumTextField.text,@"phoneNum",
                             _nameLabel.text,@"custName",
                             _NumCarLabel.text,@"custNo",
                             _addressLabel.text,@"custAddr",
                             _beiZhuTextView.text,@"remark ",
                             nil];
    
//    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                             session,@"sessionId",
//                            @"18550001417",@"phoneNum",
//                             @"yihai",@"custName",
//                            @"450821199108054988",@"custNo",
//                             @"@#$$$$$$$$",@"custAddr",
//                             @"wowoowowowow",@"remark ",
//                             nil];

    [buss sureGuiDang:SendDic];

}

- (IBAction)getSFZEvent:(id)sender {
    [self.view endEditing:YES];
    
     [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
    IDCardReader *idCardReader=[[IDCardReader alloc] init];
    //    IDCardInfo *info=[rwcard getIDCard];
    IDCardInfo *info=[idCardReader getIDCard:@""];
    NSLog(@"name:%@",info.Name);
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if (!info.Name) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"读取身份证信息失败";
        hud.dimBackground = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        
    }

    
//    NSLog(@"image---->%d:%@", [info.photo length],info.photo);
    UIImage *img=[UIImage imageWithData:info.Picture];
    self.nameLabel.text = info.Name;
    self.addressLabel.text = info.Address;
    self.NumCarLabel.text = info.CardNo;
    self.TopimageView.image = nil;
    self.TopimageView.image = img;
    [idCardReader release];
   
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    self.beiZhuTextView.text = nil;
    
    float Durationtime = 0.5;
    [UIView beginAnimations:@"alt" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:Durationtime];
    
    if([UIScreen mainScreen].bounds.size.height>=568){
        
        [self.view setFrame:CGRectMake(0, -95, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        
    }else{
        
        [self.view setFrame:CGRectMake(0, -95, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    }
    [UIView commitAnimations];

    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if ((self.beiZhuTextView.text == nil || [self.beiZhuTextView.text length] == 0)) {
        self.beiZhuTextView.text = @"备注";
    }
    
    float Durationtime = 0.5;
    [UIView beginAnimations:@"alt" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:Durationtime];
    
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [UIView commitAnimations];

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
   
    
    return YES;
}


#pragma mark ReaderDelegate
-(void)onReaderStatusChanged:(BOOL) isConnected{
    NSLog(@"%@,%d",@"onReaderStatusChanged:",isConnected);
}

-(void)onCardStatusChanged:(BOOL) isConnected{
    NSLog(@"%@,%d",@"onCardStatusChanged:",isConnected);
}

#pragma mark -
#pragma mark HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[RealFangDangMessage getBizCode] isEqualToString:bizCode])
    {
        
        bussineDataService *bus=[bussineDataService sharedDataService];
        NSLog(@"归档信息 ：%@",bus.rspInfo);
        if([@"7777" isEqualToString:errCode])
        {
            
            
            
        }
        else
        {
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:bus.rspInfo[@"respDesc"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
//        [self ShowProgressHUDwithMessage:bus.rspInfo[@"respDesc"]];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10101)
    {
        if([buttonTitle isEqualToString:@"重试"]){
            [self sureFangDang];
        }
    }

    
    
}

- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[RealFangDangMessage getBizCode] isEqualToString:bizCode]){
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
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 10101;
        [alert show];
        [alert release];
    }
    
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

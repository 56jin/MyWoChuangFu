//
//  JiGouViewController.m
//  WoChuangFu
//
//  Created by 陈亦海 on 15/5/16.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "JiGouViewController.h"
#import "TitleBar.h"
#import "CommonMacro.h"

@interface JiGouViewController ()<TitleBarDelegate,HttpBackDelegate>
{
    NSDictionary *SendDic;
}

@end

@implementation JiGouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [UIApplication sharedApplication].statusBarHidden=NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    
    self.navigationController.navigationBarHidden = YES;
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"加入机构";
    titleBar.frame = CGRectMake(0,20, SCREEN_WIDTH,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    titleBar.target = self;

    
    [AppDelegate shareMyApplication].selectInteger = 0;
    
    
    bussineDataService *buss=[bussineDataService sharedDataServicee];
    buss.target=self;
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"~~~~~id  %@",session);
    SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                       session,@"sessionId",
                       nil];
    [buss selectJigou:SendDic];
    // Do any additional setup after loading the view from its nib.
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleBlackOpaque;
}

#pragma mark -
#pragma mark HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
    
     NSLog(@"机构数据%@",info);
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[GetSelectJiGouMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            
            bussineDataService *bus=[bussineDataService sharedDataServicee];

            NSLog(@"bus,rspInfo是%@",bus.rspInfo);
            
            if([bus.rspInfo[@"flag"] integerValue] == 1) {
                self.nameLabel.text = [NSString stringWithFormat:@"%@",bus.rspInfo[@"agency"]];
                _theVIew.hidden = NO;
                
            }
            else {
                _theVIew.hidden = NO;
            }
            
            NSString *str = [NSString stringWithFormat:@"%@",bus.rspInfo[@"agencyEffectMsg"]];
            
            
            //
            [self showagencyEffectLabel:![str isEqualToString:@"<null>"] agencyEffectMsg:str];

            
            
            
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
    
    if([[GetAddJiGouMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            
            bussineDataService *bus=[bussineDataService sharedDataServicee];
            
            NSLog(@"bus,rspInfo是%@",bus.rspInfo);
            
            if([bus.rspInfo[@"flag"] integerValue] == 1) {
                self.nameLabel.text = [NSString stringWithFormat:@"%@",bus.rspInfo[@"agency"]];
                _theVIew.hidden = NO;
            }
            else {
                _theVIew.hidden = NO;
            }
            
            if ([bus.rspInfo[@"flag"] integerValue ] == 3) {
                 NSString *str = [NSString stringWithFormat:@"%@",bus.rspInfo[@"agencyEffectMsg"]];                
            [self showagencyEffectLabel:![str isEqualToString:@"<null>"] agencyEffectMsg:str];
                

             
            }else{
                
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
    
    NSLog(@"失败机构数据%@",info);
    
    
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[GetSelectJiGouMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"登录失败！";
        }
        if(nil == msg){
            msg = @"登录失败！";
        }
    }
    
    if([[GetAddJiGouMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"提交失败！";
        }
        if(nil == msg){
            msg = @"提交失败！";
        }
    }

    
    [self showAlertViewTitle:@"提示"
                     message:msg
                    delegate:self
                         tag:10101
           cancelButtonTitle:@"取消"
           otherButtonTitles:@"重试",nil];
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


#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10101){
        if([buttonTitle isEqualToString:@"重试"]){
            bussineDataService *bus=[bussineDataService sharedDataServicee];
            bus.target=self;
            if (SendDic.count >= 2) {
                [bus addJigou:SendDic];

            }
            else
                [bus selectJigou:SendDic];
            
        }
    }
}


-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



- (IBAction)sureButton:(id)sender {
     [self.view endEditing:YES];
    
    if([self.JiGouCoreText.text length] == 0 || [self.JiGouCoreText.text isEqualToString:@""]) {
        [self showSimpleAlertView:@"请先输入机构代码"];
        return;
    }
    
    NSLog(@"%@",self.JiGouCoreText.text);
    
    bussineDataService *buss=[bussineDataService sharedDataServicee];
    buss.target=self;
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    if (SendDic) {
        SendDic = nil;
    }
    SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
               session,@"sessionId",self.JiGouCoreText.text,@"jgid",
               nil];
    [buss addJigou:SendDic];

}

- (void)dealloc {
    [_JiGouCoreText release];
    [_nameLabel release];
    [_theVIew release];
    [_agenEffectLabel release];
    [super dealloc];
}

- (void)viewDidUnload {
    
    [self setJiGouCoreText:nil];
    [self setNameLabel:nil];
    [self setTheVIew:nil];
    [self setAgenEffectLabel:nil];
    [super viewDidUnload];
}

//显示提示
-(void)showagencyEffectLabel:(BOOL) isShow agencyEffectMsg:(NSString*)agencyEffectMsg{
    [self setAutofitLabel:self.agenEffectLabel text:agencyEffectMsg];
    CGRect theViewFrame = self.theVIew.frame;
    CGRect angeLabelFrame = self.agenEffectLabel.frame;
    if (isShow) {
        
        theViewFrame.origin.y = angeLabelFrame.origin.y+angeLabelFrame.size.height+18;
        self.theVIew.frame = theViewFrame;
        self.agenEffectLabel.hidden = NO;
    }else{
        theViewFrame.origin.y = angeLabelFrame.origin.y;
        self.theVIew.frame = theViewFrame;
        self.agenEffectLabel.hidden = YES;
    }
}
//label自适应
-(void)setAutofitLabel:(UILabel*)label text:(NSString*)text{
    label.text = text;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Helvetica" size:12];
    [label setTextColor:[UIColor redColor]];
    CGSize maximumSize = CGSizeMake(300, CGFLOAT_MAX);
    CGSize expectedLabelSize = [text sizeWithFont:label.font
                                constrainedToSize:maximumSize
                                    lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    newFrame.size.width = self.view.frame.size.width-10;
    label.frame = newFrame;
    [label sizeToFit];
}




@end

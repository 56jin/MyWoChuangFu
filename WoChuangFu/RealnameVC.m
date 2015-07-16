//
//  RealnameVC.m
//  WoChuangFu
//
//  Created by 陈 贵邦 on 15-6-8.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "RealnameVC.h"
#import "TitleBar.h"
//#import "ReaderDelegate.h"
//
//#import "RWSimCard.h"
//#import "IDCardInfo.h"
//#import "IDCardReader.h"
//#import "SimCardReader.h"
#import <CoreBluetooth/CoreBluetooth.h>
//#import "BlueToothDCAdapter.h"

#import "3Des.h"
#import <BLEIDCardReaderItem/BLEIDCardReaderItem.h>
#import "GDataXMLNode.h"
#import "ZSYPopListView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LABELEDITHEIGHT 50
#define HUISE ([UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1])

@interface RealnameVC ()<TitleBarDelegate,ZSYPopListViewDelegate,UITextFieldDelegate,UITextViewDelegate,HttpBackDelegate,CBCentralManagerDelegate,BR_Callback> {
//    SimCardReader *rwcard; //读身份证号
    CBCentralManager *manager;
//    BlueToothDCAdapter *adapter;
//    BleTool *bletool;//bleTool对象
    BOOL isRead;
    BOOL isReadAgin;
    ZSYPopListView *zsy;
    UILabel *BlootLabel;  // 显示当前连接的蓝牙设备名称
    NSDictionary *blootDic;  //当前选择的蓝牙设备信息
    BleTool *tools;
    
    BOOL failStat;
}

@end

@implementation RealnameVC

@synthesize fanNumTextFiled,getIdCradBtn,idCardAddress,idCardLabel,nameLabel,messageLabel,remarkTextFild,photoImageView,realBtn;



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
    [self layoutView];
     tools =[[BleTool alloc]init:self];
}

-(void)layoutView{
    [self inittitleBar];
    [self initMainView];
}

-(void)inittitleBar{
    self.navigationController.navigationBarHidden = YES;
    TitleBar *titleBar = [[TitleBar alloc]initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    CGRect tmpFrame = titleBar.frame;
    tmpFrame.origin.y = 20;
    titleBar.frame = tmpFrame;
    titleBar.target = self;
    titleBar.title = @"实名返档";
    [self.view addSubview:titleBar];
    [titleBar release];
}

-(void)initMainView{
    UIScrollView *mainView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    mainView.tag = 266;
    mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 去掉弹簧效果
    mainView.bounces = NO;
    // 增加额外的滚动区域（逆时针，上、左、下、右）
    // top  left  bottom  right
    mainView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    mainView.contentSize = CGSizeMake(MainWidth, MainHeight);
    [self.view addSubview:mainView];
    
   
    BlootLabel = [[UILabel alloc]init];
    [BlootLabel setBackgroundColor:[UIColor clearColor]];
    [BlootLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [BlootLabel setTextColor:[self colorWithHexString:@"#b6b6b6"]];
    [BlootLabel setFrame:CGRectMake(10, 10, MainWidth - 20, 20)];
    [BlootLabel setText:@"您当前暂无连接蓝牙设备，请打开蓝牙"];
    [mainView addSubview:BlootLabel];
    
    
    
    CGPoint ponit = CGPointMake(self.view.frame.size.width/2, 0);
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, 40)];
    ponit.y = 60;
    [line1.layer setCornerRadius:5.0];
    [line1.layer setBorderWidth:2];
    [line1.layer setMasksToBounds:YES];
    [line1.layer setBorderColor:[self colorWithHexString:@"dbdbdb"].CGColor];
    line1.backgroundColor = [self colorWithHexString:@"#f5f5f5"];
    line1.center = ponit;
    
//    CGRect tmpFrame = CGRectMake(0, 0, 0, 0);
    //返档号码
    LWEdit *fanNum = [[LWEdit alloc]initWithFrame:CGRectMake(10 , 0, 100, 10)];
    [fanNum setFont:[UIFont systemFontOfSize:15.0f]];
    //    fanNum.backgroundColor = [UIColor yellowColor];
    fanNum.textColor = [self colorWithHexString:@"#363636"];
    fanNum.text = @"返档号码:";
    CGPoint fannumP = fanNum.center;
    fannumP.y = line1.frame.size.height/2;
    fanNum.center = fannumP;
    
    fanNumTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(fanNum.frame.origin.x+fanNum.frame.size.width+10, 0, 120, fanNum.frame.size.height)];
//    fanNumTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    fanNumTextFiled.returnKeyType = UIReturnKeyDone;
    fanNumTextFiled.delegate = self;
    fanNumTextFiled.adjustsFontSizeToFitWidth = YES;
    fanNumTextFiled.returnKeyType = UIReturnKeyDone;
    
    getIdCradBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getIdCradBtn.frame = CGRectMake(fanNumTextFiled.frame.origin.x+fanNumTextFiled.frame.size.width+10, 0, 90,fanNumTextFiled.frame.size.height+8);
    CGPoint fanTextponit = fanNumTextFiled.center;
    fanTextponit.y = line1.frame.size.height/2;
    fanNumTextFiled.center = fanTextponit;
    
    [getIdCradBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    getIdCradBtn.backgroundColor = [UIColor orangeColor];
    [getIdCradBtn addTarget:self action:@selector(getMessage) forControlEvents:UIControlEventTouchUpInside];
    [getIdCradBtn setTitle:@"获取身份证" forState:UIControlStateNormal];
    CGPoint btnpont = getIdCradBtn.center;
    btnpont.y = fanNum.center.y;
    getIdCradBtn.center = btnpont;
    [getIdCradBtn.layer setCornerRadius:3];
    [getIdCradBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(fanNum.frame.origin.x, line1.frame.size.height+line1.frame.origin.y+10, self.view.frame.size.width, fanNum.frame.size.height)];
    messageLabel.text = @"获取身份证信息前，请将身份证原件放置在阅读器上";
    [messageLabel setFont:[UIFont fontWithName:nil size:13]];
    messageLabel.textColor = [self colorWithHexString:@"#b6b6b6"];
    
   
    
    UIView *line2 = [[UIView alloc]initWithFrame:line1.frame];
    ponit.y = line1.frame.origin.y+line1.frame.size.height*2.5;
    [line2.layer setCornerRadius:5.0];
    [line2.layer setBorderWidth:2];
    [line2.layer setMasksToBounds:YES];
    [line2.layer setBorderColor:[self colorWithHexString:@"dbdbdb"].CGColor];
    line2.backgroundColor = [self colorWithHexString:@"#f5f5f5"];
    line2.center = ponit;
    
    
    //姓名
    LWEdit *name = [[LWEdit alloc]initWithFrame:CGRectMake(10, 0, 100, 50)];
  
//    name.backgroundColor = [UIColor yellowColor];
    name.text = @"姓       名:";
    name.textColor = [self colorWithHexString:@"#363636"];
    CGPoint namePoint = name.center;
    namePoint.y = line2.frame.size.height/2;
    name.center = namePoint;
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.origin.x + name.frame.size.width+10, 0, self.view.frame.size.width-10-name.frame.size.width, name.frame.size.height)];
    CGPoint namelabelPoint =nameLabel.center;
    namelabelPoint.y = line2.frame.size.height/2;
    nameLabel.center = namelabelPoint;
    nameLabel.text = @"";
    nameLabel.textColor =  [self colorWithHexString:@"#8e8e8e"];
    
    
   
    
    UIView *line3 = [[UIView alloc]initWithFrame:line1.frame];
    ponit.y = line2.frame.origin.y+line2.frame.size.height*2;
    [line3.layer setCornerRadius:5.0];
    [line3.layer setBorderWidth:2];
    [line3.layer setMasksToBounds:YES];
    [line3.layer setBorderColor:[self colorWithHexString:@"dbdbdb"].CGColor];
    line3.backgroundColor = [self colorWithHexString:@"#f5f5f5"];
    line3.center = ponit;
    
    //身份正号码
    LWEdit *idCard = [[LWEdit alloc]initWithFrame:CGRectMake(10, 0, 100, 50)];

//    idCard.backgroundColor = [UIColor yellowColor];
    idCard.text = @"身份证号码:";
    idCard.textColor = [self colorWithHexString:@"#363636"];
    CGPoint idCardPoint = idCard.center;
    idCardPoint.y = line3.frame.size.height/2;
    idCard.center = idCardPoint;
    idCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(idCard.frame.origin.x + idCard.frame.size.width+10, idCard.frame.origin.y, self.view.frame.size.width-10-idCard.frame.size.width, idCard.frame.size.height)];
    idCardLabel.text = @"";
    idCardLabel.textColor  = [self colorWithHexString:@"#8e8e8e"];
    
 
    
    UIView *line4 = [[UIView alloc]initWithFrame:line1.frame];
    CGRect frame = line4.frame;
    frame.size.height = 60;
    line4.frame = frame;
    ponit.y = line3.frame.origin.y+line3.frame.size.height*2;
    [line4.layer setCornerRadius:5.0];
    [line4.layer setBorderWidth:2];
    [line4.layer setMasksToBounds:YES];
    [line4.layer setBorderColor:[self colorWithHexString:@"dbdbdb"].CGColor];
    line4.backgroundColor = [self colorWithHexString:@"#f5f5f5"];
    line4.center = ponit;

    //身份证地址
    LWEdit *idCardAdress = [[LWEdit alloc]initWithFrame:CGRectMake(10, 0, 100, 50)];
//    idCardAdress.backgroundColor = [UIColor yellowColor];
    idCardAdress.text = @"身份证地址:";
    idCardAdress.textColor = [self colorWithHexString:@"#363636"];
    CGPoint idCAddrPoint = idCardAdress.center;
    idCAddrPoint.y = line4.frame.size.height/2;
    idCardAdress.center = idCAddrPoint;
    
    idCardAddress = [[UILabel alloc]initWithFrame:CGRectMake(idCardAdress.frame.origin.x + idCardAdress.frame.size.width+10, idCardAdress.frame.origin.y - 10, self.view.frame.size.width- 30 -idCardAdress.frame.size.width, idCardAdress.frame.size.height *2)];
    idCardAddress.numberOfLines = 0;
    idCardAddress.lineBreakMode = NSLineBreakByCharWrapping;
    idCardAddress.font = [UIFont boldSystemFontOfSize:15.0f];
//    idCardAddress.text = @"广西南宁北大南路一号邕江时代广场一期2107";
    idCardAddress.textColor =  [self colorWithHexString:@"#8e8e8e"];
//    [idCardAddress setAdjustsFontSizeToFitWidth:YES];
    
  
    photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, line4.frame.origin.y+line4.frame.size.height+20, 100, 100)];
    photoImageView.backgroundColor = [UIColor darkGrayColor];
    [photoImageView setImage:[UIImage imageNamed:@"imageBackground.png"]];
    [photoImageView.layer setMasksToBounds:YES];
    [photoImageView.layer setCornerRadius:4];

    
    remarkTextFild = [[UITextView alloc]initWithFrame:CGRectMake(photoImageView.frame.origin.x+photoImageView.frame.size.width+20, photoImageView.frame.origin.y, self.view.frame.size.width - photoImageView.frame.size.width - 40, photoImageView.frame.size.height)];
    
    remarkTextFild.backgroundColor = [self colorWithHexString:@"#f5f5f5"];
    [remarkTextFild.layer setCornerRadius:10.0];
    [remarkTextFild.layer setBorderWidth:1.0];
    [remarkTextFild.layer setBorderColor:[self colorWithHexString:@"#dbdbdb"].CGColor];
    remarkTextFild.delegate = self;
    remarkTextFild.text = @"备注(选填)";
    remarkTextFild.returnKeyType = UIReturnKeyDone;
    remarkTextFild.textColor =  [self colorWithHexString:@"#8e8e8e"];
    remarkTextFild.returnKeyType = UIReturnKeyDone;
    realBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    realBtn.backgroundColor = [UIColor orangeColor];
    CGPoint btnpoint = CGPointMake(self.view.frame.size.width/2, remarkTextFild.frame.origin.y+remarkTextFild.frame.size.height+40);
    realBtn.center = btnpoint;
    [realBtn setTitle:@"实名返档" forState:UIControlStateNormal];
    [realBtn setImage:[UIImage imageNamed:@"fandang.png"] forState:UIControlStateNormal];
    [realBtn.layer setMasksToBounds:YES];
    [realBtn.layer setCornerRadius:4];
    [realBtn addTarget:self action:@selector(sureFangDangEven) forControlEvents:UIControlEventTouchUpInside];
    realBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 5);
    [realBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [mainView addSubview:messageLabel];
    [mainView addSubview:realBtn];

    
    [mainView addSubview:photoImageView];
    [mainView addSubview:remarkTextFild];
    
    [mainView addSubview:line1];
    [line1 addSubview:fanNum];
    [line1 addSubview:fanNumTextFiled];
    [line1 addSubview:getIdCradBtn];
   
    [mainView addSubview:line2];
    [line2 addSubview:name];
    [line2 addSubview:nameLabel];
    
    
    [mainView addSubview:line3];
    [line3 addSubview:idCard];
    [line3 addSubview:idCardLabel];
    [mainView addSubview:line4];
    [line4 addSubview:idCardAdress];
    [line4 addSubview:idCardAddress];
    [mainView bringSubviewToFront:remarkTextFild];
    
    [fanNum release];
    [line1 release];
    [name release];
    [line2 release];
    [idCard release];
    [line3 release];
    [idCardAdress release];
    [line4 release];
    [mainView release];
    
    
}

- (void)dealloc {
    [super dealloc];
    blootDic = nil;
    [tools release];
    [fanNumTextFiled release];
    [getIdCradBtn release];
    [nameLabel release];
    [idCardLabel release];
    [idCardAddress release];
    [messageLabel release];
    [photoImageView release];
    [remarkTextFild release];
    [realBtn release];
    [BlootLabel release];
    
}


- (void)getShowFail {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"读取身份证信息失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新读取", nil];
    alert.tag = 101010;
    [alert show];
    [alert release];
}

#pragma mark -toolFunc
//加密读卡中把返回的nsdata类型的加密数据解密成xml格式文本
-(NSString*)Decdata:(NSData*)encedData byKey:(NSData*)key{
    //    NSLog(@"开始解密xml");
    //    NSLog(@"收到数据：%@",recvdata);
    Byte baseDict[encedData.length];
    bzero(baseDict, encedData.length);
    Des3_Decrypt((unsigned char*)[encedData bytes], baseDict, encedData.length, (unsigned char*)[key bytes]);
    NSData* baseinfo=[NSData dataWithBytes:baseDict length:encedData.length];
    NSString *resultstr=[[NSString alloc]initWithData:baseinfo encoding:NSUTF8StringEncoding];
    return  resultstr;
}


- (void)sureFangDangEven {
    [self.view endEditing:YES];
    if ([fanNumTextFiled.text length] <= 0) {
        [self ShowProgressHUDwithMessage:@"请先输入返档号码"];
        return;
    }
    if ([nameLabel.text isEqualToString:@""] || [nameLabel.text length] <= 0 || [idCardAddress.text isEqualToString:@""] || [idCardAddress.text length] <= 0 || [idCardLabel.text isEqualToString:@""] || [idCardLabel.text length] <= 0) {
        [self ShowProgressHUDwithMessage:@"请先将身份证放置读卡器上读取信息"];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"是否确定实名返档\n到%@号码上",fanNumTextFiled.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上返档", nil];
    alertView.tag = 288;
    [alertView show];
    [alertView release];
    
   
}

- (void)sureFangDang {
    bussineDataService *buss=[bussineDataService sharedDataService];
    buss.target=self;
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    
    NSDictionary *SendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             session,@"sessionId",
                             fanNumTextFiled.text,@"phoneNum",
                             nameLabel.text,@"custName",
                             idCardLabel.text,@"custNo",
                             idCardAddress.text,@"custAddr",
                             remarkTextFild.text,@"remark ",
                             nil];
    

    
    [buss sureGuiDang:SendDic];
    [SendDic release];
    
}

-(UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ((![fanNumTextFiled
           isExclusiveTouch])||(![remarkTextFild
                                  isExclusiveTouch])) {
        [fanNumTextFiled
         resignFirstResponder];
        [remarkTextFild
         resignFirstResponder];
    }
}


//UItextFiled回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [fanNumTextFiled
     resignFirstResponder];
    return YES;
}
//UITextView回收键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"textViewDidBeginEditing");
    textView.text = nil;
    tmpPoint = textView.center;
    
    
    
//    [UIView animateKeyframesWithDuration:0.3f delay:0.0f options:UIViewAnimationTransitionCurlUp animations:^{
//      textView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/5);
////         textView.backgroundColor = [UIColor grayColor];
//    } completion:^(BOOL finished) {
//        NSLog(@"动画完成");
//    }];
    
    float Durationtime = 0.3;
    [UIView beginAnimations:@"alt" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:Durationtime];
    
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:266];

    CGRect frame = mainView.frame;
    frame.size.height -= 200;
    mainView.frame = frame;
    [mainView setContentOffset:CGPointMake(0, frame.size.height) animated:YES];
    
//    [mainView setContentOffset:CGPointMake(MainWidth/2  , MainHeight/2) animated:YES];
    
//    if([UIScreen mainScreen].bounds.size.height>=568){
//        
//        
//        
//        
//        
//        [self.view setFrame:CGRectMake(0, -125, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
//        
//    }else{
//        
//        [self.view setFrame:CGRectMake(0, -125, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
//    }
    [UIView commitAnimations];

}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing");
    if ([textView.text length]==0) {
        textView.text = @"备注（选填）";
    }
//    [UIView animateKeyframesWithDuration:0.3f delay:0.0f options:UIViewAnimationTransitionCurlUp animations:^{
//       textView.center = tmpPoint;
////        textView.backgroundColor = [UIColor clearColor];
//    } completion:^(BOOL finished) {
//        NSLog(@"动画完成");
//    }];
    float Durationtime = 0.3;
    [UIView beginAnimations:@"alt" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:Durationtime];
    
//    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:266];
    
    CGRect frame = mainView.frame;
    frame.size.height += 200;
    mainView.frame = frame;
      [mainView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView commitAnimations];


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(alertView.tag==10101 || alertView.tag == 288 )
    {

        if([buttonTitle isEqualToString:@"重试"] || [buttonTitle isEqualToString:@"马上返档"]){
            [self sureFangDang];
        }
    }
    
    if(alertView.tag==10108)
    {
        if([buttonTitle isEqualToString:@"重新搜索"]){
//            [self afertBtn];
            [self performSelector:@selector(afertBtn) withObject:nil afterDelay:0.5];
        }
    }
    
    if(alertView.tag==101010)
    {
        if([buttonTitle isEqualToString:@"重新读取"]){
            
            [self performSelector:@selector(getIdCradBtnEvent) withObject:nil afterDelay:1];
           

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
    [hud hide:YES afterDelay:2.5];
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




-(void)backAction{
    
    if (isRead) {
        //断开连接
        [tools disconnectBt];

    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getMessage{
    
    
    
    //搜索蓝牙设备
    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];

    NSMutableArray *devarry = [[NSMutableArray alloc]init];
    NSArray *arry = [tools ScanDeiceList:2.0f];
    [devarry addObjectsFromArray:arry];
    if (devarry && devarry != nil && devarry.count > 0) {
        NSLog(@"设备信息 %@",devarry);
        
        for (NSDictionary *dic in arry) {
            if ( dic.count <= 0 || [dic allKeys].count <= 0) {
                NSLog(@"移除信息 ");
                [devarry removeObject:dic];
            }
        }
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        
        if(devarry.count <= 0){
            [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
            [self ShowProgressHUDwithMessage:@"搜索不到蓝牙,请重试"];
            
        }
        else {
            zsy = [[ZSYPopListView alloc]initWitZSYPopFrame:CGRectMake(0, 0, 200, devarry.count  * 55 + 50) WithNSArray:devarry WithString:@"选择蓝牙读卡器类型"];
            zsy.isTitle = NO;
            zsy.delegate = self;
        }
    }else{
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        [self ShowProgressHUDwithMessage:@"搜索不到蓝牙,请重试"];
    }
    
}

#pragma mark -选择连接的蓝牙
- (void)sureDoneWith:(NSDictionary *)resion{
    
    
    if (zsy) {
        [zsy dissViewClose];
        zsy = nil;
        zsy.delegate = nil;
    }
    blootDic = resion;
    [tools connectBt:[resion valueForKey:@"uuid"]];
}


#pragma  mark - 蓝牙连接代理
-(void)BR_connectResult:(BOOL)isconnected{
    //    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if(isconnected){  //链接成功
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器成功"];
        
        [BlootLabel setText:[NSString stringWithFormat:@"您当前连接蓝牙设备: %@",blootDic[@"name"] ]];
        [self readCard];
        
    }
    else if(failStat == YES){
        failStat = NO;
        //        [self ShowProgressHUDwithMessage:@"身份证读取失败,请重试"];
    }else{
        [self ShowProgressHUDwithMessage:@"链接蓝牙读卡器失败,请重试"];
    }
    
    
}

#pragma mark 读取身份证信息
-(void)readCard{
    
    
    NSDictionary *result=[tools readIDCardS];//读出来的加密数据 其中baseInfo是加密后的数据，需要用设备对应的key解密。
    
    
    //处理xml字符串，因为返回的xml字符没有根节点，所以此处加上一个根节点，便于GDataXmlNode取xml值
    NSString *resultstr = [result valueForKey:@"baseInfo"];
    NSLog(@"获取身份证信息：---- %@",resultstr);
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if(resultstr == nil || [resultstr isEqualToString:@""]){
        [tools disconnectBt];
        [NSThread sleepForTimeInterval:1];
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        [self ShowProgressHUDwithMessage:@"读取身份证信息失败，请重试"];
        
        failStat = YES;
        //        [result release];
        
        //        tools = nil;
        return;
        
    }else{
        failStat = YES;
        [tools disconnectBt];
        [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
        [NSThread sleepForTimeInterval:1];
        
        GDataXMLDocument *xmlroot=[[GDataXMLDocument alloc] initWithXMLString:resultstr options:0 error:nil];
        GDataXMLElement *xmlelement= [xmlroot rootElement];
        NSArray *xmlarray= [xmlelement children];
        NSMutableDictionary *xmldictionary=[NSMutableDictionary dictionary];
        for(GDataXMLElement *childElement in xmlarray){
            NSString *childName= [childElement name];
            NSString *childValue= [childElement stringValue];
            [xmldictionary setValue:childValue forKey:childName];
        }
        
        [xmldictionary valueForKey:@""];
        nameLabel.text = [xmldictionary valueForKey:@"name"];
        idCardLabel.text = [xmldictionary valueForKey:@"idNum"];
        idCardAddress.text = [xmldictionary valueForKey:@"address"];
        
        
        [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
        
        
        
        
        
        
    }
    
    //    相片解码 start
    NSData *_decodedImageData=[result objectForKey:@"picBitmap"];
    if(_decodedImageData!=nil){
        NSDictionary *imgdecodeDict=[tools DecodePicFunc:_decodedImageData];
        NSString *errcode= [imgdecodeDict objectForKey:@"errCode"];
        
        if([errcode isEqualToString:@"-1"]){
            
            [self ShowProgressHUDwithMessage:@"解码图片失败"];
            return;
            
            
        }else if([errcode isEqualToString:@"0"]){
            NSData *imgdecodeData=[imgdecodeDict objectForKey:@"DecPicData"];
            
            UIImage *image = [UIImage imageWithData:imgdecodeData];
            
            
            CGSize origImageSize= [image size];
            CGRect newRect;
            newRect.origin= CGPointZero;
            //拉伸到多大
            newRect.size.width= photoImageView.frame.size.width *2;
            newRect.size.height= photoImageView.frame.size.height*2;
            //缩放倍数
            float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
            UIGraphicsBeginImageContext(newRect.size);
            CGRect projectRect;
            projectRect.size.width =ratio * origImageSize.width;
            projectRect.size.height=ratio * origImageSize.height;
            projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
            projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
            [image drawInRect:projectRect];
            UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
            //压缩比例
            NSData *smallData=UIImageJPEGRepresentation(small, 1);
            UIGraphicsEndImageContext();
            
            if (smallData) {
                photoImageView.image  = [UIImage imageWithData:smallData];
            }
            
            
            
        }
        
    }else{
        
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        //        hud.mode = MBProgressHUDModeText;
        //        hud.labelText = @"解码图片失败";
        //        hud.dimBackground = NO;
        //        hud.removeFromSuperViewOnHide = YES;
        //        [hud hide:YES afterDelay:2];
        [self ShowProgressHUDwithMessage:@"解码图片失败"];
        
        return;
        
    }
    //    相片解码 end
    
    

    
    
    
}



//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    if (![fanNumTextFiled isExclusiveTouch]) {
//        
//    }
//    
//    
//}






@end

@interface LWEdit()

@end

@implementation LWEdit
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:self];
//        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:self];
        [self setFont:[UIFont systemFontOfSize:15.0f]];
//        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSString *newKey = [change objectForKey:NSKeyValueChangeNewKey];
    NSString *oldKey = [change objectForKey:NSKeyValueChangeOldKey];

   
        if ([newKey isEqualToString:oldKey]) {
        
        }
        else{
            NSLog(@"das");
            [self setAutofitLabel:self text:self.text];
        }
  
    
}
//label自适应
-(void)setAutofitLabel:(UILabel*)label2 text:(NSString*)text{
    self.text = text;
    //设置断行模式
    self.lineBreakMode = UILineBreakModeWordWrap;
    //为零设置多行
    self.numberOfLines = 0;
//    self.font = [UIFont fontWithName:@"Helvetica" size:12];
//    [label2 setTextColor:[UIColor redColor]];
    CGSize maximumSize = CGSizeMake(300, CGFLOAT_MAX);
    //获取文字的size
    CGSize expectedLabelSize = [text sizeWithFont:self.font
                                constrainedToSize:maximumSize
                                    lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame = self.frame;
    newFrame.size.height = expectedLabelSize.height;
    newFrame.size.width = self.frame.size.width;
    self.frame = newFrame;
    [self sizeToFit];
}



@end

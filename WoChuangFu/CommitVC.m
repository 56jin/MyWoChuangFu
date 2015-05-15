//
//  CommitVC.m
//  WoChuangFu
//
//  Created by duwl on 12/15/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "CommitVC.h"
#import "GTMBase64_My.h"
#import "ChooseAreaVC.h"
#import "passParams.h"
#import "ShowWebVC.h"
#import "ShowWebVC.h"
#import "WebProductDetailVC.h"
#import "UrlParser.h"

#define TWITTERFON_FORM_BOUNDARY  @"imgBase64"

@interface CommitVC (){
    BOOL showCert;
    BOOL needCertImage;
    BOOL isUpLoadIDCardBack;
}

@property(nonatomic,strong)NSDictionary* saveRequestData;

@end

@implementation CommitVC



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    int moduleId = [self.receiveData[@"ProductInfo"][@"moduleId"] intValue];
    if (moduleId != TypeNet)
    {
        if(self.commitView != nil){
            passParams* pass = [passParams sharePassParams];
            NSDictionary* city = [pass.params objectForKey:@"cityCode"];
            NSDictionary* country = [pass.params objectForKey:@"countryCode"];
            if(city != nil && country != nil){
                [self.commitView updateAreaData:[[city objectForKey:@"areaName"] stringByAppendingString:[country objectForKey:@"areaName"]]];
            }
        }
    }
}

-(void)loadView
{
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[UIColor blackColor];//[ComponentsFactory createColorByHex:@"#F8F8F8"];
    self.view = BackV;
    self.navigationController.navigationBarHidden=YES;
    [self initTitleBar];
    [self initContentView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    showCert = NO;
    int moduleId = [self.receiveData[@"ProductInfo"][@"moduleId"] intValue];
    if (moduleId != TypeNet)
    {
        passParams *pass = [passParams sharePassParams];
        [pass.params removeAllObjects];
    }
}

- (void)initTitleBar
{
    TitleBar* title = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:left_position];
    [title setLeftIsHiden:NO];
    [title setTitle:@"提交订单"];
    if (IOS7){
        title.frame = CGRectMake(0, 20, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
    }
    title.target = self;
    self.titleBar = title;
    [self.view addSubview:self.titleBar];
    
}

- (void)initContentView
{
    int moduleId = [self.receiveData[@"ProductInfo"][@"moduleId"] intValue];
    
    if(moduleId == TypePhone)
    {
        if (self.receiveData[@"ProductInfo"][@"cardNum"]!= [NSNull null] &&![self.receiveData[@"ProductInfo"][@"cardNum"] isEqualToString:@""]&&self.receiveData[@"ProductInfo"][@"cardNum"]!=nil)
        {
            moduleId = TypeContract;
        }
    }
    CommitView* commit = [[CommitView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT+SYSTEM_BAR_HEIGHT, [AppDelegate sharePhoneWidth], [AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-SYSTEM_BAR_HEIGHT) productType:moduleId];
    commit.target = self;
    self.commitView = commit;
    [self.view addSubview:self.commitView];
    
    float price = [self.receiveData[@"ProductInfo"][@"Price"] floatValue];
    
    [self.commitView updataPriceinfo:[NSString stringWithFormat:@"%.2f",price]];
    if (moduleId == TypeNet)
    {
        [self.commitView initAreaData:self.receiveData[@"ProductInfo"][@"areaName"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma
#pragma TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma
#pragma 相机调用
-(void) showCameraForPhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    //    self.imgPicker = picker;
#ifdef __IPHONE_6_0
    //    [self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
#else
    [self presentModalViewController:picker animated:YES];
#endif
}

- (void) imagePickerController: (UIImagePickerController*) picker
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    UIImage *photoImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(photoImg==nil){
        return;
    }
    self.photoImage = photoImg;
    [picker dismissModalViewControllerAnimated:YES];
    if (self.saveedUploadPhotoId == nil) {
        [((UIButton*)[self.view viewWithTag:UPLOAD_PHOTO_BTN])
         setImage:self.photoImage forState:UIControlStateNormal];
        
        [[self.view viewWithTag:UPLOAD_PHOTO_IMG] setHidden:YES];
    }else{
        [((UIButton*)[self.view viewWithTag:UPLOAD_PHOTO_BACK_BTN])
         setImage:self.photoImage forState:UIControlStateNormal];
        
        [[self.view viewWithTag:UPLOAD_PHOTO_BACK_IMG] setHidden:YES];
    }
    [self uploadPhotoRequest];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)showCamera
{
    [self showCameraForPhoto];
}

-(void)requestAreaData
{
    ChooseAreaVC* chooseArea = [[ChooseAreaVC alloc] init];
    NSDictionary* passParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"",@"title_str",
                                [NSNull null],@"request_data",nil];
    chooseArea.params = passParams;
    [self.navigationController pushViewController:chooseArea animated:YES];
}

- (NSString*)encodeURL:(NSString *)string
{
    //CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`")
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)string, NULL,CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if (newString) {
        return newString;
    }
    return @"";
}

-(void)showProtocal:(NSString *)userName
{
    NSDictionary* previewData = [self.receiveData objectForKey:@"ProductInfo"];
//                        ];
    NSString *urlStr = [NSString stringWithFormat:@"%@/mapp/getProtocal?skuId=%@&pkgId=%@&moduleId=%@&userName=%@&period=%@&cardNum=%@&basicName=%@&productId=%@&presentDesc=%@&FROM_ID=app",
                        service_IP,
                        previewData[@"skuId"],
                        previewData[@"pkgId"],
                        previewData[@"moduleId"],
                        userName,
                        previewData[@"period"]== nil?@"":previewData[@"period"],
                        previewData[@"cardNum"],
                        previewData[@"productName"],
                        previewData[@"productId"],
                        @""
                        ];
    ShowWebVC *webVC = [[ShowWebVC alloc] init];
    webVC.urlStr = urlStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma
#pragma 创建订单
-(void)commitRequestData:(NSDictionary*)data
{
    self.saveRequestData = data;
    [self commitOrderRequest:data];
//    if (showCert == YES) {
//        if (needCertImage)
//        {
//            if(self.saveedUploadPhotoId == nil){
//                [self uploadPhotoRequest];
//            }
//        }
//        else
//            [self commitOrderRequest:data];
//    }
//    else {
//        [self commitOrderRequest:data];
//    }
    
    /*支付测试使用
     NSDictionary* sendDic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"M2014122321000030274",@"order_code", nil];
     
     [buss paymentUrl:sendDic1 url:@"http://mall.gx10010.com/emallorder/alipay_wap_mobile.do" key:@"order_code"];
     [sendDic1 release];*/
}

-(void)commitOrderRequest:(NSDictionary*)data
{
    NSMutableDictionary* addrInfo = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"addrInfo"]];
    [addrInfo setObject:[NSString stringWithFormat:@"%@%@%@",addrInfo[@"cityName"],addrInfo[@"countryName"],addrInfo[@"address"]] forKey:@"address"];
    
    NSDictionary* productInfo = [self makeProductInfoData:[data objectForKey:@"productInfo"]];
    NSDictionary* payInfo = nil;
    NSDictionary *expand = nil;
    if (self.receiveData[@"ProductInfo"][@"broadbrand"]!= [NSNull null] &&self.receiveData[@"ProductInfo"][@"broadbrand"] != nil)
    {
        expand = [NSDictionary dictionaryWithObject:self.receiveData[@"ProductInfo"][@"broadbrand"] forKey:@"broadbrand"];
    }
    payInfo=[[NSDictionary alloc] initWithObjectsAndKeys:
             @"com.ailk.app.mapp.model.req.CF0026Request$PayInfo",@"@class",
             [NSNull null],@"expand",
             @"1",@"payType",
             @"1",@"payWay", nil];
    
    NSDictionary* sendDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             expand==nil?[NSNull null]:expand,@"expand",
                             addrInfo,@"addrInfo",
                             productInfo,@"productInfo",
                             payInfo,@"payInfo", nil];
    
    
    bussineDataService* buss = [bussineDataService sharedDataService];
    buss.target = self;
    [buss createOrder:sendDic];
    
}

-(NSDictionary*)makeProductInfoData:(NSMutableDictionary*)enterData
{
    NSDictionary* previewData = [self.receiveData objectForKey:@"ProductInfo"];
    NSMutableDictionary* fullProductInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSString *requestClass = [[[NSString alloc] initWithFormat:JSON_BODY_REUEST,[CREATE_ORDER_BIZCODE uppercaseString]] stringByAppendingString:@"$ProductInfo"];
    [fullProductInfo setObject:requestClass forKey:@"@class"];
    
    if (self.saveedUploadPhotoId == nil)
    {
        [fullProductInfo setObject:[NSNull null] forKey:@"fileId"];
    }
    else
        [fullProductInfo setObject:self.saveedUploadPhotoId forKey:@"fileId"];
    
    [fullProductInfo setObject:[previewData objectForKey:@"woYibaoFlag"]==nil?[NSNull null]:[previewData objectForKey:@"woYibaoFlag"] forKey:@"woYibaoFlag"];
    [fullProductInfo setObject:[enterData objectForKey:@"invoiceInfo"] forKey:@"invoiceInfo"];
    if ([enterData objectForKey:@"certName"] == [NSNull null]||[enterData objectForKey:@"certName"]==nil)
    {
        [fullProductInfo setObject:[NSNull null] forKey:@"certName"];
    }
    else
        [fullProductInfo setObject:[enterData objectForKey:@"certName"] forKey:@"certName"];
    if ([enterData objectForKey:@"certNum"] == [NSNull null]||[enterData objectForKey:@"certNum"]==nil)
    {
        [fullProductInfo setObject:[NSNull null] forKey:@"certNum"];
    }
    else
        [fullProductInfo setObject:[enterData objectForKey:@"certNum"] forKey:@"certNum"];
    [fullProductInfo setObject:[enterData objectForKey:@"remark"]==nil?[NSNull null]:[enterData objectForKey:@"remark"] forKey:@"remark"];
    [fullProductInfo setObject:previewData[@"moduleId"] forKey:@"moduleId"];
    if ([enterData objectForKey:@"modeCode"] == [NSNull null]||[enterData objectForKey:@"modeCode"]==nil) {
            [fullProductInfo setObject:[NSNull null] forKey:@"modeCode"];
    }
    else
        [fullProductInfo setObject:[enterData objectForKey:@"modeCode"] forKey:@"modeCode"];
    
    [fullProductInfo setObject:[previewData objectForKey:@"period"]==nil?[NSNull null]:[previewData objectForKey:@"period"] forKey:@"period"];
    [fullProductInfo setObject:[previewData objectForKey:@"pkgId"]==nil?[NSNull null]:[previewData objectForKey:@"pkgId"] forKey:@"pkgId"];
    [fullProductInfo setObject:[previewData objectForKey:@"productId"]==nil?[NSNull null]:[previewData objectForKey:@"productId"] forKey:@"productId"];
    [fullProductInfo setObject:[previewData objectForKey:@"cardNum"]==nil?[NSNull null]:[previewData objectForKey:@"cardNum"] forKey:@"cardNum"];
//    [fullProductInfo setObject:[previewData objectForKey:@"colorProp"]==nil?[NSNull null]:[previewData objectForKey:@"colorProp"] forKey:@"colorProp"];
//    [fullProductInfo setObject:[previewData objectForKey:@"ramProp"]==nil?[NSNull null]:[previewData objectForKey:@"ramProp"] forKey:@"ramProp"];
    [fullProductInfo setObject:[previewData objectForKey:@"seckillFlag"]==nil?[NSNull null]:[previewData objectForKey:@"seckillFlag"] forKey:@"seckillFlag"];
    [fullProductInfo setObject:[previewData objectForKey:@"skuId"]==nil?[NSNull null]:[previewData objectForKey:@"skuId"] forKey:@"skuId"];
    [fullProductInfo setObject:[previewData objectForKey:@"custType"]==nil?[NSNull null]:[previewData objectForKey:@"custType"] forKey:@"custType"];
    
    return fullProductInfo;
}

#pragma
#pragma 照片上传
- (void)uploadPhotoRequest
{
    NSString *str = [GTMBase64_My stringByEncodingData:UIImageJPEGRepresentation(self.photoImage,0.01)];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:str,@"photoStr", nil];
    
    bussineDataService *buss = [bussineDataService sharedDataService];
    buss.target = self;
    [buss uploadPhoto:dic];
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

//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestDidFinished:(NSDictionary*)info
{
    MyLog(@"%@",info);
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    
    if([bizCode isEqualToString:[CreateOrderMessage getBizCode]]){
        if([oKCode isEqualToString:errCode]){
            bussineDataService* buss = [bussineDataService sharedDataService];
            NSString* postData = [buss.rspInfo objectForKey:@"postData"];
            NSMutableArray* postArr = [[NSMutableArray alloc] initWithArray:[postData componentsSeparatedByString:@"="]];
            if(postArr.count>=2){
                NSDictionary* sendDic = [[NSDictionary alloc] initWithObjectsAndKeys:postArr[1],@"order_code", nil];
                
                buss.target = self;
                [buss paymentUrl:sendDic url:[buss.rspInfo objectForKey:@"postUrl"] key:postArr[0]];
            }
            
        } else {
            if(nil == msg || [info objectForKey:@"MSG"] == [NSNull null]){
                msg = @"提交订单失败！";
            }
            [self showSimpleAlertView:msg];
        }
    } else if([bizCode isEqualToString:[UploadPhotoMessage getBizCode]]){//UploadPhotoMessage
        NSString* saveId = [info objectForKey:@"saveId"];
        if(saveId != nil && saveId.length > 0){
            if (isUpLoadIDCardBack == NO) {
                self.saveedUploadPhotoId = saveId;
                [self.commitView setNeedUploadIDCardBack];
                isUpLoadIDCardBack = YES;
            }else{
                self.saveedUploadPhotoId = [NSString stringWithFormat:@"%@|%@",self.saveedUploadPhotoId,saveId];
            }
        } else {
            [self showSimpleAlertView:@"上传图片失败，请重新上传！"];
        }
    } else if([bizCode isEqualToString:[PaymentUrlMessage getBizCode]]){//PaymentUrlMessage
        NSString* paymentUrl = [info objectForKey:@"paymentUrl"];
        if(paymentUrl != nil && paymentUrl.length>0){
            ShowWebVC* webVC = [[ShowWebVC alloc] init];
            webVC.titleStr = @"在线支付";
            webVC.urlStr = paymentUrl;
            webVC.isPayment = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        } else {
            [self showSimpleAlertView:@"请求支付失败，请重新提交订单"];
        }
    }
    
}
//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestFailed:(NSDictionary*)info
{
    MyLog(@"%@",info);
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    
    if([[CreateOrderMessage getBizCode] isEqualToString:bizCode]){
        if(nil == msg || [info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"提交订单失败！";
        }
        [self showSimpleAlertView:msg];
        
    }
}
@end

//
//  NewChooseAddressVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-2-7.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "NewChooseAddressVC.h"
#import "TitleBar.h"
#import "InsetsLabel.h"
#import "AddressComBox.h"
#import "UIImage+LXX.h"
#import "FilterView.h"
#import "passParams.h"
#define ADDRESS_INPUT_TAG 1024
#define PACKAGE_LABLE_TAG 1025
#define SUBMIT_BTN_TAG    1026
#define TITLE_HEIGHT ([UIScreen mainScreen].applicationFrame.origin.y+TITLE_BAR_HEIGHT)

@interface NewChooseAddressVC ()<TitleBarDelegate,AddressComBoxDelegate,UITextFieldDelegate,FilterViewDelegate,HttpBackDelegate>

@property(nonatomic,strong) NSMutableDictionary *addressRequest;
@property(nonatomic,strong) NSMutableDictionary *packageRequest;
@property(nonatomic,copy)   NSString *lastRequest;//最后访问
@property(nonatomic,strong) NSMutableDictionary *returnDict;
@property(nonatomic,strong) NSMutableArray *broadBandPkg;
@property(nonatomic,strong) NSMutableArray *addrs;
@property(nonatomic,strong) NSString *resAreaCode;

@end

@implementation NewChooseAddressVC

- (NSMutableDictionary *)addressRequest
{
    if (nil == _addressRequest) {
        _addressRequest = [NSMutableDictionary dictionary];
        [_addressRequest setObject:@"10" forKey:@"maxRows"];
    }
    return _addressRequest;
}

- (NSMutableDictionary *)packageRequest
{
    if (nil == _packageRequest) {
        _packageRequest = [NSMutableDictionary dictionary];
    }
    return _packageRequest;
}
- (NSMutableDictionary *)returnDict
{
    if (_returnDict == nil)
    {
        _returnDict = [NSMutableDictionary dictionary];
    }
    return _returnDict;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
    view.backgroundColor = [UIColor blackColor];
    [self createTitleBar];
    [self createMainInfoView];
}

-(void)createTitleBar
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:left_position];
    titleBar.frame = CGRectMake(0,[UIScreen mainScreen].applicationFrame.origin.y,[AppDelegate sharePhoneHeight],TITLE_BAR_HEIGHT);
    titleBar.target = self;
    titleBar.title = @"地址与套餐";
    [self.view addSubview:titleBar];
}

- (void)createMainInfoView
{
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0,TITLE_HEIGHT,[AppDelegate sharePhoneHeight],[AppDelegate sharePhoneHeight]-TITLE_HEIGHT)];
    mainView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    [self.view addSubview:mainView];
    
    InsetsLabel *cityLable = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,TITLE_HEIGHT+30, [AppDelegate sharePhoneWidth],40) andInsets:UIEdgeInsetsMake(0, 15,0, 0)];
    cityLable.backgroundColor = [UIColor whiteColor];
    cityLable.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    cityLable.text = @"城市:";
    [self.view addSubview:cityLable];
    
    AddressComBox *combox = [[AddressComBox alloc] initWithFrame:CGRectMake(60,TITLE_HEIGHT+30,[AppDelegate sharePhoneWidth]-70, 40)];
    combox.delegate = self;
    combox.dataSources = self.cardOrderKeyValuelist;
    combox.layer.borderWidth = 1;
    combox.layer.borderColor = [[ComponentsFactory createColorByHex:@"#eeeeee"] CGColor];
    combox.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:combox];
    

    InsetsLabel *addrLable = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,TITLE_HEIGHT+80, [AppDelegate sharePhoneWidth],40) andInsets:UIEdgeInsetsMake(0, 15,0, 0)];
    addrLable.backgroundColor = [UIColor whiteColor];
    addrLable.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    addrLable.text = @"地址:";
    [self.view addSubview:addrLable];
    
    UITextField *addressInput = [[UITextField alloc] initWithFrame:CGRectMake(60,TITLE_HEIGHT+80, [AppDelegate sharePhoneWidth]-70,40)];
    addressInput.placeholder = @"请输入您的地址(模糊匹配)";
    addressInput.delegate = self;
    addressInput.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    addressInput.tag = ADDRESS_INPUT_TAG;
    [addressInput setFont:[UIFont systemFontOfSize:16.0]];
    [self.view addSubview:addressInput];
    
    InsetsLabel *packageLable = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,TITLE_HEIGHT+130, [AppDelegate sharePhoneWidth],40) andInsets:UIEdgeInsetsMake(0, 15,0, 0)];
    packageLable.backgroundColor = [UIColor whiteColor];
    packageLable.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    packageLable.text = @"套餐:";
    [self.view addSubview:packageLable];
    
    UILabel *package = [[UILabel alloc] initWithFrame:CGRectMake(60,TITLE_HEIGHT+130,[AppDelegate sharePhoneWidth]-60,40)];
    package.tag = PACKAGE_LABLE_TAG;
    package.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    
    [self.view addSubview:package];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"确认选择" forState:UIControlStateNormal];
    submitBtn.tag = SUBMIT_BTN_TAG;
    submitBtn.frame = CGRectMake(10,TITLE_HEIGHT+180,[AppDelegate sharePhoneWidth] - 20, 33);
    [submitBtn setBackgroundImage:[UIImage resizedImage:@"bnt_content_primary_n.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = (UIButton *)[self.view viewWithTag:SUBMIT_BTN_TAG];
    button.enabled = NO;
}

- (void)submit:(UIButton *)sender
{
    if (self.block) {
        self.block(self.returnDict);
    }
    [self backAction];
}

- (void)addressComBox:(AddressComBox *)comBoxView didSelectAtIndex:(NSInteger)index withData:(NSDictionary *)data
{
    self.resAreaCode = data[@"resAreaCode"];
    [self.addressRequest setObject:data[@"areaName"] forKey:@"city"];
    [self.packageRequest setObject:data[@"areaCode"] forKey:@"cityCode"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.tag == ADDRESS_INPUT_TAG &&textField.text.length <2)
    {
        [self ShowProgressHUDwithMessage:@"请至少输入两个字符"];
        return YES;
    }
    else if (textField.tag == ADDRESS_INPUT_TAG && textField.text.length >= 2)
    {
        bussineDataService *bus = [bussineDataService sharedDataService];
        bus.target = self;
        [self.addressRequest setObject:textField.text forKey:@"addrInfo"];
        
        NSString *city = [self.addressRequest objectForKey:@"city"];
        if (city == nil)
        {
            [self ShowProgressHUDwithMessage:@"请先选择城市"];
            return NO;
        }
        
        [bus filterAddress:self.addressRequest];
    }
    return YES;
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

#pragma mark
#pragma mark - TitleBarDeleagete
-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if ([[filterAddressMessage getBizCode] isEqualToString:bizCode]){
        if ([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            NSDictionary *dict = bus.rspInfo;
            if (dict[@"addrs"] != [NSNull null]){
                self.addrs = dict[@"addrs"];
                if (self.addrs.count >0){
                    FilterView *filter = [[FilterView alloc] initWithDataArray:self.addrs andType:FilterViewDataTypeAddress];
                    filter.delegate = self;
                    [filter showInView:self];
                }
                else{
                    [self ShowProgressHUDwithMessage:@"没有搜索结果"];
                }
            }else{
                [self ShowProgressHUDwithMessage:@"没有搜索结果"];
            }
        }else{
            [self ShowProgressHUDwithMessage:@"没有搜索结果"];
        }
    }
    else if([[FilterAddressPackageMessage getBizCode] isEqualToString:bizCode]){
        if ([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            NSDictionary *dict = bus.rspInfo;
            if (dict[@"broadbandPackage"] != [NSNull null]){
                NSDictionary *broadbandPackage = dict[@"broadbandPackage"];
                if (broadbandPackage[@"broadBandPkg"]!=[NSNull null]){
                    self.broadBandPkg = broadbandPackage[@"broadBandPkg"];
                    NSMutableDictionary *broadbrandDict = [NSMutableDictionary dictionary];
                    [broadbrandDict setObject:broadbandPackage[@"addrId"] forKey:@"bssAddr_Id"];
                    [broadbrandDict setObject:broadbandPackage[@"usertypeId"] forKey:@"usertype_Id"];
                    [broadbrandDict setObject:broadbandPackage[@"bssProductId"] forKey:@"bssproduct_Id"];
                    [broadbrandDict setObject:broadbandPackage[@"alTypeId"] forKey:@"aLType_Id"];
                    [broadbrandDict setObject:@"1" forKey:@"bssBandFlag"];
                    [self.returnDict setObject:broadbrandDict forKey:@"broadbrand"];
                    if (self.broadBandPkg.count >0){
                        FilterView *filter = [[FilterView alloc] initWithDataArray:self.broadBandPkg andType:FilterViewDataTypeNetPackage];
                        filter.delegate = self;
                        [filter showInView:self];
                    }
                    else{
                        [self ShowProgressHUDwithMessage:@"没有匹配套餐"];
                    }
                }else{
                    [self ShowProgressHUDwithMessage:@"没有匹配套餐"];
                }
            }
        }else{
            [self ShowProgressHUDwithMessage:@"没有匹配套餐"];
        }
    }
}
- (void)requestFailed:(NSDictionary *)info
{
    [self  ShowProgressHUDwithMessage:@"获取网络数据失败"];
}

- (void)didSelectedRowAtIndex:(NSInteger)index withData:(NSDictionary *)data andType:(FilterViewDataType)type
{
    if (type == FilterViewDataTypeAddress) {
        UITextField *address = (UITextField *)[self.view viewWithTag:ADDRESS_INPUT_TAG];
        address.text = [data objectForKey:@"areaName"];
        [self.packageRequest setObject:[data objectForKey:@"areaCode"] forKey:@"addrId"];
        [self.packageRequest setObject:self.moduleId forKey:@"moduleId"];
        NSDictionary *country = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"",@"areaName",
                                 @"",@"areaCode",
                                 nil];
        NSDictionary *city = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.resAreaCode == nil?@"":self.resAreaCode,@"resAreaCode",
                              self.addrs[index][@"areaName"],@"areaName",
                              self.addrs[index][@"areaCode"],@"areaCode",
                              nil];
        passParams *pass = [passParams sharePassParams];
        [pass.params setObject:country forKey:@"countryCode"];
        [pass.params setObject:city forKey:@"cityCode"];
        bussineDataService *bus = [bussineDataService sharedDataService];
        [self.returnDict setObject:[data objectForKey:@"areaName"] forKey:@"areaName"];
        bus.target = self;
        [bus filterAddressPackage:self.packageRequest];
        
    }else if(type == FilterViewDataTypeNetPackage){
        UILabel *package = (UILabel *)[self.view viewWithTag:PACKAGE_LABLE_TAG];
        package.text = [data objectForKey:@"packDesc"];
        [self.returnDict setObject:self.broadBandPkg[index] forKey:@"broadBandPkg"];
        UIButton *button = (UIButton *)[self.view viewWithTag:SUBMIT_BTN_TAG];
        button.enabled = YES;
    }
}

@end

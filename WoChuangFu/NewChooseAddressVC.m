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

@interface NewChooseAddressVC ()<TitleBarDelegate,AddressComBoxDelegate,UITextFieldDelegate,FilterViewDelegate,HttpBackDelegate,UITableViewDataSource,UITableViewDelegate>

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
    [combox setUserInteractionEnabled:YES];
//    combox.layer.borderWidth = 1;
//    combox.layer.borderColor = [[ComponentsFactory createColorByHex:@"#eeeeee"] CGColor];
    combox.backgroundColor = [UIColor whiteColor];
    [combox setLabelToLeft];
    combox.tag = 7000;
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
    addressInput.clearButtonMode  = UITextFieldViewModeWhileEditing;
    addressInput.returnKeyType = UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textchaange:) name:UITextFieldTextDidChangeNotification object:addressInput];
//    [addressInput addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    
    [self.view addSubview:addressInput];
    
    UITableView *addrssTable = [[UITableView alloc]initWithFrame:CGRectMake(60, TITLE_HEIGHT+120, [AppDelegate sharePhoneWidth]-70, 240) style:UITableViewStylePlain];
    addrssTable.backgroundColor = [UIColor whiteColor];
    addrssTable.tag = 1500;
    addrssTable.dataSource = self;
    addrssTable.delegate = self;
    addrssTable.bounces = NO;
    
//    addrssTable.bounds = CGRectMake(0, 0, 320 / 1.5, 320 / 1.5);
//    addrssTable.layer.cornerRadius  = 10;
    addrssTable.layer.shadowColor   = [UIColor blackColor].CGColor;
    addrssTable.layer.shadowOffset  = CGSizeMake(0, 5);
    addrssTable.layer.shadowOpacity = 0.5f;
    addrssTable.layer.shadowRadius  = 10.0f;
    
//    addrssTable.layer.borderWidth = 1;
//    addrssTable.layer.borderColor  =[UIColor darkGrayColor].CGColor;

    [addrssTable setHidden:YES];;
    [self.view addSubview:addrssTable];


    
   
   
    
    
    
    
    InsetsLabel *packageLable = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,TITLE_HEIGHT+130, [AppDelegate sharePhoneWidth],40) andInsets:UIEdgeInsetsMake(0, 15,0, 0)];
    packageLable.backgroundColor = [UIColor whiteColor];
    packageLable.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    packageLable.text = @"套餐:";
    [self.view addSubview:packageLable];
    
    UILabel *package = [[UILabel alloc] initWithFrame:CGRectMake(60,TITLE_HEIGHT+130,[AppDelegate sharePhoneWidth]-60,40)];
    package.tag = PACKAGE_LABLE_TAG;
    package.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    package.userInteractionEnabled = YES;
    UITapGestureRecognizer *single =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPack:)];
    [package addGestureRecognizer:single];
    
    

    UITableView *combox2 = [[UITableView alloc] initWithFrame:CGRectMake(60,TITLE_HEIGHT+170,[AppDelegate sharePhoneWidth]-70,180)];
    combox2.delegate = self;
    combox2.dataSource = self;
//    combox2.backgroundColor = [UIColor blueColor];
    combox2.tag = 7001;
    combox2.bounces = NO;
    
//     combox2.bounds = CGRectMake(0, 0, 320 / 1.5, 320 / 1.5);
//    combox2.layer.cornerRadius  = 10;
    combox2.layer.shadowColor   = [UIColor blackColor].CGColor;
    combox2.layer.shadowOffset  = CGSizeMake(0, 5);
    combox2.layer.shadowOpacity = 0.5f;
    combox2.layer.shadowRadius  = 10.0f;
    
    
    
    [self.view addSubview:combox2];
    [combox2 setHidden:YES];

    
    
    [self.view addSubview:package];
//    [package setHidden:YES];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"确认选择" forState:UIControlStateNormal];
    submitBtn.tag = SUBMIT_BTN_TAG;
    submitBtn.frame = CGRectMake(10,TITLE_HEIGHT+180,[AppDelegate sharePhoneWidth] - 20, 33);
    [submitBtn setBackgroundImage:[UIImage resizedImage:@"bnt_content_primary_n.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];

}
//-(void)valueChanged:(id)sender{
//   UITextField *textField =  (UITextField*)sender;
//    if (textField.tag==ADDRESS_INPUT_TAG) {
//        
//            UITableView *addressTable = (UITableView*)[self.view viewWithTag:1500];
//            if (!addressTable.hidden) {
//                [addressTable setHidden:YES];
//            }
//        
//            //模糊匹配地址
//            if (textField.tag == ADDRESS_INPUT_TAG &&textField.text.length <2)
//            {
//                [self ShowProgressHUDwithMessage:@"请至少输入两个字符"];
//            
//            }
//            else if (textField.tag == ADDRESS_INPUT_TAG && textField.text.length >= 2)
//            {
//                bussineDataService *bus = [bussineDataService sharedDataService];
//                bus.target = self;
//                [self.addressRequest setObject:textField.text forKey:@"addrInfo"];
//        
//                NSString *city = [self.addressRequest objectForKey:@"city"];
//                if (city == nil)
//                {
//                    [self ShowProgressHUDwithMessage:@"请先选择城市"];
//                }
//                
//                [bus filterAddress:self.addressRequest];
//            }
//    }
//}


-(void)textchaange:(NSNotification*)notifition{
    UITextField *textField = (UITextField*)[self.view viewWithTag:ADDRESS_INPUT_TAG];
    
    if (textField.tag==ADDRESS_INPUT_TAG&&[textField.text length]!=0) {
        
        UITableView *addressTable = (UITableView*)[self.view viewWithTag:1500];
        if (!addressTable.hidden) {
            [addressTable setHidden:YES];
        }
        
        //        //模糊匹配地址
        //        if (textField.tag == ADDRESS_INPUT_TAG &&textField.text.length <1)
        //        {
        //            [self ShowProgressHUDwithMessage:@"请至少输入两个字符"];
        //
        //        }
        if (textField.tag == ADDRESS_INPUT_TAG)
        {
            bussineDataService *bus = [bussineDataService sharedDataService];
            bus.target = self;
            [self.addressRequest setObject:textField.text forKey:@"addrInfo"];
            
            NSString *city = [self.addressRequest objectForKey:@"city"];
            if (city == nil)
            {
                [self ShowProgressHUDwithMessage:@"请先选择城市"];
            }
            
            [bus filterAddress:self.addressRequest];
        }
    }
    
    UITableView *addressTable = (UITableView*)[self.view viewWithTag:1500];
    
    if ([textField.text length]==0) {
        [addressTable setHidden:YES];
    }
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.tag==ADDRESS_INPUT_TAG) {
//        
//        UITableView *addressTable = (UITableView*)[self.view viewWithTag:1500];
//        if (!addressTable.hidden) {
//            [addressTable setHidden:YES];
//        }
//        
////        //模糊匹配地址
////        if (textField.tag == ADDRESS_INPUT_TAG &&textField.text.length <1)
////        {
////            [self ShowProgressHUDwithMessage:@"请至少输入两个字符"];
////            
////        }
//         if (textField.tag == ADDRESS_INPUT_TAG)
//        {
//            bussineDataService *bus = [bussineDataService sharedDataService];
//            bus.target = self;
//            [self.addressRequest setObject:textField.text forKey:@"addrInfo"];
//            
//            NSString *city = [self.addressRequest objectForKey:@"city"];
//            if (city == nil)
//            {
//                [self ShowProgressHUDwithMessage:@"请先选择城市"];
//            }
//            
//            [bus filterAddress:self.addressRequest];
//        }
//    }
//    return YES;
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = (UIButton *)[self.view viewWithTag:SUBMIT_BTN_TAG];
    button.enabled = NO;
}

- (void)submit:(UIButton *)sender
{
    
    
    NSLog(@"%@",self.returnDict);
    if (self.block) {
        self.block(self.returnDict);
    }
    [self backAction];
}

- (void)addressComBox:(AddressComBox *)comBoxView didSelectAtIndex:(NSInteger)index withData:(NSDictionary *)data
{
    if (comBoxView.tag == 7000) {
        self.resAreaCode = data[@"resAreaCode"];
        [self.addressRequest setObject:data[@"areaName"] forKey:@"city"];
        [self.packageRequest setObject:data[@"areaCode"] forKey:@"cityCode"];
    }else if(comBoxView.tag == 7000){
        
    }
    
    UITextField *address = (UITextField *)[self.view viewWithTag:ADDRESS_INPUT_TAG];
    [address becomeFirstResponder];

}
-(void)showPack:(UITapGestureRecognizer *)recognizer{
    
    UITableView *addressTable = (UITableView*)[self.view viewWithTag:7001];
    if (addressTable.hidden&&[self.broadBandPkg count]!=0) {
        [addressTable setHidden:NO];
    }

    else {
        [addressTable setHidden:YES];
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
    //匹配地址
    if ([[filterAddressMessage getBizCode] isEqualToString:bizCode]){
        if ([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            NSDictionary *dict = bus.rspInfo;
            if (dict[@"addrs"] != [NSNull null]){
                 [self.addrs removeAllObjects];
                self.addrs = dict[@"addrs"];
                if (self.addrs.count >0){
                    UITableView *addressTable = (UITableView*)[self.view viewWithTag:1500];
                     UITableView *packTable = (UITableView*)[self.view viewWithTag:7001];
                    //    [addressTable setHidden:NO];
                    [self.view bringSubviewToFront:addressTable];
                    if (addressTable.isHidden) {
                        [addressTable setHidden:NO];
                        [packTable setHidden:YES];
                        [self.view bringSubviewToFront:addressTable];
                        [addressTable reloadData];
                    }else{
                        [addressTable reloadData];
                    }
                }
                else{
                    UITableView *addressTable = (UITableView*)[self.view viewWithTag:1500];
                    [addressTable setHidden:YES];
//                    [self ShowProgressHUDwithMessage:@"没有搜索结果"];
                    
                }
            }else{
                UITableView *addressTable = (UITableView*)[self.view viewWithTag:1500];
                [addressTable setHidden:YES];
//                [self ShowProgressHUDwithMessage:@"没有搜索结果"];
            }
        }else{
            UITableView *addressTable = (UITableView*)[self.view viewWithTag:1500];
            [addressTable setHidden:YES];
//            [self ShowProgressHUDwithMessage:@"没有搜索结果"];
        }
    }
    
    //匹配套餐
    else if([[FilterAddressPackageMessage getBizCode] isEqualToString:bizCode]){
        if ([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            NSDictionary *dict = bus.rspInfo;
            if (dict[@"broadbandPackage"] != [NSNull null]){
                NSDictionary *broadbandPackage = dict[@"broadbandPackage"];
                if (broadbandPackage[@"broadBandPkg"]!=[NSNull null]){
                    [self.broadBandPkg removeAllObjects];
                    self.broadBandPkg = broadbandPackage[@"broadBandPkg"];
                    NSMutableDictionary *broadbrandDict = [NSMutableDictionary dictionary];
                    [broadbrandDict setObject:broadbandPackage[@"addrId"] forKey:@"bssAddr_Id"];
                    [broadbrandDict setObject:broadbandPackage[@"usertypeId"] forKey:@"usertype_Id"];
                    [broadbrandDict setObject:broadbandPackage[@"bssProductId"] forKey:@"bssproduct_Id"];
                    [broadbrandDict setObject:broadbandPackage[@"alTypeId"] forKey:@"aLType_Id"];
                    [broadbrandDict setObject:@"1" forKey:@"bssBandFlag"];
                    [self.returnDict setObject:broadbrandDict forKey:@"broadbrand"];
                    if (self.broadBandPkg.count >0){
                        UITableView *addressTable = (UITableView*)[self.view viewWithTag:7001];
                        UITableView *addressTable2 = (UITableView*)[self.view viewWithTag:1500];
                        [self.view bringSubviewToFront:addressTable];
                        if (addressTable.isHidden) {
                            [addressTable setHidden:NO];
                            [addressTable2 setHidden:YES];
                            [self.view bringSubviewToFront:addressTable];
                            [addressTable reloadData];
                        }else{
                            [addressTable reloadData];
                        }
                    }
                    else{
                        UITableView *addressTable = (UITableView*)[self.view viewWithTag:7001];
                        [addressTable setHidden:YES];
                        [self ShowProgressHUDwithMessage:@"没有匹配套餐"];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                }else{
                    UITableView *addressTable = (UITableView*)[self.view viewWithTag:7001];
                    [addressTable setHidden:YES];
                    [self ShowProgressHUDwithMessage:@"没有匹配套餐"];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }
        }else{
            UITableView *addressTable = (UITableView*)[self.view viewWithTag:7001];
            [addressTable setHidden:YES];
            [self ShowProgressHUDwithMessage:@"没有匹配套餐"];
            
            
        
        }
    }
    
}
- (void)requestFailed:(NSDictionary *)info
{
    [self  ShowProgressHUDwithMessage:@"获取网络数据失败"];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1500) {
        return [self.addrs count];
    }
    else if(tableView.tag == 7001){
        return [self.broadBandPkg count];
    }
    else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    
    if (tableView.tag == 1500) {
         cell.textLabel.text = [self.addrs objectAtIndex:[indexPath row]][@"areaName"];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
    }
    else if (tableView.tag == 7001){
        cell.textLabel.text =  [self.broadBandPkg objectAtIndex:[indexPath row]][@"packDesc"];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1500) {
        
        
        UITextField *address = (UITextField *)[self.view viewWithTag:ADDRESS_INPUT_TAG];
        address.text = [self.addrs objectAtIndex:[indexPath row]][@"areaName"];
        [self.packageRequest setObject:[[self.addrs objectAtIndex:indexPath.row] objectForKey:@"areaCode"] forKey:@"addrId"];
        [self.packageRequest setObject:self.moduleId forKey:@"moduleId"];
        NSDictionary *country = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"",@"areaName",
                                 @"",@"areaCode",
                                 nil];
        NSDictionary *city = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.resAreaCode == nil?@"":self.resAreaCode,@"resAreaCode",
                              self.addrs[indexPath.row][@"areaName"],@"areaName",
                              self.addrs[indexPath.row][@"areaCode"],@"areaCode",
                              nil];
        passParams *pass = [passParams sharePassParams];
        [pass.params setObject:country forKey:@"countryCode"];
        [pass.params setObject:city forKey:@"cityCode"];
        
        bussineDataService *bus = [bussineDataService sharedDataService];
        [self.returnDict setObject:[[self.addrs objectAtIndex:indexPath.row] objectForKey:@"areaName"] forKey:@"areaName"];
        
        bus.target = self;
        [bus filterAddressPackage:self.packageRequest];
        
        [address resignFirstResponder];
    }
    if (tableView.tag == 7001) {
        UILabel *package = (UILabel *)[self.view viewWithTag:PACKAGE_LABLE_TAG];
        package.text =  [self.broadBandPkg objectAtIndex:[indexPath row]][@"packDesc"];
        [self.returnDict setObject:self.broadBandPkg[indexPath.row] forKey:@"broadBandPkg"];
        UIButton *button = (UIButton *)[self.view viewWithTag:SUBMIT_BTN_TAG];
        button.enabled = YES;

    }
    [tableView setHidden:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITextField *tf = (UITextField*)[self.view viewWithTag:ADDRESS_INPUT_TAG];
    if ((![tf isExclusiveTouch])) {
        [tf
         resignFirstResponder];
    }}
@end

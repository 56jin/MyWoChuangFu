//
//  insuranceVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/26.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "insuranceVC.h"
#import <QuartzCore/QuartzCore.h>
#import "TitleBar.h"
#import "CommonMacro.h"
#import "UIImage+LXX.h"
#import "ZSYCommonPickerView.h"
#import "DataDictionary_back_cart_item.h"
#import "InsuranceShowVC.h"
#define MyTextFieldHeight 33

@interface InsuranceVC ()<TitleBarDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@end

@implementation InsuranceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    [_userName resignFirstResponder];
    [_userPhoneNum resignFirstResponder];
    [_certNum resignFirstResponder];
    [_phoneName resignFirstResponder];
    [_imeiNub resignFirstResponder];
}

-(void)layout
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:left_position];
    titleBar.title = @"手机意外保";
    [titleBar setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [self.view addSubview:titleBar];
    titleBar.target = self;
    
    _phoneTypeData = [NSMutableArray array];
    _phoneTypeData = [NSMutableArray arrayWithObjects:@"三星",@"联想",@"酷派",@"iphone",@"华为",@"HTC",@"海信",nil];

    _userName = [[UITextField alloc]initWithFrame:CGRectMake(10, 24, SCREEN_WIDTH-20, MyTextFieldHeight)];
      _userName.delegate = self;
    _userName.placeholder = @"客户姓名";
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.layer.cornerRadius = 5.0;
//    _userName.borderStyle = UITextBorderStyleLine;



    _userPhoneNum = [[UITextField alloc]initWithFrame:CGRectMake(10, 24+MyTextFieldHeight+1, SCREEN_WIDTH-20, MyTextFieldHeight)];
    _userPhoneNum.delegate = self;
    _userPhoneNum.placeholder = @"客户手机号码";
    _userPhoneNum.backgroundColor = [UIColor whiteColor];
     _userPhoneNum.layer.cornerRadius = 5.0;

 
    UIImageView *btnDown = [[UIImageView alloc]initWithFrame:CGRectMake(115, 24+MyTextFieldHeight*3+23,10, 8)];
    btnDown.image = [UIImage imageNamed:@"btn_content_down_n"];
    
//    UIView *certNum3= [[UIView alloc]initWithFrame:CGRectMake(0, MyTextFieldHeight*2+74+1, SCREEN_WIDTH, MyTextFieldHeight)];
    _certNum = [[UITextField alloc]initWithFrame:CGRectMake(10, 24+MyTextFieldHeight*2+2, SCREEN_WIDTH-20, MyTextFieldHeight)];
    _certNum.delegate = self;
    _certNum.backgroundColor = [UIColor whiteColor];
    _certNum.placeholder = @"证件号码";
     _certNum.layer.cornerRadius = 5.0;

    _choosePhBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 24+MyTextFieldHeight*3+10, SCREEN_WIDTH/2-30, MyTextFieldHeight)];
    [_choosePhBtn setTitle:@"手机品牌" forState:UIControlStateNormal];
    [_choosePhBtn addTarget:self action:@selector(choosePhClicked) forControlEvents:UIControlEventTouchUpInside];
    [_choosePhBtn setBackgroundColor:[UIColor whiteColor]];
    [_choosePhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//      [_choosePhBtn.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色
    _choosePhBtn.backgroundColor = [UIColor whiteColor];
//     [_choosePhBtn.layer setBorderWidth:1.0];
    
    _phoneName = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-10, 24+MyTextFieldHeight*3+10, SCREEN_WIDTH/2, MyTextFieldHeight)];
    _phoneName.delegate = self;
    _phoneName.backgroundColor = [UIColor whiteColor];
    _phoneName.placeholder = @"品牌型号";
    _phoneName.layer.cornerRadius = 5.0;
    
    _imeiNub = [[UITextField alloc]initWithFrame:CGRectMake(10, 24+MyTextFieldHeight*4+20, SCREEN_WIDTH-20, MyTextFieldHeight)];
    _imeiNub.delegate = self;
    _imeiNub.backgroundColor = [UIColor whiteColor];
    _imeiNub.placeholder = @"手机IMEI号";
    _imeiNub.layer.cornerRadius = 5.0;
    
    

    
    UIScrollView *bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    [bgView setContentSize:CGSizeMake(0, SCREEN_HEIGHT+20)];
    [bgView setShowsVerticalScrollIndicator:NO];
    [bgView setBounces:YES];
    bgView.delegate = self;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH-60, 33)];
    
    UIImage* image = [UIImage resizedImage:@"btn_alter_bg_p"];
    //image = [image stretchableImageWithLeftCapWidth:19 topCapHeight:19];
    [searchBtn setBackgroundImage:image forState:UIControlStateNormal];
    [searchBtn setTitle:@"提交" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(sendClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
    
    [self.view addSubview:bgView];
    [bgView addSubview:_choosePhBtn];
    [bgView addSubview:_userName];
    [bgView addSubview:_userPhoneNum];
    [bgView addSubview:_certNum];
    [bgView addSubview:_phoneName];
    [bgView addSubview:_imeiNub];
    [bgView addSubview:btnDown];
    
    [self.view addSubview:view];
    bgView.backgroundColor = UIColorWithRGBA(240, 239, 245, 1);
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)choosePhClicked
{
    NSArray* sourceData = _phoneTypeData;
    NSMutableArray* phoneData = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i=0;i<sourceData.count;i++){
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"ITEM_CODE",sourceData[i],@"ITEM_NAME", nil];
        DataDictionary_back_cart_item *dat=[[DataDictionary_back_cart_item alloc] initWithDataItem:dic];
        [phoneData addObject:dat];
    }
    
    NSString* title = @"手机品牌";
    ZSYCommonPickerView *pickerView = [[ZSYCommonPickerView alloc] initWithTitle:title
                                                                      includeAll:NO
                                                                      dataSource:phoneData
                                                               selectedIndexPath:1
                                                                        Firstrow:@"" cancelButtonBlock:^{
                                                                            [self.choosePhBtn setTitle:@"手机品牌" forState:UIControlStateNormal];
                                                                           _phoneType = nil;
                                                                            [_choosePhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                                                                            [self reloadNumList];
                                                                        } makeSureButtonBlock:^(NSInteger indexPath) {
                                                                            if([_phoneTypeData count]>0){
                                                                                _phoneType = _phoneTypeData[indexPath];
                                                                                [self.choosePhBtn setTitle:_phoneTypeData[indexPath] forState:UIControlStateNormal];

                                                                                [self.choosePhBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                                                                            }
                                                                        }];
    
    
    [pickerView show];
}

-(void)sendClicked
{

    InsuranceShowVC *show=[[InsuranceShowVC alloc] init];

    show.userName = self.userName.text;
    show.userPhoneNum = self.userPhoneNum.text;
    show.certNum = self.certNum.text;
    show.userName = self.userName.text;
    show.phoneName = self.phoneName.text;
    show.imeiNub = self.imeiNub.text;
    show.phoneType = self.phoneType;

    if ([_userName.text isEqualToString: @""]||[_userPhoneNum.text isEqualToString: @""]||[_certNum.text isEqualToString: @""]||[_userName.text isEqualToString:@""]||[_phoneName.text isEqualToString:@""]||[_imeiNub.text isEqualToString:@""]||_phoneType ==nil) {

//        [self ShowProgressHUDwithMessage:@"请输入完整的搜索条件！"];
    }
    else
        [self.navigationController pushViewController:show animated:YES];
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


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

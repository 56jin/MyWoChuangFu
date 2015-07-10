//
//  CommitView.m
//  WoChuangFu
//
//  Created by duwl on 12/15/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "CommitView.h"
#import "ZSYCommonPickerView.h"
#import "DataDictionary_back_cart_item.h"
#import "UIImage+LXX.h"
#import "passParams.h"
#import "PackManager.h"
#import "UIWindow+YUBottomPoper.h"

#define INFO_HEIGHT         49
#define SEPARATE_LINE       10
#define SEPARATE_LINE_S     2
#define FOOTER_HEIGHT       70

@interface CommitView()

@property(nonatomic,retain) UILabel* payMoneyLab;

@end

@implementation CommitView
@synthesize scrollView;
@synthesize target;
@synthesize pkgDataArray;
@synthesize payMoneyLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - FOOTER_HEIGHT)];
        scroll.delegate = self;
        [self addSubview:scroll];
        self.scrollView = scroll;
        [self layoutView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame productType:(DetailType)type
{
    myType = type;
    return [self initWithFrame:frame];
}

- (void)layoutView
{
    float offset_y = 0;
    switch (myType)
    {
        case TypeCard:
        case TypeContract:
        {
            offset_y = [self layoutCertInfo:offset_y];
            offset_y = [self layoutUserInfo:offset_y];
            offset_y = [self layoutPackageInfo:offset_y];
        }
            break;
        case TypeNet:
        {
            offset_y = [self layoutCertInfo:offset_y];
            offset_y = [self layoutUserInfo:offset_y];
        }
            break;
        case TypePhone:
            break;
        case TypeParts:
            break;
        default:
            break;
    }
    if (myType == TypeNet)
    {
        offset_y = [self layoutReceiverPhone:offset_y];
    }
    else
    {
        offset_y = [self layoutReceiverInfo:offset_y];
    }
    offset_y = [self layoutAddrInfo:offset_y];
    offset_y = [self layoutOtherInfo:offset_y];
    
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width, offset_y)];
    
    [self layoutFooterInfo];
}

//身份证信息
- (float)layoutCertInfo:(float)offset_y
{
    InsetsLabel* safetyInfo = [[InsetsLabel alloc] initWithFrame:CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT)];
    safetyInfo.text = @"按照公安部、工信部实名制要求，为保障用户的合法权益，请机主上传本人身份证！";
    safetyInfo.lineBreakMode = UILineBreakModeWordWrap;
    safetyInfo.numberOfLines = 0;
    [safetyInfo setTextColor:[ComponentsFactory createColorByHex:@"#666666"]];
    [safetyInfo setFont:[UIFont systemFontOfSize:14.0]];
    [safetyInfo setInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
#ifdef __IPHONE_6_0
    [safetyInfo setTextAlignment:NSTextAlignmentLeft];
#else
    [safetyInfo setTextAlignment:UITextAlignmentLeft];
#endif
    safetyInfo.backgroundColor = [ComponentsFactory createColorByHex:@"#efeff4"];
    [self.scrollView addSubview:safetyInfo];
    
    offset_y = offset_y+safetyInfo.frame.size.height;
    
    [self drawSeprete:1 Offset:offset_y];
    offset_y += SEPARATE_LINE_S;
    
    
    UIScrollView *IDCardScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT*4)];
    IDCardScroll.backgroundColor = [UIColor whiteColor];
    IDCardScroll.tag = IDCARD_SCROLL_VIEW;
    IDCardScroll.scrollEnabled = NO;
    IDCardScroll.pagingEnabled = YES;
    IDCardScroll.contentSize = CGSizeMake(self.frame.size.width*2,INFO_HEIGHT*4);
    [self.scrollView addSubview:IDCardScroll];

    UIButton* getCertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCertBtn.frame = CGRectMake(0,0, self.frame.size.width, INFO_HEIGHT*4);
    getCertBtn.backgroundColor = [UIColor whiteColor];
    [getCertBtn setTitle:@"上传本人身份证正面" forState:UIControlStateNormal];
    [getCertBtn setTitleColor:[ComponentsFactory createColorByHex:@"#999999"] forState:UIControlStateNormal];
       [getCertBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
#ifdef __IPHONE_6_0
    [getCertBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
#else
    [getCertBtn.titleLabel setTextAlignment:UITextAlignmentCenter];
#endif
    getCertBtn.tag = UPLOAD_PHOTO_BTN;
    getCertBtn.userInteractionEnabled = YES;
    [IDCardScroll addSubview:getCertBtn];
    
    UIImageView* photoImg = [[UIImageView alloc] init];
    photoImg.frame = CGRectMake(46, (getCertBtn.frame.size.height-34)/2, 34, 34);
    photoImg.image = [UIImage imageNamed:@"btn_order_photo_n"];
    photoImg.tag = UPLOAD_PHOTO_IMG;
    [getCertBtn addSubview:photoImg];
    
    
    UIButton* getCertBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCertBackBtn.frame = CGRectMake(self.frame.size.width,0, self.frame.size.width, INFO_HEIGHT*4);
    getCertBackBtn.backgroundColor = [UIColor whiteColor];
    [getCertBackBtn setTitle:@"上传本人身份证反面" forState:UIControlStateNormal];
    [getCertBackBtn setTitleColor:[ComponentsFactory createColorByHex:@"#999999"] forState:UIControlStateNormal];
    [getCertBackBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
#ifdef __IPHONE_6_0
    [getCertBackBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
#else
    [getCertBackBtn.titleLabel setTextAlignment:UITextAlignmentCenter];
#endif
    getCertBackBtn.tag = UPLOAD_PHOTO_BACK_BTN;
    getCertBackBtn.userInteractionEnabled = YES;
    [IDCardScroll addSubview:getCertBackBtn];
    
    UIImageView* photoBackImg = [[UIImageView alloc] init];
    photoBackImg.frame = CGRectMake(46, (getCertBackBtn.frame.size.height-34)/2, 34, 34);
    photoBackImg.image = [UIImage imageNamed:@"btn_order_photo_n"];
    photoBackImg.tag = UPLOAD_PHOTO_BACK_IMG;
    [getCertBackBtn addSubview:photoBackImg];
    
    offset_y += IDCardScroll.frame.size.height;
    
    [self drawSeprete:2 Offset:offset_y];
    offset_y += SEPARATE_LINE;
    
    return offset_y;
}

- (void)setNeedUploadIDCardBack
{
    UIScrollView *IDCardScroll = (UIScrollView *)[self viewWithTag:IDCARD_SCROLL_VIEW];
    [IDCardScroll setContentOffset:CGPointMake(IDCardScroll.frame.size.width,0) animated:YES];
}

//用户信息
- (float)layoutUserInfo:(float)offset_y
{
    UIView* nameView = [[UIView alloc] init];
    nameView.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    nameView.backgroundColor = [UIColor whiteColor];
    offset_y+= INFO_HEIGHT;
    
    UITextField* textName = [[UITextField alloc] init];
    textName.frame = CGRectMake(10, 10, self.frame.size.width-20, INFO_HEIGHT-20);
    textName.placeholder = @"请输入姓名";
    textName.font = [UIFont systemFontOfSize:16.0];
    textName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textName.backgroundColor = [UIColor whiteColor];
    textName.tag = ENTER_NAME;
    [textName setReturnKeyType:UIReturnKeyDone];
    textName.delegate = self;
    
    [nameView addSubview:textName];
    [self.scrollView addSubview:nameView];
    
    [self drawSeprete:1 Offset:offset_y];
    offset_y += SEPARATE_LINE_S;
    
    UIView* numView = [[UIView alloc] init];
    numView.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    numView.backgroundColor = [UIColor whiteColor];
    offset_y+= INFO_HEIGHT;
    
    UITextField* textNum = [[UITextField alloc] init];
    textNum.frame = CGRectMake(10, 10, self.frame.size.width-20, INFO_HEIGHT-20);
    textNum.placeholder = @"请输入身份证号";
    textNum.font = [UIFont systemFontOfSize:16.0];
    textNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textNum.backgroundColor = [UIColor whiteColor];
    textNum.tag = ENTER_CER;
    [textNum setReturnKeyType:UIReturnKeyDone];
    textNum.delegate = self;
    
    [numView addSubview:textNum];
    [self.scrollView addSubview:numView];
    
    [self drawSeprete:2 Offset:offset_y];
    offset_y += SEPARATE_LINE;
    
    return offset_y;
}

- (float)layoutPackageInfo:(float)offset_y
{
    UIView* pkgView = [[UIView alloc] init];
    pkgView.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    pkgView.backgroundColor = [UIColor whiteColor];
    offset_y+= INFO_HEIGHT;
    
    UISwitch* swit = [[UISwitch alloc] init];
    swit.frame = CGRectMake(10, 10, 60, 20);
    [pkgView addSubview:swit];
    
    UIButton* pro = [UIButton buttonWithType:UIButtonTypeCustom];
    pro.frame = CGRectMake(10+60+10+10, 0, self.frame.size.width - 70, INFO_HEIGHT);
    [pro setTitle:@"《中国联通移动项目入网协议》" forState:UIControlStateNormal];
    [pro.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    pro.tag = SELECT_READ_PROTOCAL;
    [pro addTarget:self action:@selector(showProtocalClicked) forControlEvents:UIControlEventTouchDown];
    [pro setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pkgView addSubview:pro];
    [self.scrollView addSubview:pkgView];
    
    [self drawSeprete:1 Offset:offset_y];
    offset_y += SEPARATE_LINE_S;
    
    UIButton* addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addrBtn.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    addrBtn.backgroundColor = [UIColor whiteColor];
    [addrBtn setTitle:@"套餐生效时间" forState:UIControlStateNormal];
    [addrBtn setTitleColor:[ComponentsFactory createColorByHex:@"#666666"] forState:UIControlStateNormal];
    [addrBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
#ifdef __IPHONE_6_0
    [addrBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
#else
    [addrBtn.titleLabel setTextAlignment:UITextAlignmentLeft];
#endif
    addrBtn.tag = SELECT_PACKAGE_TYPE;
    offset_y += addrBtn.frame.size.height;
    addrBtn.userInteractionEnabled = YES;
    [addrBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:addrBtn];
    
    [self drawSeprete:2 Offset:offset_y];
    offset_y += SEPARATE_LINE;
    return offset_y;
}

-(float)layoutReceiverPhone:(float)offset_y
{
    UIView* phoneView = [[UIView alloc] init];
    phoneView.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    phoneView.backgroundColor = [UIColor whiteColor];
    offset_y+= INFO_HEIGHT;
    
    UITextField* textPhone = [[UITextField alloc] init];
    textPhone.frame = CGRectMake(10, 10, self.frame.size.width-20, INFO_HEIGHT-20);
    textPhone.placeholder = @"请输入联系人手机号码";
    textPhone.font = [UIFont systemFontOfSize:16.0];
    textPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textPhone.backgroundColor = [UIColor whiteColor];
    textPhone.tag = ENTER_CONTRACT;
    [textPhone setReturnKeyType:UIReturnKeyDone];
    textPhone.delegate = self;
    
    [phoneView addSubview:textPhone];
    [self.scrollView addSubview:phoneView];
    
    [self drawSeprete:2 Offset:offset_y];
    offset_y += SEPARATE_LINE;
    
    return offset_y;
}
- (float)layoutReceiverInfo:(float)offset_y
{
    UIView* nameView = [[UIView alloc] init];
    nameView.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    nameView.backgroundColor = [UIColor whiteColor];
    offset_y+= INFO_HEIGHT;
    
    UITextField* textName = [[UITextField alloc] init];
    textName.frame = CGRectMake(10, 10, self.frame.size.width-20, INFO_HEIGHT-20);
    textName.placeholder = @"请输入收货人姓名";
    textName.font = [UIFont systemFontOfSize:16.0];
    textName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textName.backgroundColor = [UIColor whiteColor];
    textName.tag = ENTER_RECEIVER_NAME;
    [textName setReturnKeyType:UIReturnKeyDone];
    textName.delegate = self;
    
    [nameView addSubview:textName];
    [self.scrollView addSubview:nameView];
    
    [self drawSeprete:1 Offset:offset_y];
    offset_y += SEPARATE_LINE_S;
    
    UIView* phoneView = [[UIView alloc] init];
    phoneView.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    phoneView.backgroundColor = [UIColor whiteColor];
    offset_y+= INFO_HEIGHT;
    
    UITextField* textPhone = [[UITextField alloc] init];
    textPhone.frame = CGRectMake(10, 10, self.frame.size.width-20, INFO_HEIGHT-20);
    textPhone.placeholder = @"请输入收货人手机号码";
    textPhone.font = [UIFont systemFontOfSize:16.0];
    textPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textPhone.backgroundColor = [UIColor whiteColor];
    textPhone.tag = ENTER_CONTRACT;
    [textPhone setReturnKeyType:UIReturnKeyDone];
    textPhone.delegate = self;
    
    [phoneView addSubview:textPhone];
    [self.scrollView addSubview:phoneView];
    [self drawSeprete:2 Offset:offset_y];
    offset_y += SEPARATE_LINE;
    
    return offset_y;
}

//地址信息
- (float)layoutAddrInfo:(float)offset_y
{
    
    
    UIButton* sendTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendTypeBtn.frame = CGRectMake(150, offset_y, self.frame.size.width/2-5, INFO_HEIGHT);
    sendTypeBtn.backgroundColor = [UIColor whiteColor];
    [sendTypeBtn setTitle:@"选择配送方式" forState:UIControlStateNormal];
    [sendTypeBtn setTitleColor:[ComponentsFactory createColorByHex:@"#666666"] forState:UIControlStateNormal];
    [sendTypeBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    sendTypeBtn.tag = 1020;
     sendTypeBtn.userInteractionEnabled = YES;
     [self.scrollView addSubview:sendTypeBtn];
    [sendTypeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addrBtn.frame = CGRectMake(0, offset_y, self.frame.size.width/2-5, INFO_HEIGHT);
    addrBtn.backgroundColor = [UIColor whiteColor];
    [addrBtn setTitle:@"选择配送地区" forState:UIControlStateNormal];
    [addrBtn setTitleColor:[ComponentsFactory createColorByHex:@"#666666"] forState:UIControlStateNormal];
    [addrBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
#ifdef __IPHONE_6_0
    [addrBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
#else
    [addrBtn.titleLabel setTextAlignment:UITextAlignmentLeft];
#endif
    addrBtn.tag = SELECT_ADDR_AREA;
    offset_y += addrBtn.frame.size.height;
    addrBtn.userInteractionEnabled = YES;
    [addrBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    [self.scrollView addSubview:addrBtn];
    
    [self drawSeprete:1 Offset:offset_y];
    offset_y += SEPARATE_LINE_S;
    
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    offset_y+= INFO_HEIGHT;
    
    UITextField* textPhone = [[UITextField alloc] init];
    textPhone.frame = CGRectMake(10, 10, self.frame.size.width-20, INFO_HEIGHT-20);
    textPhone.placeholder = @"请输入详细地址";
    textPhone.font = [UIFont systemFontOfSize:16.0];
    textPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textPhone.backgroundColor = [UIColor whiteColor];
    textPhone.tag = ENTER_ADDR_DETAIL;
    [textPhone setReturnKeyType:UIReturnKeyDone];
    textPhone.delegate = self;
    
    [view addSubview:textPhone];
    [self.scrollView addSubview:view];
    
    [self drawSeprete:2 Offset:offset_y];
    offset_y += SEPARATE_LINE;
    
    return offset_y;
}

//发票及备注
- (float)layoutOtherInfo:(float)offset_y
{
    //发票
    UIView* recipeInfo = [[UIView alloc] init];
    recipeInfo.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT);
    recipeInfo.backgroundColor = [UIColor whiteColor];
    offset_y += INFO_HEIGHT;
    
    //    UISwitch* swit = [[UISwitch alloc] init];
    //    swit.frame = CGRectMake(5, 10, 60, 20);
    //    [recipeInfo addSubview:swit];
    //    [swit release];
    
    UILabel* recipeTitle = [[UILabel alloc] init];
    recipeTitle.frame = CGRectMake(10, 0, self.frame.size.width/4, INFO_HEIGHT);
    recipeTitle.text = @"发票信息";
    [recipeInfo addSubview:recipeTitle];
    
    UITextField* textRecipe = [[UITextField alloc] init];
    textRecipe.frame = CGRectMake(10+10+self.frame.size.width/4, 0, self.frame.size.width/4 * 3, INFO_HEIGHT);
    textRecipe.placeholder = @"公司名称或个人姓名，可不填";
    textRecipe.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textRecipe.font = [UIFont systemFontOfSize:16.0];
    textRecipe.backgroundColor = [UIColor whiteColor];
    textRecipe.tag = ENTER_RECEPE;
    [textRecipe setReturnKeyType:UIReturnKeyDone];
    [textRecipe setAdjustsFontSizeToFitWidth:YES];
    textRecipe.delegate = self;
    [recipeInfo addSubview:textRecipe];
    
    [self.scrollView addSubview:recipeInfo];
    
    //备注
    [self drawSeprete:2 Offset:offset_y];
    offset_y += SEPARATE_LINE;
    
    UIView* markView = [[UIView alloc] init];
    markView.frame = CGRectMake(0, offset_y, self.frame.size.width, INFO_HEIGHT*2);
    markView.backgroundColor = [UIColor whiteColor];
    offset_y+= INFO_HEIGHT*2;
    
    UITextField* textMark = [[UITextField alloc] init];
    textMark.frame = CGRectMake(10, 10, self.frame.size.width-20, INFO_HEIGHT*2-20);
    textMark.placeholder = @"订单备注，限100个字以内";
    textMark.font = [UIFont systemFontOfSize:16.0];
    textMark.backgroundColor = [UIColor whiteColor];
    textMark.tag = ENTER_MARK;
    [textMark setReturnKeyType:UIReturnKeyDone];
    textMark.delegate = self;
    
    [markView addSubview:textMark];
    [self.scrollView addSubview:markView];
    
    return offset_y;
}

//画分隔线，1:小；2:大
- (void)drawSeprete:(int)type Offset:(float)offset_y
{
    UIView* sep = [[UIView alloc] init];
    int sep_h;
    if(type == 1){
        sep_h = SEPARATE_LINE_S;
    }else{
        sep_h = SEPARATE_LINE;
    }
    sep.frame = CGRectMake(0, offset_y, self.frame.size.width, sep_h);
    sep.backgroundColor = [ComponentsFactory createColorByHex:@"#efeff4"];
    [self.scrollView addSubview:sep];
}

//显示协议
- (void)showProtocalClicked
{
    NSString *enterStr = ((UITextField*)[self viewWithTag:ENTER_NAME]).text;
    if (enterStr == nil || [enterStr isEqualToString:@""])
    {
        [self showSimpleAlertView:@"请先输入身份证名称！"];
        return;
    }
    if(self.target != nil && [self.target respondsToSelector:@selector(showProtocal:)]){
        [self.target performSelector:@selector(showProtocal:) withObject:enterStr];
    }
}

//提交按钮
- (void)layoutFooterInfo
{
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-FOOTER_HEIGHT,
                                                              self.frame.size.width, FOOTER_HEIGHT)];
    UIView* sep = [[UIView alloc] init];
    sep.frame = CGRectMake(0, 0, self.frame.size.width, SEPARATE_LINE_S);
    sep.backgroundColor = [ComponentsFactory createColorByHex:@"#efeff4"];
    [footer addSubview:sep];
    
    footer.backgroundColor = [UIColor whiteColor];
    
    //实付款
    UILabel* payLab = [[UILabel alloc] init];
    payLab.frame = CGRectMake(10, 15, 50, 15);
    payLab.backgroundColor = [UIColor clearColor];
    payLab.text = @"实付款";
    payLab.font = [UIFont systemFontOfSize:14.0];
    [footer addSubview:payLab];
    
    payMoneyLab = [[UILabel alloc] init];
    payMoneyLab.frame = CGRectMake(10, 30+2, 100, 25);
    payMoneyLab.backgroundColor = [UIColor clearColor];
    payMoneyLab.text = @"￥4900.00";
    payMoneyLab.font = [UIFont systemFontOfSize:18.0];
    payMoneyLab.textColor = [ComponentsFactory createColorByHex:@"#ff7e0c"];
    payMoneyLab.tag = LABEL_PAY_VALUE;
    [footer addSubview:payMoneyLab];
    
    UIImage* image = [[UIImage resizedImage:@"btn_alter_bg_p"] stretchableImageWithLeftCapWidth:15 topCapHeight:10];
    
    UIButton* payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(self.frame.size.width - 110-10, (FOOTER_HEIGHT-33)/2, 110, 33);
    [payBtn setBackgroundImage:image forState:UIControlStateNormal];
    [payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.tag = COMMIT_ORDER;
    [footer addSubview:payBtn];
    
    [self addSubview:footer];
}

-(void)buttonAction:(id)sender
{
    UIButton* button = (UIButton*)sender;
    switch (button.tag) {
        case UPLOAD_PHOTO_BTN:
        case UPLOAD_PHOTO_BACK_BTN:
            [self showCameraAction];
            break;
        case SELECT_ADDR_AREA:
            [self selectAreaAction];
            break;
        case 1020:
            [self selctSendMode];
            break;
        
        case SELECT_PACKAGE_TYPE:
            [self showPackageSelect];
            break;
        case COMMIT_ORDER:
            [self commitRequestDataAction];
        default:
            break;
    }
}

-(void)showPackageSelect
{
    NSArray *packageModes =  [PackManager shareInstance].packageModes;
    NSMutableArray *sourceData = [NSMutableArray arrayWithCapacity:[packageModes count]];
    for (int i = 0; i<[packageModes count]; i++) {
        [sourceData addObject:[packageModes[i] objectForKey:@"codeName"]];
    }
//    NSArray* sourceData = [[NSArray alloc] initWithObjects:@"全月套餐",@"半月套餐",@"次月开通", nil];
    self.pkgDataArray = sourceData;
    NSMutableArray* pkgData = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i=0;i<sourceData.count;i++){
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"ITEM_CODE",sourceData[i],@"ITEM_NAME", nil];
        DataDictionary_back_cart_item *dat=[[DataDictionary_back_cart_item alloc] initWithDataItem:dic];
        [pkgData addObject:dat];

    }
    NSString* title =@"选择套餐";
    [self hiddenAllKeyBoard];
    ZSYCommonPickerView *pickerView = [[ZSYCommonPickerView alloc] initWithTitle:title
                                                                      includeAll:NO
                                                                      dataSource:pkgData
                                                               selectedIndexPath:1
                                                                        Firstrow:@"" cancelButtonBlock:^{
                                                                            
                                                                        } makeSureButtonBlock:^(NSInteger sindexPath) {
                                                                            [((UIButton*)[self viewWithTag:SELECT_PACKAGE_TYPE]) setTitle:[self.pkgDataArray objectAtIndex:sindexPath] forState:UIControlStateNormal];
                                                                        }];
    [pickerView show];
}

-(BOOL)checkEnterData
{
    NSString* enterStr = nil;
    //显示照片
    
    if (myType == TypeCard ||myType == TypeContract||myType == TypeNet) {
        if(((UIButton*)[self viewWithTag:UPLOAD_PHOTO_BTN]).imageView.image == nil){
            [self showSimpleAlertView:@"请先拍摄身份证照片正面！"];
            return NO;
        }
        if(((UIButton*)[self viewWithTag:UPLOAD_PHOTO_BACK_BTN]).imageView.image == nil){
            [self showSimpleAlertView:@"请先拍摄身份证照片反面！"];
            return NO;
        }
        if (myType != TypeNet) {
            enterStr = ((UIButton*)[self viewWithTag:SELECT_PACKAGE_TYPE]).titleLabel.text;
            if(enterStr == nil || enterStr.length <=0 || [enterStr isEqualToString:@"套餐生效时间"]){
                [self showSimpleAlertView:@"请选择套餐生效时间!"];
                return NO;
            }
        }
    }
    if(myType !=TypePhone && myType != TypeParts)
    {
        enterStr = ((UITextField*)[self viewWithTag:ENTER_NAME]).text;
        if(enterStr == nil || enterStr.length <=0){
            [self showSimpleAlertView:@"请手动输入身份证名称！"];
            return NO;
        }
        enterStr = ((UITextField*)[self viewWithTag:ENTER_CER]).text;
        if(enterStr == nil || enterStr.length <=0){
            [self showSimpleAlertView:@"请手动输入身份证号码！"];
            return NO;
        }
    }
    if (myType != TypeNet)
    {
        enterStr = ((UITextField*)[self viewWithTag:ENTER_RECEIVER_NAME]).text;
        if(enterStr == nil || enterStr.length <=0){
            [self showSimpleAlertView:@"请输入收货人名称！"];
            return NO;
        }
    }
    
    enterStr = ((UITextField*)[self viewWithTag:ENTER_CONTRACT]).text;
    if(enterStr == nil || enterStr.length <=0){
        [self showSimpleAlertView:@"请输入联系方式！"];
        return NO;
    }
    enterStr = ((UIButton*)[self viewWithTag:SELECT_ADDR_AREA]).titleLabel.text;
    if(enterStr == nil || enterStr.length <=0 || [enterStr isEqualToString:@"请选择配送地区"]){
        [self showSimpleAlertView:@"请选择配送地区！"];
        return NO;
    }
    enterStr = ((UITextField*)[self viewWithTag:ENTER_ADDR_DETAIL]).text;
    if(enterStr == nil || enterStr.length <=0){
        [self showSimpleAlertView:@"请输入详细收货地址！"];
        return NO;
    }
    return YES;
}

-(void)commitRequestDataAction
{
    //step 1:数据chck
    if(![self checkEnterData]) return;
    //step 2:数据提交
    NSMutableDictionary* addrInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (myType != TypeNet)
    {
        [addrInfo setObject:((UITextField*)[self viewWithTag:ENTER_RECEIVER_NAME]).text forKey:@"name"];
    }
    [addrInfo setObject:((UITextField*)[self viewWithTag:ENTER_CONTRACT]).text forKey:@"phoneNum"];
    
    passParams* pass = [passParams sharePassParams];
    NSDictionary* city = [pass.params objectForKey:@"cityCode"];
    NSDictionary* country = [pass.params objectForKey:@"countryCode"];
    if (city == nil ||country == nil) {
        [self showSimpleAlertView:@"请先选择收货地址！"];
        return;
    }
    [addrInfo setObject:[city objectForKey:@"resAreaCode"]==nil?@"":[city objectForKey:@"resAreaCode"]forKey:@"cityId"];
//    [addrInfo setObject:[city objectForKey:@"areaCode"]==nil?@"":[city objectForKey:@"areaCode"]forKey:@"cityId"];
    [addrInfo setObject:[city objectForKey:@"areaName"] forKey:@"cityName"];
    [addrInfo setObject:[country objectForKey:@"areaCode"] forKey:@"countryId"];
    [addrInfo setObject:[country objectForKey:@"areaName"] forKey:@"countryName"];
    [addrInfo setObject:((UITextField*)[self viewWithTag:ENTER_ADDR_DETAIL]).text forKey:@"address"];
    [addrInfo setObject:@"com.ailk.app.mapp.model.req.CF0026Request$AddrInfo" forKey:@"@class"];
    
    NSMutableDictionary* allInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    [allInfo setObject:addrInfo forKey:@"addrInfo"];
    
    NSMutableDictionary* productInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSString* enterStr = ((UITextField*)[self viewWithTag:ENTER_RECEPE]).text;
    if(enterStr == nil){
        enterStr = @"";
    }
    [productInfo setObject:enterStr forKey:@"invoiceInfo"];
    
    if(myType ==TypeCard||myType==TypeContract||myType == TypeNet)
    {
        [productInfo setObject:((UITextField*)[self viewWithTag:ENTER_NAME]).text forKey:@"certName"];
        [productInfo setObject:((UITextField*)[self viewWithTag:ENTER_CER]).text forKey:@"certNum"];
    }
    if(myType ==TypeCard||myType==TypeContract)
    {
        enterStr = ((UIButton*)[self viewWithTag:SELECT_PACKAGE_TYPE]).titleLabel.text;
        if([enterStr isEqualToString:@"全月套餐"]||[enterStr isEqualToString:@"全月开通"]){
            [productInfo setObject:@"01" forKey:@"modeCode"];
        } else if([enterStr isEqualToString:@"半月套餐"]||[enterStr isEqualToString:@"半月开通"]){
            [productInfo setObject:@"02" forKey:@"modeCode"];
        } else if([enterStr isEqualToString:@"次月开通"]){
            [productInfo setObject:@"03" forKey:@"modeCode"];
        }
    }else{
        [productInfo setObject:@"" forKey:@"modeCode"];
    }
    [productInfo setObject:((UITextField*)[self viewWithTag:ENTER_MARK]).text == nil?@""
                          :((UITextField*)[self viewWithTag:ENTER_MARK]).text forKey:@"remark"];
    
    [allInfo setObject:productInfo forKey:@"productInfo"];
    
    if(self.target != nil && [self.target respondsToSelector:@selector(commitRequestData:)]){
        [self.target performSelector:@selector(commitRequestData:) withObject:allInfo];
    }
    
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

-(void)showCameraAction
{
    if(self.target != nil && [self.target respondsToSelector:@selector(showCamera)]){
        [self.target performSelector:@selector(showCamera) withObject:nil];
    }
}

-(void)selectAreaAction
{
    //requestAreaData
    [self hiddenAllKeyBoard];
    if(self.target != nil && [self.target respondsToSelector:@selector(requestAreaData)]){
        [self.target performSelector:@selector(requestAreaData) withObject:nil];
    }
}

-(void)selctSendMode{
    
    NSArray *arr = [NSArray arrayWithObjects:@"邮寄快递",@"上门配送", nil];
    
    [self.window  showPopWithButtonTitles:@[@"邮寄快递",@"上门配送"] styles:@[YUDefaultStyle,YUDefaultStyle,YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        
        if (index==0) {
            
            UIButton *btn = (UIButton*)[self viewWithTag:1020];
            [btn setTitle:@"邮寄快递" forState:UIControlStateNormal];
            
            
            
        }else if(index == 1){
            UIButton *btn = (UIButton*)[self viewWithTag:1020];
            [btn setTitle:@"上门配送" forState:UIControlStateNormal];
        }else{
            
        }
        
    }];

//    NSMutableArray* pkgData = [[NSMutableArray alloc] initWithCapacity:0];
////    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"邮寄快递",@"0",@"上门配送",@"1", nil];
//    
//    
//     NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0],@"ITEM_CODE",@"邮寄快递",@"ITEM_NAME", nil];
//    
//    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",1],@"ITEM_CODE",@"上门配送",@"ITEM_NAME", nil];
//    
//    
//    [pkgData addObject:dic];
//    [pkgData addObject:dic2];
//    ZSYCommonPickerView *pickerView = [[ZSYCommonPickerView alloc] initWithTitle:@"配送方式"
//                                                                      includeAll:NO
//                                                                      dataSource:pkgData
//                                                               selectedIndexPath:0
//                                                                        Firstrow:@"" cancelButtonBlock:^{
//                                                                            
//                                                                        } makeSureButtonBlock:^(NSInteger sindexPath) {
////                                                                            [((UIButton*)[self viewWithTag:1020]) setTitle:[self.pkgDataArray objectAtIndex:sindexPath] forState:UIControlStateNormal];
//                                                                        }];
//    [pickerView show];
    

    
    
    
    
    
}

#pragma mark -
#pragma mark hide keyboard
-(void)hiddenAllKeyBoard
{
    [self hiddenKeyBoard:[self viewWithTag:ENTER_NAME]];
    [self hiddenKeyBoard:[self viewWithTag:ENTER_CER]];
    [self hiddenKeyBoard:[self viewWithTag:ENTER_CONTRACT]];
    [self hiddenKeyBoard:[self viewWithTag:ENTER_ADDR_DETAIL]];
    [self hiddenKeyBoard:[self viewWithTag:ENTER_RECEPE]];
    [self hiddenKeyBoard:[self viewWithTag:ENTER_MARK]];
}

#pragma mark -
#pragma mark Recognizer
-(void) hiddenKeyBoard:(UIResponder*)txtFiled
{
    [UIView animateWithDuration:0.30f animations:^{
           self.scrollView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    
    [txtFiled resignFirstResponder];
}

#pragma mark
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == ENTER_RECEPE||textField.tag == ENTER_MARK)
    {
        
        [UIView animateWithDuration:0.30f animations:^{
            self.scrollView.transform = CGAffineTransformMakeTranslation(0,-230);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hiddenKeyBoard:textField];
}

-(BOOL)textFieldShouldReturn :(UITextField *) textField
{
    [self hiddenKeyBoard:textField];
    
    return YES;
}

- (void)updataPriceinfo:(NSString *)price
{
    self.payMoneyLab.text = [NSString stringWithFormat:@"%@元",price];
}
#pragma
#pragma viewController 调用方法
-(void)updateAreaData:(NSString*)area
{
    UIButton* areaBtn = (UIButton*)[self viewWithTag:SELECT_ADDR_AREA];
    [areaBtn setTitle:area forState:UIControlStateNormal];
}

-(void)initAreaData:(NSString*)area
{
    UIButton* areaBtn = (UIButton*)[self viewWithTag:SELECT_ADDR_AREA];
    [areaBtn setTitle:area forState:UIControlStateNormal];
    areaBtn.userInteractionEnabled = NO;
}

@end

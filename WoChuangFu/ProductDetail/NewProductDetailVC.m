//
//  NewProductDetailVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-28.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "NewProductDetailVC.h"
#import "FileHelpers.h"
#import "TitleBar.h"
#import "UIImage+LXX.h"
#import "CrossLineLable.h"
#import "MyHeader.h"
#import "InsetsLabel.h"
#import "ChoosePhoneNumVC.h"
#import "ChoosePackageVC.h"
#import "ProductEvaluationVC.h"
#import "CommitVC.h"
#import "MayYouLikeView.h"
#import "UrlParser.h"
#import "SIMPackageChooseVC.h"
#import "PackManager.h"
#import "ChooseAddressVC.h"
#import "NewChooseAddressVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSContent.h>
#import "ImageCheckVC.h"

#define SCROLL_CONTENT_VIEW_TAG      2000
#define PRODUCT_DETAIL_IMAGEVIEW_TAG 2001
#define SUBMIT_ORDER_BTN_TAG         2002
#define DISCOUNT_PRICE_TAG           2003
#define SAIL_PRICE_TAG               2004
#define INVENTORY_IMG_TAG            2005
#define TABLE_VIEW_TAG               2006
#define PRODUCT_IMAGE_HEIGHT         200    //商品图片高度
#define PRICE_CONTENTVIEW_HEIGHT     56     //价格标签容器视图高度
#define BTN_CONTENTVIEW_HEIGHT       50     //按钮容器高度

typedef enum{
    PropetryOrOptionColor             = 2007,//颜色
    PropetryOrOptionMemory            = 2008,//内存
    PropetryOrOptionContract          = 2009,//合约
    PropetryOrOptionPhoneNumber       = 2010,//号码
    PropetryOrOptionAccidentInsurance = 2011,//意外保
    PropetryOrOptionEvaluation        = 2012,//商品评价
    PropetryOrOptionMayYouLike        = 2013,//猜你喜欢
    PropetryOrOptionPullForMore       = 2014,//图文详情
    PropetryOrOptionSIM               = 2015,//卡包套餐
    PropetryOrOptionBroadband         = 2016,//宽带地址和套餐
    PropetryOrOptionsWebView         = 2017 // 商品详情图文
}PropetryOrOptions;

typedef enum{
    AnimationDirectionTop = 1,
    AnimationDirectionBottom
}AnimationDirection;

typedef enum{
    ProductDetailTypeContract    = 1001, //合约机
    ProductDetailTypeCardPackage = 1002, //卡包
    ProductDetailTypeBroadband   = 1011, //宽带
    ProductDetailTypePhone       = 1004, //手机
    ProductDetailTypeAccessory   = 1005  //配件
}ProductDetailType;

@interface NewProductDetailVC ()<TitleBarDelegate,HttpBackDelegate,UITableViewDataSource,UITableViewDelegate,MyHeaderDelegate,MayYouLikeViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>
{
    float offset_Y;//滚动视图高度
    float lastpropetryLocation;//最后一个属性的位置
    float giftsHeight;
    BOOL  ifNeedCheckColor;
    BOOL  ifNeedCheckMemory;
    BOOL  ifNeedCheckContract;
    BOOL  ifNeedCheckPhoneNumber;
    BOOL  ifAlreadyHavaWebView;
    float ginsengPremium;
    BOOL  joinWoYibao;
}
@property(nonatomic,copy)   NSString             *skuId;
@property(nonatomic,copy)   NSString             *moduleId;          //商品moduleId
@property(nonatomic,strong) NSDictionary         *productDetailDict; //商品详情数据字典
@property(nonatomic,strong) NSMutableDictionary  *httpRequestDict;   //网络请求报文字典
@property(nonatomic,strong) NSMutableDictionary  *sectionDict;       //所有标题行的字典
@property(nonatomic,strong) NSMutableArray       *skuList;
@property(nonatomic,strong) NSMutableArray       *selectedPropetryList;//选中的属性列表

@property(nonatomic,strong) NSDictionary         *productInfo;         //单品信息
@property(nonatomic,strong) NSDictionary         *phoneNumberInfoDict; //号码信息
@property(nonatomic,strong) NSDictionary         *packageInfoDict;     //套餐信息
@property(nonatomic,strong) NSDictionary         *broadbandInfoDict;   //宽带信息
@property(nonatomic,strong) NSDictionary         *SIMPackageInfoDict;  //SIM套餐信息
@property(nonatomic,strong) NSMutableDictionary  *commitOrderDict;     //订单参数信息

@property(nonatomic,weak)   UIButton             *selectedColorBtn;  //选中的颜色按钮
@property(nonatomic,weak)   UIButton             *selectedMemoryBtn; //选中的内存按钮

//购手机
@property(nonatomic,strong) UIButton             *onlyPhoneBtn;
@property(nonatomic,strong) UIButton             *contractBtn;

@property(nonatomic,strong) NSArray              *imgUrls;

@end

@implementation NewProductDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sendHttpRequest];
    ifNeedCheckColor = NO;
    ifNeedCheckMemory = NO;
    ifNeedCheckContract = NO;
    ifNeedCheckPhoneNumber = NO;
    joinWoYibao = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)commitOrderDict
{
    if (nil == _commitOrderDict) {
        _commitOrderDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _commitOrderDict;
}
- (NSMutableDictionary *)sectionDict
{
    if (nil == _sectionDict) {
        _sectionDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _sectionDict;
}

- (NSMutableArray *)selectedPropetryList
{
    if(nil == _selectedPropetryList){
        _selectedPropetryList = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedPropetryList;
}

#pragma mark
#pragma mark - 发送网络请求
- (void)sendHttpRequest
{
    bussineDataService *buss = [bussineDataService sharedDataService];
    buss.target = self;
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjectsAndKeys:self.params,@"params",nil];
      NSLog(@"id是这些%@",self.params[@"developId"]);
    self.httpRequestDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            paramsDict,@"expand",
                            self.params[@"productId"],@"id",
                            self.params[@"developId"],@"developerId",
                            nil];
    [buss getProductDetail:self.httpRequestDict];
  
}

#pragma mark
#pragma mark - 初始化视图
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor blackColor];
    self.view = view;
    [self layoutSubV];
}

- (void)layoutSubV
{
    [self initTitleBar];
    [self initMainContView];
    [self initBuyBtn];
}

#pragma mark 暂无商品详情
- (void)initNoProductImageView
{
    UIScrollView *scrollview = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    UIImage *image = [UIImage imageNamed:@"has_no_content"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = CGPointMake(scrollview.center.x,scrollview.frame.size.height/2);
    [scrollview addSubview:imageView];
}
#pragma mark 导航栏
- (void)initTitleBar
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:middle_position];
    titleBar.frame = CGRectMake(0, [[UIScreen mainScreen] applicationFrame].origin.y, [AppDelegate sharePhoneWidth],TITLE_BAR_HEIGHT);
    titleBar.title = @"商品详情";
    titleBar.target = self;
    [self.view addSubview:titleBar];
}

#pragma mark 主容器
- (void)initMainContView
{
    float scrollViewOrginY = [[UIScreen mainScreen] applicationFrame].origin.y+TITLE_BAR_HEIGHT;
    float scrollViewHeight = [AppDelegate sharePhoneHeight] - scrollViewOrginY-BTN_CONTENTVIEW_HEIGHT;
    //滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                              scrollViewOrginY,
                                                                              [AppDelegate sharePhoneWidth],
                                                                              scrollViewHeight)];
    scrollView.delegate = self;
    scrollView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    scrollView.tag = SCROLL_CONTENT_VIEW_TAG;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}

#pragma mark 购买按钮
-(void)initBuyBtn
{
    //按钮界面
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, [AppDelegate sharePhoneHeight] - BTN_CONTENTVIEW_HEIGHT, [AppDelegate sharePhoneWidth],BTN_CONTENTVIEW_HEIGHT)];
    btnView.backgroundColor = [UIColor whiteColor];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"一键分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(7, 8,104, 33);
    [shareBtn setBackgroundImage:[UIImage resizedImage:@"bnt_content_second_n"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:shareBtn];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(118, 8, 195, 33);
    [submitBtn setBackgroundImage:[UIImage resizedImage:@"bnt_content_primary_n"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tag = SUBMIT_ORDER_BTN_TAG;
    [btnView addSubview:submitBtn];
    [self.view addSubview:btnView];
    
}

#pragma mark  商品图片
- (void)initProductDetailImagesWithArray:(NSArray *)imgUrls
{
    self.imgUrls = imgUrls;
    float imageViewWidth = [AppDelegate sharePhoneWidth];
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    UIScrollView *imgScroll = [[UIScrollView alloc] init];
    imgScroll.pagingEnabled = YES;
    imgScroll.frame = (CGRect){CGPointZero,{imageViewWidth,PRODUCT_IMAGE_HEIGHT}};
    imgScroll.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:imgScroll];
    
    for (int i = 0;i<imgUrls.count;i++) {
        NSString *imageUrl = imgUrls[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = (CGRect){{i*imageViewWidth,0},{imageViewWidth,PRODUCT_IMAGE_HEIGHT}};
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(tap:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        [imgScroll addSubview:imageView];
        if (hasCachedImage([NSURL URLWithString:imageUrl])){
            UIImage *image = [UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:imageUrl])];
            [imageView setImage:image];
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:imageUrl,@"url",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *image)
             {
                 
                 [imageView setImage:image];
             }];
        }
    }
    [imgScroll setContentSize:CGSizeMake(imageViewWidth*imgUrls.count,PRODUCT_IMAGE_HEIGHT)];
    offset_Y +=PRODUCT_IMAGE_HEIGHT;
}

#pragma mark 商品描述
- (void)initProductDescriptionWithDesc:(NSString *)desc
{
    float descWidth = 310;
    float margin = 5;
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    CGRect descRect = [desc boundingRectWithSize:CGSizeMake(descWidth, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                         context:nil];
    UILabel *descLabel = [[UILabel alloc] init];
    [mainView addSubview:descLabel];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.frame = (CGRect){{margin,margin+offset_Y},{descWidth,descRect.size.height}};
    [descLabel setFont:[UIFont systemFontOfSize:15]];
    descLabel.textColor = [ComponentsFactory createColorByHex:@"#000000"];
    descLabel.text = desc;
    [descLabel setNumberOfLines:0];
    offset_Y += margin*2+descRect.size.height;
    
    [self initPriceAndShareView];
}
#pragma mark 价格与分享
- (void)initPriceAndShareView
{
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    //价格信息视图
    UIView *priceShowView = [[UIView alloc] initWithFrame:CGRectMake(0,offset_Y,[AppDelegate sharePhoneWidth],PRICE_CONTENTVIEW_HEIGHT)];
    priceShowView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:priceShowView];
    
    //现价
    UILabel *discountPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,200, 20)];
    discountPrice.tag = DISCOUNT_PRICE_TAG;
    discountPrice.font = [UIFont systemFontOfSize:20.0f];
    discountPrice.textColor = [ComponentsFactory createColorByHex:@"#d73902"];
    [priceShowView addSubview:discountPrice];
    
    //原价
    CrossLineLable *sailPriceLable = [[CrossLineLable alloc] initWithFrame:CGRectMake(10, 30, 180,20)];
    sailPriceLable.font = [UIFont systemFontOfSize:14.0f];
    sailPriceLable.tag = SAIL_PRICE_TAG;
    sailPriceLable.textColor = [ComponentsFactory createColorByHex:@"#999999"];
    [priceShowView addSubview:sailPriceLable];
    
    //是否有货
    UIImageView *ifHaveView = [[UIImageView alloc] initWithFrame:CGRectMake(priceShowView.frame.size.width-37,(priceShowView.frame.size.height-13)/2, 27, 13)];
    ifHaveView.tag = INVENTORY_IMG_TAG;
    ifHaveView.image = [UIImage imageNamed:@"lable_content_sku_y"];
    [priceShowView addSubview:ifHaveView];
    
    offset_Y += PRICE_CONTENTVIEW_HEIGHT;
}

#pragma mark 赠品视图
- (void)initTableViewWithGifts:(NSArray *)gifts;
{
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    float tableViewH = 35+gifts.count*44;
    giftsHeight = gifts.count*44;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,offset_Y+10,[AppDelegate sharePhoneWidth],tableViewH) style:UITableViewStylePlain];
    [mainView addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.scrollEnabled = NO;
    tableView.tag = TABLE_VIEW_TAG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    offset_Y += tableViewH+10;
}

#pragma mark 上拉查看更多

- (void)initPullForMoreView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,offset_Y+10,[AppDelegate sharePhoneWidth],44)];
    view.tag = PropetryOrOptionPullForMore;
    view.backgroundColor = [UIColor whiteColor];
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    [mainView addSubview:view];
    
    UILabel *title = [[UILabel alloc] initWithFrame:view.bounds];
    [title setFont:[UIFont systemFontOfSize:14.0f]];
#ifdef __IPHONE_6_0
    [title setTextAlignment:NSTextAlignmentCenter];
#else
    [title setTextAlignment:NSTextAlignmentCenter];
#endif
    [title setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
    title.text = @"上拉查看图文详情";
    [view addSubview:title];
    offset_Y += 64;
    [mainView setContentSize:CGSizeMake(0,offset_Y)];
}


#pragma mark 意外保
- (void)initAccidentInsuranceView
{
    UIView *insuranceView = [self.view viewWithTag:PropetryOrOptionAccidentInsurance];
    if (nil == insuranceView){
        UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
        UIView *evaluateView = [self.view viewWithTag:PropetryOrOptionEvaluation];
        insuranceView = [[UIView alloc] init];
        insuranceView.tag = PropetryOrOptionAccidentInsurance;
        insuranceView.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:insuranceView];
        if (evaluateView == nil) {
            insuranceView.frame = CGRectMake(0,offset_Y+10,[AppDelegate sharePhoneWidth],44);
        }else{
            MyHeader *header = self.sectionDict[@(0)];
            if (header!= nil && header.isOpen == NO) {
                insuranceView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
            }
            UIView *mayYoulikeView = [self.view viewWithTag:PropetryOrOptionMayYouLike];
            UIView *pullForMoreView = [self.view viewWithTag:PropetryOrOptionPullForMore];
            insuranceView.frame = evaluateView.frame;
            if (mayYoulikeView == nil) {
                evaluateView.frame = pullForMoreView.frame;
                pullForMoreView.frame = CGRectMake(0,evaluateView.frame.origin.y+54,[AppDelegate sharePhoneWidth],44);
            }else{
                evaluateView.frame = CGRectMake(0,mayYoulikeView.frame.origin.y,[AppDelegate sharePhoneWidth],44);
                mayYoulikeView.frame = CGRectMake(0,evaluateView.frame.origin.y+54,[AppDelegate sharePhoneWidth],135);
                pullForMoreView.frame = CGRectMake(0,mayYoulikeView.frame.origin.y+145,[AppDelegate sharePhoneWidth],44);
            }
            UIView *webView = [self.view viewWithTag:PropetryOrOptionsWebView];
            webView.frame = CGRectMake(0,pullForMoreView.frame.origin.y+54,[AppDelegate sharePhoneWidth],webView.frame.size.height);
        }
        
        InsetsLabel *title = [[InsetsLabel alloc] initWithFrame:insuranceView.bounds andInsets:UIEdgeInsetsMake(0,15,0,0)];
        title.backgroundColor = [UIColor clearColor];
        [title setFont:[UIFont boldSystemFontOfSize:14]];
        title.text = @"参加意外保险";
        [insuranceView addSubview:title];
        
        UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(105,0,100,44)];
        priceLable.backgroundColor = [UIColor clearColor];
        priceLable.textColor = [ComponentsFactory createColorByHex:@"#0066cc"];
        priceLable.font = [UIFont systemFontOfSize:13];
        priceLable.text = [NSString stringWithFormat:@"服务费%@元\\年",self.productInfo[@"ginsengPremium"]];
        [insuranceView addSubview:priceLable];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake([AppDelegate sharePhoneWidth]-90,9,76, 25);
        [button setImage:[UIImage imageNamed:@"btn_content_ywb_p"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_content_ywb_n"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(insurancebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.adjustsImageWhenHighlighted = NO;
        [insuranceView addSubview:button];
        
        offset_Y += 54;
        mainView.contentSize = CGSizeMake(0,offset_Y);
    }
}

#pragma mark 移除意外保险
- (void)removeAccidentInsuranceView
{
    UIView *insuranceView = [self.view viewWithTag:PropetryOrOptionAccidentInsurance];
    if (insuranceView != nil) {
        float insuranceViewH = insuranceView.frame.size.height;
        [insuranceView removeFromSuperview];
        
        UIView *evaluateView = [self.view viewWithTag:PropetryOrOptionEvaluation];
        CGRect evaluateFrame = evaluateView.frame;
        evaluateFrame.origin.y -= insuranceViewH;
        evaluateView.frame = evaluateFrame;
        
        UIView *mayYoulikeView = [self.view viewWithTag:PropetryOrOptionMayYouLike];
        CGRect mayYoulikeFrame = mayYoulikeView.frame;
        mayYoulikeFrame.origin.y -= insuranceViewH;
        mayYoulikeView.frame = mayYoulikeFrame;
        
        UIView *pullForMoreView = [self.view viewWithTag:PropetryOrOptionPullForMore];
        CGRect pullForMoreFrame = pullForMoreView.frame;
        pullForMoreFrame.origin.y -= insuranceViewH;
        pullForMoreView.frame = pullForMoreFrame;
        
        UIView *webView = [self.view viewWithTag:PropetryOrOptionsWebView];
        webView.frame = CGRectMake(0,pullForMoreView.frame.origin.y+54,[AppDelegate sharePhoneWidth],webView.frame.size.height);
        
        UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
        offset_Y -=insuranceViewH;
        mainView.contentSize = CGSizeMake(0, offset_Y);
        ifNeedCheckPhoneNumber = NO;
        
    }
}

#pragma mark 猜你喜欢
- (void)initMayYouLikeView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,offset_Y+10,[AppDelegate sharePhoneWidth],135)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = PropetryOrOptionMayYouLike;
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    [mainView addSubview:view];
    
    InsetsLabel *title = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,0,view.frame.size.width,35) andInsets:UIEdgeInsetsMake(0,15,0,0)];
    title.backgroundColor = [UIColor clearColor];
    title.layer.borderWidth = 1;
    title.layer.borderColor = [[ComponentsFactory createColorByHex:@"#eeeeee"] CGColor];
    [title setFont:[UIFont boldSystemFontOfSize:14]];
    title.text = @"猜你喜欢";
    [view addSubview:title];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(15,35,view.frame.size.width-30,100)];
    scroll.backgroundColor = [UIColor clearColor];
    [view addSubview:scroll];
    NSArray *mayYouLikeData = self.productDetailDict[@"productDetail"][@"maybeYourLiker"];
    for (int i = 0; i < mayYouLikeData.count; i++)
    {
        MayYouLikeView *mayYouLikeView = [[MayYouLikeView alloc] initWithFrame:CGRectMake(0+100*i,0,100,100)];
        mayYouLikeView.delegate = self;
        mayYouLikeView.dataDict = mayYouLikeData[i];
        [scroll addSubview:mayYouLikeView];
    }
    scroll.contentSize = CGSizeMake(mayYouLikeData.count*100,0);
    offset_Y += 145;
    mainView.contentSize = CGSizeMake(0,offset_Y);
}

#pragma mark 评论视图
- (void)initEvaluateView
{
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    UIView *evaluateView = [[UIView alloc] initWithFrame:CGRectMake(0,offset_Y+10,[AppDelegate sharePhoneWidth],44)];
    evaluateView.tag = PropetryOrOptionEvaluation;
    evaluateView.layer.borderWidth = 1;
    evaluateView.layer.borderColor = [[ComponentsFactory createColorByHex:@"#eeeeee"]CGColor];
    evaluateView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:evaluateView];
    
    InsetsLabel *title = [[InsetsLabel alloc] initWithFrame:evaluateView.bounds andInsets:UIEdgeInsetsMake(0,15,0,0)];
    title.backgroundColor = [UIColor clearColor];
    [title setFont:[UIFont boldSystemFontOfSize:14]];
    title.text = @"商品评价";
    [evaluateView addSubview:title];
    
    InsetsLabel *evaluatelabel = [[InsetsLabel alloc] initWithFrame:evaluateView.bounds andInsets:UIEdgeInsetsMake(0,0,0,10)];
#ifdef __IPHONE_6_0
    [evaluatelabel setTextAlignment:NSTextAlignmentRight];
#else
    [evaluatelabel setTextAlignment:NSTextAlignmentRight];
#endif
    evaluatelabel.backgroundColor = [UIColor clearColor];
    evaluatelabel.font = [UIFont systemFontOfSize:12.0f];
    [evaluateView addSubview:evaluatelabel];
    
    NSDictionary *evaluateDict = self.productDetailDict[@"productDetail"][@"evaluateResult"];
    int evaluateCount = [evaluateDict[@"evaluateCount"] intValue];
    int evaluateNiceCount = [evaluateDict[@"evaluateNiceCount"] intValue];
    NSString *evaluateInfo = nil;
    if (evaluateCount == 0) {
        evaluateInfo = @"共0人评价,好评率0%";
    }else{
        evaluateInfo = [NSString stringWithFormat:@"共%d人评价,好评率%.2f%%",evaluateCount,(float)evaluateNiceCount/evaluateCount*100];
    }
    evaluatelabel.text = evaluateInfo;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = evaluateView.bounds;
    [btn addTarget:self action:@selector(evaluateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [evaluateView addSubview:btn];
    
    
    offset_Y += 54;
    [mainView setContentSize:CGSizeMake(0,offset_Y)];
}
#pragma mark 属性视图
- (void)initViewWithPropetryDict:(NSDictionary *)propertyDict
{
    PropetryOrOptions propetryOrOption;
    
    if ([propertyDict[@"propertyName"] isEqualToString:@"颜色"]) {
        propetryOrOption = PropetryOrOptionColor;
    }else if ([propertyDict[@"propertyName"] isEqualToString:@"内存"]) {
        propetryOrOption = PropetryOrOptionMemory;
    }
    [self initViewWithPropetryDict:propertyDict withPropetryOrOptions:propetryOrOption];
}

- (void)initViewWithPropetryDict:(NSDictionary *)propertyDict withPropetryOrOptions:(PropetryOrOptions)propetryOrOption
{
    if(ifNeedCheckPhoneNumber) return;
    UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    UIView *view = [[UIView alloc] init];
    if([self.moduleId intValue] == ProductDetailTypePhone &&propetryOrOption == PropetryOrOptionPhoneNumber){
        MyHeader *header = self.sectionDict[@(0)];
        if (header!= nil && header.isOpen == NO) {
            view.frame = CGRectMake(0,lastpropetryLocation,[AppDelegate sharePhoneWidth],100);
            view.transform = CGAffineTransformMakeTranslation(0,-giftsHeight);
        }else{
            view.frame = CGRectMake(0,lastpropetryLocation,[AppDelegate sharePhoneWidth],100);
        }
    }else{
        view.frame = CGRectMake(0,offset_Y,[AppDelegate sharePhoneWidth],100);
    }
    view.tag = propetryOrOption;
    view.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:view];
    
    InsetsLabel *propetryAndOptions = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,0,view.frame.size.width,35) andInsets:UIEdgeInsetsMake(0,15,0,0)];
    propetryAndOptions.layer.borderWidth = 1;
    propetryAndOptions.layer.borderColor = [[ComponentsFactory createColorByHex:@"#eeeeee"]CGColor];
    [propetryAndOptions setFont:[UIFont boldSystemFontOfSize:14]];
    [view addSubview:propetryAndOptions];
    
    propetryAndOptions.text = propertyDict[@"propertyName"];
    
    SEL sel = NULL;
    switch (propetryOrOption) {
        case PropetryOrOptionColor:
        {
            ifNeedCheckColor = YES;
            sel = @selector(colorBtnClicked:);
        }
            break;
        case PropetryOrOptionMemory:
        {
            ifNeedCheckMemory = YES;
            sel = @selector(memoryBtnClicked:);
        }
            break;
        case PropetryOrOptionContract:
        {
            ifNeedCheckContract = YES;
            if ([self.moduleId intValue] == ProductDetailTypePhone) {
                sel = @selector(phoneBuyTypeChoose:);
            }else{
                sel = @selector(chooseContract:);
            }
        }
            break;
        case PropetryOrOptionPhoneNumber:
        {
            ifNeedCheckPhoneNumber = YES;
            sel = @selector(choosePhoneNumber:);
        }
            break;
        case PropetryOrOptionSIM:
        {
            sel = @selector(chooseSIMPackage:);
        }
            break;
        case PropetryOrOptionBroadband:
        {
            sel = @selector(chooseAreaAndPackage:);
        }
            break;
        default:
            break;
    }
    float ViewHeight = 0;
    if (propetryOrOption == PropetryOrOptionColor || propetryOrOption == PropetryOrOptionMemory) {
        if (propertyDict[@"propertyValueList"]!= [NSNull null]) {
            NSArray *propertyValueList = propertyDict[@"propertyValueList"];
            ViewHeight = 35 + [propertyValueList count]/4*43+10;
            for (int i = 0;i<[propertyValueList count];i++) {
                NSDictionary *propetry = propertyValueList[i];
                UIButton *btn = [self createPropetrtButton];
                [btn setTitle:propetry[@"propertyValue"] forState:UIControlStateNormal];
                btn.frame = CGRectMake(20+i%4*70,45+i/4*43,60,33);
                //tag存储属性ID
                btn.tag = [propetry[@"propertyValueId"] intValue];
                if ([propertyValueList count] == 1) {
                    btn.selected = YES;
                    btn.userInteractionEnabled = NO;
                    if (propetryOrOption == PropetryOrOptionColor) {
                        self.selectedColorBtn = btn;
                    }else if (propetryOrOption == PropetryOrOptionMemory){
                        self.selectedMemoryBtn = btn;
                    }
                    [self.selectedPropetryList addObject:propetry[@"propertyValueId"]];
                }
                [btn addTarget:self action:sel forControlEvents:UIControlEventTouchDown];
                [view addSubview:btn];
            }
        }
    }else if (propetryOrOption == PropetryOrOptionContract || propetryOrOption == PropetryOrOptionPhoneNumber) {
        if ([self.moduleId intValue] == ProductDetailTypePhone &&propetryOrOption == PropetryOrOptionContract) {
            UIButton *btn1 = [self createPropetrtButton];
            [btn1 setTitle:@"裸机" forState:UIControlStateNormal];
            [btn1 addTarget:self action:sel forControlEvents:UIControlEventTouchDown];
            btn1.frame = CGRectMake(20,45,70,33);
            btn1.selected = YES;
            [view addSubview:btn1];
            self.onlyPhoneBtn = btn1;
            UIButton *btn2 = [self createPropetrtButton];
            [btn2 setTitle:@"合约机" forState:UIControlStateNormal];
            [btn2 addTarget:self action:sel forControlEvents:UIControlEventTouchDown];
            btn2.frame = CGRectMake(100,45,70,33);
            [view addSubview:btn2];
            self.contractBtn = btn2;
        }else{
            NSString *valueName = propertyDict[@"propertyValue"];
            UIButton *btn = [self createPropetrtButton];
            [btn setTitle:valueName forState:UIControlStateNormal];
            [btn addTarget:self action:sel forControlEvents:UIControlEventTouchDown];
            btn.frame = CGRectMake(20,45,120,33);
            [view addSubview:btn];
        }
    }else if (propetryOrOption == PropetryOrOptionSIM){
        
        NSDictionary *simDetail = self.productDetailDict[@"simDetail"];
        if (simDetail[@"bsuiPkg"] != [NSNull null]) {
            NSDictionary *bsuiPkg = simDetail[@"bsuiPkg"];
            if (bsuiPkg[@"packageType"] != [NSNull null]) {
                NSArray *packageType = bsuiPkg[@"packageType"];
                UIButton *btn = [self createPropetrtButton];
                [btn addTarget:self action:sel forControlEvents:UIControlEventTouchDown];
                [view addSubview:btn];
                NSString *valueName = nil;
                if ([packageType count] ==1) {
                    [PackManager shareInstance].packageModes = [[packageType firstObject] objectForKey:@"packageModes"];
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    valueName = [NSString stringWithFormat:@"%@,%@,%@,%@",packageType[0][@"packageName"],packageType[0][@"packageInlandVoice"],packageType[0][@"packageInlandFlow"],packageType[0][@"packageInlandMessage"]];
                    CGRect rect = [valueName boundingRectWithSize:CGSizeMake(MAXFLOAT,33) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];
                    self.SIMPackageInfoDict = [packageType firstObject];
                    btn.frame = CGRectMake(20,45,rect.size.width+20,33);
                    btn.selected = YES;
                    btn.userInteractionEnabled = NO;
                }else{
                    valueName = propertyDict[@"propertyValue"];
                    btn.frame = CGRectMake(20,45,120,33);
                }
                [btn setTitle:valueName forState:UIControlStateNormal];
            }
        }
    }else if (propetryOrOption == PropetryOrOptionBroadband){
        NSString *valueName = propertyDict[@"propertyValue"];
        UIButton *btn = [self createPropetrtButton];
        [btn setTitle:valueName forState:UIControlStateNormal];
        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchDown];
        btn.frame = CGRectMake(20,45,140,33);
        [view addSubview:btn];
    }
    
    if (ViewHeight < 90) {
        ViewHeight = 90;
    }
    if([self.moduleId intValue] == ProductDetailTypePhone &&propetryOrOption == PropetryOrOptionPhoneNumber){
        MyHeader *header = self.sectionDict[@(0)];
        if (header!= nil && header.isOpen == NO) {
            view.frame = CGRectMake(0,lastpropetryLocation-giftsHeight,[AppDelegate sharePhoneWidth],ViewHeight);
        }else{
            view.frame = CGRectMake(0,lastpropetryLocation,[AppDelegate sharePhoneWidth],ViewHeight);
        }
        UIView *insuranceView = [self.view viewWithTag:PropetryOrOptionAccidentInsurance];
        UIView *evaluateView = [self.view viewWithTag:PropetryOrOptionEvaluation];
        UIView *mayYoulikeView = [self.view viewWithTag:PropetryOrOptionMayYouLike];
        UIView *pullForMoreView = [self.view viewWithTag:PropetryOrOptionPullForMore];
        if(insuranceView != nil){
            insuranceView.frame = CGRectMake(0,view.frame.origin.y+ViewHeight+10,[AppDelegate sharePhoneWidth],44);
            evaluateView.frame = CGRectMake(0,insuranceView.frame.origin.y+54,[AppDelegate sharePhoneWidth],44);
            if (mayYoulikeView != nil) {
                mayYoulikeView.frame = CGRectMake(0,evaluateView.frame.origin.y+54,[AppDelegate sharePhoneWidth],mayYoulikeView.frame.size.height);
                pullForMoreView.frame = CGRectMake(0,mayYoulikeView.frame.origin.y+mayYoulikeView.frame.size.height+10,[AppDelegate sharePhoneWidth],44);
                UIView *webView = [self.view viewWithTag:PropetryOrOptionsWebView];
                webView.frame = CGRectMake(0,pullForMoreView.frame.origin.y+54,[AppDelegate sharePhoneWidth],webView.frame.size.height);
            }else{
                pullForMoreView.frame = CGRectMake(0,evaluateView.frame.origin.y+54,[AppDelegate sharePhoneWidth],44);
                UIView *webView = [self.view viewWithTag:PropetryOrOptionsWebView];
                webView.frame = CGRectMake(0,pullForMoreView.frame.origin.y+54,[AppDelegate sharePhoneWidth],webView.frame.size.height);
            }
        }else{
            evaluateView.frame = CGRectMake(0,view.frame.origin.y+ViewHeight+10,[AppDelegate sharePhoneWidth],44);
            if (mayYoulikeView != nil) {
                mayYoulikeView.frame = CGRectMake(0,evaluateView.frame.origin.y+54,[AppDelegate sharePhoneWidth],mayYoulikeView.frame.size.height);
                pullForMoreView.frame = CGRectMake(0,mayYoulikeView.frame.origin.y+mayYoulikeView.frame.size.height+10,[AppDelegate sharePhoneWidth],44);
                UIView *webView = [self.view viewWithTag:PropetryOrOptionsWebView];
                webView.frame = CGRectMake(0,pullForMoreView.frame.origin.y+54,[AppDelegate sharePhoneWidth],webView.frame.size.height);
            }else{
                pullForMoreView.frame = CGRectMake(0,evaluateView.frame.origin.y+54,[AppDelegate sharePhoneWidth],44);
                UIView *webView = [self.view viewWithTag:PropetryOrOptionsWebView];
                webView.frame = CGRectMake(0,pullForMoreView.frame.origin.y+54,[AppDelegate sharePhoneWidth],webView.frame.size.height);
            }
        }
    }else{
        view.frame = CGRectMake(0,offset_Y,[AppDelegate sharePhoneWidth],ViewHeight);
    }
    
    offset_Y += ViewHeight;
    if([propertyDict[@"propertyName"] isEqualToString:@"方式"]){
        lastpropetryLocation = offset_Y;
    }
    
    [mainView setContentSize:CGSizeMake(0,offset_Y)];
}

#pragma mark  移除号码模块
- (void)removePhoneNumberModule
{
    UIView *phoneNumberView = [self.view viewWithTag:PropetryOrOptionPhoneNumber];
    if (phoneNumberView != nil) {
        float postionY = phoneNumberView.frame.size.height;
        [phoneNumberView removeFromSuperview];
        UIView *insuranceView = [self.view viewWithTag:PropetryOrOptionAccidentInsurance];
        CGRect insuranceFrame = insuranceView.frame;
        insuranceFrame.origin.y -= postionY;
        insuranceView.frame = insuranceFrame;
        
        UIView *evaluateView = [self.view viewWithTag:PropetryOrOptionEvaluation];
        CGRect evaluateFrame = evaluateView.frame;
        evaluateFrame.origin.y -= postionY;
        evaluateView.frame = evaluateFrame;
        
        UIView *mayYoulikeView = [self.view viewWithTag:PropetryOrOptionMayYouLike];
        
        CGRect mayYoulikeFrame = mayYoulikeView.frame;
        mayYoulikeFrame.origin.y -= postionY;
        mayYoulikeView.frame = mayYoulikeFrame;
        
        UIView *pullForMoreView = [self.view viewWithTag:PropetryOrOptionPullForMore];
        CGRect pullForMoreFrame = pullForMoreView.frame;
        pullForMoreFrame.origin.y -= postionY;
        pullForMoreView.frame = pullForMoreFrame;
        UIView *webView = [self.view viewWithTag:PropetryOrOptionsWebView];
        
        webView.frame = CGRectMake(0,pullForMoreView.frame.origin.y+54,[AppDelegate sharePhoneWidth],webView.frame.size.height);
        UIScrollView *mainView = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
        offset_Y -=postionY;
        mainView.contentSize = CGSizeMake(0, offset_Y);
        ifNeedCheckPhoneNumber = NO;
    }
}
#pragma mark  确认商品
//根据属性筛选商品
- (NSMutableArray *)SelectProductsByPropetrys:(NSArray *)propetrys
{
    NSMutableArray *mySkuList = [NSMutableArray arrayWithArray:self.skuList];
    NSMutableArray *selectedProducts = [NSMutableArray array];
    //遍历属性
    for (int a= 0;a <propetrys.count;a++)
    {
        NSString *propetry = propetrys[a];
        //遍历所有单品
        for(int i = 0;i <mySkuList.count;i++)
        {
            NSDictionary *product = mySkuList[i];
            //获得单品属性列表
            NSArray *propertyList = product[@"propertyList"];
            //遍历所有属性
            for(int b = 0;b < propertyList.count;b++)
            {
                NSDictionary *propertyDict = propertyList[b];
                //如果属性匹配
                if ([propetry isEqualToString:propertyDict[@"propertyId"]])
                {
                    [selectedProducts addObject:product];
                    break;
                }
            }
        }
        [mySkuList removeAllObjects];
        [mySkuList addObjectsFromArray:selectedProducts];
        [selectedProducts removeAllObjects];
    }
    return mySkuList;
}
//每次选择属性都调用
- (void)makeSureProductByPropetrys
{
    NSArray *productArray = [self SelectProductsByPropetrys:self.selectedPropetryList];
    if ([productArray count] == 1) {
        self.productInfo = [productArray firstObject];
        self.skuId = self.productInfo[@"skuId"];
        [self reViewProductInfo];
    }
}
//skuList Count为1时调用
- (void)makeSureProduct
{
    //step1.取出商品
    NSDictionary *product = [self.skuList firstObject];
    self.productInfo = product;
    //step2.确认SkuId
    self.skuId = product[@"skuId"];
    [self reViewProductInfo];
}
#pragma mark - 刷新商品信息
- (void)reViewProductInfo
{
    //.刷新价格与库存
    UILabel *discountPrice = (UILabel *)[self.view viewWithTag:DISCOUNT_PRICE_TAG];
    UILabel *sailPrice = (UILabel *)[self.view viewWithTag:SAIL_PRICE_TAG];
    UIImageView *ifHaveView = (UIImageView *)[self.view viewWithTag:INVENTORY_IMG_TAG];
    int inventory = [self.productInfo[@"inventory"] intValue];
    if (inventory > 10) {
        ifHaveView.image = [UIImage imageNamed:@"lable_content_sku_y"];
    }else if(inventory <= 10 && inventory > 0){
        ifHaveView.image = [UIImage imageNamed:@"lable_content_sku_s"];
    }else if(inventory <= 0){
        ifHaveView.image = [UIImage imageNamed:@"lable_content_sku_w"];
        [self ShowProgressHUDwithMessage:@"该商品已售罄！"];
    }
    discountPrice.text = [NSString stringWithFormat:@"折扣价:¥%@元",self.productInfo[@"discountPrice"]];
    sailPrice.text = [NSString stringWithFormat:@"原价:¥%@元",self.productInfo[@"sailPrice"]];
    if ([self.productInfo[@"ginsengPremium"] intValue]!= 0 &&self.productInfo[@"ginsengPremium"] !=[NSNull null]) {
        [self initAccidentInsuranceView];
    }else{
        [self removeAccidentInsuranceView];
    }
}
- (NSString *)makeSureSkuId:(NSArray *)propetrys
{
    NSArray *products = [self SelectProductsByPropetrys:propetrys];
    if (1 != [products count]){
        return nil;
    }
    else{
        NSString *skuId = [(NSDictionary *)[products objectAtIndex:0] objectForKey:@"skuId"];
        return skuId;
    }
}
#pragma mark - 属性按钮
- (UIButton *)createPropetrtButton
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_n"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_hover"xPos:0.1 yPos:0.2] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_hover"xPos:0.1 yPos:0.2] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    //   [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btn setTitleColor:[ComponentsFactory createColorByHex:@"#333333"] forState:UIControlStateNormal];
    return btn;
}
#pragma mark - 界面平移动画
- (void)moveAnimationWithDirection:(AnimationDirection)direction duration:(NSTimeInterval)interval
{
    UIView *colorView = [self.view viewWithTag:PropetryOrOptionColor];
    UIView *memoryView = [self.view viewWithTag:PropetryOrOptionMemory];
    UIView *contractView = [self.view viewWithTag:PropetryOrOptionContract];
    UIView *phoneNumberView = [self.view viewWithTag:PropetryOrOptionPhoneNumber];
    UIView *insuranceView = [self.view viewWithTag:PropetryOrOptionAccidentInsurance];
    UIView *evaluateView = [self.view viewWithTag:PropetryOrOptionEvaluation];
    UIView *pullForMoreView = [self.view viewWithTag:PropetryOrOptionPullForMore];
    UIView *mayYoulikeView = [self.view viewWithTag:PropetryOrOptionMayYouLike];
    UIView *areaAndpackageView = [self.view viewWithTag:PropetryOrOptionBroadband];
    UIView *SIMView = [self.view viewWithTag:PropetryOrOptionSIM];
    UIView *webView = [self.view viewWithTag:PropetryOrOptionsWebView];
    void (^animations)(void) = ^{
		switch (direction) {
            case AnimationDirectionTop:{
                colorView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                memoryView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                contractView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                phoneNumberView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                evaluateView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                pullForMoreView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                insuranceView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                mayYoulikeView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                areaAndpackageView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                SIMView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
                webView.transform  = CGAffineTransformMakeTranslation(0,-giftsHeight);
            }
                break;
            case AnimationDirectionBottom:{
                colorView.transform  = CGAffineTransformMakeTranslation(0,0);
                memoryView.transform  = CGAffineTransformMakeTranslation(0,0);
                contractView.transform  = CGAffineTransformMakeTranslation(0,0);
                phoneNumberView.transform  = CGAffineTransformMakeTranslation(0,0);
                evaluateView.transform  = CGAffineTransformMakeTranslation(0,0);
                pullForMoreView.transform  = CGAffineTransformMakeTranslation(0,0);
                insuranceView.transform  = CGAffineTransformMakeTranslation(0,0);
                mayYoulikeView.transform  = CGAffineTransformMakeTranslation(0,0);
                areaAndpackageView.transform  = CGAffineTransformMakeTranslation(0,0);
                SIMView.transform  = CGAffineTransformMakeTranslation(0,0);
                webView.transform  = CGAffineTransformMakeTranslation(0,0);
            }
                break;
            default:
                break;
        }
	};
    
    [UIView animateWithDuration:interval animations:animations];
}

#pragma mark -  根据数据初始化界面
- (void)initDetailWithData:(NSDictionary *)dict
{
    self.productDetailDict = dict;
    if (dict[@"moduleId"]!= [NSNull null]) {
        self.moduleId = dict[@"moduleId"];
    }
    if (dict[@"productDetail"]!= [NSNull null]) {
        NSDictionary *productDetail = dict[@"productDetail"];
        //step1.取出商品图片
        if (productDetail[@"imgURLs"] != [NSNull null]) {
            [self initProductDetailImagesWithArray:productDetail[@"imgURLs"]];
        }
        //step2.取出商品描述
        if (productDetail[@"desc"] !=[NSNull null]&&![productDetail[@"desc"] isEqualToString:@""]) {
            NSString *descStr = nil;
            if (productDetail[@"name"] !=[NSNull null]&&![productDetail[@"name"] isEqualToString:@""]) {
                descStr = [NSString stringWithFormat:@"%@,%@",productDetail[@"name"],productDetail[@"desc"]];
            }else{
                descStr = productDetail[@"desc"];
            }
            [self initProductDescriptionWithDesc:descStr];
        }else{
            if (productDetail[@"name"] !=[NSNull null]&&![productDetail[@"name"] isEqualToString:@""]) {
                [self initProductDescriptionWithDesc:productDetail[@"name"]];
            }
        }
        //step3.取出商品价格
        UILabel *discountPrice = (UILabel *)[self.view viewWithTag:DISCOUNT_PRICE_TAG];
        UILabel *sailPrice = (UILabel *)[self.view viewWithTag:SAIL_PRICE_TAG];
        switch ([self.moduleId intValue])
        {
            case ProductDetailTypePhone:{
                discountPrice.text = [NSString stringWithFormat:@"裸机价:¥%@元",productDetail[@"sailPrice"]];
                sailPrice.hidden = YES;
                break;
            }
            case ProductDetailTypeAccessory:
            case ProductDetailTypeContract:{
                discountPrice.text = [NSString stringWithFormat:@"折扣价:¥%@元",productDetail[@"discountPrice"]];
                sailPrice.text = [NSString stringWithFormat:@"原价:¥%@元",productDetail[@"sailPrice"]];
                break;
            }
            case 1010:
            case ProductDetailTypeBroadband:{
                discountPrice.text = [NSString stringWithFormat:@"价格:¥%@～1800元",productDetail[@"sailPrice"]];
                sailPrice.hidden = YES;
                break;
            }
            case ProductDetailTypeCardPackage:{
                discountPrice.text = [NSString stringWithFormat:@"预存款:¥%@元",productDetail[@"sailPrice"]];
                sailPrice.hidden = YES;
                break;
            }
            default:
                break;
        }
        //step4.赠品
        NSMutableArray *gifts = nil;
        if (productDetail[@"gifts"] != [NSNull null] && [productDetail[@"gifts"] count] != 0) {
            gifts = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dict in productDetail[@"gifts"]) {
                if (dict[@"giftDetail"] != [NSNull null] && ![dict[@"giftDetail"] isEqualToString:@""]) {
                    [gifts addObject:dict];
                }
            }
            if ([gifts count] != 0) {
                [self initTableViewWithGifts:gifts];
            }
        }
        
        //step5.根据商品类型读取不同数据
        if (dict[@"phoneDetail"] != [NSNull null]){
            //设置属性
            NSDictionary *phoneDetail = dict[@"phoneDetail"];
            if (phoneDetail[@"propertyList"]!=[NSNull null]) {
                NSArray *propertyList = phoneDetail[@"propertyList"];
                if ([propertyList count] !=0) {
                    offset_Y +=10;
                    for (NSDictionary *dict in propertyList) {
                        [self initViewWithPropetryDict:dict];
                    }
                }
            }
            int moduleId = [self.moduleId intValue];
            if (moduleId == ProductDetailTypeContract) {
                [self initViewWithPropetryDict:@{@"propertyName":@"方式",@"propertyValue":@"请选择套餐"} withPropetryOrOptions:PropetryOrOptionContract];
                [self initViewWithPropetryDict:@{@"propertyName":@"号码",@"propertyValue":@"请选择号码"} withPropetryOrOptions:PropetryOrOptionPhoneNumber];
            }
            else if (moduleId == ProductDetailTypePhone){
                [self initViewWithPropetryDict:@{@"propertyName":@"方式"} withPropetryOrOptions:PropetryOrOptionContract];
            }
            self.skuList = phoneDetail[@"skuList"];
            if ([self.skuList count] == 1) {
                [self makeSureProduct];
            }
        }else if (dict[@"simDetail"]!= [NSNull null]){
            offset_Y +=10;
            [self initViewWithPropetryDict:@{@"propertyName":@"套餐",@"propertyValue":@"请选择套餐"} withPropetryOrOptions:PropetryOrOptionSIM];
            [self initViewWithPropetryDict:@{@"propertyName":@"号码",@"propertyValue":@"请选择号码"} withPropetryOrOptions:PropetryOrOptionPhoneNumber];
            
        }else if(dict[@"netDetail"]!= [NSNull null]){
            offset_Y +=10;
            [self initViewWithPropetryDict:@{@"propertyName":@"地址和套餐",@"propertyValue":@"请选择地址和套餐"} withPropetryOrOptions:PropetryOrOptionBroadband];
        }
        //step6.评论
        [self initEvaluateView];
        //step7.猜你喜欢
        if (productDetail[@"maybeYourLiker"] != [NSNull null] && [productDetail[@"maybeYourLiker"] count] != 0) {
            [self initMayYouLikeView];
        }
        //step8.上拉查看详情
        [self initPullForMoreView];
    }
}

#pragma mark
#pragma mark - 查看图片详情
- (void)tap:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    if (imageView.tag ==10000) {
        imageView.hidden = YES;
    }else{
        [self showImageDetailWithImage:imageView.image];
    }
}

#pragma mark 查看大图
- (void)showImageDetailWithImage:(UIImage *)image
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:10000];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        imageView.userInteractionEnabled = YES;
        imageView.image = image;
        imageView.tag = 10000;
        imageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:imageView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(tap:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
    }else{
        imageView.image = image;
        imageView.hidden = NO;
    }
}

#pragma mark
#pragma mark - 异步图片
- (UIImage *)LoadImage:(NSDictionary*)aDic{
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"url"]];
    NSData *data=[NSData dataWithContentsOfURL:aURL];
    if (data == nil) {
        return nil;
    }
    UIImage *image=[UIImage imageWithData:data];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager createFileAtPath:pathForURL(aURL) contents:data attributes:nil];
    return image;
}

#pragma mark
#pragma mark - BtnAction
- (void)chooseAreaAndPackage:(UIButton *)sender
{
    //    ChooseAddressVC *chooseAddressVC = [[ChooseAddressVC alloc] init];
    //    chooseAddressVC.moduleId = self.moduleId;
    //    chooseAddressVC.cardOrderKeyValuelist = self.productDetailDict[@"netDetail"][@"cardOrderKeyValuelist"];
    //    chooseAddressVC.block = ^(NSDictionary *dict){
    //        self.broadbandInfoDict = dict;
    //        NSString *desc = [dict[@"broadBandPkg"] objectForKey:@"packDesc"];
    //        UILabel *discountlable = (UILabel *)[self.view viewWithTag:DISCOUNT_PRICE_TAG];
    //        discountlable.text = [NSString stringWithFormat:@"折扣价¥:%.2f元",[dict[@"broadBandPkg"][@"packCost"] floatValue]];
    //        CGRect rect = [desc boundingRectWithSize:CGSizeMake(MAXFLOAT,28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil];
    //        [sender setTitle:desc forState:UIControlStateSelected];
    //        [sender.titleLabel setFont:[UIFont systemFontOfSize:12]];
    //        sender.frame = CGRectMake(20,50,rect.size.width+20,28);
    //        sender.selected = YES;
    //    };
    //    [self.navigationController pushViewController:chooseAddressVC animated:YES];
    
    NewChooseAddressVC *chooseAddressVC = [[NewChooseAddressVC alloc] init];
    chooseAddressVC.moduleId = self.moduleId;
    chooseAddressVC.cardOrderKeyValuelist = self.productDetailDict[@"netDetail"][@"cardOrderKeyValuelist"];
    chooseAddressVC.block = ^(NSDictionary *dict){
        sender.selected = NO;
        self.broadbandInfoDict = dict;
        NSString *desc = [dict[@"broadBandPkg"] objectForKey:@"packDesc"];
        UILabel *discountlable = (UILabel *)[self.view viewWithTag:DISCOUNT_PRICE_TAG];
        discountlable.text = [NSString stringWithFormat:@"折扣价¥:%.2f元",[dict[@"broadBandPkg"][@"packCost"] floatValue]];
        CGRect rect = [desc boundingRectWithSize:CGSizeMake(MAXFLOAT,28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];
        [sender setTitle:desc forState:UIControlStateSelected];
        [sender.titleLabel setFont:[UIFont systemFontOfSize:14]];
        sender.frame = CGRectMake(20,50,rect.size.width+20,28);
        sender.selected = YES;
    };
    
    [self.navigationController pushViewController:chooseAddressVC animated:YES];
}
- (void)chooseSIMPackage:(UIButton *)sender
{
    SIMPackageChooseVC *simChooseVC = [[SIMPackageChooseVC alloc] init];
    NSArray *packageType = self.productDetailDict[@"simDetail"][@"bsuiPkg"][@"packageType"];
    simChooseVC.dataSources = packageType;
    simChooseVC.handler = ^(NSDictionary *SIMPackage){
        [PackManager shareInstance].packageModes = [SIMPackage objectForKey:@"packageModes"];
        self.SIMPackageInfoDict = SIMPackage;
        NSString *valueName =[NSString stringWithFormat:@"%@,%@,%@,%@",SIMPackage[@"packageName"],SIMPackage[@"packageInlandVoice"],SIMPackage[@"packageInlandFlow"],SIMPackage[@"packageInlandMessage"]];
        CGRect rect = [valueName boundingRectWithSize:CGSizeMake(MAXFLOAT,28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];
        self.SIMPackageInfoDict = [packageType firstObject];
        [sender setTitle:valueName forState:UIControlStateSelected];
        [sender.titleLabel setFont:[UIFont systemFontOfSize:14]];
        sender.frame = CGRectMake(20,50,rect.size.width+20,28);
        sender.selected = YES;
    };
    [self.navigationController pushViewController:simChooseVC animated:YES];
}
- (void)phoneBuyTypeChoose:(UIButton *)sender
{
    if (sender == self.onlyPhoneBtn) {
        sender.selected = YES;
        self.contractBtn.selected = NO;
        self.contractBtn.frame = CGRectMake(100,50,60,28);
        [self.contractBtn setTitle:@"合约机" forState:UIControlStateNormal];
        self.packageInfoDict = nil;
        [self removePhoneNumberModule];
    }else if(sender == self.contractBtn){
        [self chooseContract:sender];
    }
}

- (void)insurancebtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        joinWoYibao = YES;
        ginsengPremium = [self.productInfo[@"ginsengPremium"] floatValue];
    }else{
        joinWoYibao = NO;
        ginsengPremium = 0;
    }
}
- (void)evaluateBtnClicked:(UIButton *)sender
{
    NSDictionary *evaluateDict = self.productDetailDict[@"productDetail"][@"evaluateResult"];
    ProductEvaluationVC *evaluateVC = [[ProductEvaluationVC alloc] init];
    evaluateVC.evaluateDict = [NSMutableDictionary dictionaryWithDictionary:evaluateDict];
    evaluateVC.productId = self.params[@"productId"];
    [self.navigationController pushViewController:evaluateVC animated:YES];
}
- (void)chooseContract:(UIButton *)sender
{
    if (self.skuId != nil &&![self.skuId isEqualToString:@""]) {
        ChoosePackageVC *choosePackageVC = [[ChoosePackageVC alloc] init];
        choosePackageVC.attributes = @{@"skuId": self.skuId,@"productId":self.params[@"productId"],@"moduleId":self.moduleId};
        choosePackageVC.block = ^(NSDictionary *dict){
            sender.selected = NO;
            self.packageInfoDict = dict;
            NSString *info = [NSString stringWithFormat:@"%@【%@】",dict[@"_lowCost"],dict[@"packTypeName"]];
            CGRect rect = [info boundingRectWithSize:CGSizeMake(MAXFLOAT,33) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:sender.titleLabel.font} context:nil];
            if (rect.size.width > 100) {
                [sender setFrame:(CGRect){sender.frame.origin,{rect.size.width+20,33}}];
            }else{
                [sender setFrame:(CGRect){sender.frame.origin,{120,33}}];
            }
            [sender setTitle:info forState:UIControlStateNormal];
            sender.selected = YES;
            if([self.moduleId intValue] == ProductDetailTypePhone)
            {
                [self initViewWithPropetryDict:@{@"propertyName":@"号码",@"propertyValue":@"请选择号码"} withPropetryOrOptions:PropetryOrOptionPhoneNumber];
                self.onlyPhoneBtn.selected = NO;
            }
        };
        [self.navigationController pushViewController:choosePackageVC animated:YES];
    }else{
        [self ShowProgressHUDwithMessage:@"请先选择商品属性"];
    }
}
- (void)choosePhoneNumber:(UIButton *)sender
{
    sender.selected = NO;
    ChoosePhoneNumVC *choosePhoneNumberVC = [[ChoosePhoneNumVC alloc] init];
    choosePhoneNumberVC.params = @{@"productId":self.params[@"productId"]};
    choosePhoneNumberVC.handler = ^(NSDictionary *dict){
        self.phoneNumberInfoDict = dict;
        [sender setTitle:dict[@"phoneNum"] forState:UIControlStateNormal];
        sender.selected = YES;
    };
    [self.navigationController pushViewController:choosePhoneNumberVC animated:YES];
}

- (void)colorBtnClicked:(UIButton *)sender
{
    if (self.selectedColorBtn == nil) {
        sender.selected = !sender.selected;
        self.selectedColorBtn = sender;
        NSString *propetryValueId = [NSString stringWithFormat:@"%d",sender.tag];
        [self.selectedPropetryList addObject:propetryValueId];
        [self makeSureProductByPropetrys];
    }else{
        if (self.selectedColorBtn.tag != sender.tag) {
            [self.selectedPropetryList removeObject:[NSString stringWithFormat:@"%d",self.selectedColorBtn.tag]];
            NSString *propetryValueId = [NSString stringWithFormat:@"%d",sender.tag];
            if (![self.selectedPropetryList containsObject:propetryValueId]) {
                [self.selectedPropetryList addObject:propetryValueId];
            }
            self.selectedColorBtn.selected = NO;
            sender.selected = !sender.selected;
            self.selectedColorBtn = sender;
            [self makeSureProductByPropetrys];
        }
    }
}
- (void)memoryBtnClicked:(UIButton *)sender
{
    if (self.selectedMemoryBtn == nil) {
        sender.selected = !sender.selected;
        self.selectedMemoryBtn = sender;
        NSString *propetryValueId = [NSString stringWithFormat:@"%d",sender.tag];
        [self.selectedPropetryList addObject:propetryValueId];
        [self makeSureProductByPropetrys];
        
    }else{
        if (self.selectedMemoryBtn.tag != sender.tag) {
            [self.selectedPropetryList removeObject:[NSString stringWithFormat:@"%d",self.selectedMemoryBtn.tag]];
            NSString *propetryValueId = [NSString stringWithFormat:@"%d",sender.tag];
            if (![self.selectedPropetryList containsObject:propetryValueId]) {
                [self.selectedPropetryList addObject:propetryValueId];
            }
            self.selectedMemoryBtn.selected = NO;
            sender.selected = !sender.selected;
            self.selectedMemoryBtn = sender;
            [self makeSureProductByPropetrys];
        }
    }
}
- (void)submitOrder:(UIButton *)sender
{
    if ([self.productDetailDict objectForKey:@"netDetail"] == nil&&[self.productDetailDict objectForKey:@"phoneDetail"] == nil&&[self.productDetailDict objectForKey:@"productDetail"] == nil&&[self.productDetailDict objectForKey:@"simDetail"] == nil) {
        return;
    }
    if ([self checkData]) {
        CommitVC *commitVC = [[CommitVC alloc] init];
        MyLog(@"%@",self.commitOrderDict);
        commitVC.receiveData = [NSMutableDictionary dictionaryWithObject:self.commitOrderDict forKey:@"ProductInfo"];
        [self.navigationController pushViewController:commitVC animated:YES];
    }
}

- (BOOL)checkData
{
    [self.commitOrderDict setObject:self.params[@"productId"] forKey:@"productId"];
    [self.commitOrderDict setObject:[NSNull null] forKey:@"custType"];
    [self.commitOrderDict setObject:[NSNull null] forKey:@"seckillFlag"];
    [self.commitOrderDict setObject:self.moduleId forKey:@"moduleId"];
    [self.commitOrderDict setObject:self.productDetailDict[@"productDetail"][@"name"]forKey:@"productName"];
    int moduleId = [self.moduleId intValue];
    if (moduleId == ProductDetailTypeContract) {
        if (self.productInfo == nil) {
            [self ShowProgressHUDwithMessage:@"请先选择商品属性"];
            return NO;
        }else if([self.productInfo[@"inventory"] intValue] == 0){
            [self ShowProgressHUDwithMessage:@"该商品已售罄！"];
            return NO;
        }else if (self.packageInfoDict == nil){
            [self ShowProgressHUDwithMessage:@"请先选择合约套餐"];
            return NO;
        }else if (self.phoneNumberInfoDict == nil) {
            [self ShowProgressHUDwithMessage:@"请先选择手机号码"];
            return NO;
        }else{
            [self.commitOrderDict setObject:self.productInfo[@"skuId"] forKey:@"skuId"];
            [self.commitOrderDict setObject:self.packageInfoDict[@"period"] forKey:@"period"];
            [self.commitOrderDict setObject:self.packageInfoDict[@"pkgId"] forKey:@"pkgId"];
            [self.commitOrderDict setObject:self.packageInfoDict[@"packTypeName"] forKey:@"packageName"];
            [self.commitOrderDict setObject:self.phoneNumberInfoDict[@"phoneNum"] forKey:@"cardNum"];
            if (joinWoYibao == YES) {
                [self.commitOrderDict setObject:@"1" forKey:@"woYibaoFlag"];
            }
            float price = 0;
            float contractPhonePrice = [self.packageInfoDict[@"totalPrice"] floatValue];
            float phoneNumPrice = [self.phoneNumberInfoDict[@"phoneNumPrice"] floatValue];
            price = contractPhonePrice + phoneNumPrice+ginsengPremium;
            NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
            [self.commitOrderDict setObject:priceStr forKey:@"Price"];
        }
    }else if(moduleId == ProductDetailTypePhone){
        float price = 0;
        float contractPhonePrice = 0;
        float phoneNumPrice = 0;
        if (self.productInfo == nil) {
            [self ShowProgressHUDwithMessage:@"请先选择商品属性"];
            return NO;
        }else if([self.productInfo[@"inventory"] intValue] == 0){
            [self ShowProgressHUDwithMessage:@"该商品已售罄！"];
            return NO;
        }
        if(self.contractBtn.selected == YES){
            if (self.packageInfoDict == nil) {
                [self ShowProgressHUDwithMessage:@"请先选择合约套餐"];
                return NO;
            }else{
                [self.commitOrderDict setObject:self.packageInfoDict[@"period"] forKey:@"period"];
                [self.commitOrderDict setObject:self.packageInfoDict[@"pkgId"] forKey:@"pkgId"];
                [self.commitOrderDict setObject:self.packageInfoDict[@"packTypeName"] forKey:@"packageName"];
                contractPhonePrice = [self.packageInfoDict[@"totalPrice"] floatValue];
            }
        }
        if (ifNeedCheckPhoneNumber == YES) {
            if (self.phoneNumberInfoDict == nil) {
                [self ShowProgressHUDwithMessage:@"请先选择手机号码"];
                return NO;
            }else{
                [self.commitOrderDict setObject:self.phoneNumberInfoDict[@"phoneNum"] forKey:@"cardNum"];
                phoneNumPrice = [self.phoneNumberInfoDict[@"phoneNumPrice"] floatValue];
            }
        }
        if (joinWoYibao == YES) {
            [self.commitOrderDict setObject:@"1" forKey:@"woYibaoFlag"];
        }
        if(self.packageInfoDict != nil&&self.contractBtn.selected == YES){
            price = contractPhonePrice+phoneNumPrice+ginsengPremium;
        }else{
            price = [self.productInfo[@"discountPrice"] floatValue]+ginsengPremium;
        }
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        [self.commitOrderDict setObject:self.productInfo[@"skuId"] forKey:@"skuId"];
        [self.commitOrderDict setObject:priceStr forKey:@"Price"];
    }else if (moduleId == ProductDetailTypeAccessory){
        if (self.productInfo == nil) {
            [self ShowProgressHUDwithMessage:@"请先选择商品属性"];
            return NO;
        }else{
            [self.commitOrderDict setObject:self.productInfo[@"discountPrice"] forKey:@"Price"];
            [self.commitOrderDict setObject:self.productInfo[@"skuId"] forKey:@"skuId"];
        }
        if (joinWoYibao == YES) {
            [self.commitOrderDict setObject:@"1" forKey:@"woYibaoFlag"];
        }
    }else if (moduleId == ProductDetailTypeBroadband){
        if (self.broadbandInfoDict == nil) {
            if (self.productInfo == nil) {
                [self ShowProgressHUDwithMessage:@"请先选择地址与套餐"];
                return NO;
            }
        }
        [self.commitOrderDict setObject:self.broadbandInfoDict[@"broadBandPkg"][@"packCost"]forKey:@"Price"];
        [self.commitOrderDict setObject:self.broadbandInfoDict[@"broadBandPkg"][@"packCode"] forKey:@"pkgId"];
        [self.commitOrderDict setObject:self.broadbandInfoDict[@"broadbrand"] forKey:@"broadbrand"];
        [self.commitOrderDict setObject:self.broadbandInfoDict[@"areaName"] forKey:@"areaName"];
        [self.commitOrderDict setObject:self.productDetailDict[@"netDetail"][@"skuId"] forKey:@"skuId"];
    }else if(moduleId == ProductDetailTypeCardPackage){
        if (self.SIMPackageInfoDict == nil) {
            [self ShowProgressHUDwithMessage:@"请先选择号卡套餐"];
            return NO;
        }else if (self.phoneNumberInfoDict == nil) {
            [self ShowProgressHUDwithMessage:@"请先选择手机号码"];
            return NO;
        }
        [self.commitOrderDict setObject:self.SIMPackageInfoDict[@"pkgId"] forKey:@"pkgId"];
        [self.commitOrderDict setObject:self.SIMPackageInfoDict[@"skuId"] forKey:@"skuId"];
        [self.commitOrderDict setObject:self.phoneNumberInfoDict[@"phoneNum"] forKey:@"cardNum"];
        [self.commitOrderDict setObject:self.SIMPackageInfoDict[@"sailPrice"] forKey:@"Price"];
        [self.commitOrderDict setObject:[NSNull null] forKey:@"woYibaoFlag"];
    }
    return YES;
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

- (void)share
{
    //    NSString *desc = nil;
    //    if ([[self.productDetailDict objectForKey:@"productDetail"] objectForKey:@"desc"] != [NSNull null]) {
    //        desc = [[self.productDetailDict objectForKey:@"productDetail"] objectForKey:@"desc"];
    //    }else if([[self.productDetailDict objectForKey:@"productDetail"] objectForKey:@"name"] != [NSNull null]){
    //        desc = [[self.productDetailDict objectForKey:@"productDetail"] objectForKey:@"name"];
    //    }else{
    //        desc = @"";
    //    }
    NSString *productUrl = [[self.productDetailDict objectForKey:@"productDetail"] objectForKey:@"productUrl"];
    //    //构造分享内容
    //    id<ISSContent> publishContent = [ShareSDK content:desc
    //                                       defaultContent:@""
    //                                                image:nil
    //                                                title:@"沃创富"
    //                                                  url:productUrl
    //                                          description:@""
    //                                            mediaType:SSPublishContentMediaTypeText];
    //
    //    [ShareSDK showShareActionSheet:nil
    //                         shareList:shareList
    //                           content:publishContent
    //                     statusBarTips:YES
    //                       authOptions:nil
    //                      shareOptions: nil
    //                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
    //                                if (state == SSResponseStateSuccess)
    //                                {
    //                                    MyLog(@"分享成功");
    //                                }
    //                                else if (state == SSResponseStateFail)
    //                                {
    //                                    MyLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
    //                                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"错误提示"
    //                                                                                    message:[error errorDescription]
    //                                                                                   delegate:nil
    //                                                                          cancelButtonTitle:@"确定"
    //                                                                          otherButtonTitles:nil];
    //                                    [alter show];
    //                                }
    //                            }];
    //
    NSURL *url = [NSURL URLWithString:productUrl];
    NSString*str =  [url absoluteString];
    if ([str rangeOfString:@"wcfsproduct"].location!=NSNotFound)
    {
        NSString *query = url.query;
        NSMutableDictionary * paramsDict = [NSMutableDictionary dictionary];
        NSString *decodeQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange shareRange = [decodeQuery rangeOfString:@"shareurl"];
        if (shareRange.location != NSNotFound &&shareRange.length != 0)
        {
            NSString *shareUrl =  [decodeQuery substringFromIndex:shareRange.location+shareRange.length+1];
            [paramsDict setObject:shareUrl forKey:@"shareurl"];
            decodeQuery = [decodeQuery substringToIndex:shareRange.location-1];
        }
        NSArray *queryParams = [decodeQuery componentsSeparatedByString:@"&"];
        for (NSString *param in queryParams)
        {
            NSArray *paramElement = [param componentsSeparatedByString:@"="];
            [paramsDict setObject:paramElement[1] forKey:paramElement[0]];
        }
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@",paramsDict[@"name"],paramsDict[@"shareurl"]]
                                           defaultContent:nil
                                                    image:[ShareSDK pngImageWithImage:[UIImage  imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:paramsDict[@"img"]]]]] title:@"沃创富分享挣钱"
                                                      url:paramsDict[@"shareurl"]
                                              description:paramsDict[@"name"]
                                                mediaType:SSPublishContentMediaTypeNews];
        
        NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSMS,ShareTypeQQ,ShareTypeQQSpace,ShareTypeTencentWeibo,ShareTypeSinaWeibo,nil];
        //2.调用分享菜单分享
        [ShareSDK showShareActionSheet:nil
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    //如果分享成功
                                    if (state == SSResponseStateSuccess) {
                                        //                NSLog(@"分享成功");
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    }
                                    //如果分享失败
                                    if (state == SSResponseStateFail) {
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[error errorDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    }
                                }];
    }
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if([[ProductDetail getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            bussineDataService *buss=[bussineDataService sharedDataService];
            [self initDetailWithData:buss.rspInfo];
        }else{
            msg = @"没有找到产品信息！";
            [self ShowProgressHUDwithMessage:msg];
            [self initNoProductImageView];
        }
    }
}
- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if([[ProductDetail getBizCode] isEqualToString:bizCode]){
        if([NSNull null] == [info objectForKey:@"MSG"] || nil == msg){
            msg = @"没有找到产品信息！";
            [self ShowProgressHUDwithMessage:msg];
        }
        [self initNoProductImageView];
    }
}

#pragma mark
#pragma mark - TitleBarDelegate
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)homeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - HUD
- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyHeader *header = self.sectionDict[@(section)];
    if (header == nil) {
        return [self.productDetailDict[@"productDetail"][@"gifts"]count];;
    }else{
        if (header.isOpen) {
            return [self.productDetailDict[@"productDetail"][@"gifts"]count];
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //step1.创建Cell
    static NSString *identifier = @"CustomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //        [cell.textLabel setFont:[UIFont systemFontOfSize:12.f]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [ComponentsFactory createColorByHex:@"#4a4a4a"];
        cell.textLabel.numberOfLines = 0;
    }
    NSString *str = self.productDetailDict[@"productDetail"][@"gifts"][indexPath.row][@"giftDetail"];
    if ([str isEqualToString:@""]) {
        str = @"暂无赠品信息";
    }
    cell.textLabel.text = str;
    
    return cell;
}

#pragma mark
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifierForheader = @"HeaderIdentifier";
    MyHeader *header = self.sectionDict[@(section)];
    if (nil == header) {
        header = [[MyHeader alloc] initWithReuseIdentifier:identifierForheader];
        [header setDelegate:self];
        [header setIsOpen:YES];
        [self.sectionDict setObject:header forKey:@(section)];
        [header.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [header.textLabel setTextColor:[ComponentsFactory createColorByHex:@"#000000"]];
    }
    [header setSection:section];
    if (self.productDetailDict[@"giftOrInstruction"]!=[NSNull null]&& ![self.productDetailDict[@"giftOrInstruction"] isEqualToString:@""]) {
        header.textLabel.text = self.productDetailDict[@"giftOrInstruction"];
    }else{
        header.textLabel.text = @"赠品";
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark
#pragma mark - MyHeaderDelegate
- (void)myHeaderDidSelectedHeader:(MyHeader *)header
{
    MyHeader *clickHeader = self.sectionDict[@(header.section)];
    BOOL isOpen = clickHeader.isOpen;
    [header setIsOpen:!isOpen];
    UIScrollView *scrollview = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    if (!isOpen == YES) {
        offset_Y += giftsHeight;
    }else
        offset_Y -= giftsHeight;
    scrollview.contentSize = CGSizeMake(0, offset_Y);
    UITableView *table = (UITableView *)[self.view viewWithTag:TABLE_VIEW_TAG];
    UITableViewRowAnimation animation;
    [self moveAnimationWithDirection:header.isOpen?AnimationDirectionBottom:AnimationDirectionTop duration:0.3f];
    animation = header.isOpen?UITableViewRowAnimationBottom:UITableViewRowAnimationFade;
    [table reloadSections:[NSIndexSet indexSetWithIndex:header.section] withRowAnimation:animation];
    
}

#pragma mark
#pragma mark - MayYouLikeViewDelegate
- (void)mayYouLikeView:(MayYouLikeView *)mayYouLikeView didSelectWithClickUrl:(NSString *)clickUrl
{
    [UrlParser gotoNewVCWithUrl:clickUrl];
}

#pragma mark
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *pullForMore = [self.view viewWithTag:PropetryOrOptionPullForMore];
    float location = pullForMore.frame.origin.y +44;
    if (scrollView.contentOffset.y+scrollView.frame.size.height>location+80 &&ifAlreadyHavaWebView==NO) {
        
        UIWebView *webView = [[UIWebView alloc] init];
        MyHeader *header = self.sectionDict[@(0)];
        if (header!= nil && header.isOpen == NO) {
            webView.transform = CGAffineTransformMakeTranslation(0,-giftsHeight);
        }
        webView.frame = CGRectMake(0,offset_Y,[AppDelegate sharePhoneWidth],scrollView.frame.size.height);
        webView.tag = PropetryOrOptionsWebView;
        webView.scrollView.scrollEnabled = NO;
        webView.delegate = self;
        [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.productDetailDict[@"productDetail"][@"allDetailUrl"]]]];
        UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
        [scroll addSubview:webView];
        offset_Y += scrollView.frame.size.height;
        [scroll setContentSize:CGSizeMake(0, offset_Y)];
        ifAlreadyHavaWebView = YES;
    }
}

#pragma mark
#pragma mark - 监听UIWebView contentSize
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:SCROLL_CONTENT_VIEW_TAG];
    UIWebView *webview =  (UIWebView *)[self.view viewWithTag:PropetryOrOptionsWebView];
    CGRect webViewFrame = webview.frame;
    float orginHeight = webViewFrame.size.height;
    webViewFrame.size.height = webview.scrollView.contentSize.height;
    float newHeight = webViewFrame.size.height;
    webview.frame = webViewFrame;
    offset_Y += newHeight - orginHeight;
    [scroll setContentSize:CGSizeMake(0,offset_Y)];
}

#pragma mark
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //为防止加载完成后修改webView的frame的操作还在执行，延迟2秒移除监听
        [webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    });
}

@end

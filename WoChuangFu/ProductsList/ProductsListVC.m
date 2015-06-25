//
//  ProductsListVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-23.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ProductsListVC.h"
#import "MJRefresh.h"
#import "TitleBar.h"
#import "ProductDetailVC.h"
#import "ProductCell.h"
#import "UrlParser.h"
#import "InsetsLabel.h"
#import "ProductModel.h"
#import "FileHelpers.h"
#import "CrossLineLable.h"
#import "BrandChooseBar.h"

#define PAGE_COUNT @"20" //每页显示数目
#define TITLEBAR_HEIGHT 44
#define MAIN_CONTENT_VIEW_OFFSET_Y ([[UIScreen mainScreen] applicationFrame].origin.y + TITLEBAR_HEIGHT)
#define FOOT_VIEW_HEIGHT 44
#define TOPBUTTONWIDTH 34 //回到顶部button宽度
#define TOPBUTTONHEIGHT 34 //回到顶部button高度
#define KMARGIN 5.0
#define LEFT_IMAGEVIEW_TAG 2000
#define LEFT_PRODUCTNAME_TAG 2001
#define LEFT_PRODUCTPRICE_TAG 2002
#define LEFT_ORGINPRICE_TAG 2003
#define LEFT_BTN_TAG 2004
#define RIGHT_IMAGEVIEW_TAG 3000
#define RIGHT_PRODUCTNAME_TAG 3001
#define RIGHT_PRODUCTPRICE_TAG 3002
#define RIGHT_ORGINPRICE_TAG 3003
#define RIGHT_BTN_TAG 3004
#define TITLE_BAT_TAG 3005

#define ITEM_WIDTH ([AppDelegate sharePhoneWidth]-3*KMARGIN)/2
#define ITEM_HEIGHT 190
#define HEXCOLOR(color) [ComponentsFactory createColorByHex:color]
#define BORDER_COLOR [[ComponentsFactory createColorByHex:@"#dedede"] CGColor]
#define IMAGEVIEW_HEIGHT 120 //145
#define IMAGEVIEW_WIDTH  120
#define LABLE_HEIGHT 25

@interface ProductsListVC ()<UITableViewDataSource,UITableViewDelegate,HttpBackDelegate,TitleBarDelegate,BrandChooseBarDelegate>
{
     BOOL    sortByPriceSelected;
     BOOL    isTdLayout;
     BOOL    sortBySailCountSelected;
     BOOL    sortByTimeSelected;
     BOOL    sideBarShowing;           //侧滑栏显示标志
     CGFloat currentTranslate;         //当前偏移
     int     ContentOffset;            //侧滑栏偏移量
     int     ContentMinOffset;         //最小偏移量
     float   MoveAnimationDuration;    //动画时间
}
@property (nonatomic,strong) BrandChooseBar      *brandBar;
@property (nonatomic,assign) int                 currentPage;     //当前页
@property (nonatomic,assign) int                 moduleId;
@property (nonatomic,strong) NSArray             *typeList;
@property (nonatomic,strong) NSMutableArray      *btnList;
@property (nonatomic,strong) NSMutableArray      *productsList;        //商品列表
@property (nonatomic,strong) UITableView         *productsTable;       //商品列表视图
@property (nonatomic,strong) NSMutableDictionary *webRequestDict;         //请求参数字典
@property (nonatomic,strong) UIImageView         *noContentImageView;

@end

@implementation ProductsListVC

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initTitleBar];
    [self initMainContentView];
    [self initFootFilterView];
    [self initBackToTopButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sortByTimeSelected = YES;
    sortByPriceSelected = NO;
    sortBySailCountSelected = NO;
    isTdLayout = YES;
    currentTranslate = 0;
    sideBarShowing = NO;
    ContentOffset = -220;
    ContentMinOffset = -160;
    MoveAnimationDuration = 0.3;
    [NdUncaughtExceptionHandler setDefaultHandler];
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:0];
    /*防止图片加载时候多次刷新同一张图片*/
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"NowLoad"];
    TitleBar *titlebar = (TitleBar *)[self.view viewWithTag:TITLE_BAT_TAG];
    if (self.params[@"moduleId"] != [NSNull null])
    {
        self.moduleId = [self.params[@"moduleId"] intValue];
        switch (self.moduleId)
        {
            case 1001:
                titlebar.title = @"办合约";
                break;
            case 1002:
                titlebar.title = @"选号卡";
                break;
            case 1004:
                titlebar.title = @"购手机";
                break;
            case 1005:
                titlebar.title = @"买配件";
                break;
            case 1011:
                titlebar.title = @"装宽带";
                break;
            default:
                titlebar.title = @"商品列表";
                break;
        }
    }else{
        titlebar.title = @"商品列表";
    }
    self.currentPage = 1;
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjectsAndKeys:self.params,@"params",nil];
    self.webRequestDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           paramsDict,@"expand",
                           @"",@"filter",
                           self.params[@"searchKey"]==nil?@"":self.params[@"searchKey"],@"searchKey",
                           @"",@"phoneBrand",
                           self.params[@"moduleId"]==nil?[NSNull null]:self.params[@"moduleId"],@"moduleId",
                           self.params[@"developId"]==nil?[NSNull null]:self.params[@"developId"],@"developerId",
                           @"initSearch",@"requestType",
                           @"6",@"sortType",
                           @"1",@"pageIndex",
                           PAGE_COUNT,@"pageCount",
                           @"1",@"needType",
                           @"",@"speciseId", nil];
    [self sendWebRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

- (void)initTitleBar
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:YES TitlePos:left_position];
    [titleBar setFrame:CGRectMake(0,
                                  [[UIScreen mainScreen] applicationFrame].origin.y,
                                  [AppDelegate sharePhoneWidth],
                                  TITLEBAR_HEIGHT)];
    titleBar.tag = TITLE_BAT_TAG;

    titleBar.target = self;
    [self.view addSubview:titleBar];
}

- (void)initMainContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           MAIN_CONTENT_VIEW_OFFSET_Y + 44,
                                                                           [AppDelegate sharePhoneWidth],
                                                                           [AppDelegate sharePhoneHeight]-MAIN_CONTENT_VIEW_OFFSET_Y-FOOT_VIEW_HEIGHT - 47
                                                                           )
                                                          style:UITableViewStylePlain];
    tableView.backgroundColor = HEXCOLOR(@"#eeeeee");
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.productsTable = tableView;
    // 上拉加载更多
    [tableView addFooterWithTarget:self action:@selector(getNextPage)];
    [self.view addSubview:tableView];
    
    UIImage *image = [UIImage imageNamed:@"has_no_content"];
    UIImageView *imageview= [[UIImageView alloc] initWithImage:image];
    self.noContentImageView = imageview;
    self.noContentImageView.hidden = YES;
    imageview.backgroundColor = [UIColor clearColor];
    imageview.center = CGPointMake(tableView.frame.size.width/2, tableView.frame.size.height/2);
    imageview.userInteractionEnabled = YES;
    [tableView addSubview:imageview];
}

- (void)initBackToTopButton
{
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setImage:[UIImage imageNamed:@"btn_list_top_n"] forState:UIControlStateNormal];
    [topBtn setImage:[UIImage imageNamed:@"btn_list_top_p"] forState:UIControlStateHighlighted];
    [topBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [topBtn setFrame:CGRectMake([AppDelegate sharePhoneWidth]-TOPBUTTONWIDTH-25,
                                [AppDelegate sharePhoneHeight]-100,
                                TOPBUTTONWIDTH,
                                TOPBUTTONHEIGHT)];
    [self.view addSubview:topBtn];
}

- (void)initFootFilterView
{
    //筛选栏
    UIView *view =  [[UIView alloc] init];
    view.frame = CGRectMake(0,
//                            [AppDelegate sharePhoneHeight]-FOOT_VIEW_HEIGHT,
                            64,
                            [AppDelegate sharePhoneWidth],
                            FOOT_VIEW_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    CGFloat width = ([AppDelegate sharePhoneWidth]-40)/4;
    
    
    //按时间排序
    UIButton *timeFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeFilterBtn setTitle:@"按时间排序" forState:UIControlStateNormal];
    timeFilterBtn.frame = CGRectMake(0, 0, width - 1, 44);
    //    [sailFilterBtn setImage:[UIImage imageNamed:@"icon_down_n"] forState:UIControlStateNormal];
    [timeFilterBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [timeFilterBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [timeFilterBtn addTarget:self action:@selector(timeByCount:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:timeFilterBtn];
    
    UIImageView *imageView8 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sifeBar_line_s"]];
    imageView8.frame = CGRectMake(width, 4, 1, 36);
    [view addSubview:imageView8];
    

    //按价格排序
    UIButton *priceFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceFilterBtn setTitle:@"按价格排序" forState:UIControlStateNormal];
    priceFilterBtn.frame = CGRectMake(width, 0, width - 1, 44);
    [priceFilterBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [priceFilterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [priceFilterBtn addTarget:self action:@selector(sortByPrice:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:priceFilterBtn];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sifeBar_line_s"]];
    imageView1.frame = CGRectMake(width*2,4, 1,36);
    [view addSubview:imageView1];
    
    //按销量排序
    UIButton *sailFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sailFilterBtn setTitle:@"按销量排序" forState:UIControlStateNormal];
    sailFilterBtn.frame = CGRectMake(width*2, 0, width - 1, 44);
//    [sailFilterBtn setImage:[UIImage imageNamed:@"icon_down_n"] forState:UIControlStateNormal];
    [sailFilterBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [sailFilterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sailFilterBtn addTarget:self action:@selector(sortBySailCount:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sailFilterBtn];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sifeBar_line_s"]];
    imageView2.frame = CGRectMake(width*3, 4, 1, 36);
    [view addSubview:imageView2];
    
    //按价格排序
    UIButton *typeFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeFilterBtn setTitle:@"按分类排序" forState:UIControlStateNormal];
    typeFilterBtn.frame = CGRectMake(width*3, 0, width, 44);
    [typeFilterBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [typeFilterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [typeFilterBtn addTarget:self action:@selector(sortByType:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:typeFilterBtn];
    self.btnList = [NSMutableArray arrayWithObjects:timeFilterBtn,priceFilterBtn,sailFilterBtn,typeFilterBtn, nil];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sifeBar_line_s"]];
    imageView3.frame = CGRectMake(width*4,4, 1,36);
    [view addSubview:imageView3];
    
    
    UIButton *layoutTypebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    layoutTypebtn.frame = CGRectMake(width*4+1,0,40,44);
    layoutTypebtn.adjustsImageWhenHighlighted = NO;
    [layoutTypebtn setImage:[UIImage imageNamed:@"icon_list_td"] forState:UIControlStateSelected];
    [layoutTypebtn setImage:[UIImage imageNamed:@"icon_list_tr"] forState:UIControlStateNormal];
    [layoutTypebtn addTarget:self action:@selector(changeLayout:) forControlEvents:UIControlEventTouchUpInside];
    layoutTypebtn.selected = YES;
    [view addSubview:layoutTypebtn];
    
}
- (void)changeLayout:(UIButton *)sender
{
    isTdLayout = !isTdLayout;
    sender.selected =isTdLayout;
    [self.productsTable reloadData];
}

- (void)initBrandChooseView
{
    if (self.brandBar == nil)
    {
        self.brandBar = [[BrandChooseBar alloc] initWithFrame:CGRectMake([AppDelegate sharePhoneWidth],
                                                                         MAIN_CONTENT_VIEW_OFFSET_Y,
                                                                         220,
                                                                         [AppDelegate sharePhoneHeight]-MAIN_CONTENT_VIEW_OFFSET_Y-FOOT_VIEW_HEIGHT
                                                                         )];
        self.brandBar.delegate = self;
        [self.view addSubview:self.brandBar];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
        [self.view addGestureRecognizer:panGes];
    }
}

- (NSMutableArray *)productsList
{
    if (_productsList == nil)
    {
        _productsList = [NSMutableArray arrayWithCapacity:0];
    }
    return _productsList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)sendWebRequest
{
    bussineDataService *buss=[bussineDataService sharedDataService];
    buss.target=self;
    [buss getProducts:self.webRequestDict];
}

#pragma mark - UITableViewDataSource
//返回分组里单元行的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isTdLayout){
        if (self.productsList.count%2==0){
            return self.productsList.count/2;
        }else{
            return self.productsList.count/2+1;
        }
    }else{
        return [self.productsList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isTdLayout)
    {
        static NSString *identifier_td = @"CustomCell_td";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_td];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_td];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            //左边
            UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(KMARGIN,KMARGIN,ITEM_WIDTH,ITEM_HEIGHT-KMARGIN)];
            leftBgView.backgroundColor = [UIColor whiteColor];
            leftBgView.layer.borderWidth = 1;
            leftBgView.layer.borderColor = BORDER_COLOR;
            leftBgView.layer.cornerRadius = 5;
            leftBgView.clipsToBounds = YES;
            [cell.contentView addSubview:leftBgView];
            
            float imageMarginW = (ITEM_WIDTH-IMAGEVIEW_WIDTH)/2;
            UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageMarginW,KMARGIN,ITEM_WIDTH-2*imageMarginW,IMAGEVIEW_HEIGHT)];
            leftImgView.tag = LEFT_IMAGEVIEW_TAG;
            leftImgView.image = [UIImage imageNamed:@"has_no_content"];
            [leftBgView addSubview:leftImgView];
            
            InsetsLabel *leftProductName = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,KMARGIN+IMAGEVIEW_HEIGHT,ITEM_WIDTH,35) andInsets:UIEdgeInsetsMake(0,KMARGIN,0,KMARGIN)];
            [leftProductName setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
            leftProductName.backgroundColor = [UIColor whiteColor];
            leftProductName.tag =LEFT_PRODUCTNAME_TAG;
            [leftProductName setFont:[UIFont systemFontOfSize:14]];
//            [leftProductName setFont:[UIFont systemFontOfSize:10]];
            [leftProductName setNumberOfLines:0];
            [leftBgView addSubview:leftProductName];
            
            InsetsLabel *leftPrice = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,KMARGIN+IMAGEVIEW_HEIGHT+35,ITEM_WIDTH/2,20) andInsets:UIEdgeInsetsMake(0,KMARGIN,0,KMARGIN)];
            leftPrice.backgroundColor = [UIColor whiteColor];
            leftPrice.tag = LEFT_PRODUCTPRICE_TAG;
            [leftPrice setTextColor:[ComponentsFactory createColorByHex:@"#ff6600"]];
            [leftPrice setFont:[UIFont systemFontOfSize:13]];
            [leftBgView addSubview:leftPrice];
            
            CrossLineLable *leftOrginPrice= [[CrossLineLable alloc] initWithFrame:CGRectMake(ITEM_WIDTH/2-KMARGIN,KMARGIN+IMAGEVIEW_HEIGHT+35,ITEM_WIDTH/2,20)];
#ifdef __IPHONE_6_0
            leftOrginPrice.textAlignment = NSTextAlignmentRight;
#else
            leftOrginPrice.textAlignment = UITextAlignmentRight;
#endif
            leftOrginPrice.backgroundColor = [UIColor whiteColor];
            leftOrginPrice.tag = LEFT_ORGINPRICE_TAG;
//            [leftOrginPrice setFont:[UIFont systemFontOfSize:10]];
            [leftOrginPrice setFont:[UIFont systemFontOfSize:13]];
            [leftOrginPrice setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
            [leftBgView addSubview:leftOrginPrice];
            
            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            leftBtn.frame = leftBgView.bounds;
            leftBtn.tag = LEFT_BTN_TAG;
            [leftBgView addSubview:leftBtn];
            
            //右边
            UIView *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(2*KMARGIN+ITEM_WIDTH,KMARGIN,ITEM_WIDTH,ITEM_HEIGHT-KMARGIN)];
            rightBgView.backgroundColor = [UIColor whiteColor];
            rightBgView.layer.borderWidth = 1;
            rightBgView.layer.borderColor = BORDER_COLOR;
            rightBgView.layer.cornerRadius = 5;
            rightBgView.clipsToBounds = YES;
            [cell.contentView addSubview:rightBgView];
            
            UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageMarginW,KMARGIN,ITEM_WIDTH-2*imageMarginW,IMAGEVIEW_HEIGHT)];
            rightImgView.tag = RIGHT_IMAGEVIEW_TAG;
            rightImgView.image = [UIImage imageNamed:@"has_no_content"];
            rightImgView.backgroundColor = [UIColor whiteColor];
            [rightBgView addSubview:rightImgView];
            
            InsetsLabel *rightProductName = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,IMAGEVIEW_HEIGHT+KMARGIN,ITEM_WIDTH,35) andInsets:UIEdgeInsetsMake(0,KMARGIN,0,KMARGIN)];
            [rightProductName setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
            rightProductName.backgroundColor = [UIColor whiteColor];
            rightProductName.tag = RIGHT_PRODUCTNAME_TAG;
//            [rightProductName setFont:[UIFont systemFontOfSize:10]];
            [rightProductName setFont:[UIFont systemFontOfSize:14]];
            [rightProductName setNumberOfLines:0];
            [rightBgView addSubview:rightProductName];
            
            InsetsLabel *rightPrice = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,IMAGEVIEW_HEIGHT+KMARGIN+35,ITEM_WIDTH/2,20) andInsets:UIEdgeInsetsMake(0,KMARGIN,0,KMARGIN)];
            rightPrice.backgroundColor = [UIColor whiteColor];
            [rightPrice setTextColor:[ComponentsFactory createColorByHex:@"#ff6600"]];
            rightPrice.tag =  RIGHT_PRODUCTPRICE_TAG;
            [rightPrice setFont:[UIFont systemFontOfSize:14]];
//            [rightPrice setFont:[UIFont systemFontOfSize:13]];
            [rightBgView addSubview:rightPrice];
            CrossLineLable *rightOrginPrice= [[CrossLineLable alloc] initWithFrame:CGRectMake(ITEM_WIDTH/2-KMARGIN,KMARGIN+IMAGEVIEW_HEIGHT+35,ITEM_WIDTH/2,20)];
#ifdef __IPHONE_6_0
            rightOrginPrice.textAlignment = NSTextAlignmentRight;
#else
            rightOrginPrice.textAlignment = UITextAlignmentRight;
#endif
            rightOrginPrice.backgroundColor = [UIColor whiteColor];
            rightOrginPrice.tag = RIGHT_ORGINPRICE_TAG;
            [rightOrginPrice setFont:[UIFont systemFontOfSize:13]];
//            [rightOrginPrice setFont:[UIFont systemFontOfSize:10]];
            [rightOrginPrice setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
            [rightBgView addSubview:rightOrginPrice];
            
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            rightBtn.frame = rightBgView.bounds;
            rightBtn.tag = RIGHT_BTN_TAG;
            [rightBgView addSubview:rightBtn];

            
//            //左边
//            UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(KMARGIN,KMARGIN,ITEM_WIDTH,ITEM_HEIGHT)];
//            leftBgView.backgroundColor = [UIColor whiteColor];
//            leftBgView.layer.borderWidth = 1;
//            leftBgView.layer.borderColor = BORDER_COLOR;
//            leftBgView.layer.cornerRadius = 5;
//            leftBgView.clipsToBounds = YES;
//            [cell.contentView addSubview:leftBgView];
//            
//            UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(KMARGIN,KMARGIN,ITEM_WIDTH-2*KMARGIN,IMAGEVIEW_HEIGHT)];
//            leftImgView.tag = LEFT_IMAGEVIEW_TAG;
//            leftImgView.image = [UIImage imageNamed:@"has_no_content"];
//            [leftBgView addSubview:leftImgView];
//            
//            InsetsLabel *leftProductName = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,KMARGIN+IMAGEVIEW_HEIGHT,ITEM_WIDTH,LABLE_HEIGHT) andInsets:UIEdgeInsetsMake(0,KMARGIN,0,KMARGIN)];
//            [leftProductName setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
//            leftProductName.backgroundColor = [UIColor whiteColor];
//            leftProductName.tag =LEFT_PRODUCTNAME_TAG;
//            [leftProductName setFont:[UIFont systemFontOfSize:10]];
//            [leftProductName setNumberOfLines:0];
//            [leftBgView addSubview:leftProductName];
//            
//            InsetsLabel *leftPrice = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,KMARGIN+IMAGEVIEW_HEIGHT+LABLE_HEIGHT,ITEM_WIDTH/2,LABLE_HEIGHT) andInsets:UIEdgeInsetsMake(0,KMARGIN,0,KMARGIN)];
//            leftPrice.backgroundColor = [UIColor whiteColor];
//            leftPrice.tag = LEFT_PRODUCTPRICE_TAG;
//            [leftPrice setTextColor:[ComponentsFactory createColorByHex:@"#ff6600"]];
//            [leftPrice setFont:[UIFont systemFontOfSize:13]];
//            [leftBgView addSubview:leftPrice];
//            
//            CrossLineLable *leftOrginPrice= [[CrossLineLable alloc] initWithFrame:CGRectMake(ITEM_WIDTH/2-KMARGIN,KMARGIN+IMAGEVIEW_HEIGHT+LABLE_HEIGHT,ITEM_WIDTH/2,LABLE_HEIGHT)];
//#ifdef __IPHONE_6_0
//            leftOrginPrice.textAlignment = NSTextAlignmentRight;
//#else
//            leftOrginPrice.textAlignment = UITextAlignmentRight;
//#endif
//            leftOrginPrice.backgroundColor = [UIColor whiteColor];
//            leftOrginPrice.tag = LEFT_ORGINPRICE_TAG;
//            [leftOrginPrice setFont:[UIFont systemFontOfSize:10]];
//            [leftOrginPrice setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
//            [leftBgView addSubview:leftOrginPrice];
//            
//            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [leftBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//            leftBtn.frame = leftBgView.bounds;
//            leftBtn.tag = LEFT_BTN_TAG;
//            [leftBgView addSubview:leftBtn];
//            
//            //右边
//            
//            UIView *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(2*KMARGIN+ITEM_WIDTH,KMARGIN,ITEM_WIDTH,ITEM_HEIGHT)];
//            rightBgView.backgroundColor = [UIColor whiteColor];
//            rightBgView.layer.borderWidth = 1;
//            rightBgView.layer.borderColor = BORDER_COLOR;
//            rightBgView.layer.cornerRadius = 5;
//            rightBgView.clipsToBounds = YES;
//            [cell.contentView addSubview:rightBgView];
//            
//            UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(KMARGIN,KMARGIN,ITEM_WIDTH-2*KMARGIN,IMAGEVIEW_HEIGHT)];
//            rightImgView.tag = RIGHT_IMAGEVIEW_TAG;
//            rightImgView.image = [UIImage imageNamed:@"has_no_content"];
//            rightImgView.backgroundColor = [UIColor whiteColor];
//            [rightBgView addSubview:rightImgView];
//            
//            InsetsLabel *rightProductName = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,IMAGEVIEW_HEIGHT+KMARGIN,ITEM_WIDTH,LABLE_HEIGHT) andInsets:UIEdgeInsetsMake(0,KMARGIN,0,KMARGIN)];
//            [rightProductName setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
//            rightProductName.backgroundColor = [UIColor whiteColor];
//            rightProductName.tag = RIGHT_PRODUCTNAME_TAG;
//            [rightProductName setFont:[UIFont systemFontOfSize:10]];
//            [rightProductName setNumberOfLines:0];
//            [rightBgView addSubview:rightProductName];
//            
//            InsetsLabel *rightPrice = [[InsetsLabel alloc] initWithFrame:CGRectMake(0,IMAGEVIEW_HEIGHT+KMARGIN+LABLE_HEIGHT,ITEM_WIDTH/2,LABLE_HEIGHT) andInsets:UIEdgeInsetsMake(0,KMARGIN,0,KMARGIN)];
//            rightPrice.backgroundColor = [UIColor whiteColor];
//            [rightPrice setTextColor:[ComponentsFactory createColorByHex:@"#ff6600"]];
//            rightPrice.tag =  RIGHT_PRODUCTPRICE_TAG;
//            [rightPrice setFont:[UIFont systemFontOfSize:13]];
//            [rightBgView addSubview:rightPrice];
//            
//            CrossLineLable *rightOrginPrice= [[CrossLineLable alloc] initWithFrame:CGRectMake(ITEM_WIDTH/2-KMARGIN,KMARGIN+IMAGEVIEW_HEIGHT+LABLE_HEIGHT,ITEM_WIDTH/2,LABLE_HEIGHT)];
//#ifdef __IPHONE_6_0
//            rightOrginPrice.textAlignment = NSTextAlignmentRight;
//#else
//            rightOrginPrice.textAlignment = UITextAlignmentRight;
//#endif
//            rightOrginPrice.backgroundColor = [UIColor whiteColor];
//            rightOrginPrice.tag = RIGHT_ORGINPRICE_TAG;
//            [rightOrginPrice setFont:[UIFont systemFontOfSize:10]];
//            [rightOrginPrice setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
//            [rightBgView addSubview:rightOrginPrice];
//            
//            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//            rightBtn.frame = rightBgView.bounds;
//            rightBtn.tag = RIGHT_BTN_TAG;
//            [rightBgView addSubview:rightBtn];
        }
        
        UIImageView *leftImgView = (UIImageView *)[cell viewWithTag:LEFT_IMAGEVIEW_TAG];
        InsetsLabel *leftProductName = (InsetsLabel *)[cell viewWithTag:LEFT_PRODUCTNAME_TAG];
        InsetsLabel *leftPrice = (InsetsLabel *)[cell viewWithTag:LEFT_PRODUCTPRICE_TAG];
        CrossLineLable *leftOriginPrice = (CrossLineLable *)[cell viewWithTag:LEFT_ORGINPRICE_TAG];
        UIButton *leftBtn = (UIButton *)[cell viewWithTag:LEFT_BTN_TAG];
        
        UIImageView *rightImgView = (UIImageView *)[cell viewWithTag:RIGHT_IMAGEVIEW_TAG];
        InsetsLabel *rightProductName = (InsetsLabel *)[cell viewWithTag:RIGHT_PRODUCTNAME_TAG];
        InsetsLabel *rightPrice = (InsetsLabel *)[cell viewWithTag:RIGHT_PRODUCTPRICE_TAG];
        CrossLineLable *rightOriginPrice = (CrossLineLable *)[cell viewWithTag:RIGHT_ORGINPRICE_TAG];
        UIButton *rightBtn = (UIButton *)[cell viewWithTag:RIGHT_BTN_TAG];
        
        ProductModel *product = [self.productsList objectAtIndex:[indexPath row]*2];
        
        leftProductName.text = product.name;
        leftPrice.text = [NSString stringWithFormat:@"¥%@",product.discountPrice];
        leftOriginPrice.text = [NSString stringWithFormat:@"¥%@",product.sailPrice];
        leftBtn.titleLabel.text = product.clickURL;
        if (hasCachedImage([NSURL URLWithString:product.imgURL]))
        {
            leftImgView.image=[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:product.imgURL])];
        }
        else
        {
            BOOL IsLoadImage=YES;
            NSMutableArray *NowArr=[[NSMutableArray alloc] initWithCapacity:0];
            [NowArr setArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"NowLoad"]];
            for(int i=0;i<[NowArr count];i++)
            {
                if([[NowArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%dLeft",product.imgURL,indexPath.row*2]])
                {
                    IsLoadImage=NO;
                    break;
                }
            }
            if(IsLoadImage)
            {
                [NowArr addObject:[NSString stringWithFormat:@"%@%dLeft",product.imgURL,indexPath.row*2]];
                [[NSUserDefaults standardUserDefaults] setObject:NowArr forKey:@"NowLoad"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:product.imgURL,@"Url",nil];
                [ComponentsFactory dispatch_process_with_thread:^{
                    UIImage* img = [self LoadImage:dic];
                    return img;
                } result:^(UIImage *ima){
                    leftImgView.image=ima;
                }];
            }
        }
        rightImgView.hidden = NO;
        rightProductName.hidden = NO;
        rightPrice.hidden = NO;
        rightOriginPrice.hidden = NO;
        rightImgView.superview.hidden = NO;
        //如果为奇数
        if ([self.productsList count]%2!=0)
        {
            if ([self.productsList count]/2==indexPath.row)
            {
                rightImgView.hidden = YES;
                rightProductName.hidden = YES;
                rightPrice.hidden = YES;
                rightOriginPrice.hidden = YES;
                rightImgView.superview.hidden = YES;
            }
            else
            {
                product = [self.productsList objectAtIndex:indexPath.row*2+1];
                rightProductName.text = product.name;
                rightBtn.titleLabel.text = product.clickURL;
                rightPrice.text = [NSString stringWithFormat:@"¥%@",product.discountPrice];
                rightOriginPrice.text = [NSString stringWithFormat:@"¥%@",product.sailPrice];
                
                if (hasCachedImage([NSURL URLWithString:product.imgURL]))
                {
                    rightImgView.image=[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:product.imgURL])];
                }
                else
                {
                    BOOL IsLoadImage=YES;
                    NSMutableArray *NowArr=[[NSMutableArray alloc] initWithCapacity:0];
                    [NowArr setArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"NowLoad"]];
                    for(int i=0;i<[NowArr count];i++)
                    {
                        if([[NowArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%dRight",product.imgURL,indexPath.row*2+1]])
                        {
                            IsLoadImage=NO;
                            break;
                        }
                    }
                    if(IsLoadImage)
                    {
                        [NowArr addObject:[NSString stringWithFormat:@"%@%dRight",product.imgURL,indexPath.row*2+1]];
                        [[NSUserDefaults standardUserDefaults] setObject:NowArr forKey:@"NowLoad"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:product.imgURL,@"Url",nil];
                        [ComponentsFactory dispatch_process_with_thread:^{
                            UIImage* img = [self LoadImage:dic];
                            return img;
                        } result:^(UIImage *ima){
                            rightImgView.image=ima;
                        }];
                    }
                }
                
            }
        }
        else
        {
            product = [self.productsList objectAtIndex:indexPath.row*2+1];
            rightBtn.titleLabel.text = product.clickURL;
            rightProductName.text = product.name;
            rightPrice.text = [NSString stringWithFormat:@"¥%@",product.discountPrice];
            rightOriginPrice.text = [NSString stringWithFormat:@"¥%@",product.sailPrice];
            if (hasCachedImage([NSURL URLWithString:product.imgURL]))
            {
                rightImgView.image=[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:product.imgURL])];
            }
            else
            {
                BOOL IsLoadImage=YES;
                NSMutableArray *NowArr=[[NSMutableArray alloc] initWithCapacity:0];
                [NowArr setArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"NowLoad"]];
                for(int i=0;i<[NowArr count];i++)
                {
                    if([[NowArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%dRight",product.imgURL,indexPath.row*2+1]])
                    {
                        IsLoadImage=NO;
                        break;
                    }
                }
                if(IsLoadImage)
                {
                    [NowArr addObject:[NSString stringWithFormat:@"%@%dRight",product.imgURL,indexPath.row*2+1]];
                    [[NSUserDefaults standardUserDefaults] setObject:NowArr forKey:@"NowLoad"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:product.imgURL,@"Url",nil];
                    [ComponentsFactory dispatch_process_with_thread:^{
                        UIImage* img = [self LoadImage:dic];
                        return img;
                    } result:^(UIImage *ima){
                        rightImgView.image=ima;
                    }];
                }
            }
        }
        return cell;
    }
    else
    {
        static NSString *identifier_tr = @"CustomCell_tr";
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_tr];
        if (cell == nil)
        {
            cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_tr];
        }
        cell.product = self.productsList[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isTdLayout) {
        return ITEM_HEIGHT;
    }else{
        return 95;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UrlParser gotoNewVCWithUrl:[self.productsList[indexPath.row] clickURL] VC:self];
}

-(void)btnClicked:(UIButton *)sender
{
    UIButton* clickBtn = (UIButton*)sender;
    NSString* clickUrl = clickBtn.titleLabel.text;
    if(clickUrl != nil && clickUrl.length >0)
    {
        [UrlParser gotoNewVCWithUrl:clickUrl VC:self];
    }
}


-(UIImage *)LoadImage:(NSDictionary*)aDic{
    
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"Url"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil)
    {
        return [UIImage imageNamed:@"loadpicture.png"];
    }
    [fileManager createFileAtPath:pathForURL(aURL) contents:data attributes:nil];
    return image;
}

#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if ([[ProductsMessage getBizCode] isEqualToString:bizCode])
    {
        if ([oKCode isEqualToString:errCode])
        {
            bussineDataService *bus=[bussineDataService sharedDataService];
            NSArray *dataList = bus.rspInfo[@"dataList"];
            if (dataList.count == 0)
            {
                [self ShowProgressHUDwithMessage:@"没有更多商品了"];
            }
            else
            {
                for (NSDictionary *dict in dataList)
                {
                    ProductModel *item = [[ProductModel alloc] init];
                    item.ID = dict[@"productId"];
                    item.name = dict[@"name"];
                    item.imgURL = dict[@"imgURL"];
                    item.desc = dict[@"desc"] == [NSNull null]?@"":dict[@"desc"];
                    item.sellCount = dict[@"sellCount"];
                    item.sailPrice = dict[@"sailPrice"];
                    item.discountPrice = dict[@"discountPrice"];
                    item.contractPrice = dict[@"contractPrice"];
                    item.clickURL = dict[@"clickUrl"];
                    item.moduleId = dict[@"moduleId"];
                    [self.productsList addObject:item];
                }
                [self.productsTable reloadData];
                self.typeList = bus.rspInfo[@"productType"][@"typeList"] == [NSNull null]? nil:bus.rspInfo[@"productType"][@"typeList"];
                if (self.typeList != nil && self.typeList.count != 0)
                {
                    [self initBrandChooseView];
                    self.brandBar.brands = self.typeList;
                }
                //更新页码
                self.currentPage ++;
                [self.webRequestDict setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"pageIndex"];
            }
            if (self.productsList.count == 0 || self.productsList == nil)
            {
                self.noContentImageView.hidden = NO;
            }
            else
            {
                self.noContentImageView.hidden = YES;
            }
            //调用endRefreshing结束刷新状态
            [self.productsTable footerEndRefreshing];
        }
    }
}

- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ProductsMessage getBizCode] isEqualToString:bizCode])
    {
        if([info objectForKey:@"MSG"] == [NSNull null] || nil == msg)
        {
            msg = @"请求数据失败！";
        }
        [self ShowProgressHUDwithMessage:msg];
    }
    //结束刷新状态
    [self.productsTable footerEndRefreshing];
}
- (void)cancelTimeOutAndLinkError
{
    //结束刷新状态
    [self.productsTable footerEndRefreshing];
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
#pragma
#pragma mark - BrandChooseBarDelegate

-(void)brandChooseBar:(BrandChooseBar *)bar didSelectedRowAtIndex:(NSInteger)index
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
    if (self.moduleId == 0)
    {
        [self.webRequestDict setObject:self.typeList[index][@"id"] forKey:@"phoneBrand"];
    }
    else if (self.moduleId == 1004 ||self.moduleId == 1001) {
        [self.webRequestDict setObject:self.typeList[index][@"id"] forKey:@"phoneBrand"];
    }
    else
    {
        [self.webRequestDict setObject:self.typeList[index][@"id"] forKey:@"speciseId"];
    }
    self.currentPage = 1;
    [self.webRequestDict setObject:@"1" forKey:@"pageIndex"];
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;
    [self.productsList removeAllObjects];
    [self.productsTable reloadData];
    [bus getProducts:self.webRequestDict];
}

#pragma
#pragma mark - TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)searchAction:(NSString *)key
{
    [self.webRequestDict setObject:key forKey:@"searchKey"];
    [self.webRequestDict setObject:@"1" forKey:@"pageIndex"];
    [self.productsList removeAllObjects];
    [self.productsTable reloadData];
    [self sendWebRequest];
}


- (void)timeByCount:(UIButton *)sender {
    sortByTimeSelected = !sortByTimeSelected;
    if (sortByTimeSelected)
    {
        sortByPriceSelected = NO;
        sortBySailCountSelected = NO;
        [self.webRequestDict setObject:@"6" forKey:@"sortType"];
//        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        [self.btnList[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.btnList[2] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.webRequestDict setObject:@"5" forKey:@"sortType"];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.btnList[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnList[2] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    self.currentPage = 1;
    [self.webRequestDict setObject:@"1" forKey:@"pageIndex"];
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;
    [self.productsList removeAllObjects];
    [self.productsTable reloadData];
    [bus getProducts:self.webRequestDict];
}

- (void)sortByPrice:(UIButton *)sender
{
    sortByPriceSelected = !sortByPriceSelected;
    if (sortByPriceSelected)
    {
        sortBySailCountSelected = NO;
        sortByTimeSelected = NO;
        [self.webRequestDict setObject:@"3" forKey:@"sortType"];
//        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        [self.btnList[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.btnList[2] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.webRequestDict setObject:@"4" forKey:@"sortType"];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.btnList[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnList[2] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.currentPage = 1;
    [self.webRequestDict setObject:@"1" forKey:@"pageIndex"];
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;
    [self.productsList removeAllObjects];
    [self.productsTable reloadData];
    [bus getProducts:self.webRequestDict];
}
- (void)sortBySailCount:(UIButton *)sender
{
    sortBySailCountSelected = !sortBySailCountSelected;
    if (sortBySailCountSelected)
    {
        sortByPriceSelected = NO;
        sortByTimeSelected = NO;
        [self.webRequestDict setObject:@"2" forKey:@"sortType"];
//        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        [self.btnList[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.btnList[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.webRequestDict setObject:@"1" forKey:@"sortType"];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
     [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.btnList[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnList[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.currentPage = 1;
    [self.webRequestDict setObject:@"1" forKey:@"pageIndex"];
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;
    [self.productsList removeAllObjects];
    [self.productsTable reloadData];
    [bus getProducts:self.webRequestDict];

}
- (void)sortByType:(UIButton *)sender
{
    if (sideBarShowing) {
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
    }
    else
    {
        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
    }
}
#pragma mark - 拖动手势
-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat translation = [gestureRecognizer translationInView:self.view].x;
        if(translation+currentTranslate<0&&translation+currentTranslate>ContentOffset)
        {
            self.brandBar.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        }
	}
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
		currentTranslate = self.brandBar.transform.tx;
        if (!sideBarShowing)
        {//左边
            if (currentTranslate>=ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }
            else if(currentTranslate<ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }
        }
        else//全屏
        {
            if (currentTranslate<=ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }
            else if(currentTranslate>ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }
        }
	}
}

//滑动中的动画
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.brandBar.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.brandBar.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        if (direction == SideBarShowDirectionNone)
        {
            sideBarShowing = NO;
        }
        else
        {
            sideBarShowing = YES;
        }
        currentTranslate =self.brandBar.transform.tx;
	};
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

//滚动到表单顶部
- (void)scrollToTop
{
    [self.productsTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

//上拉刷新时调用
- (void)getNextPage
{
    bussineDataService *bus=[bussineDataService sharedDataService];
    bus.target = self;
    [bus getProducts:self.webRequestDict];
}


#pragma mark - UIScrollViewDelegate

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    sideBarShowing = NO;
    NSLog(@"    huandong   stat  ");
     [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    sideBarShowing = NO;
    NSLog(@"    huandong    end ");
}

@end

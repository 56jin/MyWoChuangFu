#import "ProductsVC.h"
#import "ProductCell.h"
#import "ProductModel.h"
#import "MJRefresh.h"
#import "bussiness/bussineDataService.h"
#import "ProductDetailVC.h"
#import "AppDelegate.h"
#import "TitleBar.h"
#import "ZSYCommonPickerView.h"
#import "DataDictionary_back_cart_item.h"
#import "UrlParser.h"

#define PAGE_COUNT @"20"      //每页多少数据
#define NAVBAR_HEIGHT 64      //导航栏高度
#define PHONE_CONTENT_HEIGHT [AppDelegate sharePhoneContentHeight] //屏幕高度除去手机工具栏高度
#define PHONE_WIDTH [AppDelegate sharePhoneWidth] //手机宽度
#define PHONE_HEIGHT [AppDelegate sharePhoneHeight] //手机高度
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a] //RGB颜色
#define TOPBUTTONWIDTH 34 //回到顶部button宽度
#define TOPBUTTONHEIGHT 34 //回到顶部button高度

static NSString *identifier = @"CustomCell";
@interface ProductsVC ()<UITableViewDataSource,UITableViewDelegate,HttpBackDelegate,TitleBarDelegate>

@property (nonatomic,strong) NSMutableArray      *dataSources;           //数据源
@property (nonatomic,strong) UITableView         *myTableView;           //表单视图
@property (nonatomic,assign) int                 pageIndex;              //当前页
@property (nonatomic,strong) NSMutableDictionary *requestDict;           //请求参数字典
@property (nonatomic,strong) ZSYCommonPickerView *pricePickerView;
@property (nonatomic,strong) ZSYCommonPickerView *sortCountPickerView;
@property (nonatomic,strong) ZSYCommonPickerView *typePickerView;
@property (nonatomic,strong) NSArray             *typeList;
@property (nonatomic,strong) NSMutableArray      *btnList;
@property (nonatomic,assign) int                 moduleId;

@end

@implementation ProductsVC
{
    ProductDetailVC *productDetailVC;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if (self.params[@"moduleId"] != [NSNull null])
    {
        self.moduleId = [self.params[@"moduleId"] intValue];
    }
    self.pageIndex = 1;
    bussineDataService *bus=[bussineDataService sharedDataService];
    bus.target=self;
    _requestDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    @"",@"filter",
                    self.params[@"searchKey"]==nil?@"":self.params[@"searchKey"],@"searchKey",
                    @"",@"phoneBrand",
                    self.params[@"moduleId"],@"moduleId",
                    self.params[@"developId"],@"developerId",
                    @"initSearch",@"requestType",
                    @"",@"sortType",
                    @"1",@"pageIndex",
                    PAGE_COUNT,@"pageCount",
                    @"1",@"needType",
                    @"",@"speciseId",nil];
    [bus getProducts:_requestDict];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self LayoutV];
}

//布局界面
- (void)LayoutV
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:middle_position];
    titleBar.title = @"商品列表";
    titleBar.target = self;
    if (IOS7)
        titleBar.frame = CGRectMake(0, 20, PHONE_WIDTH, 44);
    [self.view addSubview:titleBar];
    
    // 表单视图
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, PHONE_WIDTH, PHONE_HEIGHT - NAVBAR_HEIGHT - 44) style:UITableViewStylePlain];
    tableView.backgroundColor = RGBCOLOR(235, 236, 241, 1);
    tableView.rowHeight = 95;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView = tableView;
    
    // 上拉加载更多
    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableView];
    
    //筛选栏
    UIView *view =  [[UIView alloc] init];
    view.frame = CGRectMake(0, PHONE_HEIGHT - 44, PHONE_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    CGFloat width = PHONE_WIDTH/3;
    //按价格排序
    UIButton *priceFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceFilterBtn setTitle:@"按价格排序" forState:UIControlStateNormal];
    priceFilterBtn.frame = CGRectMake(0, 0, width - 1, 44);
    [priceFilterBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [priceFilterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [priceFilterBtn addTarget:self action:@selector(sortByPrice:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:priceFilterBtn];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sifeBar_line_s"]];
    imageView1.frame = CGRectMake(width, 2, 1, 40);
    [view addSubview:imageView1];
    
    //按销量排序
    UIButton *sailFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sailFilterBtn setTitle:@"按销量排序" forState:UIControlStateNormal];
    sailFilterBtn.frame = CGRectMake(width, 0, width - 1, 44);
    [sailFilterBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [sailFilterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sailFilterBtn addTarget:self action:@selector(sortBySailCount:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sailFilterBtn];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sifeBar_line_s"]];
    imageView2.frame = CGRectMake(width*2, 2, 1, 40);
    [view addSubview:imageView2];
    
    //按价格排序
    UIButton *typeFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeFilterBtn setTitle:@"按分类排序" forState:UIControlStateNormal];
    typeFilterBtn.frame = CGRectMake(width*2, 0, width, 44);
    [typeFilterBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [typeFilterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [typeFilterBtn addTarget:self action:@selector(sortByType:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:typeFilterBtn];
    self.btnList = [NSMutableArray arrayWithObjects:priceFilterBtn,sailFilterBtn,typeFilterBtn, nil];
    
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setImage:[UIImage imageNamed:@"btn_list_top_n"] forState:UIControlStateNormal];
    [topBtn setImage:[UIImage imageNamed:@"btn_list_top_p"] forState:UIControlStateHighlighted];
    [topBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [topBtn setFrame:CGRectMake(PHONE_WIDTH - TOPBUTTONWIDTH - 25, PHONE_HEIGHT - 100, TOPBUTTONWIDTH,TOPBUTTONHEIGHT)];
    [self.view addSubview:topBtn];
}

- (void)sortByPrice:(UIButton *)sender
{
    [self.requestDict setObject:[NSString stringWithFormat:@"%d",3] forKey:@"sortType"];
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.btnList[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnList[1] setTitle:@"按销量排序" forState:UIControlStateNormal];
    [self.btnList[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.pageIndex = 1;
    [self.requestDict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;
    [self.dataSources removeAllObjects];
    [self.myTableView reloadData];
    [bus getProducts:self.requestDict];
    
    
//    if (nil == _pricePickerView)
//    {
//        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
//        DataDictionary_back_cart_item *item1 = [[DataDictionary_back_cart_item alloc] init];
//        item1.ITEM_NAME =@"按价格排序";
//        DataDictionary_back_cart_item *item2 = [[DataDictionary_back_cart_item alloc] init];
//        item2.ITEM_NAME =@"价格从低到高";
//        DataDictionary_back_cart_item *item3 = [[DataDictionary_back_cart_item alloc] init];
//        item3.ITEM_NAME =@"价格从高到低";
//        [array addObject:item1];
//        [array addObject:item2];
//        [array addObject:item3];
//        _pricePickerView = [[ZSYCommonPickerView alloc] initWithTitle:@"按价格排序"
//                                                           includeAll:NO
//                                                           dataSource:array
//                                                    selectedIndexPath:0
//                                                             Firstrow:nil
//                                                    cancelButtonBlock:^{
//                                                        
//                                                    } makeSureButtonBlock:^(NSInteger indexPath) {
//                                                        if (0 == indexPath)
//                                                        {
//                                                            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                                                            [self.requestDict setObject:@"" forKey:@"sortType"];
//                                                        }
//                                                        else
//                                                        {
//                                                            [self.requestDict setObject:[NSString stringWithFormat:@"%d",indexPath + 2] forKey:@"sortType"];
//                                                            [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//                                                        }
//                                                        [self.btnList[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                                                        [self.btnList[1] setTitle:@"按销量排序" forState:UIControlStateNormal];
//                                                        [self.btnList[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                                                        self.pageIndex = 1;
//                                                        [self.requestDict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
//                                                        bussineDataService *bus = [bussineDataService sharedDataService];
//                                                        bus.target = self;
//                                                        [self.dataSources removeAllObjects];
//                                                        [self.myTableView reloadData];
//                                                        [bus getProducts:self.requestDict];
//                                                        [sender setTitle:[(DataDictionary_back_cart_item *)array[indexPath] ITEM_NAME] forState:UIControlStateNormal];
//                                                    }];
//    }
//    
//    [_pricePickerView show];
}
- (void)sortBySailCount:(UIButton *)sender
{
    if (nil == _sortCountPickerView)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
        DataDictionary_back_cart_item *item1 = [[DataDictionary_back_cart_item alloc] init];
        item1.ITEM_NAME =@"按销量排序";
        DataDictionary_back_cart_item *item2 = [[DataDictionary_back_cart_item alloc] init];
        item2.ITEM_NAME =@"销量从低到高";
        DataDictionary_back_cart_item *item3 = [[DataDictionary_back_cart_item alloc] init];
        item3.ITEM_NAME =@"销量从高到低";
        [array addObject:item1];
        [array addObject:item2];
        [array addObject:item3];
        
        _sortCountPickerView = [[ZSYCommonPickerView alloc] initWithTitle:@"按销量排序"
                                                               includeAll:NO
                                                               dataSource:array
                                                        selectedIndexPath:0
                                                                 Firstrow:nil
                                                        cancelButtonBlock:^{
                                                            
                                                        } makeSureButtonBlock:^(NSInteger indexPath) {
                                                            if (0 == indexPath)
                                                            {
                                                                [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                                                [self.requestDict setObject:@"" forKey:@"sortType"];
                                                            }
                                                            else
                                                            {
                                                                [self.requestDict setObject:[NSString stringWithFormat:@"%d",indexPath] forKey:@"sortType"];
                                                                [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                                                            }
                                                            [self.btnList[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                                            [self.btnList[0] setTitle:@"按销量排序" forState:UIControlStateNormal];
                                                            self.pageIndex = 1;
                                                            [self.requestDict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
                                                            bussineDataService *bus = [bussineDataService sharedDataService];
                                                            bus.target = self;
                                                            [self.dataSources removeAllObjects];
                                                            [self.myTableView reloadData];
                                                            [bus getProducts:self.requestDict];
                                                            [sender setTitle:[(DataDictionary_back_cart_item *)array[indexPath] ITEM_NAME] forState:UIControlStateNormal];
                                                        }];
    }
    
    [_sortCountPickerView show];
}
- (void)sortByType:(UIButton *)sender
{
    if (nil == _typePickerView)
    {
        NSMutableArray *array = nil;
        if (self.typeList == nil || self.typeList.count == 0)
        {
            DataDictionary_back_cart_item *item = [[DataDictionary_back_cart_item alloc] init];
            item.ITEM_NAME =@"按分类排序";
            array = [NSMutableArray arrayWithObjects:item,nil];
        }
        else
        {
            array = [NSMutableArray arrayWithCapacity:self.typeList.count + 1];
            DataDictionary_back_cart_item *item = [[DataDictionary_back_cart_item alloc] init];
            item.ITEM_NAME =@"按分类排序";
            array = [NSMutableArray arrayWithObjects:item,nil];
            for (int i = 0; i < self.typeList.count; i++)
            {
                DataDictionary_back_cart_item *item = [[DataDictionary_back_cart_item alloc] init];
                item.ITEM_NAME = self.typeList[i][@"name"];
                item.ITEM_CODE = self.typeList[i][@"id"];
                [array addObject:item];
            }
        }
        _typePickerView = [[ZSYCommonPickerView alloc] initWithTitle:@"按分类排序"
                                                          includeAll:NO
                                                          dataSource:array
                                                   selectedIndexPath:0
                                                            Firstrow:nil
                                                   cancelButtonBlock:^{
                                                       
                                                   } makeSureButtonBlock:^(NSInteger indexPath) {
                                                       if (0 == indexPath)
                                                       {
                                                           [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                                           [self.requestDict setObject:@"" forKey:@"speciseId"];
                                                           [self.requestDict setObject:@"" forKey:@"phoneBrand"];
                                                       }
                                                       else
                                                       {
                                                           DataDictionary_back_cart_item *item = array[indexPath];
                                                           if (self.moduleId == 0)
                                                           {
                                                               [self.requestDict setObject:item.ITEM_CODE forKey:@"phoneBrand"];
                                                           }
                                                           else if (self.moduleId == 1004 ||self.moduleId == 1001) {
                                                                [self.requestDict setObject:item.ITEM_CODE forKey:@"phoneBrand"];
                                                           }
                                                           else
                                                           {
                                                               [self.requestDict setObject:item.ITEM_CODE forKey:@"speciseId"];
                                                           }
                                                           [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                                                       }
                                                       self.pageIndex = 1;
                                                       [self.requestDict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
                                                       DataDictionary_back_cart_item *item = array[indexPath];
                                                       [sender setTitle:item.ITEM_NAME forState:UIControlStateNormal];
                                                       bussineDataService *bus = [bussineDataService sharedDataService];
                                                       bus.target = self;
                                                       [self.dataSources removeAllObjects];
                                                       [self.myTableView reloadData];
                                                       
                                                       [bus getProducts:self.requestDict];
                                                   }];
    }
    [_typePickerView show];
}

//滚动到表单顶部
- (void)scrollToTop
{
    [_myTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

//上拉刷新时调用
- (void)footerRereshing
{
    bussineDataService *bus=[bussineDataService sharedDataService];
    bus.target = self;
    [self.requestDict setObject:[NSString stringWithFormat:@"%d",_pageIndex] forKey:@"pageIndex"];
    [bus getProducts:self.requestDict];
}

#pragma mark - dataSources
- (NSMutableArray *)dataSources
{
    if (nil == _dataSources)
    {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

#pragma mark - UITableViewDataSource
//返回分组里单元行的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.product = self.dataSources[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UrlParser gotoNewVCWithUrl:[self.dataSources[indexPath.row] clickURL] VC:self];
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
                    [self.dataSources addObject:item];
//                    [self.myTableView beginUpdates];
//                    int newRowIndex = [self.dataSources count];
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex-1<0?newRowIndex:newRowIndex-1 inSection:0];
//                    [self.myTableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//                    [self.myTableView endUpdates];
                }
                [self.myTableView reloadData];
                self.typeList = bus.rspInfo[@"productType"][@"typeList"] == [NSNull null]? nil:bus.rspInfo[@"productType"][@"typeList"];
                //更新页码
                self.pageIndex ++;
                [self.requestDict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
            }
            //调用endRefreshing结束刷新状态
            [self.myTableView footerEndRefreshing];
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
    }
    //结束刷新状态
    [self.myTableView footerEndRefreshing];
}
- (void)cancelTimeOutAndLinkError
{
    //结束刷新状态
    [self.myTableView footerEndRefreshing];
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
#pragma TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
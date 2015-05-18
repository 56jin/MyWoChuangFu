//
//  NewMainSearchVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-25.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "NewMainSearchVC.h"
#import "ProductsListVC.h"
#import "FileHelpers.h"
#import "SearchTypeBar.h"
#import "ProductsListVC.h"
#import "UrlParser.h"
#import "ShowWebVC.h"
#import "TextDeclareViewController.h"

#define SEARCHBAR_TAG 31121
#define NO_HISTORY_IMAGEVIEW_TAG 31122
#define TABLEVIEW_TAG 31124
#define LEFT_BAR_TAG  31125
#define LEFT_BAR_WIDTH 90
#define TITLE_HEIGHT (TITLE_BAR_HEIGHT+[[UIScreen mainScreen] applicationFrame].origin.y)

@interface NewMainSearchVC ()<SearchTypeBarDelegate,UISearchBarDelegate,HttpBackDelegate,TitleBarDelegate>{
    TextDeclareViewController *gotoVC;
}

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) NSMutableArray *searchHistoryList;
@property(nonatomic,assign) NSInteger      currentIndex;
@property(nonatomic,strong) UIImageView    *noSearchHistoryImageview;
@property(nonatomic,strong) NSMutableArray *groups;

@end

@implementation NewMainSearchVC


- (void)dealloc {
  
    gotoVC = nil;
}

- (void)loadView
{
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[UIColor blackColor];
    self.view = BackV;
    self.navigationController.navigationBarHidden=YES;
    
    [self initTitleBar];
    [self initLeftBar];
    [self initRightView];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if ([AppDelegate shareMyApplication].isLogin == NO) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上登录", nil];
//        [alert show];
//        
//    }
//    else{
//        
//        self.navigationController.navigationBarHidden = YES;
//        if (gotoVC == nil) {
//            gotoVC = [[TextDeclareViewController alloc] initWithNibName:@"TextDeclareViewController" bundle:nil];
//            NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
//            gotoVC.URL = [NSString stringWithFormat:@"%@/mall/goods?sessionid=%@",service_IPqq,sessionid];
//            
//           
//        }
//         [self.navigationController pushViewController:gotoVC animated:NO];
////        [UrlParser gotoNewVCWithUrl:[NSString stringWithFormat:@"%@/mall/goods",service_IPqq] VC: self];
//    }
    
    
    
    NSString *groupName = [self.groups[self.currentIndex] objectForKey:@"groupName"];
    if ([groupName isEqualToString:@"历史搜索"]) {
        self.searchHistoryList = [self getSearchHistoryList];
        if (self.searchHistoryList != nil &&self.searchHistoryList.count!=0) {
            self.noSearchHistoryImageview.hidden = YES;
            UITableView *table = (UITableView *)[self.view viewWithTag:TABLEVIEW_TAG];
            [self.dataSources removeAllObjects];
            [table reloadData];
            self.dataSources = [NSMutableArray arrayWithArray:self.searchHistoryList];
            [self updateTableWithDataSources:self.dataSources];
            table.tableFooterView.hidden = NO;
        }else{
            self.noSearchHistoryImageview.hidden = NO;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        [self sendSeachPageInfoRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark
#pragma mark - 网络请求

- (void)sendSeachPageInfoRequest
{
    bussineDataService *buss = [bussineDataService sharedDataService];
    buss.target = self;
    [buss getSearchInfo:nil];
}

#pragma mark
#pragma mark - 初始化视图
-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initTitleBar
{
    
    TitleBar* title = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:middle_position];
    [title setLeftIsHiden:NO];
    if (IOS7){
        title.frame = CGRectMake(0, 20, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
    }
    //    if(self.titleStr !=nil && self.titleStr.length >0){
    //        [title setTitle:self.titleStr];
    //    } else {
    //        [title setTitle:@"沃创富"];
    //    }
    //    [title setTitle:@"沃创富"];
    title.target = self;
    
    
    [self.view addSubview:title];

    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 20, [AppDelegate sharePhoneWidth] - 40, TITLE_BAR_HEIGHT)];
    searchBar.placeholder = @"请输入搜索关键字";
    searchBar.tag = SEARCHBAR_TAG;
    for (UIView *subView in searchBar.subviews)
    {
        for (UIView *subSubView in subView.subviews)
        {
            if ([subSubView isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subSubView removeFromSuperview];
                break;
            }
        }
    }
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:searchBar];
    
    

}

- (void)initLeftBar
{
    SearchTypeBar *searchTypeBar = [[SearchTypeBar alloc] initWithFrame:CGRectMake(0,TITLE_HEIGHT,LEFT_BAR_WIDTH, [AppDelegate sharePhoneHeight])];
    searchTypeBar.delegate = self;
    searchTypeBar.tag = LEFT_BAR_TAG;
    [self.view addSubview:searchTypeBar];
}
- (void)initRightView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(LEFT_BAR_WIDTH,TITLE_HEIGHT,[AppDelegate sharePhoneWidth]-LEFT_BAR_WIDTH, [AppDelegate sharePhoneHeight]) style:UITableViewStylePlain];
    tableView.tag = TABLEVIEW_TAG;
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[AppDelegate sharePhoneWidth]-LEFT_BAR_WIDTH,40)];
    btnBgView.layer.cornerRadius = 5;
    [btnBgView setClipsToBounds:YES];
    [btnBgView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *clearHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearHistoryBtn setBackgroundColor:[UIColor orangeColor]];
    [clearHistoryBtn setTitle:@"清空搜索纪录" forState:UIControlStateNormal];
    clearHistoryBtn.frame =CGRectMake(10,5,[AppDelegate sharePhoneWidth]-LEFT_BAR_WIDTH-20, 30);
    [clearHistoryBtn addTarget:self action:@selector(clearSearchHistroy) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBgView addSubview:clearHistoryBtn];
    tableView.tableFooterView = btnBgView;
    tableView.tableFooterView.hidden = YES;
    
    UIImage *image = [UIImage imageNamed:@"no_search_history"];
    UIImageView *imageview= [[UIImageView alloc] initWithImage:image];
    imageview.backgroundColor = [UIColor whiteColor];
    imageview.tag = NO_HISTORY_IMAGEVIEW_TAG;
    imageview.center = CGPointMake(tableView.frame.size.width/2, tableView.frame.size.height/2);
    self.noSearchHistoryImageview = imageview;
    imageview.userInteractionEnabled = YES;
    self.noSearchHistoryImageview.hidden = YES;
    [tableView addSubview:imageview];
}

#pragma mark
#pragma mark - SearchTypeBarDelegate

- (void)searchTypeBar:(SearchTypeBar *)searchTypeBar didSelectAtIndex:(NSInteger)index
{
    UITableView *table = (UITableView *)[self.view viewWithTag:TABLEVIEW_TAG];
    self.dataSources = nil;
    [table reloadData];
    self.currentIndex = index;
    NSDictionary *group = self.groups[index];
    NSString *groupName = [group objectForKey:@"groupName"];
    if ([groupName isEqualToString:@"历史搜索"]) {
        self.searchHistoryList = [NSMutableArray arrayWithArray:[self getSearchHistoryList]];
        if (self.searchHistoryList.count!= 0&&self.searchHistoryList!= nil) {
            table.tableFooterView.hidden = NO;
        }else{
            self.noSearchHistoryImageview.hidden = NO;
        }
        self.dataSources = self.searchHistoryList;
    }else{
        self.noSearchHistoryImageview.hidden = YES;
        table.tableFooterView.hidden = YES;
        self.dataSources = group[@"items"];
    }
    
    [self updateTableWithDataSources:self.dataSources];
}

- (void)updateTableWithDataSources:(NSMutableArray *)data
{
    UITableView *table = (UITableView *)[self.view viewWithTag:TABLEVIEW_TAG];
    if (data != nil && [data count] != 0) {
        NSMutableArray  *indexPathArray = [NSMutableArray arrayWithCapacity:data.count];
        for (int i= 0;i<data.count;i++){
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:indexpath];
        }
        [table beginUpdates];
        [table insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
        [table endUpdates];
    }
}

#pragma mark
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15]];
    }
    NSDictionary *group = self.groups[self.currentIndex];
    NSString *groupName = [group objectForKey:@"groupName"];
    if ([groupName isEqualToString:@"历史搜索"]) {
        cell.textLabel.text = self.dataSources[indexPath.row];
    }else{
        NSDictionary *dict = self.dataSources[indexPath.row];
        cell.textLabel.text = [dict objectForKey:@"itemName"];
    }
    return cell;
}

#pragma mark
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *group = self.groups[self.currentIndex];
    
    NSString *groupName = [group objectForKey:@"groupName"];
    if ([groupName isEqualToString:@"历史搜索"]) {
        [self searchAction:self.dataSources[indexPath.row]];
    }else{
        NSArray *items = [group objectForKey:@"items"];
        NSDictionary *item = [items objectAtIndex:indexPath.row];
        NSString *itemClickUrl = [item objectForKey:@"itemClickUrl"];
        [UrlParser gotoNewVCWithUrl:itemClickUrl VC:self];
    }
}

#pragma mark
#pragma mark - FileManage
- (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    return documentPath;
}

- (NSMutableArray *)getSearchHistoryList
{
    NSString *filePath = [[self getDocumentPath] stringByAppendingPathComponent:@"SearchHistory.xml"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
    return array;
}

- (void)saveSearchHistoryList:(NSArray *)list
{
    NSString *filePath = [[self getDocumentPath] stringByAppendingPathComponent:@"SearchHistory.xml"];
    [list writeToFile:filePath atomically:YES];
}
- (void)clearSearchHistroy
{
    [self.searchHistoryList removeAllObjects];
    NSString *filePath = [[self getDocumentPath] stringByAppendingPathComponent:@"SearchHistory.xml"];
    [self.searchHistoryList writeToFile:filePath atomically:YES];
    self.dataSources = nil;
    UITableView *table = (UITableView *)[self.view viewWithTag:TABLEVIEW_TAG];
    table.tableFooterView.hidden = YES;
    [table reloadData];
    self.noSearchHistoryImageview.hidden = NO;
}

#pragma mark
#pragma mark - UISearchBarDelegate
// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    [searchBar setShowsCancelButton:YES animated:YES];
    for (UIView *subView in [searchBar subviews])
    {
        for (UIView *subSubView in [subView subviews])
        {
            if ([subSubView isKindOfClass:[UIButton class]])
            {
                UIButton *cancelButton = (UIButton*)subSubView;
                // 修改文字颜色
                [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                break;
            }
        }
    }
}

// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    [searchBar setShowsCancelButton:NO animated:YES];
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchHistoryList == nil)
    {
        self.searchHistoryList  = [NSMutableArray array];
    }
    [self.searchHistoryList insertObject:[searchBar text] atIndex:0];
    [self saveSearchHistoryList:self.searchHistoryList];
    [searchBar resignFirstResponder];
    [self searchAction:searchBar.text];
}
// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
}

#pragma mark
#pragma mark - SearchAction
-(void)searchAction:(NSString*)key
{
    if (key!=nil&&![key isEqualToString:@""])
    {
        NSDictionary* passParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNull null],@"expand",
                                    [NSNull null],@"filter",
                                    key,@"searchKey",
                                    [NSNull null],@"moduleId",
                                    [NSNull null],@"developId",
                                    [NSNull null],@"sortType",
                                    @"1",@"pageIndex",
                                    @"20",@"pageCount",
                                    @"1",@"needType",
                                    [NSNull null],@"speciseId",
                                    [NSNull null],@"requestType",
                                    nil];
        
        ProductsListVC* vc = [[ProductsListVC alloc] init];
        vc.params = passParams;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if ([[GetSearchInfoMessage getBizCode] isEqualToString:bizCode]){
        if ([oKCode isEqualToString:errCode]) {
            bussineDataService *buss = [bussineDataService sharedDataService];
            SearchTypeBar *searchBar = (SearchTypeBar *)[self.view viewWithTag:LEFT_BAR_TAG];
            self.groups = [NSMutableArray arrayWithArray:buss.rspInfo[@"groups"]];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"历史搜索",@"groupName",
                                  @"icon_search_history_search_n",@"groupLogo",
                                 @"icon_search_history_search_p",@"groupLogo_On",
                                  nil];
            [self.groups addObject:dict];
            
            searchBar.searchTypes = self.groups;
        }
    }
}
-(void)requestFailed:(NSDictionary *)info
{
    
}

@end

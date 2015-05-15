//
//  MainSearchVC.m
//  WoChuangFu
//
//  Created by duwl on 12/27/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "MainSearchVC.h"
#import "ProductsVC.h"
#import "FileHelpers.h"

#define SEARCHBAR_TAG 31121
#define HISTORY_TABLE_TAG 31122
#define NO_HISTORY_IMAGEVIEW_TAG 31123

@interface MainSearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UIImageView    *noSearchHistoryImageview;
@property(nonatomic,retain) UITableView    *searchHistoryTable;
@property(nonatomic,retain) NSMutableArray *searchHistoryList;

@end

@implementation MainSearchVC
@synthesize noSearchHistoryImageview,searchHistoryTable,searchHistoryList;

- (void)dealloc
{
    if (noSearchHistoryImageview != nil)
    {
        [noSearchHistoryImageview release];
    }
    if (searchHistoryTable != nil)
    {
        [searchHistoryTable release];
    }
    if (searchHistoryList != nil)
    {
        [searchHistoryList release];
    }
    [super dealloc];
}

-(void)loadView
{
    [super loadView];
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[UIColor blackColor];
    self.view = BackV;
    [BackV release];
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitleBar];
    [self initNoResultImageView];
    [self initHistoryTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.searchHistoryList = [self getSearchHistoryList];
    if (self.searchHistoryList == nil || [self.searchHistoryList count] == 0)
    {
        self.searchHistoryTable.hidden = YES;
    }
    else
    {
        self.searchHistoryTable.hidden = NO;
        [self.searchHistoryTable reloadData];
    }
}

- (void)initTitleBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT)];
    searchBar.placeholder = @"请输入搜索关键字";
    searchBar.tag = SEARCHBAR_TAG;
    for (UIView *subView in searchBar.subviews)
    {
        for (UIView *subSubView in subView.subviews)
        {
            if ([subSubView isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subSubView removeFromSuperview];
                subView.backgroundColor = [UIColor orangeColor];
                break;
            }
        }
    }
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    [searchBar release];
}

-(void)initHistoryTableView
{
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AppDelegate sharePhoneWidth],40)];
    btnBgView.layer.cornerRadius = 5;
    [btnBgView setClipsToBounds:YES];
    [btnBgView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *clearHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearHistoryBtn setBackgroundColor:[UIColor orangeColor]];
    [clearHistoryBtn setTitle:@"清空搜索纪录" forState:UIControlStateNormal];
    clearHistoryBtn.frame =CGRectMake(10,5,[AppDelegate sharePhoneWidth]-20, 30);
    [clearHistoryBtn addTarget:self action:@selector(clearSearchHistroy) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBgView addSubview:clearHistoryBtn];
    
    UITableView *historyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT+20, [AppDelegate sharePhoneWidth], [AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-20-TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    historyTable.tag = HISTORY_TABLE_TAG;
    historyTable.delegate = self;
    historyTable.dataSource = self;
    
    historyTable.tableFooterView = btnBgView;//[[[UIView alloc] init] autorelease];
    self.searchHistoryTable = historyTable;
    [self.view addSubview:historyTable];
    [historyTable release];
    [btnBgView release];
}

- (void)initNoResultImageView
{
    UIImage *image = [UIImage imageNamed:@"no_search_history"];
    UIImageView *imageview= [[UIImageView alloc] initWithImage:image];
    imageview.backgroundColor = [UIColor whiteColor];
    imageview.frame = CGRectMake(0, TITLE_BAR_HEIGHT+20, [AppDelegate sharePhoneWidth], [AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-20-TAB_BAR_HEIGHT);
    imageview.tag = NO_HISTORY_IMAGEVIEW_TAG;
    self.noSearchHistoryImageview = imageview;
    imageview.userInteractionEnabled = YES;
    [self.view addSubview:imageview];
    [imageview release];
}

- (void)gestureAction:(UIGestureRecognizer*)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateEnded:
        {
            UISearchBar *searchBar = (UISearchBar *)[self.view viewWithTag:31121];
            searchBar.text = @"";
            [searchBar resignFirstResponder];
        }
            break;
        default:break;
    }
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchHistoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.searchHistoryList objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark
#pragma mark - UITableViewDelegate
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UISearchBar *searchBar = (UISearchBar *)[self.view viewWithTag:SEARCHBAR_TAG];
    [searchBar resignFirstResponder];
    [self searchAction:[self.searchHistoryList objectAtIndex:[indexPath row]]];;
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
        
        ProductsVC* vc = [[ProductsVC alloc] init];
        
        vc.params = passParams;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [passParams release];
        [vc release];
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
    [alert release];
}

#pragma mark
#pragma mark - HttpBackDelegate
//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestDidFinished:(NSDictionary*)info
{
    MyLog(@"%@",info);
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    
    if([bizCode isEqualToString:[ProductsMessage getBizCode]]){
        if([oKCode isEqualToString:errCode]){
            
        } else {
            if(nil == msg || [info objectForKey:@"MSG"] == [NSNull null]){
                msg = @"搜索失败！";
            }
            [self showSimpleAlertView:msg];
        }
    }
    
}
//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestFailed:(NSDictionary*)info
{
    MyLog(@"%@",info);
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    
    if([[ProductsMessage getBizCode] isEqualToString:bizCode]){
        if(nil == msg || [info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"搜索失败！";
        }
        [self showSimpleAlertView:msg];
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
    self.searchHistoryTable .hidden = YES;
}

@end

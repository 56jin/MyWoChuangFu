//
//  RefreshSingleView.m
//  SaleToolsKit
//
//  Created by wuhui on 14-6-20.
//
//

#import "RefreshSingleView.h"
#import "RefreshTableHeaderView.h"

@implementation RefreshSingleView
@synthesize contentTable;
@synthesize moreDataArray;
@synthesize dataArray;

@synthesize dataSource;
@synthesize delegate;
@synthesize pageNumLoad;
@synthesize loadIndex;

- (void)dealloc
{
    [dataArray release];
    [moreDataArray release];
    [contentTable release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        _loadingMore = NO;
        pageNumLoad = 0;
        loadIndex = 0;
        
        NSMutableArray *itemDatas = [[NSMutableArray alloc] initWithCapacity:0];
        self.dataArray = itemDatas;
        [itemDatas release];
        
        [self layoutContentView];
    }
    return self;
}

#pragma mark
#pragma mark - 布局视图
- (void)layoutContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)
                                                          style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundView = nil;
    tableView.scrollEnabled = YES;
//    tableView.pagingEnabled = YES;
	tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
	[self addSubview:tableView];
    
    self.contentTable = tableView;
    [tableView release];
}

#pragma mark
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshSingleView:cellForRowAtIndexPath:)]) {
        cell = [self.delegate refreshSingleView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tableFooterView = nil;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshSingleView:viewForFooterInSection:)]) {
        tableFooterView = [self.delegate refreshSingleView:tableView viewForFooterInSection:section];
    }
    return tableFooterView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tableHeaderView = nil;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshSingleView:viewForHeaderInSection:)]) {
        tableHeaderView = [self.delegate refreshSingleView:tableView viewForHeaderInSection:section];
    }
    return tableHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshSingleView:didSelectRowAtIndexPath:)]) {
        [self.delegate refreshSingleView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshSingleView:accessoryButtonTappedForRowWithIndexPath:)]) {
        [self.delegate refreshSingleView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

#pragma mark
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat tableFooterHeight = 0.0f;
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(refreshSingleView:heightForFooterInSection:)]) {
        tableFooterHeight = [self.dataSource refreshSingleView:self heightForFooterInSection:section];
    }
    return tableFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat tableHeaderHeight = 0.0f;
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(refreshSingleView:heightForHeaderInSection:)]) {
        tableHeaderHeight = [self.dataSource refreshSingleView:self heightForHeaderInSection:section];
    }
    return tableHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tableCellHeight = 0.0f;
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(refreshSingleView:heightForRowAtIndexPath:)]) {
        tableCellHeight = [self.dataSource refreshSingleView:self heightForRowAtIndexPath:indexPath];
    }
    return tableCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger RowCnt = 0;
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(refreshSingleView:numberOfRowsInSection:)]) {
        RowCnt = [self.dataSource refreshSingleView:self numberOfRowsInSection:section];
    }
    return RowCnt;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionCnt = 0;
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(numberOfSectionsInRefreshSingleView:)]) {
        sectionCnt = [self.dataSource numberOfSectionsInRefreshSingleView:self];
    }
    return sectionCnt;
}

#pragma mark
#pragma mark - InterFace
- (void)reloadViewData:(NSArray *)itemDatas
{
    NSMutableArray *itemTableData = [[NSMutableArray alloc] initWithArray:itemDatas];
    self.moreDataArray = itemTableData;
    [itemTableData release];
    
    [self loadDataEnd];
}

- (void)resetViewDataStream
{
    pageNumLoad = 0;
    [self.dataArray removeAllObjects];
}

#pragma mark
#pragma mark - Pull To Refresh
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.dataArray count] < loadIndex) {
        return;
    }
    
    // 下拉到最底部时显示更多数据
    CGFloat off = scrollView.contentSize.height - scrollView.frame.size.height;
    CGFloat off_y = scrollView.contentOffset.y-off;
	if(!_loadingMore && off_y > 10)
    {
        NSLog(@"wwwwwwwww");
        [self loadDataBegin];
	}
}
// 开始加载数据
- (void) loadDataBegin
{
    if (_loadingMore == NO)
    {
        _loadingMore = YES;
        
        RefreshTableHeaderView *footerView = (RefreshTableHeaderView *)self.contentTable.tableFooterView;
        [footerView startRefresh];
        [self loadDataing];
    }
}

// 加载数据中
- (void) loadDataing
{
    //    [self requestData:reqCondition];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshLoadData:)]) {
        [self.delegate refreshLoadData:pageNumLoad];
    }
}

// 加载数据完毕
- (void) loadDataEnd
{
    NSInteger cnt = moreDataArray.count;
    if (moreDataArray == nil || cnt == 0 || [moreDataArray isEqual:[NSNull null]]) {
        self.contentTable.tableFooterView = nil;
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DataChange:)]) {
            [self.delegate DataChange:self.dataArray];
        }
        [self.contentTable reloadData];
        _loadingMore = YES;
        return;
    }
    
	for (int x = 0; x < cnt; x++)
	{
		[self.dataArray addObject:[moreDataArray objectAtIndex:x]];
	}
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DataChange:)]) {
        [self.delegate DataChange:self.dataArray];
    }
    
	[self.contentTable reloadData];
    
    _loadingMore = NO;
    pageNumLoad ++;
    RefreshTableHeaderView *footerView = (RefreshTableHeaderView *)self.contentTable.tableFooterView;
    if (footerView != nil) {
        [footerView startRefresh];
    }
    
    if (cnt < loadIndex || cnt == 0) {
        self.contentTable.tableFooterView = nil;
    } else {
        [self createTableFooter];
    }
}

// 创建表格底部
- (void) createTableFooter
{
    RefreshTableHeaderView *footerView = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentTable.bounds.size.width, 40.0f)];
    self.contentTable.tableFooterView = footerView;
    [footerView release];
}

@end

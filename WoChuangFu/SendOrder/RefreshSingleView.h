//
//  RefreshSingleView.h
//  SaleToolsKit
//
//  Created by wuhui on 14-6-20.
//
//

#import <UIKit/UIKit.h>
@protocol RefreshSingleViewDataSource;
@protocol RefreshSingleViewDelegate;

@interface RefreshSingleView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *contentTable;
    id<RefreshSingleViewDataSource> dataSource;
    id<RefreshSingleViewDelegate> delegate;
    
    BOOL _loadingMore;
    NSInteger pageNumLoad;
    
    NSInteger loadIndex;//加载个数
    NSInteger selectCellIndex;
}
@property (nonatomic ,assign) NSInteger loadIndex;
@property (nonatomic ,assign) NSInteger pageNumLoad;
@property (nonatomic ,retain) NSMutableArray *moreDataArray;
@property (nonatomic ,retain) NSMutableArray *dataArray;
@property (nonatomic ,retain) UITableView *contentTable;
@property (nonatomic ,assign) id<RefreshSingleViewDataSource> dataSource;
@property (nonatomic ,assign) id<RefreshSingleViewDelegate> delegate;

- (void)reloadViewData:(NSArray *)itemDatas;
- (void)resetViewDataStream;
@end

@protocol RefreshSingleViewDataSource <NSObject>
@optional
- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)refreshSingleView:(RefreshSingleView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInRefreshSingleView:(RefreshSingleView *)tableView;
@end

@protocol RefreshSingleViewDelegate <NSObject>
@optional
- (UITableViewCell *)refreshSingleView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)refreshSingleView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (UIView *)refreshSingleView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (void)refreshSingleView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshSingleView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

- (void)DataChange:(NSMutableArray *)itemData;
- (void)refreshLoadData:(NSInteger)pageNumLoad;
@end


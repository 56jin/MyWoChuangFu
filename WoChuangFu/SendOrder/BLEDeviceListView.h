//
//  BLEDeviceListView.h
//  WoChuangFu
//
//  Created by wuhui on 15/6/24.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLEDeviceListViewDelegate;
@interface BLEDeviceListView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *deviceTable;
    NSArray *deviceList;
    id<BLEDeviceListViewDelegate> delegate;
}
@property (nonatomic ,assign)id<BLEDeviceListViewDelegate> delegate;
@property (nonatomic ,retain)UITableView *deviceTable;
@property (nonatomic ,retain)NSArray *deviceList;

- (void)reloadViewData:(NSArray *)itemList;
@end

@protocol BLEDeviceListViewDelegate <NSObject>
- (void)bleDeviceDidSelectbLE:(NSString *)uuid;
@end

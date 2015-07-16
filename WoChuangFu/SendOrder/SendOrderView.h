//
//  SendOrderView.h
//  WoChuangFu
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//  此界面为整个现场开户界面


#import <UIKit/UIKit.h>
#import "RefreshSingleView.h"//单条内容详情界面
#import "SectionClickView.h"//单条信息简要界面
#import "OrderSearchConditionView.h"//搜索条件界面
#import "bussineDataService.h"

@protocol SendOrderViewDelegate <NSObject>
- (void)didGoToPhotoView:(NSDictionary *)data;
- (void)didGoToFlowVC:(NSDictionary *)flowData;
@end


@interface SendOrderView : UIView<RefreshSingleViewDataSource,
                                  RefreshSingleViewDelegate,
                                  SectionClickViewDelegate,
                                  OrderSeachConditionDelegate,
                                  HttpBackDelegate>
{
    RefreshSingleView *contentTable;
    NSInteger pageLoadNum;
    NSArray *itemList;
    NSArray *rowShowList;
    BOOL *showItems;
    id<SendOrderViewDelegate> delegate;
    
    NSMutableDictionary *paramterDic;
}
@property (nonatomic ,retain)NSArray *itemList;
@property (nonatomic ,retain)NSArray *rowShowList;
@property (nonatomic ,retain)RefreshSingleView *contentTable;
@property (nonatomic ,assign)NSInteger pageLoadNum;
@property (nonatomic ,assign)id<SendOrderViewDelegate> delegate;
@property (nonatomic ,retain)NSMutableDictionary *paramterDic;
@end


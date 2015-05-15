//
//  FilterView.h
//  WoChuangFu
//
//  Created by 李新新 on 15-1-30.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    FilterViewDataTypeCity = 0,
    FilterViewDataTypeNumberType = 1,
    FilterViewDataTypeAddress = 2,
    FilterViewDataTypeNetPackage = 3,
}FilterViewDataType;

@class FilterView;
@protocol FilterViewDelegate <NSObject>

@optional
- (void)didSelectedRowAtIndex:(NSInteger)index withData:(NSDictionary *)data andType:(FilterViewDataType)type;

@end

@interface FilterView : UIView

@property(nonatomic,strong) NSArray *dataSources;
@property(nonatomic,assign) id<FilterViewDelegate> delegate;

- (id)initWithDataArray:(NSArray *)dataArray andType:(FilterViewDataType)type;

- (void)showInView:(UIViewController *)view;

@end

//
//  SearchTypeBar.h
//  WoChuangFu
//
//  Created by 李新新 on 15-1-26.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchTypeBar;
@protocol SearchTypeBarDelegate <NSObject>

@optional

-(void)searchTypeBar:(SearchTypeBar *)searchTypeBar didSelectAtIndex:(NSInteger)index;

@end

@interface SearchTypeBar : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *searchTypes;
@property(nonatomic,assign) id      delegate;

@end

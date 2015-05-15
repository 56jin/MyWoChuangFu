//
//  SideBar.h
//  WoChuangFu
//
//  Created by 李新新 on 14-12-30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SideBar;
@protocol SideBarDelegate <NSObject>

@optional

//点击
- (void)sideBar:(SideBar *)sideBar didSelectAtIndex:(NSInteger)index;
//用户退出
- (void)userDidLogout;

@end

@interface SideBar : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *dataSources;

@property(nonatomic,weak) id<SideBarDelegate> delegate;

@property(nonatomic,copy) NSString *customName;

@end

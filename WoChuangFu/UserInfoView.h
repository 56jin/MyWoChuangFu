//
//  UserInfoView.h
//  WoChuangFu
//
//  Created by 李新新 on 14-12-30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoView : UIScrollView<UITableViewDelegate,UITableViewDataSource,HttpBackDelegate>

- (void)loadUserInfo;

@end

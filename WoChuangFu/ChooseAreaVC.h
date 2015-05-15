//
//  ChooseAreaVC.h
//  WoChuangFu
//
//  Created by duwl on 12/19/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleBar.h"

@interface ChooseAreaVC : UIViewController<HttpBackDelegate,
                                        TitleBarDelegate,
                                        UITableViewDataSource,
                                        UITableViewDelegate>
{
    NSDictionary* params;
}

@property(nonatomic,retain)NSDictionary* params;

@end

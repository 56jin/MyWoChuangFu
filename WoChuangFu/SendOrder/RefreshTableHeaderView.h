//
//  RefreshTableHeaderView.h
//  SaleToolsKit
//
//  Created by Wu YouJian on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RefreshTableHeaderView : UIView{
    UIActivityIndicatorView* activityView;
}

@property(nonatomic,retain) UIActivityIndicatorView* activityView;

-(void)startRefresh;
-(void)stopRefresh;

@end

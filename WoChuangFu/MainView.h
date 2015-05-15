//
//  MainView.h
//  WoChuangFu
//
//  Created by duwl on 12/8/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIView<HttpBackDelegate,UIScrollViewDelegate>
{
    UIScrollView* allScrollView;
}
@property(nonatomic,retain)UIScrollView* allScrollView;

- (void)sendMainUIRequest;

@end

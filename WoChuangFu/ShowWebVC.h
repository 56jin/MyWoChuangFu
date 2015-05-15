//
//  ShowWebVC.h
//  WoChuangFu
//
//  Created by duwl on 12/12/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleBar.h"

@interface ShowWebVC : UIViewController<UIWebViewDelegate,TitleBarDelegate>
{
    UIActivityIndicatorView *indicator;
    NSString* urlStr;
    NSString* titleStr;
    TitleBar* titleBar;
    NSInteger FIRST;
    NSString* postData;
    BOOL isPayment;
}

@property(nonatomic,retain)NSString* urlStr;
@property(nonatomic,retain)NSString* titleStr;
@property(nonatomic,retain)TitleBar* titleBar;
@property(nonatomic,retain)NSString* postData;
@property(nonatomic,assign)BOOL isPayment;

@end

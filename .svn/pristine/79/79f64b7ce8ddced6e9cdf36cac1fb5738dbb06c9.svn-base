//
//  FirstVC.h
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-15.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageControl.h"
//#import "FirstPageToolView.h"
#import "MyEGORefreshTableHeaderView.h"


@protocol FirstDelegate <NSObject>

@optional

-(void)ShowList;

@end

@protocol FirTabDelegate <NSObject>

@optional

-(void)SetTab:(NSMutableArray *)Arr;

@end

@interface FirstVC : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,HttpBackDelegate,MyEGORefreshTableHeaderDelegate,FirstDelegate,FirTabDelegate,UIWebViewDelegate>{
    id<FirstDelegate> delegate;
    id<FirTabDelegate> tabDelegate;
    UIScrollView *scroll;
    NSMutableArray *PageArr;
    UIScrollView *scrView;
    CustomPageControl *Page;
    int PageNum;//计算自动滚动
    MyEGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSTimer *Timer;
    BOOL isFirst;
    NSMutableDictionary *ShujuDic;
    BOOL isLogINCome;
    NSMutableString *TypeStr;
    UIWebView* viewWeb;
    NSMutableString *URlStr;
    NSMutableString *appstoreUrl;
}

@property(nonatomic,retain)id<FirstDelegate> delegate;
@property(nonatomic,retain)id<FirTabDelegate> tabDelegate;

@end

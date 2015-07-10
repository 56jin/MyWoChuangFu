//
//  WebViewController.h
//  WoChuangFu
//
//  Created by 陈贵邦 on 15/7/7.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController{
    UIWebView *webView;
}
@property (retain,nonatomic) UIWebView *webView;

@property (nonatomic,copy) NSString *URL;
@end

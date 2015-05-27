//
//  JiGouWebViewControler.h
//  WoChuangFu
//
//  Created by 陈 贵邦 on 15-5-27.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiGouWebViewControler : UIViewController{
    UIWebView *webView;
}
@property (retain,nonatomic) UIWebView *webView;

@property (nonatomic,copy) NSString *URL;
@end

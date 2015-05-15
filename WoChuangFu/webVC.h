//
//  webVC.h
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-17.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface webVC : UIViewController<UIWebViewDelegate>{
    UIWebView* viewWeb;
}

@property(nonatomic,retain)NSString *Url;
@property(nonatomic,retain)NSString *TStr;
@property(nonatomic,retain)NSString *webType;

- (id)initwithStr:(NSString *)Str title:(NSString *)TitleStr withType:(NSString *)type;

@end

//
//  TextDeclareViewController.h
//  Neighbor
//
//  Created by 1 on 10/17/14.
//  Copyright (c) 2014 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextDeclareViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (nonatomic,copy) NSString *IDString,*shengHuo;
@property (nonatomic,copy) NSString *URL;
@property (nonatomic,copy) NSString *isHuDong;

@end

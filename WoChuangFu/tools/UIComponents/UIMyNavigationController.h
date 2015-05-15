//
//  UIMyNavigationController.h
//  YuWOGYPro
//
//  Created by wuyj on 10/9/12.
//  Copyright (c) 2012 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMyNavigationController : UINavigationController

//重载
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

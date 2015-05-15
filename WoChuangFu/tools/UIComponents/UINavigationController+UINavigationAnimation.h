//
//  UINavigationController+UINavigationAnimation.h
//  WOXTXPro
//
//  Created by wu youjian on 7/23/12.
//  Copyright (c) 2012 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (UINavigationAnimation)
-(void)pushViewControllerWithPageCurl:(UIViewController*)viewController;
-(void)popViewControllerWithPageUncurl;
-(void)popToRootViewControllerWithPageUncurl;
@end

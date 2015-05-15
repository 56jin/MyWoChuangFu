//
//  UINavigationController+UINavigationAnimation.m
//  WOXTXPro
//
//  Created by wu youjian on 7/23/12.
//  Copyright (c) 2012 asiainfo-linkage. All rights reserved.
//

#import<QuartzCore/QuartzCore.h>
#import "UINavigationController+UINavigationAnimation.h"


@implementation UINavigationController (UINavigationAnimation)

-(void)pushViewControllerWithPageCurl:(UIViewController*)viewController{
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    CATransition *animation = [CATransition animation];
	//相关参数设置
	[animation setDelegate:self];
	[animation setDuration:0.6f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:YES];
    [animation setType:@"pageCurl"];
    [animation setStartProgress:0.0f];
    [animation setEndProgress:1.0f];
     
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [animation setSubtype:kCATransitionFromLeft];
    }else {
        [animation setSubtype:kCATransitionFromRight];
    }
    
    //NSLog(@"top:%@",kCATransitionFromTop);
    //NSLog(@"Bottom:%@",kCATransitionFromBottom);
    
    [self.view.layer addAnimation:animation forKey:kCATransition];
    [self pushViewController:viewController animated:NO];//
}

-(void)popViewControllerWithPageUncurl{
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    
    CATransition *animation = [CATransition animation];
	//相关参数设置
	[animation setDelegate:self];
	[animation setDuration:0.6f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setFillMode:kCAFillModeBackwards];
    [animation setRemovedOnCompletion:YES];
    [animation setType:@"pageUnCurl"];
    [animation setStartProgress:0.0f];
    [animation setEndProgress:1.0f];
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [animation setSubtype:kCATransitionFromLeft];
    }else {
        [animation setSubtype:kCATransitionFromRight];
    }
	

    [self.view.layer addAnimation:animation forKey:kCATransition];
    [self popViewControllerAnimated:NO];//
}
-(void)popToRootViewControllerWithPageUncurl{
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    
    CATransition *animation = [CATransition animation];
	//相关参数设置
	[animation setDelegate:self];
	[animation setDuration:0.6f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setFillMode:kCAFillModeBackwards];
    [animation setRemovedOnCompletion:YES];
    [animation setType:@"pageUnCurl"];
    [animation setStartProgress:0.0f];
    [animation setEndProgress:1.0f];
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [animation setSubtype:kCATransitionFromLeft];
    }else {
        [animation setSubtype:kCATransitionFromRight];
    }
	
    
    [self.view.layer addAnimation:animation forKey:kCATransition];
    [self popToRootViewControllerAnimated:NO];//
}
@end

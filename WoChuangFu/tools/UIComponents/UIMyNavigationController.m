//
//  UIMyNavigationController.m
//  YuWOGYPro
//
//  Created by wuyj on 10/9/12.
//  Copyright (c) 2012 asiainfo-linkage. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIMyNavigationController.h"

@interface UIMyNavigationController ()
-(CATransition*)createPushAnimation;
-(CATransition*)createPopAnimation;

@end

@implementation UIMyNavigationController

-(CATransition*)createPushAnimation{
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    CATransition *animation = [[[CATransition animation] retain] autorelease];
	//相关参数设置
	//[animation setDelegate:self];
	[animation setDuration:0.5f];
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
    
    return animation;
}


-(CATransition*)createPopAnimation{
    UIInterfaceOrientation orientation = [self interfaceOrientation];
    
    CATransition *animation = [[[CATransition animation] retain] autorelease];
	//相关参数设置
	//[animation setDelegate:self];
	[animation setDuration:0.5f];
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
    
    return animation;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    CATransition *animation = [self createPushAnimation];
    [self.view.layer addAnimation:animation forKey:kCATransition];
    [super pushViewController:viewController animated:NO];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
	CATransition *animation = [self createPopAnimation];
    [self.view.layer addAnimation:animation forKey:kCATransition];
    return [super popViewControllerAnimated:NO];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    CATransition *animation = [self createPopAnimation];
    [self.view.layer addAnimation:animation forKey:kCATransition];
    return [super popToViewController:viewController animated:NO];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    CATransition *animation = [self createPopAnimation];
    [self.view.layer addAnimation:animation forKey:kCATransition];
    return [super popToRootViewControllerAnimated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

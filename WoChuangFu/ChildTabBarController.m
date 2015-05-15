//
//  ChildTabBarController.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-12-16.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "ChildTabBarController.h"

@interface ChildTabBarController ()

@end

@implementation ChildTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return [[self.viewControllers objectAtIndex:self.selectedIndex] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers objectAtIndex:self.selectedIndex] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers objectAtIndex:self.selectedIndex] preferredInterfaceOrientationForPresentation];
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    CATransition* animation = [CATransition animation];
//    [animation setDuration:0.5f];
//    [animation setType:kCATransitionFade];
//    [animation setSubtype:kCATransitionFromRight];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [[self.view layer]addAnimation:animation forKey:nil];
//}

@end

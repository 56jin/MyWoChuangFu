//
//  ChildNavigationController.m
//  EsayBuy
//
//  Created by 颜 梁坚 on 13-12-16.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "ChildNavigationController.h"

@interface ChildNavigationController ()

@end

@implementation ChildNavigationController

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

-(BOOL)shouldAutorotate
{
    return NO;//[self.viewControllers.lastObject shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation==UIInterfaceOrientationPortrait);//[self.viewControllers.lastObject shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end

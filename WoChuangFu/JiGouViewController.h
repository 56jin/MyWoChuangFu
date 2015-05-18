//
//  JiGouViewController.h
//  WoChuangFu
//
//  Created by 陈亦海 on 15/5/16.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiGouViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIView *theVIew;

@property (retain, nonatomic) IBOutlet UITextField *JiGouCoreText;


@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)sureButton:(id)sender;


@end

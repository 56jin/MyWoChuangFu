//
//  RealNameCarViewController.h
//  WoChuangFu
//
//  Created by 陈亦海 on 15/6/2.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealNameCarViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UITextField *NumTextField;
@property (retain, nonatomic) IBOutlet UIButton *SFZbutton;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@property (retain, nonatomic) IBOutlet UILabel *NumCarLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;

@property (retain, nonatomic) IBOutlet UITextView *beiZhuTextView;

@property (retain, nonatomic) IBOutlet UIImageView *TopimageView;

@property (retain, nonatomic) IBOutlet UIButton *sureBtn;


- (IBAction)SureEven:(id)sender;

- (IBAction)getSFZEvent:(id)sender;

@end

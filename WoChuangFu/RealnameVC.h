//
//  RealnameVC.h
//  WoChuangFu
//
//  Created by 陈 贵邦 on 15-6-8.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealnameVC : UIViewController{
    CGPoint tmpPoint;
}
@property(retain,nonatomic) UITextField *fanNumTextFiled;
@property(retain,nonatomic) UIButton *getIdCradBtn;
@property(retain,nonatomic) UILabel *nameLabel;
@property(retain,nonatomic) UILabel *idCardLabel;
@property(retain,nonatomic) UILabel *idCardAddress;
@property(retain,nonatomic) UILabel *messageLabel;
@property(retain,nonatomic) UIImageView *photoImageView;
@property(retain,nonatomic) UITextView *remarkTextFild;
@property(retain,nonatomic) UIButton *realBtn;
@end



@interface LWEdit : UILabel

@end
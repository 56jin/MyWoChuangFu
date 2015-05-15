//
//  LoginSuccessView.h
//  WoChuangFu
//
//  Created by 陈亦海 on 15/5/13.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMWaveButton.h"



typedef void (^ReturnTextBlock)(NSString *showText);

@interface LoginSuccessView : UIView

@property (nonatomic,copy) NSString *urlLogin;
@property (nonatomic,strong) BMWaveButton *seachButton;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

- (void)builtView;
- (void)showView;

@end

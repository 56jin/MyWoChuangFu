//
//  LoginSuccessView.m
//  WoChuangFu
//
//  Created by 陈亦海 on 15/5/13.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "LoginSuccessView.h"


#pragma mark - 硬件
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation LoginSuccessView{
    BMWaveButton *_seachButton;
}


@synthesize seachButton = _seachButton;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGBA(240, 112, 33, 1);

    }
    return self;
}

- (void)builtView {
    _seachButton = [[BMWaveButton alloc] initWithType:BMWaveButtonDefault Image:@"logo_key_safari2"];
    //    [_seachButton setBackgroundImage:[UIImage imageNamed:@"safari_azul"] forState:UIControlStateNormal];
    [_seachButton setTitle:nil forState:UIControlStateNormal];
    [_seachButton addTarget:self action:@selector(searchedClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_seachButton];
    
    
    UIImageView *chuangimg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT-180, 120 , 32)];
    chuangimg.image = [UIImage imageNamed:@"logo_key_wocf"];
    [self addSubview:chuangimg];
    
    UIImageView *chuowo = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+40, SCREEN_HEIGHT/2-150, 50 , 40)];
    chuowo.image = [UIImage imageNamed:@"chuowo"];
    [self addSubview:chuowo];
    
    UIImageView *textImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-112, SCREEN_HEIGHT-140, 225 , 35)];
    textImg.image = [UIImage imageNamed:@"txt_key_coryright"];
    [self addSubview:textImg];
    
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT-100, 100, 40)];
    lable2.text = [NSString stringWithFormat:@"版本号：%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.font = [UIFont systemFontOfSize:10];
    lable2.textColor = [UIColor blackColor];
    lable2.backgroundColor = [UIColor clearColor];
    [self addSubview:lable2];
}

- (void)showView {
    
}

- (void)searchedClicked

{
    _seachButton.userInteractionEnabled=NO;
    [_seachButton StartWave];
    
    //使用block
    if (self.returnTextBlock) {
        self.returnTextBlock(self.urlLogin);
    }
    
    
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

@end
